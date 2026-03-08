-- ========================================
-- Module: tx_mux.vhd
-- Function: multiplexes data signals going to uart_tx (based on priority)
-- Author: Jakob Kieszek Ottesen
--
-- INPUTS:					DATA		FROM MODULE
-- i_clk					: 1 bit		<- clocking module
-- i_rst					: 1 bit		<- top
-- i_fsm_tx_status_byte		: 8 bits 	<- analyzer_fsm
-- i_fsm_tx_start_pulse		: 1 bit		<- analyzer_fsm
-- i_send_tx_byte			: 8 bits	<- send_engine
-- i_send_tx_start_pulse	: 1 bit		<- send_engine
--
-- OUTPUTS:					DATA		TO MODULE
-- o_mux_tx_byte			: 8 bits	-> uart_tx
-- o_mux_tx_start_pulse		: 1 bit		-> uart_tx
--
-- Notes:
-- 
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

entity tx_mux is
	generic (
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk					: in  std_logic;
		i_rst					: in  std_logic;
		i_fsm_tx_status_byte	: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_fsm_tx_start_pulse	: in  std_logic;
		i_send_tx_byte			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_send_tx_start_pulse	: in  std_logic;
		o_mux_tx_byte			: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_mux_tx_start_pulse	: out std_logic
	);
end entity tx_mux;

architecture RTL of tx_mux is
	-- Register signals
	signal r_mux_tx_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal r_mux_tx_start_pulse	: std_logic := '0';
		
begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				-- Reset logic / defaults
				r_mux_tx_byte <= (others => '0');
				r_mux_tx_start_pulse <= '0';
			else
				-- Priority: analyzer_fsm > send_engine
				if i_fsm_tx_start_pulse = '1' then
					r_mux_tx_byte <= i_fsm_tx_status_byte;
					r_mux_tx_start_pulse <= '1';
				elsif i_send_tx_start_pulse = '1' then
					r_mux_tx_byte <= i_send_tx_byte;
					r_mux_tx_start_pulse <= '1';
				else
					r_mux_tx_start_pulse <= '0';
				end if;
			end if;
		end if;
	end process seq_proc;
	
	
	-- Set outputs
	o_mux_tx_byte <= r_mux_tx_byte;
	o_mux_tx_start_pulse <= r_mux_tx_start_pulse;
	
end architecture RTL;
