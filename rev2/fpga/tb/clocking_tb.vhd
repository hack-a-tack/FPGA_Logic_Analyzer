-- ========================================
-- MODULE: clocking_tb.vhd
-- FUNCTION: TESTBENCH for entity which generates the system clock and sampling pulse
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-08-30 (YYYY-MM-DD)
--
-- NOTES
-- clocking.vhd has no i_clk and no i_rst_n port. It generates o_clk itself, via an
-- internal SB_HFOSC component instantiation. This testbench therefore does NOT drive a
-- clock: o_clk is an OUTPUT of the DUT that this testbench only observes. For the
-- SB_HFOSC component to resolve to anything in simulation, rtl/SB_HFOSC.vhd's
-- "architecture sim" stub must also be compiled into the work library (default
-- component-to-entity binding: same entity name, same ports). run_tb.bat compiles it
-- for exactly this DUT, mirroring check.bat's own dependency order
-- (la_pkg.vhd, SB_HFOSC.vhd, clocking.vhd).
--
-- WHY THIS MODULE MATTERS
-- Rev1's samp_tick was documented as a one-cycle 24 MHz pulse but was actually a
-- toggle (a divided square wave, 50% duty). That happened to work at divide-by-2
-- specifically, because "high for one cycle, low for one cycle, repeat" and "a genuine
-- one-cycle pulse every 2 clocks" are the SAME waveform at that one ratio. The bug was
-- invisible there. It becomes visible, and breaks capture, at any slower ratio: a
-- divide-by-4 or divide-by-8 toggle stays high for 2 or 4 consecutive clocks, which
-- would make capture_engine (edge-gated on i_samp_tick) capture the same input sample
-- more than once. TC1 and TC2 exist to catch exactly this class of bug, at all three
-- selectable rates, not just the one rate where it would hide.
--
-- TEST CASES
-- TC1: samp_tick is a genuine one-clock-wide pulse, at all three selectable rates
--      ("00"/24MHz, "01"/12MHz, "10"/6MHz) for every observed pulse, not just the first.
-- TC2: pulse period matches the selected rate (every 2/4/8 o_clk cycles) for every
--      observed interval, not just the first.
-- TC3: i_cfg_sample_rate_sel = "11". The RTL's "when others" branch drives
--      r_samp_tick <= '0' unconditionally. This is well-defined (never pulses), not
--      undefined behaviour. TC3 confirms samp_tick stays low, not that anything is
--      "wrong" with the DUT for this input.
-- TC4: rate change mid-operation ("00" -> "10"). r_div_counter free-runs and is not
--      reset by a rate change, so the interval spanning the transition may be
--      irregular. That's expected and not checked here. What must still hold is
--      pulse WIDTH: no pulse, before or after the transition, is ever more than one
--      clock wide.
-- TC5: initial state. clocking.vhd has no i_rst_n port.
--      The only "reset" is the VHDL signal initializers on r_samp_tick/r_div_counter,
--      matching FPGA power-on/configuration behaviour. TC5 checks the one externally
--      observable consequence: o_samp_tick reads '0' at simulation time 0, before
--      any clock edge. So it must run before anything else lets simulation time or
--      clock edges pass.
-- TC6: o_clk is actually being driven (via the SB_HFOSC simulation stub) and settles
--      to a defined logic level, rather than sitting undriven/unknown.
--
-- PREFIXES
-- v_ : variable
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clocking_tb is
end entity clocking_tb;

architecture sim of clocking_tb is
	signal i_cfg_sample_rate_sel : std_logic_vector(1 downto 0) := "00";
	signal o_clk       : std_logic;
	signal o_samp_tick : std_logic;

	-- Generously sized for the largest single measurement window used below (20 pulses).
	type width_array_t is array(0 to 31) of integer;

