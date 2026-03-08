-- ========================================
-- MODULE: uart_tx.vhd
-- FUNCTION: transmits data from logic analyzer to host via UART (i.e. serially)
-- AUTHOR: Jakob Kieszek Ottesen
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking module
-- i_rst					1 bit		<- top
-- i_mux_tx_byte			8 bits 		<- tx_mux
-- i_mux_tx_start_pulse		1 bit		<- tx_mux
--
-- OUTPUTS					DATA		TO MODULE
-- o_tx_busy				1 bit		-> analyzer_fsm ; send_engine
-- o_UART_TX				1 bit		-> top
-- o_UART_TX_LED			1 bit		-> top
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

entity uart_tx is
	port (
		i_clk					: in  std_logic;
		i_rst					: in  std_logic;
		i_mux_tx_byte			: in  std_logic_vector(7 downto 0);
		i_mux_tx_start_pulse	: in  std_logic;
		o_tx_busy				: out std_logic;
		o_UART_TX				: out std_logic;
		o_UART_TX_LED			: out std_logic
	);
end entity uart_tx;

architecture RTL of uart_tx is
begin
end architecture RTL;
