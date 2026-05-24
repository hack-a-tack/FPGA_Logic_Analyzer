-- ========================================
-- MODULE: SB_HFOSC.vhd
-- FUNCTION: dummy entity for proper simulation of clocking.vhd
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-07 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- CLKHFEN					1 bit		(internal)
-- CLKHFPU					1 bit		(internal)
--
-- OUTPUTS					DATA		TO MODULE
-- CLKHF					1 bit		-> clocking (SB_HFOSC is a dummy module within clocking.vhd)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SB_HFOSC is
	generic (
		CLKHF_DIV : string := "0b00";  -- 0b00=48MHz, 0b01=24MHz, 0b10=12MHz, 0b11=6MHz
		ROUTE_THROUGH_FABRIC : string := "0"
	);
	port (
		CLKHFEN : in  std_logic;
		CLKHFPU : in  std_logic;
		CLKHF 	: out std_logic
	);
end entity SB_HFOSC; 

architecture sim of SB_HFOSC is
	constant HALF : time := 10.4165 ns;  -- 48MHz, 20.833 period
begin
	process
	begin
		CLKHF <= '0';
		wait for HALF;
		while true loop
			CLKHF <= not CLKHF;
			wait for HALF;
		end loop;
	end process;
end;
