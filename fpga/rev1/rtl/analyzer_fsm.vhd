-- ========================================
-- MODULE: analyzer_fsm.vhd
-- FUNCTION: manages the logic analyzer state machine
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-23 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_samp_tick				1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_cmd_error_pulse		1 bit		<- cmd_parser
-- i_capture_cmd_pulse		1 bit		<- cmd_parser
-- i_capture_done_pulse		1 bit		<- capture_engine
-- i_read_cmd_pulse			1 bit		<- cmd_parser
-- i_send_done_pulse		1 bit		<- send_engine
-- i_tx_busy				1 bit		<- uart_tx
--
-- OUTPUTS					DATA		TO MODULE
-- o_capture_start_pulse	1 bit		-> capture_engine
-- o_send_start_pulse		1 bit		-> send_engine
-- o_fsm_tx_status_byte		8 bits		-> tx_mux
-- o_fsm_tx_start_pulse		1 bit		-> tx_mux
-- o_USER_LED				1 bit		-> top
--
-- NOTES
-- Pending status code is just sent if not overridden by a new, higher-priority event in the same cycle
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity analyzer_fsm is
	generic(
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk 					: in  std_logic;
		i_samp_tick 			: in  std_logic;
		i_rst 					: in  std_logic;
		i_cmd_error_pulse		: in  std_logic;
		i_capture_cmd_pulse		: in  std_logic;
		i_capture_done_pulse	: in  std_logic;
		i_read_cmd_pulse		: in  std_logic;
		i_send_done_pulse		: in  std_logic;
		i_tx_busy				: in  std_logic;
		o_capture_start_pulse	: out std_logic;
		o_send_start_pulse		: out std_logic;
		o_fsm_tx_status_byte	: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_fsm_tx_start_pulse	: out std_logic;
		o_USER_LED				: out std_logic
	);
end entity analyzer_fsm;

architecture RTL of analyzer_fsm is
	type runtime_state_type is (IDLE, CAPTURE, DONE, SEND);
	signal r_state, n_state : runtime_state_type := IDLE;
	
	-- Register signals, next-state signals
	signal r_fsm_tx_status_byte, n_fsm_tx_status_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');	-- output
	signal r_fsm_tx_start_pulse, n_fsm_tx_start_pulse : std_logic := '0';												-- output
	signal r_capture_start_pulse, n_capture_start_pulse : std_logic := '0';												-- output
	signal r_send_start_pulse, n_send_start_pulse : std_logic := '0';													-- output
	signal r_USER_LED, n_USER_LED : std_logic := '0';																	-- output
	signal r_status_pending_valid, n_status_pending_valid : std_logic := '0';											-- internal
	signal r_status_pending_byte, n_status_pending_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');	-- internal
	signal r_wd_count, n_wd_count : unsigned(23 downto 0) := (others => '0');											-- Watchdog
	signal wd_timeout : std_logic := '0'; 																				-- Watchdog
	
	-- Watchdog limits
	constant WD_LIMIT_CAPTURE 	: unsigned(23 downto 0) := 100_000;
	constant WD_LIMIT_SEND		: unsigned(23 downto 0) := 4_800_000;
	
