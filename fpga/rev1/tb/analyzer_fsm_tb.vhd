-- ========================================
-- MODULE: analyzer_fsm_tb.vhd
-- FUNCTION: TESTBENCH for controlling entity of logic analyzer state machine
-- AUTHOR: Jakob Kieszek Ottesen
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
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity analyzer_fsm_tb is
end entity analyzer_fsm_tb;

architecture sim of analyzer_fsm_tb is
    -- Component declaration (optional in VHDL-2008)
    component analyzer_fsm
        port(
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
    end component;
	
	-- Constant declaration
	constant CLK_FREQ   : real := 48e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;

    -- Signals to connect to DUT
	signal i_clk 					: std_logic := '0';
	signal i_samp_tick 				: std_logic := '0';
	signal i_rst 					: std_logic := '0';
	signal i_cmd_error_pulse		: std_logic := '0';
	signal i_capture_cmd_pulse		: std_logic := '0';
	signal i_capture_done_pulse		: std_logic := '0';
	signal i_read_cmd_pulse			: std_logic := '0';
	signal i_send_done_pulse		: std_logic := '0';
	signal o_capture_start_pulse	: std_logic := '0';
	signal o_send_start_pulse		: std_logic := '0';
	signal o_fsm_tx_status_byte		: std_logic_vector(7 downto 0) := (others => '0');
	signal o_fsm_tx_start_pulse		: std_logic := '0';
	signal o_USER_LED				: std_logic := '0';

begin

    -- DUT Instantiation
    uut: analyzer_fsm
        port map (
            i_clk => i_clk,
			i_samp_tick => i_samp_tick,
			i_rst => i_rst,
			i_cmd_error_pulse => i_cmd_error_pulse,
			i_capture_cmd_pulse => i_capture_cmd_pulse,
			i_capture_done_pulse => i_capture_done_pulse,
			i_read_cmd_pulse => i_read_cmd_pulse,
			i_send_done_pulse => i_send_done_pulse,
			o_capture_start_pulse => o_capture_start_pulse,
			o_send_start_pulse => o_send_start_pulse,
			o_fsm_tx_status_byte => o_fsm_tx_status_byte,
			o_fsm_tx_start_pulse => o_fsm_tx_start_pulse,
			o_USER_LED => o_USER_LED
        );

    -- Clock generation
    clk_process: process is
    begin
        while true loop
            i_clk <= '0';
            wait for CLK_PERIOD / 2;
            i_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process is
    begin
        -- Reset phase
        wait for 2*CLK_PERIOD;
		i_rst <= '1';
		wait for 5*CLK_PERIOD;
		i_rst <= '0';
		
        -- Test case 1
        i_cmd_error_pulse <= '1';
        wait for CLK_PERIOD;
		i_cmd_error_pulse <= '0';

        -- Test case 2
        i_capture_cmd_pulse <= '1';
        wait for CLK_PERIOD;
		i_capture_cmd_pulse <= '0';
		
		-- Test case 3
        i_capture_done_pulse <= '1';
        wait for CLK_PERIOD;
		i_capture_done_pulse <= '0';
		
		-- Test case 4
        i_read_cmd_pulse <= '1';
        wait for CLK_PERIOD;
		i_read_cmd_pulse <= '0';
		
		-- Test case 5
        i_send_done_pulse <= '1';
        wait for CLK_PERIOD;
		i_send_done_pulse <= '0';

        -- Finish simulation
        wait for 5*CLK_PERIOD;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
