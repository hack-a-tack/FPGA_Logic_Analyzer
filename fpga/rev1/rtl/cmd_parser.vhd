-- ========================================
-- MODULE: cmd_parser.vhd
-- FUNCTION: decodes opcodes and outputs one-cycle command pulses
-- AUTHOR: Jakob Kieszek Ottesen
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

entity cmd_parser is
	generic (
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk					: in  std_logic;
		i_rst					: in  std_logic;
		i_rx_byte				: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_rx_valid_pulse		: in  std_logic;
		o_capture_cmd_pulse		: out std_logic;
		o_read_cmd_pulse		: out std_logic;
		o_cmd_error_pulse		: out std_logic
	);
end entity cmd_parser;

architecture RTL of cmd_parser is	
	-- Constants representing command bytes
	constant CMD_CAPTURE 	: std_logic_vector(DATA_LENGTH-1 downto 0) := x"A0";
	constant CMD_READ 		: std_logic_vector(DATA_LENGTH-1 downto 0) := x"A1";
	
begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				o_capture_cmd_pulse <= '0';
				o_read_cmd_pulse 	<= '0';
				o_cmd_error_pulse 	<= '0';
			else
				-- Defaults
				o_capture_cmd_pulse <= '0';
				o_read_cmd_pulse 	<= '0';
				o_cmd_error_pulse 	<= '0';
				
				if i_rx_valid_pulse = '1' then
					case i_rx_byte is
						when CMD_CAPTURE 	=> o_capture_cmd_pulse 	<= '1';
						when CMD_READ 		=> o_read_cmd_pulse 	<= '1';
						when others			=> o_cmd_error_pulse 	<= '1';
					end case;
				end if;
			end if;
		end if;
	end process seq_proc;
	
end architecture RTL;
