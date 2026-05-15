-- ========================================
-- MODULE: analyzer_fsm.vhd
-- FUNCTION: manages the logic analyzer state machine
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-12 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- LAST MODIFIED: 2026-05-15 (watchdog)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_cmd_error_pulse		1 bit		<- cmd_parser
-- i_capture_cmd_pulse		1 bit		<- cmd_parser
-- i_capture_done_pulse		1 bit		<- capture_engine
-- i_read_cmd_pulse			1 bit		<- cmd_parser
-- i_send_done_pulse		1 bit		<- send_engine
--
-- OUTPUTS					DATA		TO MODULE
-- o_capture_start_pulse	1 bit		-> capture_engine
-- o_send_start_pulse		1 bit		-> send_engine
-- o_fsm_tx_status_byte		8 bits		-> tx_mux
-- o_fsm_tx_start_pulse		1 bit		-> tx_mux
-- o_USER_LED				1 bit		-> top
--
-- NOTES
-- Status bytes from analyzer_fsm are prioritised over data from send_engine, because they're singular bytes and come rarely.
-- Thus, analyzer_fsm sends data to tx_mux regardless of uart_tx state (busy/ready)
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
		i_rst 					: in  std_logic;
		i_cmd_error_pulse		: in  std_logic;
		i_capture_cmd_pulse		: in  std_logic;
		i_capture_done_pulse	: in  std_logic;
		i_read_cmd_pulse		: in  std_logic;
		i_send_done_pulse		: in  std_logic;
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
	signal r_wd_count, n_wd_count : unsigned(21 downto 0) := (others => '0');											-- Watchdog
	signal r_wd_timeout, n_wd_timeout : std_logic := '0'; 																-- Watchdog
	
	-- Watchdog limits
	-- WD LIMIT for CAPTURE: capture takes 8192 clock cycles. Set limit to 100k to have plenty of margin to avoid false WD trip, and stay within 22 bit width
	constant WD_LIMIT_CAPTURE 	: unsigned(21 downto 0) := to_unsigned(100_000, r_wd_count'length);		-- CAPTURE timeout after 100k clock cycles
	-- WD LIMIT for SEND: send takes 2_129_920 clock cycles. Set limit to 4M to avoid false WD trip and stay within 2^22 to keep 22 bit counter width
	constant WD_LIMIT_SEND		: unsigned(21 downto 0) := to_unsigned(4_000_000, r_wd_count'length);  	-- SEND timeout after 4M clock cycles
	
begin
	-- Sequential process to update r_state and deal with clocking and reset logic
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '0' then
				r_state <= IDLE;
				r_fsm_tx_status_byte <= (others => '0');
				r_fsm_tx_start_pulse <= '0';
				r_capture_start_pulse <= '0';
				r_send_start_pulse <= '0';
				r_USER_LED <= '0';
				r_wd_count <= (others => '0');
				r_wd_timeout <= '0';
			else
				r_state <= n_state;
				r_fsm_tx_status_byte <= n_fsm_tx_status_byte;
				r_fsm_tx_start_pulse <= n_fsm_tx_start_pulse;
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
	begin
		-- Defaults
		n_state <= r_state;
		n_fsm_tx_status_byte <= r_fsm_tx_status_byte;
		n_fsm_tx_start_pulse <= '0';
		n_capture_start_pulse <= '0';
		n_send_start_pulse <= '0';
		n_USER_LED <= r_USER_LED;
		n_wd_count <= r_wd_count;
		n_wd_timeout <= r_wd_timeout;
		
		case r_state is
			when IDLE =>
				if i_capture_cmd_pulse = '1' then
					n_capture_start_pulse <= '1';
					n_state <= CAPTURE;
					n_fsm_tx_status_byte <= x"55";  -- 0x55 (OK), 0b01010101
					n_fsm_tx_start_pulse <= '1';
				elsif i_read_cmd_pulse = '1' then
					n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; data not ready
					n_fsm_tx_start_pulse <= '1';
				elsif i_cmd_error_pulse = '1' then
					n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; opcode not understood
					n_fsm_tx_start_pulse <= '1';
				end if;
				
			when CAPTURE =>
				if i_capture_done_pulse = '1' then
					n_USER_LED <= not r_USER_LED;  -- toggle the LED once CAPTURE is complete
					n_state <= DONE;
					n_fsm_tx_status_byte <= x"77";  -- 0x77 (DONE), 0b01110111
					n_fsm_tx_start_pulse <= '1';
				elsif i_capture_cmd_pulse = '1' then
					n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; already capturing
					n_fsm_tx_start_pulse <= '1';
				elsif i_read_cmd_pulse = '1' then
					n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; data not ready
					n_fsm_tx_start_pulse <= '1';
				elsif i_cmd_error_pulse = '1' then
					n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; opcode not understood
					n_fsm_tx_start_pulse <= '1';
				end if;
				
			when DONE => 
				if i_capture_cmd_pulse = '1' then
					n_capture_start_pulse <= '1';
					n_state <= CAPTURE;
					n_fsm_tx_status_byte <= x"55";  -- 0x55 (OK), 0b01010101
					n_fsm_tx_start_pulse <= '1';
				elsif i_read_cmd_pulse = '1' then
					n_state <= SEND;
					n_send_start_pulse <= '1';
				elsif i_cmd_error_pulse = '1' then
					n_fsm_tx_status_byte <= x"EE";  -- 0xEE (ERROR), 0b11101110; opcode not understood
					n_fsm_tx_start_pulse <= '1';
				end if;
				
			when SEND => 
				if i_send_done_pulse = '1' then 
					n_state <= IDLE;
					-- no error handling in state SEND (0xEE won't be sent as data is being streamed)
				end if;
		end case;
		
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
			n_fsm_tx_status_byte <= x"DD";  -- 0xDD (WATCHDOG ERROR), 0b11011101; watchdog triggered
			n_fsm_tx_start_pulse <= '1';
		end if;
	end process fsm_proc;
	
	
	-- Set outputs
	o_capture_start_pulse <= r_capture_start_pulse;
	o_send_start_pulse <= r_send_start_pulse;
	o_fsm_tx_status_byte <= r_fsm_tx_status_byte;
	o_fsm_tx_start_pulse <= r_fsm_tx_start_pulse;
	o_USER_LED <= r_USER_LED;

end architecture RTL;
