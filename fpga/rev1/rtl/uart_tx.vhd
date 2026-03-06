# uart_tx.vhd
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
end architecture RTL of uart_tx;