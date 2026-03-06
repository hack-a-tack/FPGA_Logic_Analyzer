-- ========================================
-- Module: analyzer_fsm.vhd
-- Function: manages the logic analyzer state machine
-- Author: Jakob Kieszek Ottesen
--
-- Inputs:
-- i_clk
-- i_samp_tick
-- i_rst
-- i_cmd_error_pulse
-- i_capture_cmd_pulse
-- i_capture_done_pulse
-- i_read_cmd_pulse
-- i_send_done_pulse
--
-- Outputs:
-- o_capture_start_pulse
-- o_send_start_pulse
-- o_fsm_tx_status_byte
-- o_fsm_tx_start_pulse
-- o_USER_LED
--
-- Notes:
-- Watchdog process not implemented
--
-- Prefixes:
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity analyzer_fsm is
	port (
		i_clk 					: in  std_logic;
		i_samp_tick 			: in  std_logic;
		i_rst 					: in  std_logic;
		i_cmd_error_pulse		: in  std_logic;
		i_capture_cmd_pulse		: in  std_logic;
		i_capture_done_pulse	: in  std_logic;
		i_read_cmd_pulse		: in  std_logic;
		i_send_done_pulse		: in  std_logic;
		o_capture_start_pulse	: out std_logic;
		o_send_start_pulse		: out std_logic;
		o_fsm_tx_status_byte	: out std_logic_vector(7 downto 0);
		o_fsm_tx_start_pulse	: out std_logic;
		o_USER_LED				: out std_logic
	);
end entity analyzer_fsm;

architecture RTL of analyzer_fsm is
	type runtime_state_type is (IDLE, CAPTURE, DONE, SEND);
	signal r_state, n_state : runtime_state_type := IDLE;
	
	signal r_fsm_tx_status_byte, n_fsm_tx_status_byte : std_logic_vector(7 downto 0) := (others => '0');
	signal r_fsm_tx_start_pulse, n_fsm_tx_start_pulse : std_logic := '0';
	signal r_capture_start_pulse, n_capture_start_pulse : std_logic := '0';
	signal r_send_start_pulse, n_send_start_pulse : std_logic := '0';
	
	signal r_USER_LED, n_USER_LED : std_logic := '0';
begin

	-- Sequential process to update r_state and deal with clocking and reset logic
	seq_proc: process (i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				r_state <= IDLE;
				r_fsm_tx_status_byte <= (others => '0');
				r_fsm_tx_start_pulse <= '0';
				r_capture_start_pulse <= '0';
				r_send_start_pulse <= '0';
				r_USER_LED <= '0';
			else
				r_state <= n_state;
				r_fsm_tx_status_byte <= n_fsm_tx_status_byte;
				r_fsm_tx_start_pulse <= n_fsm_tx_start_pulse;
				r_capture_start_pulse <= n_capture_start_pulse;
				r_send_start_pulse <= n_send_start_pulse;
				r_USER_LED <= n_USER_LED;
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
		
		case r_state is
			when IDLE =>
				if i_capture_cmd_pulse = '1' then
					n_state <= CAPTURE;
					n_capture_start_pulse <= '1';
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
					n_state <= DONE;
					n_fsm_tx_status_byte <= x"77";  -- 0x77 (DONE), 0b01110111
					n_fsm_tx_start_pulse <= '1';
					n_USER_LED <= not n_USER_LED;  -- toggle the LED once CAPTURE message is received
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
					n_state <= CAPTURE;
					n_capture_start_pulse <= '1';
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
				
			when others =>
				null;
		end case;
	end process fsm_proc;


	-- Watchdog process for counting expected number of samples captured (if state = CAPTURE)
	watchdog_proc: process(i_samp_tick) is
	begin
	end process watchdog_proc;
	
	
	-- Set outputs
	o_capture_start_pulse <= r_capture_start_pulse;
	o_send_start_pulse <= r_send_start_pulse;
	o_fsm_tx_status_byte <= r_fsm_tx_status_byte;
	o_fsm_tx_start_pulse <= r_fsm_tx_start_pulse;
	o_USER_LED <= r_USER_LED;

end architecture RTL;
