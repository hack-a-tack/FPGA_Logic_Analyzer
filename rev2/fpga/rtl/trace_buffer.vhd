-- ========================================
-- MODULE: trace_buffer.vhd
-- FUNCTION: writes sample data to RAM and reads captured data out to host
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-14 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-08-03 (rev2)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_capture_width_sel		1 bit		<- capture_engine
-- i_ram_wr_en_pulse		1 bit 		<- capture_engine
-- i_ram_wr_addr			14 bits		<- capture_engine
-- i_ram_wr_data [din]		16 bits		<- capture_engine
-- i_ram_rd_addr			14 bits		<- send_engine
--
-- OUTPUTS					DATA		TO MODULE
-- o_ram_rd_data [dout]		16 bits		-> send_engine
--
-- NOTES
-- Synchronous simple dual-port RAM (separate read/write addresses, same clock signal)
-- Be aware: reading to and writing from the same address at the same time can be problematic.
-- ... but should not cause problems in this design, as writing to/reading from RAM occurs in different states of the main FSM.
--
-- In this module, address referes to sample address, not byte address
	-- 16-channel mode
	-- sample address N:
	-- bank_0[N] = CH7..CH0
	-- bank_1[N] = CH15..CH8
	-- --> Maximum (byte) address: 6143.
	
	-- 8-channel mode
	-- sample address 0 → bank_0[0]
	-- sample address 1 → bank_1[0]
	-- sample address 2 → bank_0[1]
	-- sample address 3 → bank_1[1]
	-- --> Maximum (byte) address: 12,287.

-- PREFIXES					
-- i_ : input
-- o_ : output

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity trace_buffer is
	generic (
		ADDR_LENGTH : integer := 14;
		BANK_DEPTH 	: integer := 6144
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;
		
		-- capture_engine
		i_capture_width_sel		: in  std_logic;
		i_ram_wr_en_pulse		: in  std_logic;
		i_ram_wr_addr			: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
		i_ram_wr_data			: in  std_logic_vector(15 downto 0);
		
		-- send_engine
		i_ram_rd_addr			: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
		o_ram_rd_data			: out std_logic_vector(15 downto 0)
	);
end entity trace_buffer;

architecture RTL of trace_buffer is	
	-- Infer EBRs (embedded block RAM)
	type mem_type is array(0 to BANK_DEPTH-1) of std_logic_vector(7 downto 0);  -- 6144 x 8
	signal r_bank_0 : mem_type;
	signal r_bank_1 : mem_type;
	
begin	
	ram_proc : process(i_clk)
        variable v_bank_addr : integer range 0 to BANK_DEPTH-1;
    begin
        if rising_edge(i_clk) then
            if i_rst_n = '0' then
                -- Reset the registered read output only. Do not reset every RAM location.
                o_ram_rd_data <= (others => '0');

            else
                ------------------------------------------------
                -- Write port
                ------------------------------------------------
                if i_ram_wr_en_pulse = '1' then

                    if i_capture_width_sel = '1' then
                        -- 16-channel mode: one 16-bit sample uses both banks.
                        v_bank_addr := to_integer(unsigned(i_ram_wr_addr));
                        r_bank_0(v_bank_addr) <= i_ram_wr_data(7 downto 0);
                        r_bank_1(v_bank_addr) <= i_ram_wr_data(15 downto 8);

                    else
                        -- 8-channel mode: consecutive samples alternate banks.
                        v_bank_addr := to_integer(unsigned(i_ram_wr_addr(ADDR_LENGTH-1 downto 1)));
                        if i_ram_wr_addr(0) = '0' then
                            r_bank_0(v_bank_addr) <= i_ram_wr_data(7 downto 0);
                        else
                            r_bank_1(v_bank_addr) <= i_ram_wr_data(7 downto 0);
                        end if;
                    end if;
                end if;

                ------------------------------------------------
                -- Synchronous read port
                ------------------------------------------------
                if i_capture_width_sel = '1' then
                    -- 16-channel sample from both banks.
                    v_bank_addr := to_integer(unsigned(i_ram_rd_addr));
                    o_ram_rd_data <= r_bank_1(v_bank_addr) & r_bank_0(v_bank_addr);

                else
                    -- 8-channel sample from alternating banks.
                    v_bank_addr := to_integer(unsigned(i_ram_rd_addr(ADDR_LENGTH-1 downto 1)));
                    if i_ram_rd_addr(0) = '0' then
                        o_ram_rd_data <= x"00" & r_bank_0(v_bank_addr);
                    else
                        o_ram_rd_data <= x"00" & r_bank_1(v_bank_addr);
                    end if;
                end if;
            end if;
        end if;
    end process ram_proc;
	
end architecture RTL;
