-- ========================================
-- MODULE: trace_buffer.vhd
-- FUNCTION: writes sample data to RAM and reads captured data out to host
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-14 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-08-03 (rev2)
-- MODIFIED: 2026-08-20 (restructured ram_proc so each bank has exactly one unconditional read and one unconditional write per clock, with mode selection moved after the read/around the write data and enable instead of around the array access -- fixes a failed Synplify RAM-to-EBR mapping caused by mode-dependent branches around the array reads)
-- MODIFIED: 2026-08-21 (rev2) (o_ram_rd_data now registered after rd_mux_proc instead of driven combinationally from it; read latency is 2 clocks, not 1 -- this was the worst P&R critical path, an unregistered combinational chain running all the way from the RAM read through send_engine/tx_mux into frame_tx's CRC register. send_engine's WAIT_RAM/WAIT_RAM_2 accounts for the extra cycle)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_capture_width_sel		1 bit		<- capture_engine
-- i_ram_wr_en_pulse		1 bit 		<- capture_engine
-- i_ram_wr_data [din]		16 bits		<- capture_engine
-- i_ram_wr_addr			14 bits		<- capture_engine
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
--
-- Each bank array (r_bank_0, r_bank_1) is read exactly once per clock and written exactly once per
-- clock, at one address, regardless of mode. This matters for RAM inference: an earlier version chose
-- which array/address expression to touch from inside mode-dependent if/else branches, which made
-- Synplify infer more than one physical RAM per bank (one per branch) instead of recognising all the
-- branches as the same array read/written two ways. That doubled the real EBR demand, one instance
-- failed to map to block RAM, and the mapper "dissolved" it into ~98k flip-flops, blowing the chip's
-- register budget. The fix: compute one address per bank per port, always touch the array once, and
-- do all mode-dependent selection (which byte range to read out, whether/what to write) on the
-- address, enable and data values instead of on the array access itself. r_bank_0_rd/r_bank_1_rd hold
-- the registered read result of both banks every cycle (reading a bank whose result goes unused in
-- 8-bit mode costs nothing -- it is a second EBR port, not extra logic); rd_mux_proc combines them
-- combinationally, and out_reg_proc registers that result into o_ram_rd_data. Read latency from
-- i_ram_rd_addr to a valid o_ram_rd_data is therefore 2 clocks (RAM read register, then mux
-- register) -- send_engine's WAIT_RAM/WAIT_RAM_2 states account for both.

-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : registered signal
-- s_ : output-only signal driven by a dedicated combinational output process
-- v_ : variable

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
		i_ram_wr_data			: in  std_logic_vector(15 downto 0);
		i_ram_wr_addr			: in  std_logic_vector(ADDR_LENGTH-1 downto 0);

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

	-- Registered read port: raw per-bank read result, plus the mode bits that select how to
	-- combine them, pipelined one cycle to stay aligned with the registered RAM read above.
	signal r_bank_0_rd		: std_logic_vector(7 downto 0) := (others => '0');
	signal r_bank_1_rd		: std_logic_vector(7 downto 0) := (others => '0');
	signal r_rd_width_sel	: std_logic := '0';
	signal r_rd_addr_lsb	: std_logic := '0';

	signal s_ram_rd_data	: std_logic_vector(15 downto 0);
	signal r_ram_rd_data	: std_logic_vector(15 downto 0) := (others => '0');	-- registered mux output; adds the 2nd pipeline stage

begin
	ram_proc : process(i_clk)
        variable v_wr_addr : integer range 0 to BANK_DEPTH-1;
        variable v_rd_addr : integer range 0 to BANK_DEPTH-1;
    begin
        if rising_edge(i_clk) then
            if i_rst_n = '0' then
                -- Reset the registered read pipeline only. Do not reset every RAM location.
                r_bank_0_rd    <= (others => '0');
                r_bank_1_rd    <= (others => '0');
                r_rd_width_sel <= '0';
                r_rd_addr_lsb  <= '0';

            else
                ------------------------------------------------
                -- Write port -- one address per bank, mode only
                -- selects write-enable and write-data, never which
                -- array/address expression gets touched.
                ------------------------------------------------
                if i_capture_width_sel = '1' then
                    v_wr_addr := to_integer(unsigned(i_ram_wr_addr));
                else
                    v_wr_addr := to_integer(unsigned(i_ram_wr_addr(ADDR_LENGTH-1 downto 1)));
                end if;

                -- 16-channel mode: one 16-bit sample uses both banks.
                -- 8-channel mode: consecutive samples alternate banks.
                
                if i_ram_wr_en_pulse = '1' and (i_capture_width_sel = '1' or i_ram_wr_addr(0) = '0') then
                    r_bank_0(v_wr_addr) <= i_ram_wr_data(7 downto 0);
                end if;

                if i_ram_wr_en_pulse = '1' and (i_capture_width_sel = '1' or i_ram_wr_addr(0) = '1') then
                    r_bank_1(v_wr_addr) <= i_ram_wr_data(15 downto 8) when i_capture_width_sel = '1' else i_ram_wr_data(7 downto 0);
                end if;

                ------------------------------------------------
                -- Synchronous read port -- one address, both
                -- banks read unconditionally every cycle. Mode
                -- selection happens afterwards in rd_mux_proc.
                ------------------------------------------------
                if i_capture_width_sel = '1' then
                    v_rd_addr := to_integer(unsigned(i_ram_rd_addr));
                else
                    v_rd_addr := to_integer(unsigned(i_ram_rd_addr(ADDR_LENGTH-1 downto 1)));
                end if;

                r_bank_0_rd    <= r_bank_0(v_rd_addr);
                r_bank_1_rd    <= r_bank_1(v_rd_addr);
                r_rd_width_sel <= i_capture_width_sel;
                r_rd_addr_lsb  <= i_ram_rd_addr(0);
            end if;
        end if;
    end process ram_proc;

	-- Combinational: combine the already-registered bank reads into the reported sample.
	-- Total address-to-output latency is unchanged (one clock) since r_bank_0_rd/r_bank_1_rd
	-- are already registered by the time this runs.
	rd_mux_proc : process(all) is
	begin
		s_ram_rd_data <= (others => '0');

		if r_rd_width_sel = '1' then
			s_ram_rd_data <= r_bank_1_rd & r_bank_0_rd;
		elsif r_rd_addr_lsb = '0' then
			s_ram_rd_data <= x"00" & r_bank_0_rd;
		else
			s_ram_rd_data <= x"00" & r_bank_1_rd;
		end if;
	end process rd_mux_proc;

	-- Registers rd_mux_proc's combinational output, breaking the previously-unregistered
	-- combinational chain that ran from here through send_engine, tx_mux and into frame_tx's CRC
	-- register with no pipeline stage in between (the worst P&R critical path once capture_engine's
	-- and send_engine's own counters were fixed). Read latency is now 2 clocks (RAM read + mux
	-- register here), not 1 -- send_engine's WAIT_RAM/WAIT_RAM_2 accounts for the extra cycle.
	out_reg_proc : process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_ram_rd_data <= (others => '0');
			else
				r_ram_rd_data <= s_ram_rd_data;
			end if;
		end if;
	end process out_reg_proc;

	o_ram_rd_data <= r_ram_rd_data;

end architecture RTL;
