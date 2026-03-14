-- ========================================
-- MODULE: top.vhd
-- FUNCTION: ties all underlying modules together
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-14 (YYYY-MM-DD)
--
-- INPUTS 					DATA		TO INTERNAL MODULE
-- i_UART_RX				1 bit		-> uart_rx
-- i_ANALYZER_INPUTS		8 bits		-> capture_engine
-- i_RESET					1 bit		-> uart_rx | cmd_parser | analyzer_fsm | capture_engine | send_engine | tx_mux | uart_tx
--
-- OUTPUTS					DATA		FROM INTERNAL MODULE
-- o_UART_TX				1 bit		<- uart_tx
-- o_UART_TX_LED			1 bit		<- uart_tx
-- o_UART_RX_LED			1 bit		<- uart_rx
-- o_USER_LED				1 bit		<- analyzer_fsm
--
-- NOTES
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
	generic (
		DATA_LENGTH : integer := 8
	);
	port (
		i_UART_RX 			: in  std_logic;
		i_ANALYZER_INPUTS	: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_RESET  			: in  std_logic;
		o_UART_TX			: out std_logic;
		o_UART_TX_LED		: out std_logic;
		o_UART_RX_LED		: out std_logic;
		o_USER_LED			: out std_logic
	);
end entity top;
	
architecture RTL of top is
	-- ...
begin

end architecture RTL;
