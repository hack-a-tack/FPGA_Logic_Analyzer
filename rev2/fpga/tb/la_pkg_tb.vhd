-- ========================================
-- MODULE: la_pkg_tb.vhd
-- FUNCTION: TESTBENCH for la_pkg's crc16_next and f_clks_per_bit functions
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-08-25 (YYYY-MM-DD)
--
-- NOTES
-- la_pkg has no entity, no ports and no clock. It is a package of pure functions,
-- not hardware. There is no DUT to instantiate and nothing to reset. A single
-- process runs every test case at time 0 and stops.
--
-- This is deliberately the smallest possible testbench in this project: it proves
-- the ModelSim flow (rev2/fpga/run_tb.bat) works end to end before any real DUT is
-- tested, and it verifies the two functions every other module's testbench will
-- implicitly depend on (frame_tx and rx_frame_parser both use crc16_next; uart_tx
-- and uart_rx both use f_clks_per_bit).
--
-- TEST CASES
-- TC1: crc16_next conformance vector. CRC-16/CCITT-FALSE's published check value.
--      Feeding ASCII "123456789" from init 0xFFFF must produce 0x29B1. This is the
--      standard test vector for this exact CRC variant (poly 0x1021, init 0xFFFF,
--      no reflection, xorout 0x0000). If this fails, crc16_next itself is wrong,
--      not just this testbench.
-- TC2: crc16_next single-byte regression anchor. crc16_next(0xFFFF, 0x00) is fixed
--      at 0xE1F0 (independently computed, not read off a first run) so a future
--      change to the function is caught even if it doesn't touch the conformance
--      vector.
-- TC3: crc16_next purity. Calling it twice with identical inputs must give
--      identical outputs. This guards against a future change accidentally introducing
--      a hidden state.
-- TC4: f_clks_per_bit's four-way mapping, including the documented "11" fallback.
--
-- PREFIXES
-- v_ : variable
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.la_pkg.ALL;

entity la_pkg_tb is
end entity la_pkg_tb;

architecture sim of la_pkg_tb is
begin

	stim_proc: process is
		variable v_checks   : integer := 0;
		variable v_passes   : integer := 0;
		variable v_failures : integer := 0;

		-- Shared check helper: every test case routes through this, so every check is
		-- a real VHDL assert with a descriptive message, and the pass/fail counters
		-- can never drift out of sync with what was actually asserted.
		procedure check(
			constant condition   : in boolean;
			constant description : in string
		) is
		begin
			v_checks := v_checks + 1;
			if condition then
				v_passes := v_passes + 1;
			else
				v_failures := v_failures + 1;
			end if;
			assert condition
				report "FAIL: " & description
				severity error;
		end procedure check;

		-- TC1: crc16_next conformance vector
		procedure tc1_crc_conformance_vector is
			variable v_crc    : std_logic_vector(15 downto 0);
			constant C_VECTOR : string := "123456789";
		begin
			v_crc := C_CRC_INIT;  -- 0xFFFF
			for i in C_VECTOR'range loop
				v_crc := crc16_next(v_crc, std_logic_vector(to_unsigned(character'pos(C_VECTOR(i)), 8)));
			end loop;

			report "TC1: crc16_next(""123456789"") from 0xFFFF = 0x" & to_hstring(v_crc);

			check(v_crc = x"29B1",
				"TC1 crc16_next conformance vector: ""123456789"" from 0xFFFF must give 0x29B1, got 0x" & to_hstring(v_crc));
		end procedure tc1_crc_conformance_vector;

		-- TC2: crc16_next single-byte regression anchor
		procedure tc2_crc_single_byte_anchor is
			variable v_crc : std_logic_vector(15 downto 0);
		begin
			v_crc := crc16_next(C_CRC_INIT, x"00");

			report "TC2: crc16_next(0xFFFF, 0x00) = 0x" & to_hstring(v_crc);

			check(v_crc = x"E1F0",
				"TC2 crc16_next(0xFFFF, 0x00) regression anchor: expected 0xE1F0, got 0x" & to_hstring(v_crc));
		end procedure tc2_crc_single_byte_anchor;

		-- TC3: crc16_next purity
		procedure tc3_crc_purity is
			variable v_a, v_b : std_logic_vector(15 downto 0);
		begin
			v_a := crc16_next(x"FFFF", x"00");
			v_b := crc16_next(x"FFFF", x"00");

			check(v_a = v_b,
				"TC3 crc16_next purity: two calls with identical inputs (0xFFFF, 0x00) must give identical outputs, got 0x" &
				to_hstring(v_a) & " and 0x" & to_hstring(v_b));
		end procedure tc3_crc_purity;

		-- TC4: f_clks_per_bit mapping
		procedure tc4_clks_per_bit_mapping is
		begin
			check(f_clks_per_bit("00") = 52,
				"TC4 f_clks_per_bit(""00"") must be 52 (921,600 baud compatibility rate), got " & integer'image(f_clks_per_bit("00")));
			check(f_clks_per_bit("01") = 12,
				"TC4 f_clks_per_bit(""01"") must be 12 (4 Mbaud), got " & integer'image(f_clks_per_bit("01")));
			check(f_clks_per_bit("10") = 8,
				"TC4 f_clks_per_bit(""10"") must be 8 (6 Mbaud), got " & integer'image(f_clks_per_bit("10")));
			check(f_clks_per_bit("11") = 52,
				"TC4 f_clks_per_bit(""11"") must fall back to 52 (documented safe fallback), got " & integer'image(f_clks_per_bit("11")));
		end procedure tc4_clks_per_bit_mapping;

	begin
		report "====================================================";
		report "la_pkg_tb starting";
		report "====================================================";

		tc1_crc_conformance_vector;
		tc2_crc_single_byte_anchor;
		tc3_crc_purity;
		tc4_clks_per_bit_mapping;

		report "====================================================";
		report "la_pkg_tb summary: " & integer'image(v_checks) & " checks, " &
			integer'image(v_passes) & " passed, " & integer'image(v_failures) & " failed";
		if v_failures = 0 then
			report "TEST PASSED";
		else
			report "TEST FAILED";
		end if;
		report "====================================================";

		std.env.stop(v_failures);
	end process stim_proc;

end architecture sim;
