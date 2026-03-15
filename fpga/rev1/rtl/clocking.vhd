-- ========================================
-- MODULE: clocking.vhd
-- FUNCTION: generates clock and sampling signal
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-13 (YYYY-MM-DD)
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
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clocking is
	port (
		o_clk		: out std_logic;
		o_samp_tick	: out std_logic
	);
end entity clocking;
	
architecture RTL of clocking is
	-- Primitive instantiation: high frequency oscillator (SB_HFOSC)
	component SB_HFOSC is
		generic (
			CLKHF_DIV : string := "0b00"  -- 0b00=48MHz, 0b01=24MHz, 0b10=12MHz, 0b11=6MHz
		);
		port (
			CLKHFEN : in  std_logic;
			CLKHFPU	: in  std_logic;
			CLKHF  	: out std_logic
		);
	end component SB_HFOSC;
	
	-- registered signals
	signal CLK : std_logic;
	signal r_samp_tick : std_logic := '0';
	
begin
	o_clk <= CLK;

	-- Use primitive to generate 48MHz o_clk signal
	OSC: SB_HFOSC port map(
		CLKHFEN	=> '1',
		CLKHFPU => '1',
		CLKHF	=> CLK
	);
	
	-- Process for generating pulse at 24MHz sampling rate
	samp_gen_proc: process(CLK) is
	begin
		if rising_edge(CLK) then
			r_samp_tick <= not r_samp_tick;
		end if;
	end process samp_gen_proc;
	
	o_samp_tick <= r_samp_tick;
	
end architecture RTL;
