-- ========================================
-- MODULE: cmd_parser_tb.vhd
-- FUNCTION: TESTBENCH for entity which decodes opcodes and outputs one-cycle command pulses
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-13 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_rx_byte				8 bits 		<- uart_rx
-- i_rx_valid_pulse			1 bit		<- uart_rx
--
-- OUTPUTS					DATA		TO MODULE
-- o_capture_cmd_pulse		1 bit		-> analyzer_fsm
-- o_read_cmd_pulse			1 bit		-> analyzer_fsm
-- o_cmd_error_pulse		1 bit		-> analyzer_fsm
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cmd_parser_tb is
end entity cmd_parser_tb;

architecture sim of cmd_parser_tb is
    -- Component declaration (optional in VHDL-2008)
    component cmd_parser
		generic (
			DATA_LENGTH : integer := 8
		);
        port(
			i_clk					: in  std_logic;
			i_rst					: in  std_logic;
			i_rx_byte				: in  std_logic_vector(DATA_LENGTH-1 downto 0);
			i_rx_valid_pulse		: in  std_logic;
			o_capture_cmd_pulse		: out std_logic;
			o_read_cmd_pulse		: out std_logic;
			o_cmd_error_pulse		: out std_logic
        );
    end component;
	
	-- Constant declaration
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  -- ~20.8 ns

    -- Signals to connect to DUT
	signal i_clk					: std_logic := '0';
	signal i_rst					: std_logic := '0';
	signal i_rx_byte				: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal i_rx_valid_pulse			: std_logic := '0';
	signal o_capture_cmd_pulse		: std_logic;
	signal o_read_cmd_pulse			: std_logic;
	signal o_cmd_error_pulse		: std_logic;

begin

    -- DUT Instantiation
    uut: cmd_parser
        port map (			
			i_clk => i_clk,
			i_rst => i_rst,
			i_rx_byte => i_rx_byte,
			i_rx_valid_pulse => i_rx_valid_pulse,
			o_capture_cmd_pulse => o_capture_cmd_pulse,
			o_read_cmd_pulse => o_read_cmd_pulse,
			o_cmd_error_pulse => o_cmd_error_pulse
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
		
		-- Test case 1a: CAPTURE command in, expecting corresponding pulse out
		wait until rising_edge(i_clk);
		i_rx_byte <= x"A0";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		i_rx_valid_pulse <= '0';
		assert o_capture_cmd_pulse = '1'
			report "expected capture pulse on output | not observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
			
		-- Test case 1b: check pulse-width is 1 cycle (output returns low after 1 clock cycle)
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
			
        -- Test case 2a: READ command in, expecting corresponding pulse out
		wait until rising_edge(i_clk);
		i_rx_byte <= x"A1";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		i_rx_valid_pulse <= '0';
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '1'
			report "expected read pulse on output | not observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
		
		-- Test case 2b: check pulse-width is 1 cycle (output returns low after 1 clock cycle)
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
				
		-- Test case 3a: invalid/unknown command in, expecting error pulse out
		wait until rising_edge(i_clk);
		i_rx_byte <= x"55";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		i_rx_valid_pulse <= '0';
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '1'
			report "expected error pulse on output | not observed"
			severity error;
		
		-- Test case 3b: check pulse-width is 1 cycle (output returns low after 1 clock cycle)
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
		
		-- Test case 4: valid byte in but rx_valid = '0'; expecting no pulse
		wait until rising_edge(i_clk);
		i_rx_byte <= x"A0";
		i_rx_valid_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
		
		-- Test case 5: back-to-back commands (noise bytes between commands), expecting pulses every clock
		-- Command stream: 99 A0 55(no valid pulse) A1 EE A0
		wait until rising_edge(i_clk);
		i_rx_byte <= x"99";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '1'
			report "expected error pulse on output | not observed"
			severity error;
		
		i_rx_byte <= x"A0";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '1'
			report "expected capture pulse on output | not observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
			
		i_rx_byte <= x"55";
		i_rx_valid_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
		
		i_rx_byte <= x"A1";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '1'
			report "expected read pulse on output | not observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
			
		i_rx_byte <= x"EE";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '1'
			report "expected error pulse on output | not observed"
			severity error;
		
		i_rx_byte <= x"A0";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '1'
			report "expected capture pulse on output | not observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
		
		-- Test case 6: back-to-back commands (multiple identical commands in a row), expecting pulses every clock
		-- Command stream: A0 A0 A0(no valid pulse) A0
		wait until rising_edge(i_clk);
		i_rx_byte <= x"A0";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '1'
			report "expected capture pulse on output | not observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
			
		i_rx_byte <= x"A0";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '1'
			report "expected capture pulse on output | not observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
		
		i_rx_byte <= x"A0";
		i_rx_valid_pulse <= '0';  -- no valid pulse for this one
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '0'
			report "expected NO capture pulse on output, but this was observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
		
		i_rx_byte <= x"A0";
		i_rx_valid_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_capture_cmd_pulse = '1'
			report "expected capture pulse on output | not observed"
			severity error;
		assert o_read_cmd_pulse = '0'
			report "expected NO read pulse on output, but this was observed"
			severity error;
		assert o_cmd_error_pulse = '0'
			report "expected NO error pulse on output, but this was observed"
			severity error;
		
        -- Finish simulation
        wait for 5*CLK_PERIOD;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
