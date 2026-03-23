-- ========================================
-- MODULE: analyzer_fsm_tb.vhd
-- FUNCTION: TESTBENCH for controlling entity of logic analyzer state machine
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
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity analyzer_fsm_tb is
end entity analyzer_fsm_tb;

architecture sim of analyzer_fsm_tb is
    -- Component declaration (optional in VHDL-2008)
    component analyzer_fsm
		generic(
			DATA_LENGTH : integer := 8
		);
        port(
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
    end component;
	
	-- Constant declaration
	constant CLK_FREQ_HZ : integer := 48_000_000;
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48.0e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  	-- 20833 ps (truncated)
	constant CLK_HALF : time := CLK_PERIOD / 2;			-- 10416 ps (truncated)
	constant CLK_ACTUAL : time := CLK_HALF * 2;			-- 20832 ps --> identical to 2 x CLK_HALF (used in clock generation)

    -- Signals to connect to DUT
	signal i_clk 					: std_logic := '0';
	signal i_samp_tick 				: std_logic := '0';
	signal i_rst 					: std_logic := '0';
	signal i_cmd_error_pulse		: std_logic := '0';
	signal i_capture_cmd_pulse		: std_logic := '0';
	signal i_capture_done_pulse		: std_logic := '0';
	signal i_read_cmd_pulse			: std_logic := '0';
	signal i_send_done_pulse		: std_logic := '0';
	signal i_tx_busy				: std_logic := '0';
	signal o_capture_start_pulse	: std_logic;
	signal o_send_start_pulse		: std_logic;
	signal o_fsm_tx_status_byte		: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal o_fsm_tx_start_pulse		: std_logic;
	signal o_USER_LED				: std_logic;
	
	-- Signals for easier troubleshooting
	signal test_id : integer := 0;  				-- increments with each test case

begin

    -- DUT Instantiation
    dut: analyzer_fsm
		generic map (
			DATA_LENGTH => DATA_LENGTH
		)
        port map (
            i_clk => i_clk,
			i_samp_tick => i_samp_tick,
			i_rst => i_rst,
			i_cmd_error_pulse => i_cmd_error_pulse,
			i_capture_cmd_pulse => i_capture_cmd_pulse,
			i_capture_done_pulse => i_capture_done_pulse,
			i_read_cmd_pulse => i_read_cmd_pulse,
			i_send_done_pulse => i_send_done_pulse,
			i_tx_busy => i_tx_busy,
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
            wait for CLK_HALF;
            i_clk <= '1';
            wait for CLK_HALF;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process is
    begin
        -- Reset phase
        wait until rising_edge(i_clk);
		i_rst <= '1';
		wait until rising_edge(i_clk);
		i_rst <= '0';
		wait until rising_edge(i_clk);
		
        -- Test case 1: command error received from cmd_parser (should send EE to tx_mux)
		test_id <= 1;
        i_cmd_error_pulse <= '1';
        wait until rising_edge(i_clk);
		assert o_fsm_tx_start_pulse = '1'
			report "TC1: Start pulse not sent to tx_mux"
			severity error;
		assert o_fsm_tx_status_byte = x"EE"
			report "TC1: Status code not updated to 0xEE"
			severity error;
		i_cmd_error_pulse <= '0';
		wait until rising_edge(i_clk);

        -- Test case 2: CAPTURE command from host(cmd_parser) (should prompt capture_engine to start capturing data)
		test_id <= 2;
        i_capture_cmd_pulse <= '1';
        wait until rising_edge(i_clk);
		assert o_capture_start_pulse = '1'
			report "TC2: Start pulse not sent to capture_engine"
			severity error;
		assert o_fsm_tx_start_pulse = '1'
			report "TC2: Start pulse not sent to tx_mux"
			severity error;
		assert o_fsm_tx_status_byte = x"55"
			report "TC2: Status code not updated to 0x55"
			severity error;
		i_capture_cmd_pulse <= '0';
		wait until rising_edge(i_clk);
		
		-- Test case 3: data capture complete
		-- but status byte should not update before uart_tx is available (i_tx_busy = '0')
		test_id <= 3;
		i_tx_busy <= '1';
        i_capture_done_pulse <= '1';
        wait until rising_edge(i_clk);
		assert o_fsm_tx_start_pulse = '0'
			report "TC3: Start pulse prematurely sent to tx_mux (uart_tx is busy)"
			severity error;
		assert o_fsm_tx_status_byte /= x"77"
			report "TC3: Status code prematurely updated to 0x77 (uart_tx is busy!)"
			severity error;
		
		i_capture_done_pulse <= '0';
		i_tx_busy <= '0';
		wait until rising_edge(i_clk);
		assert o_fsm_tx_start_pulse = '1'
			report "TC3: Start pulse not sent to tx_mux"
			severity error;
		assert o_fsm_tx_status_byte = x"77"
			report "TC3: Status code not updated to 0x77 (pending from when uart_tx was busy)"
			severity error;
		
		-- Test case 4: READ command from host (should prompt data transfer) 
        test_id <= 4;
		i_read_cmd_pulse <= '1';
        wait until rising_edge(i_clk);
		assert o_send_start_pulse = '1'
			report "TC4: Start pulse not sent to send_engine"
			severity error;
		i_read_cmd_pulse <= '0';
		wait until rising_edge(i_clk);
		
		-- Test case 5: data transfer complete (FSM goes to IDLE [state is internal signal], nothing to assert)
		test_id <= 5;
        i_send_done_pulse <= '1';
        wait until rising_edge(i_clk);
		i_send_done_pulse <= '0';
		wait until rising_edge(i_clk);

        -- Finish simulation
        wait for 10*CLK_ACTUAL;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