begin

	dut: entity WORK.clocking(RTL)
		port map (
			i_cfg_sample_rate_sel => i_cfg_sample_rate_sel,
			o_clk                 => o_clk,
			o_samp_tick           => o_samp_tick
		);

	stim_proc: process is
		variable v_checks   : integer := 0;
		variable v_passes   : integer := 0;
		variable v_failures : integer := 0;

		-- Shared check helper (see la_pkg_tb.vhd for why this exists).
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

		-- Observes n_pulses rising edges of o_samp_tick (assumes i_cfg_sample_rate_sel
		-- is already set to whatever is under test). For pulse p: v_widths(p) is how
		-- many consecutive o_clk cycles it stayed high; v_intervals(p) is how many
		-- o_clk cycles passed since the PREVIOUS pulse's rising edge (garbage at p=0.
		-- There is no previous pulse within this call, callers must not read it).
		-- Does not touch i_cfg_sample_rate_sel itself, so a rate change can be injected
		-- between two calls to observe behaviour spanning the transition (see TC4).
		procedure measure_pulses(
			constant n_pulses    : in  integer;
			variable v_widths    : out width_array_t;
			variable v_intervals : out width_array_t
		) is
			variable v_cycle           : integer := 0;
			variable v_prev_tick       : std_logic := '0';
			variable v_last_edge_cycle : integer := 0;
			variable v_pulse_idx       : integer := 0;
			variable v_width_count     : integer := 0;
			variable v_in_pulse        : boolean := false;
		begin
			while v_pulse_idx < n_pulses loop
				wait until rising_edge(o_clk);
				wait for 1 ns;  -- let the DUT's registered output settle before sampling it

				if o_samp_tick = '1' and v_prev_tick = '0' then
					-- rising edge of samp_tick: a new pulse starts this cycle
					if v_pulse_idx > 0 then
						v_intervals(v_pulse_idx) := v_cycle - v_last_edge_cycle;
					end if;
					v_last_edge_cycle := v_cycle;
					v_in_pulse := true;
					v_width_count := 1;
				elsif v_in_pulse and o_samp_tick = '1' then
					v_width_count := v_width_count + 1;
				elsif v_in_pulse and o_samp_tick = '0' then
					-- pulse just ended
					v_widths(v_pulse_idx) := v_width_count;
					v_in_pulse := false;
					v_pulse_idx := v_pulse_idx + 1;
				end if;

				v_prev_tick := o_samp_tick;
				v_cycle := v_cycle + 1;
			end loop;
		end procedure measure_pulses;

		-- TC1: pulse width is always exactly one o_clk cycle, at all three rates
		procedure tc1_pulse_is_one_cycle_wide is
			variable v_widths, v_intervals : width_array_t;
			constant N_PULSES : integer := 20;
		begin
			i_cfg_sample_rate_sel <= "00";
			measure_pulses(N_PULSES, v_widths, v_intervals);
			for p in 0 to N_PULSES - 1 loop
				check(v_widths(p) = 1,
					"TC1 rate ""00"" (24MHz): pulse " & integer'image(p) & " must be 1 clock wide, got " & integer'image(v_widths(p)));
			end loop;

			i_cfg_sample_rate_sel <= "01";
			measure_pulses(N_PULSES, v_widths, v_intervals);
			for p in 0 to N_PULSES - 1 loop
				check(v_widths(p) = 1,
					"TC1 rate ""01"" (12MHz): pulse " & integer'image(p) & " must be 1 clock wide, got " & integer'image(v_widths(p)));
			end loop;

			i_cfg_sample_rate_sel <= "10";
			measure_pulses(N_PULSES, v_widths, v_intervals);
			for p in 0 to N_PULSES - 1 loop
				check(v_widths(p) = 1,
					"TC1 rate ""10"" (6MHz): pulse " & integer'image(p) & " must be 1 clock wide, got " & integer'image(v_widths(p)));
			end loop;
		end procedure tc1_pulse_is_one_cycle_wide;

		-- TC2: pulse period matches the selected rate, every interval, not just the first
		procedure tc2_pulse_period is
			variable v_widths, v_intervals : width_array_t;
			constant N_PULSES : integer := 20;
		begin
			i_cfg_sample_rate_sel <= "00";
			measure_pulses(N_PULSES, v_widths, v_intervals);
			for p in 1 to N_PULSES - 1 loop
				check(v_intervals(p) = 2,
					"TC2 rate ""00"" (24MHz): interval before pulse " & integer'image(p) & " must be 2 clocks, got " & integer'image(v_intervals(p)));
			end loop;

			i_cfg_sample_rate_sel <= "01";
			measure_pulses(N_PULSES, v_widths, v_intervals);
			for p in 1 to N_PULSES - 1 loop
				check(v_intervals(p) = 4,
					"TC2 rate ""01"" (12MHz): interval before pulse " & integer'image(p) & " must be 4 clocks, got " & integer'image(v_intervals(p)));
			end loop;

			i_cfg_sample_rate_sel <= "10";
			measure_pulses(N_PULSES, v_widths, v_intervals);
			for p in 1 to N_PULSES - 1 loop
				check(v_intervals(p) = 8,
					"TC2 rate ""10"" (6MHz): interval before pulse " & integer'image(p) & " must be 8 clocks, got " & integer'image(v_intervals(p)));
			end loop;
		end procedure tc2_pulse_period;

		-- TC3: rate select "11". RTL's own "when others" branch defines this as
		-- "never pulses", not undefined. Confirm that.
		procedure tc3_invalid_rate_sel_11 is
		begin
			i_cfg_sample_rate_sel <= "11";
			for i in 0 to 31 loop
				wait until rising_edge(o_clk);
				wait for 1 ns;
				check(o_samp_tick = '0',
					"TC3 rate ""11"": samp_tick must stay low (RTL's when-others branch never pulses), cycle " & integer'image(i) & " read " & std_logic'image(o_samp_tick));
			end loop;
		end procedure tc3_invalid_rate_sel_11;

		-- TC4: rate change mid-operation. Only pulse WIDTH is asserted (the interval
		-- spanning the transition is allowed to be irregular since
		-- r_div_counter free-runs and is not reset by a rate change).
		procedure tc4_rate_change_mid_operation is
			variable v_widths, v_intervals : width_array_t;
		begin
			i_cfg_sample_rate_sel <= "00";
			measure_pulses(5, v_widths, v_intervals);
			for p in 0 to 4 loop
				check(v_widths(p) = 1,
					"TC4 pre-transition (rate ""00""): pulse " & integer'image(p) & " must be 1 clock wide, got " & integer'image(v_widths(p)));
			end loop;

			-- Switch mid-operation, immediately, with no settle time -- the point is to
			-- catch the transition itself, not a clean restart at the new rate.
			i_cfg_sample_rate_sel <= "10";
			measure_pulses(15, v_widths, v_intervals);
			for p in 0 to 14 loop
				check(v_widths(p) = 1,
					"TC4 spanning/after transition to rate ""10"": pulse " & integer'image(p) & " must be 1 clock wide, got " & integer'image(v_widths(p)));
			end loop;
		end procedure tc4_rate_change_mid_operation;

		-- TC5: initial state (no reset port). Must run before any other
		-- test case lets simulation time or a clock edge pass.
		procedure tc5_initial_state is
		begin
			-- Delta-cycle settle, not simulated time: o_samp_tick is a port with no
			-- initializer of its own, driven only via the concurrent assignment
			-- "o_samp_tick <= r_samp_tick;". r_samp_tick's own initializer ('0') takes
			-- effect at elaboration, but that value isn't visible through a concurrent
			-- assignment to a reader until the delta cycle after it propagates.
			wait for 0 ns;
			check(o_samp_tick = '0',
				"TC5 initial state: o_samp_tick must be '0' at simulation time 0 (no i_rst_n port; relies on signal initializers), got " & std_logic'image(o_samp_tick));
		end procedure tc5_initial_state;

		-- TC6: o_clk is actually driven and free-running (via the SB_HFOSC sim stub).
		procedure tc6_clk_is_free_running is
		begin
			for i in 0 to 9 loop
				wait until rising_edge(o_clk);
				wait for 1 ns;
				check(o_clk = '0' or o_clk = '1',
					"TC6 o_clk must settle to a defined logic level on edge " & integer'image(i) & ", got " & std_logic'image(o_clk));
			end loop;
		end procedure tc6_clk_is_free_running;

	begin
		report "====================================================";
		report "clocking_tb starting";
		report "====================================================";

		-- TC5 must run first: it asserts on the state at simulation time 0, before any
		-- wait statement (including other test cases') lets time pass.
		tc5_initial_state;
		tc6_clk_is_free_running;
		tc1_pulse_is_one_cycle_wide;
		tc2_pulse_period;
		tc3_invalid_rate_sel_11;
		tc4_rate_change_mid_operation;

		report "====================================================";
		report "clocking_tb summary: " & integer'image(v_checks) & " checks, " &
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
