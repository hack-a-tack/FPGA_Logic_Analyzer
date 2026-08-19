-- ========================================
-- MODULE: analyzer_fsm.vhd
-- FUNCTION: manages the logic analyzer state machine
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-12 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- LAST MODIFIED: 2026-05-15 (watchdog)
-- MODIFIED: 2026-08-06 (rev2)
-- MODIFIED: 2026-08-12 (rev2) (SEND now returns to DATA_READY instead of IDLE, so READ is repeatable)
-- MODIFIED: 2026-08-12 (rev2) (response transmission moved to resp_gen; removed TX-busy gate that could drop command pulses)
-- MODIFIED: 2026-08-15 (rev2) (surface rx_frame_parser frame-error and seq-gap events as resp_gen requests)
-- MODIFIED: 2026-08-19 (rev2) (migrated to la_pkg: RESP_TYPE_*/CODE_*/OPCODE_* constants deleted, replaced with la_pkg's C_TYPE_*/C_CODE_*/C_CMD_*)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_cmd_error_pulse		1 bit		<- cmd_parser
-- i_capture_cmd_pulse		1 bit		<- cmd_parser
-- i_capture_done_pulse		1 bit		<- capture_engine
-- i_read_cmd_pulse			1 bit		<- cmd_parser
-- i_send_done_pulse		1 bit		<- send_engine
-- i_cfg_ack_pulse         	1 bit		<- config_regs
-- i_cfg_error_pulse 		1 bit		<- config_regs
-- i_cmd_opcode				8 bits		<- cmd_parser
-- i_frame_error_pulse		1 bit		<- rx_frame_parser
-- i_frame_error_code		8 bits		<- rx_frame_parser
-- i_seq_gap_pulse			1 bit		<- rx_frame_parser
--
-- OUTPUTS					DATA		TO MODULE
-- o_config_write_allowed 	1 bit		-> config_regs
-- o_capture_start_pulse	1 bit		-> capture_engine
-- o_send_start_pulse		1 bit		-> send_engine
-- o_resp_req				1 bit		-> resp_gen
-- o_resp_type				8 bits		-> resp_gen
-- o_resp_code				8 bits		-> resp_gen
-- o_resp_detail			8 bits		-> resp_gen
-- o_USER_LED				1 bit		-> top
--
-- NOTES
-- UART arbitration is frame-atomic in frame_tx. A status request raised while a capture-data frame is in flight is
-- queued by resp_gen and sent as its own frame afterwards.
-- A completed capture remains readable in DATA_READY; READ may be issued repeatedly so the host can retry after a CRC or sequence failure. The capture is invalidated only by a new CAPTURE command.
-- A seq gap is reported as STATUS, not ERROR, because rx_frame_parser still releases the frame that follows the gap. That command runs normally and gets its own ACK; the gap report just says an earlier frame was lost, so the host can expect two responses (gap, then ACK) for it.
-- C_CODE_FRAME_ERROR (0xEF) is kept separate from C_CODE_ERROR (0xEE) because the detail byte means something different for each: 0xEE's detail is a command opcode, 0xEF's detail is a frame-reject subcode (bad version, bad type, bad length, CRC mismatch, timeout). Reusing one code for both would make the host guess which meaning applies.
-- Frame-error and seq-gap responses are handled after the state case, and only fire if the case did not already request a response this cycle. The case wins any same-cycle collision so i_capture_done_pulse can never be dropped for a frame event; losing a DONE would hang the host, while a dropped frame-error/seq-gap just costs an extra host-side ACK timeout and retry.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- The rev1 watchdog is incompatible with Rev2. Triggered capture may legitimately wait indefinitely.
-- ... A maximum 12,288-byte transfer at 921,600 baud takes about 133 ms. Your 4,000,000-cycle SEND watchdog expires after about 83 ms. Returning analyzer_fsm to IDLE does not stop capture_engine or send_engine. So the watchdog can falsely abort valid operations while the underlying module continues running.
-- ... Remove or disable it until you add:
-- - Explicit capture/send abort inputs
-- - Mode-aware capture timeout behaviour
-- - Baud- and payload-dependent SEND limits
-- --> Do not classify “still waiting for a trigger” as a fault.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.la_pkg.ALL;

entity analyzer_fsm is
	generic(
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk 					: in  std_logic;
		i_rst_n					: in  std_logic;

		i_cmd_error_pulse		: in  std_logic;
		i_capture_cmd_pulse		: in  std_logic;
		i_capture_done_pulse	: in  std_logic;
		i_read_cmd_pulse		: in  std_logic;
		i_send_done_pulse		: in  std_logic;

		-- config_regs
		i_cfg_ack_pulse			: in  std_logic;
		i_cfg_error_pulse		: in  std_logic;
		o_config_write_allowed 	: out std_logic;

		i_cmd_opcode			: in  std_logic_vector(DATA_LENGTH-1 downto 0);

		-- rx_frame_parser
		i_frame_error_pulse 	: in std_logic; 
		i_frame_error_code  	: in std_logic_vector(DATA_LENGTH-1 downto 0); 
		i_seq_gap_pulse     	: in std_logic;

		o_capture_start_pulse	: out std_logic;
		o_send_start_pulse		: out std_logic;

		-- resp_gen <-> analyzer_fsm
		o_resp_req				: out std_logic;								-- one cycle
		o_resp_type				: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_resp_code				: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_resp_detail			: out std_logic_vector(DATA_LENGTH-1 downto 0);

		o_USER_LED				: out std_logic
	);
end entity analyzer_fsm;

architecture RTL of analyzer_fsm is
	type runtime_state_type is (IDLE, CAPTURE, DATA_READY, SEND);
	signal r_state, n_state : runtime_state_type := IDLE;

	-- Register signals, next-state signals
	signal r_resp_req, n_resp_req : std_logic := '0';																	-- output
	signal r_resp_type, n_resp_type : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');					-- output
	signal r_resp_code, n_resp_code : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');					-- output
	signal r_resp_detail, n_resp_detail : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');				-- output
	signal r_capture_start_pulse, n_capture_start_pulse : std_logic := '0';												-- output
	signal r_send_start_pulse, n_send_start_pulse : std_logic := '0';													-- output
	signal r_USER_LED, n_USER_LED : std_logic := '0';																	-- output
	signal r_wd_count, n_wd_count : unsigned(21 downto 0) := (others => '0');											-- Watchdog
	signal r_wd_timeout, n_wd_timeout : std_logic := '0'; 																-- Watchdog

	-- Watchdog limits
	-- WD LIMIT for CAPTURE: capture takes 8192 clock cycles. Set limit to 100k to have plenty of margin to avoid false WD trip, and stay within 22 bit width
	--constant WD_LIMIT_CAPTURE 	: unsigned(21 downto 0) := to_unsigned(100_000, r_wd_count'length);		-- CAPTURE timeout after 100k clock cycles
	-- WD LIMIT for SEND: send takes 2_129_920 clock cycles. Set limit to 4M to avoid false WD trip and stay within 2^22 to keep 22 bit counter width
	--constant WD_LIMIT_SEND		: unsigned(21 downto 0) := to_unsigned(4_000_000, r_wd_count'length);  	-- SEND timeout after 4M clock cycles

begin
	-- Sequential process to update r_state and deal with clocking and reset logic
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_state <= IDLE;
				r_resp_req <= '0';
				r_resp_type <= (others => '0');
				r_resp_code <= (others => '0');
				r_resp_detail <= (others => '0');
				r_capture_start_pulse <= '0';
				r_send_start_pulse <= '0';
				r_USER_LED <= '0';
				r_wd_count <= (others => '0');
				r_wd_timeout <= '0';
			else
				r_state <= n_state;
				r_resp_req <= n_resp_req;
				r_resp_type <= n_resp_type;
				r_resp_code <= n_resp_code;
				r_resp_detail <= n_resp_detail;
				r_capture_start_pulse <= n_capture_start_pulse;
				r_send_start_pulse <= n_send_start_pulse;
				r_USER_LED <= n_USER_LED;
				r_wd_count <= n_wd_count;
				r_wd_timeout <= n_wd_timeout;
			end if;
		end if;
	end process seq_proc;


	-- Combinational process to update n_state and manage FSM logic
	fsm_proc: process(all) is
		variable v_resp_taken : boolean;
	begin
		-- Defaults
		v_resp_taken := false;
		n_state <= r_state;
		n_resp_req <= '0';						-- pulse output, default low
		n_resp_type <= r_resp_type;
		n_resp_code <= r_resp_code;
		n_resp_detail <= r_resp_detail;
		n_capture_start_pulse <= '0';
		n_send_start_pulse <= '0';
		n_USER_LED <= r_USER_LED;
		n_wd_count <= r_wd_count;
		n_wd_timeout <= r_wd_timeout;

		case r_state is
			when IDLE =>
				if i_cfg_ack_pulse = '1' then  		-- valid opcode and config byte
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_STATUS;
					n_resp_code   <= C_CODE_ACK;
					n_resp_detail <= i_cmd_opcode;
				elsif i_cfg_error_pulse = '1' then	-- undefined opcode or config byte
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_ERROR;
					n_resp_code   <= C_CODE_ERROR;
					n_resp_detail <= i_cmd_opcode;
				elsif i_capture_cmd_pulse = '1' then
					n_capture_start_pulse <= '1';
					n_state <= CAPTURE;
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_STATUS;
					n_resp_code   <= C_CODE_ACK;  -- 0x55 (OK), 0b01010101
					n_resp_detail <= C_CMD_CAPTURE;
				elsif i_read_cmd_pulse = '1' then
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_ERROR;
					n_resp_code   <= C_CODE_ERROR;  -- 0xEE (ERROR), 0b11101110; data not ready
					n_resp_detail <= C_CMD_READ;
				elsif i_cmd_error_pulse = '1' then
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_ERROR;
					n_resp_code   <= C_CODE_ERROR;  -- 0xEE (ERROR), 0b11101110; opcode not understood
					n_resp_detail <= i_cmd_opcode;
				end if;

			when CAPTURE =>
				if i_capture_done_pulse = '1' then
					n_USER_LED <= not r_USER_LED;  -- toggle the LED once CAPTURE is complete
					n_state <= DATA_READY;
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_STATUS;
					n_resp_code   <= C_CODE_DONE;  -- 0x77 (DONE), 0b01110111
					n_resp_detail <= x"00";
				elsif i_capture_cmd_pulse = '1' then
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_ERROR;
					n_resp_code   <= C_CODE_ERROR;  -- 0xEE (ERROR), 0b11101110; already capturing
					n_resp_detail <= C_CMD_CAPTURE;
				elsif i_read_cmd_pulse = '1' then
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_ERROR;
					n_resp_code   <= C_CODE_ERROR;  -- 0xEE (ERROR), 0b11101110; data not ready
					n_resp_detail <= C_CMD_READ;
				elsif i_cmd_error_pulse = '1' then
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_ERROR;
					n_resp_code   <= C_CODE_ERROR;  -- 0xEE (ERROR), 0b11101110; opcode not understood
					n_resp_detail <= i_cmd_opcode;
				end if;

			when DATA_READY =>
				if i_cfg_ack_pulse = '1' then		-- valid opcode and config byte
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_STATUS;
					n_resp_code   <= C_CODE_ACK;
					n_resp_detail <= i_cmd_opcode;
				elsif i_cfg_error_pulse = '1' then  -- undefined opcode or config byte
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_ERROR;
					n_resp_code   <= C_CODE_ERROR;
					n_resp_detail <= i_cmd_opcode;
				elsif i_capture_cmd_pulse = '1' then
					n_capture_start_pulse <= '1';
					n_state <= CAPTURE;
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_STATUS;
					n_resp_code   <= C_CODE_ACK;  -- 0x55 (OK), 0b01010101
					n_resp_detail <= C_CMD_CAPTURE;
				elsif i_read_cmd_pulse = '1' then
					n_state <= SEND;
					n_send_start_pulse <= '1';
				elsif i_cmd_error_pulse = '1' then
					v_resp_taken := true;
					n_resp_req    <= '1';
					n_resp_type   <= C_TYPE_ERROR;
					n_resp_code   <= C_CODE_ERROR;  -- 0xEE (ERROR), 0b11101110; opcode not understood
					n_resp_detail <= i_cmd_opcode;
				end if;

			when SEND =>
				if i_send_done_pulse = '1' then
					n_state <= DATA_READY;
					-- no error handling in state SEND (0xEE won't be sent as data is being streamed)
				end if;
		end case;

		-- Frame events are state-independent (a corrupted or lost frame can arrive at any time). The state case above always wins a same-cycle collision, see NOTES.
		if not v_resp_taken then
			if i_frame_error_pulse = '1' then		-- frame rejected by rx_frame_parser (bad sync/version/type/length/CRC)
				n_resp_req    <= '1';
				n_resp_type   <= C_TYPE_ERROR;
				n_resp_code   <= C_CODE_FRAME_ERROR;  -- 0xEF (FRAME ERROR), detail = frame reject subcode
				n_resp_detail <= i_frame_error_code;
			elsif i_seq_gap_pulse = '1' then		-- a host->FPGA frame was lost, released command still executes
				n_resp_req    <= '1';
				n_resp_type   <= C_TYPE_STATUS;
				n_resp_code   <= C_CODE_SEQ_GAP;  -- 0x66 (SEQ GAP)
				n_resp_detail <= x"00";
			end if;
		end if;

		/*
		-- Watchdog logic: prevents getting stuck in CAPTURE or SEND
		if n_state = CAPTURE and r_state /= CAPTURE then
			n_wd_count <= (others => '0');
		elsif n_state = SEND and r_state /= SEND then
			n_wd_count <= (others => '0');
		elsif (n_state = CAPTURE and r_state = CAPTURE) then
			if r_wd_count >= WD_LIMIT_CAPTURE then
				n_wd_count <= (others => '0');
			else
				n_wd_count <= r_wd_count + 1;
			end if;
		elsif (n_state = SEND and r_state = SEND) then
			if r_wd_count >= WD_LIMIT_SEND then
				n_wd_count <= (others => '0');
			else
				n_wd_count <= r_wd_count + 1;
			end if;
		else  -- for states IDLE and DONE, reset Watchdog counter
			n_wd_count <= (others => '0');
		end if;

		-- Watchdog timeout
		n_wd_timeout <= '1' when 	(r_state = CAPTURE and r_wd_count >= WD_LIMIT_CAPTURE) or
									(r_state = SEND and r_wd_count >= WD_LIMIT_SEND)
									else '0';

		if r_wd_timeout = '1' then
			n_state <= IDLE;
			n_resp_req    <= '1';
			n_resp_type   <= C_TYPE_ERROR;
			n_resp_code   <= C_CODE_WATCHDOG;  -- 0xDD (WATCHDOG ERROR), 0b11011101; watchdog triggered
			n_resp_detail <= x"00";
		end if;
		*/

	end process fsm_proc;


	-- Set outputs
	o_config_write_allowed <= '0' when r_state = CAPTURE or r_state = SEND else '1';

	o_capture_start_pulse	<= r_capture_start_pulse;
	o_send_start_pulse 		<= r_send_start_pulse;

	o_resp_req				<= r_resp_req;
	o_resp_type				<= r_resp_type;
	o_resp_code				<= r_resp_code;
	o_resp_detail			<= r_resp_detail;

	o_USER_LED 				<= r_USER_LED;

end architecture RTL;
