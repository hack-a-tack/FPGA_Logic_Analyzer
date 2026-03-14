-- ========================================
-- MODULE: trace_buffer.vhd
-- FUNCTION: writes sample data to RAM and reads captured data out to host
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-14 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_ram_wr_en_pulse		1 bit 		<- capture_engine
-- i_ram_wr_addr			12 bits		<- capture_engine
-- i_ram_wr_data [din]		8 bits		<- capture_engine
-- i_ram_rd_addr			12 bits		<- send_engine
--
-- OUTPUTS					DATA		TO MODULE
-- o_ram_rd_data [dout]		8 bits		-> send_engine
--
-- NOTES
-- Synchronous simple dual-port RAM (separate read/write addresses, same clock signal)
-- Be aware: reading to and writing from the same address at the same time can be problematic.
-- ... but should be okay in this design, as writing to RAM and reading from RAM happens in different states of the main FSM.
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trace_buffer_tb is
end entity trace_buffer_tb;

architecture sim of trace_buffer_tb is
    -- Component declaration (optional in VHDL-2008)
    component trace_buffer
		generic (
			ADDR_LENGTH : integer := 12;
			NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 4096
			DATA_LENGTH : integer := 8
		);
        port(
			i_clk					: in  std_logic;
			i_rst					: in  std_logic;
			i_ram_wr_en_pulse		: in  std_logic;
			i_ram_wr_addr			: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
			i_ram_wr_data			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
			i_ram_rd_addr			: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
			o_ram_rd_data			: out std_logic_vector(DATA_LENGTH-1 downto 0)
        );
    end component;
	
	-- Constant declaration
	constant ADDR_LENGTH : integer := 12;
	constant NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 4096
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  -- ~20.8 ns

    -- Signals to connect to DUT
	signal i_clk					: std_logic := '0';
	signal i_rst					: std_logic := '0';	
	signal i_ram_wr_en_pulse		: std_logic := '0';
	signal i_ram_wr_addr			: std_logic_vector(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal i_ram_wr_data			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal i_ram_rd_addr			: std_logic_vector(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal o_ram_rd_data			: std_logic_vector(DATA_LENGTH-1 downto 0);  -- don't set default value on output signal

begin

    -- DUT Instantiation
    uut: trace_buffer
        port map (			
			i_clk => i_clk,
			i_rst => i_rst,
			i_ram_wr_en_pulse => i_ram_wr_en_pulse,
			i_ram_wr_addr => i_ram_wr_addr,
			i_ram_wr_data => i_ram_wr_data,
			i_ram_rd_addr => i_ram_rd_addr,
			o_ram_rd_data => o_ram_rd_data
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
		
		-- Test case 1: write to one address, read it back | write enable, valid data, same read/write address
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '1';
		i_ram_wr_data <= x"BE";
		i_ram_wr_addr <= x"111";
		wait until rising_edge(i_clk);  -- set rd_addr in next clock cycle to avoid ambigious same-cycle rd/wr behaviour
		i_ram_wr_en_pulse <= '0';
		i_ram_rd_addr <= x"111";		-- i_ram_rd_addr updates before next edge
		wait until rising_edge(i_clk);	-- DUT samples at edge, registered output (o_ram_rd_data) updates after edge
		assert o_ram_rd_data = x"BE"
			report "expected data byte xBE | not observed"
			severity error;
		
		-- Test case 2: NO write enable pulse, valid write data, the same write address and read address
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '0';
		i_ram_wr_data <= x"AA";
		i_ram_wr_addr <= x"111";
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '0';
		i_ram_rd_addr <= x"111";
		wait until rising_edge(i_clk);
		assert o_ram_rd_data = x"BE"
			report "expected data byte xBE as it should not have been updated"
			severity error;
		
		-- Test case 3: reset clears output
		wait until rising_edge(i_clk);
		i_rst <= '1';
		wait until rising_edge(i_clk);
		i_rst <= '0';
		assert o_ram_rd_data = x"00"
			report "expected data byte x00 after reset | not observed"
			severity error;
		
		-- Test case 4: write to multiple addresses, read each back
		-- WRITE
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '1';
		i_ram_wr_data <= x"11";
		i_ram_wr_addr <= x"001";
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '0';
		
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '1';
		i_ram_wr_data <= x"22";
		i_ram_wr_addr <= x"002";
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '0';
		
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '1';
		i_ram_wr_data <= x"33";
		i_ram_wr_addr <= x"003";
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '0';
		
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '1';
		i_ram_wr_data <= x"44";
		i_ram_wr_addr <= x"004";
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '0';
		
		-- READ
		i_ram_rd_addr <= x"001";
		wait until rising_edge(i_clk);
		assert o_ram_rd_data = x"11"
			report "expected data byte x11 | not observed"
			severity error;
			
		i_ram_rd_addr <= x"002";
		wait until rising_edge(i_clk);
		assert o_ram_rd_data = x"22"
			report "expected data byte x22 | not observed"
			severity error;
			
		i_ram_rd_addr <= x"003";
		wait until rising_edge(i_clk);
		assert o_ram_rd_data = x"33"
			report "expected data byte x33 | not observed"
			severity error;
		
		i_ram_rd_addr <= x"004";
		wait until rising_edge(i_clk);
		assert o_ram_rd_data = x"44"
			report "expected data byte x44 | not observed"
			severity error;
		
		-- Test case 5: overwrite an address, confirm new value
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '1';
		i_ram_wr_data <= x"99";
		i_ram_wr_addr <= x"001";
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '0';
		i_ram_rd_addr <= x"001";
		wait until rising_edge(i_clk);
		assert o_ram_rd_data = x"99"
			report "expected data byte x99 after overwrite | not observed"
			severity error;
			
		-- Test case 6: read an unwritten address - documentation-only observation
		wait until rising_edge(i_clk);
		i_ram_rd_addr <= x"999";
		wait until rising_edge(i_clk);
		-- output (data at given address) is undefined until initialised/written
		
		-- Test case 7: same-cycle read/write edge case
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '1';
		i_ram_wr_data <= x"77";
		i_ram_wr_addr <= x"777";
		i_ram_rd_addr <= x"777";
		wait until rising_edge(i_clk);
		i_ram_wr_en_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_ram_rd_data = x"77"
			report "expected data byte x77 after same-cycle rd/wr | not observed"
			severity error;
		
        -- Finish simulation
        wait for 5*CLK_PERIOD;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