begin

	-- Sequential process to update r_state and deal with clocking and reset logic
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				r_state <= IDLE;
				r_fsm_tx_status_byte <= (others => '0');
				r_fsm_tx_start_pulse <= '0';
				r_capture_start_pulse <= '0';
				r_send_start_pulse <= '0';
				r_USER_LED <= '0';
				r_status_pending_valid <= '0';
				r_status_pending_byte <= (others => '0');
				r_wd_count <= (others => '0');
			else
				r_state <= n_state;
				r_fsm_tx_status_byte <= n_fsm_tx_status_byte;
				r_fsm_tx_start_pulse <= n_fsm_tx_start_pulse;
				r_capture_start_pulse <= n_capture_start_pulse;
				r_send_start_pulse <= n_send_start_pulse;
				r_USER_LED <= n_USER_LED;
				r_status_pending_valid <= n_status_pending_valid;
				r_status_pending_byte <= n_status_pending_byte;
				r_wd_count <= n_wd_count;
			end if;
		end if;
	end process seq_proc;
	
	
	-- Combinational process to update n_state and manage FSM logic
	fsm_proc: process(all) is
	begin
		-- Defaults
		n_state <= r_state;
		n_fsm_tx_status_byte <= r_fsm_tx_status_byte;
		n_fsm_tx_start_pulse <= '0';
		n_capture_start_pulse <= '0';
		n_send_start_pulse <= '0';
		n_USER_LED <= r_USER_LED;
		n_status_pending_valid <= r_status_pending_valid;
		n_status_pending_byte <= r_status_pending_byte;
		n_wd_count <= r_wd_count;
		
		-- Send pending status code if (exists and) uart_tx is no longer busy
		if r_status_pending_valid = '1' and i_tx_busy = '0' then
			n_fsm_tx_status_byte <= r_status_pending_byte;
			n_fsm_tx_start_pulse <= '1';
			n_status_pending_valid <= '0';
		end if;
		
		case r_state is
			when IDLE =>
				if i_capture_cmd_pulse = '1' then
					n_state <= CAPTURE;
					n_capture_start_pulse <= '1';
					
					-- tx_busy determines when status code is sent to host; independent of state transitions
					if i_tx_busy = '0' then  -- send now if possible
						n_fsm_tx_status_byte <= x"55";  -- 0x55 (OK), 0b01010101
						n_fsm_tx_start_pulse <= '1';
					else  -- else store 1 pending byte
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"55";
					end if;
				elsif i_read_cmd_pulse = '1' then
					if i_tx_busy = '0' then
						n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; data not ready
						n_fsm_tx_start_pulse <= '1';
					else
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"EE";
					end if;
				elsif i_cmd_error_pulse = '1' then
					if i_tx_busy = '0' then
						n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; opcode not understood
						n_fsm_tx_start_pulse <= '1';
					else
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"EE";
					end if;
				end if;
				
			when CAPTURE =>
				if i_capture_done_pulse = '1' then
					n_state <= DONE;
					n_USER_LED <= not r_USER_LED;  -- toggle the LED once CAPTURE message is received
					if i_tx_busy = '0' then
						n_fsm_tx_status_byte <= x"77";  -- 0x77 (DONE), 0b01110111
						n_fsm_tx_start_pulse <= '1';
					else
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"77";
					end if;
				elsif i_capture_cmd_pulse = '1' then
					if i_tx_busy = '0' then
						n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; already capturing
						n_fsm_tx_start_pulse <= '1';
					else
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"EE";
					end if;
				elsif i_read_cmd_pulse = '1' then
					if i_tx_busy = '0' then
						n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; data not ready
						n_fsm_tx_start_pulse <= '1';
					else
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"EE";
					end if;
				elsif i_cmd_error_pulse = '1' then
					if i_tx_busy = '0' then
						n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; opcode not understood
						n_fsm_tx_start_pulse <= '1';
					else
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"EE";
					end if;
				end if;
				
			when DONE => 
				if i_capture_cmd_pulse = '1' then
					n_state <= CAPTURE;
					n_capture_start_pulse <= '1';
					if i_tx_busy = '0' then
						n_fsm_tx_status_byte <= x"55";  -- 0x55 (OK), 0b01010101
						n_fsm_tx_start_pulse <= '1';
					else
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"55";
					end if;
				elsif i_read_cmd_pulse = '1' then
					n_state <= SEND;
					n_send_start_pulse <= '1';
				elsif i_cmd_error_pulse = '1' then
					if i_tx_busy = '0' then
						n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; opcode not understood
						n_fsm_tx_start_pulse <= '1';
					else
						n_status_pending_valid <= '1';
						n_status_pending_byte <= x"EE";
					end if;
				end if;
				
			when SEND => 
				if i_send_done_pulse = '1' then 
					n_state <= IDLE;
					-- no error handling in state SEND (0xEE won't be sent as data is being streamed)
				end if;
		end case;
		
		-- Watchdog logic: prevents getting stuck in CAPTURE or SEND
		if n_state = CAPTURE and r_state = IDLE then
			n_wd_count <= 0;
		elsif n_state = SEND and r_state = IDLE then
			n_wd_count <= 0;
		elsif (n_state = CAPTURE and r_state = CAPTURE) then
			if r_wd_count >= WD_LIMIT_CAPTURE then
				n_wd_count <= 0;
			else
				n_wd_count <= r_wd_count + 1;
			end if;
		elsif (n_state = SEND and r_state = SEND) then
			if r_wd_count >= WD_LIMIT_SEND then
				n_wd_count <= 0;
			else
				n_wd_count <= r_wd_count + 1;
			end if;
		else  -- for states IDLE and DONE, reset Watchdog counter
			n_wd_count <= 0;
		end if;
		
		if wd_timeout = '1' then
			n_state <= IDLE;
			if i_tx_busy = '0' then
				n_fsm_tx_status_byte <= x"DD";  -- 0xDD (WATCHDOG ERROR), 0b11011101; watchdog triggered
				n_fsm_tx_start_pulse <= '1';
			else
				n_status_pending_valid <= '1';
				n_status_pending_byte <= x"DD";
			end if;
		end if;
	end process fsm_proc;
	
	
	-- Watchdog timeout
	wd_timeout <= '1' when 	(r_state = CAPTURE and r_wd_count >= WD_LIMIT_CAPTURE) or 
							(r_state = SEND and r_wd_count >= WD_LIMIT_SEND)
							else '0';
	
	
	-- Set outputs
	o_capture_start_pulse <= r_capture_start_pulse;
	o_send_start_pulse <= r_send_start_pulse;
	o_fsm_tx_status_byte <= r_fsm_tx_status_byte;
	o_fsm_tx_start_pulse <= r_fsm_tx_start_pulse;
	o_USER_LED <= r_USER_LED;

end architecture RTL;
