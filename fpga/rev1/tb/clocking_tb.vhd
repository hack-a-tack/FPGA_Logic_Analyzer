-- ========================================
-- MODULE: clocking_tb.vhd
-- FUNCTION: TESTBENCH for entity which generates clock and sampling signal
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-14 (YYYY-MM-DD)
--
-- INPUTS (no inputs, data is generated and given to other modules)
--
-- OUTPUTS					DATA		TO MODULE
-- o_clk					1 bit		-> uart_rx | cmd_parser | analyzer_fsm | capture_engine | send_engine | tx_mux | uart_tx
-- o_samp_tick				1 bit		-> capture_engine | analyzer_fsm
--
-- NOTES
-- SB_HFOSC instantiation --> iCE40UP5K primitive
-- The main o_clk signal is 48MHz
-- The o_samp_tick signal is a one-clock-cycle enable pulse occurring every two clock cycles, giving a 24MHz sampling rate
-- It might be difficult to simulate clocking_tb since the architecture includes a lattice primitive...
-- Regardless, simulation will be attempted, and if it proves tedious, it will be neglected for this module
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clocking_tb is
end entity clocking_tb;

architecture sim of clocking_tb is
    -- Component declaration (optional in VHDL-2008)
    component clocking
        port(
			o_clk		: out std_logic;
			o_samp_tick	: out std_logic
        );
    end component;
	
	-- Constant declaration
	constant CLK_FREQ   : real := 48e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  -- ~20.8 ns

    -- Signals to connect to DUT
	signal o_clk		: std_logic;
	signal o_samp_tick	: std_logic;

begin

    -- DUT Instantiation
    uut: clocking
        port map (
			o_clk => o_clk,
			o_samp_tick => o_samp_tick
        );

    -- Stimulus process
    stim_proc: process is		
    begin		
		-- Test case 1: o_samp_tick has 24MHz from 48MHz o_clk signal
		if o_samp_tick = '0' then
			for i in range 0 to 20 loop
				wait until rising_edge(o_clk);
				wait until rising_edge(o_clk);
				assert o_samp_tick = '1'
					report "expected rising edge and high signal on o_samp_tick | not observed"
					severity error;
				wait until rising_edge(o_clk);
				wait until rising_edge(o_clk);
				assert o_samp_tick = '0'
					report "expected falling edge and low signal on o_samp_tick | not observed"
					severity error;
			end loop;
		end if;
		wait until rising_edge(o_clk);
		
        -- Finish simulation
        wait for 5*CLK_PERIOD;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
