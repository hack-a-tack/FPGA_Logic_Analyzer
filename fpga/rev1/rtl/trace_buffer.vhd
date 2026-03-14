-- ========================================
-- MODULE: trace_buffer.vhd
-- FUNCTION: writes sample data to BRAM and reads captured data out to host
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-14 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_ram_wr_en_pulse		1 bit 		<- capture_engine
-- i_ram_wr_addr			12 bits		<- capture_engine
-- i_ram_wr_data			8 bits		<- capture_engine
-- i_ram_rd_addr			12 bits		<- send_engine
--
-- OUTPUTS					DATA		TO MODULE
-- o_ram_rd_data			8 bits		-> send_engine
--
-- NOTES
-- Synchronous read --> sequential process
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trace_buffer is
	generic (
		ADDR_LENGTH : integer := 12;
		NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 4096
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk					: in  std_logic;
		i_rst					: in  std_logic;
		i_ram_wr_en_pulse		: in  std_logic;
		i_ram_wr_addr			: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
		i_ram_wr_data			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_ram_rd_addr			: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
		o_ram_rd_data			: out std_logic_vector(DATA_LENGTH-1 downto 0)
	);
end entity trace_buffer;

architecture RTL of trace_buffer is	
	-- Single-port RAM. Code to infer EBR (embedded block ram)
	type mem_type is array(NUM_SAMPLES-1 downto 0) of std_logic_vector(DATA_LENGTH-1 downto 0);  -- 4096 x 8
	signal mem : mem_type;
	
begin
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				o_ram_rd_data <= (others => '0');
			else
				if i_ram_wr_en_pulse = '1' then
					mem(conv_integer(i_ram_wr_addr)) <= i_ram_wr_data;
				end if;
				o_ram_rd_data <= mem(conv_integer(i_ram_rd_addr));
			end if;
		end if;
	end process seq_proc;	
end architecture RTL;
