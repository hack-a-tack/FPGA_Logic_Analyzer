-- ========================================
-- MODULE: uart_rx_tb.vhd
-- FUNCTION: TESTBENCH for entity which converts serial UART data from the host into data bytes
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-08-30 (YYYY-MM-DD)
--
-- NOTES
-- Rev2's uart_rx dropped the old CLKS_PER_BIT generic. The bit period is now runtime
-- selectable via i_baud_sel, resolved through la_pkg.f_clks_per_bit. This testbench
-- exercises all three bit periods (derived from baud rate), plus the DUT's own 2FF input
-- synchroniser (sync_proc in uart_rx.vhd), which adds 2 clock cycles of latency between a
-- transition on i_UART_RX and that transition becoming visible internally (r_rx_sync_2).
-- No signal here asserts on r_rx_sync_1/2 directly. TC7 only confirms reception still works
-- with input transitions placed asynchronously relative to i_clk's edges.
--
-- A concurrent monitor process (monitor_proc) watches o_rx_valid_pulse/o_rx_byte for
-- the whole simulation and logs each pulse (byte value + pulse width in clocks) into
-- mon_log_byte/mon_log_width, indexed by the free-running mon_log_count. This is what
-- makes TC4 (back-to-back frames, no idle gap) checkable: the stimulus process can
-- fire several send_uart_byte calls back-to-back without waiting on each one's
-- reception individually, then confirm afterwards that exactly that many bytes
-- landed, in order, with no drops and no double-counted pulses.
--
-- TEST CASES
-- TC1: basic reception at 921,600 (baud_sel "00", CPB (clocks per bit) 52).
-- 		Six bytes sent with a gap between each. Checks byte value and that
--		o_rx_valid_pulse is exactly one clock wide per byte. A two-clock pulse
--      would make cmd_parser/rx_frame_parser consume the same byte twice.
-- TC2: all three baud rates. A representative byte repeated at "01" (CPB 12) and "10"
--      (CPB 8). CPB 8 is the case with the least margin in the design: the mid-bit
--      sample point resolves to only 1/8 of a bit period there.
-- TC3: bit period latched per byte. i_baud_sel changes while a byte is mid-reception
--      (after the start bit and 3 data bits, still driven at the ORIGINAL CPB=52
--      timing). Confirms the in-flight byte still decodes correctly, i.e.
--      r_clks_per_bit is latched at start-bit detection and not re-read live.
-- TC4: back-to-back bytes, no idle gap between one frame's stop bit and the next
--      frame's start bit. This is the real traffic pattern once rx_frame_parser is
--      active (a validated frame arrives as a contiguous burst).
-- TC5: idle line and false-start rejection. A long idle-high period must produce no
--      spurious pulse; a narrow low glitch (2 clocks, far short of one 52-clock bit
--      period) must also produce no byte.
-- TC6: framing error (stop bit held low). uart_rx.vhd has no framing-error output.
--      Reading fsm_proc's RX_STOP_BIT branch: if the stop bit samples low,
--      n_rx_valid_pulse and o_UART_RX_LED simply never update (default '0'/hold) and
--      the FSM returns to RX_IDLE, i.e. the byte is silently dropped. o_rx_byte still
--      shows the decoded value, because n_rx_byte was already latched during
--      RX_DATA_BITS and nothing overwrites it in RX_STOP_BIT. TC6 asserts exactly
--      that documented (non-)behaviour, not an invented framing-error signal.
-- TC7: 2FF synchroniser present (sync_proc, 2-clock latency to r_rx_sync_2). For TC7,
--      bit transitions are deliberately offset by a third of a clock period so they land
--      asynchronously relative to i_clk; reception must still succeed.
--		No assertion touches r_rx_sync_1/2. Those are internal.
--
-- PREFIXES
-- v_ : variable
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.la_pkg.ALL;

entity uart_rx_tb is
end entity uart_rx_tb;

architecture sim of uart_rx_tb is
	constant DATA_LENGTH : integer := 8;

	constant CLK_PERIOD : time := 1 sec / C_SYS_CLK_HZ;		-- 20.833 ns (~48 MHz)
	constant CLK_HALF   : time := CLK_PERIOD / 2;			-- 10416 ps (truncated) --> 20832 ps full period

	signal i_clk				: std_logic := '0';
	signal i_rst_n				: std_logic := '1';
	signal i_UART_RX			: std_logic := '1';
	signal i_baud_sel			: std_logic_vector(1 downto 0) := "00";
	signal o_rx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal o_rx_valid_pulse		: std_logic;
	signal o_UART_RX_LED		: std_logic;

	-- Monitor log: every observed o_rx_valid_pulse, in order, for the whole run.
	-- mon_log_count is free-running (never reset between test cases) so each TC just
	-- records its own starting index and checks the entries logged since then.
	type byte_log_array_t is array(0 to 19) of std_logic_vector(DATA_LENGTH-1 downto 0);
	type int_log_array_t  is array(0 to 19) of integer;
	signal mon_log_byte  : byte_log_array_t := (others => (others => '0'));
	signal mon_log_width : int_log_array_t  := (others => 0);
	signal mon_log_count : integer := 0;

begin

	dut: entity WORK.uart_rx(RTL)
		generic map (
			DATA_LENGTH => DATA_LENGTH
		)
		port map (
			i_clk				=> i_clk,
			i_rst_n				=> i_rst_n,
			i_UART_RX			=> i_UART_RX,
			i_baud_sel			=> i_baud_sel,
			o_rx_byte			=> o_rx_byte,
			o_rx_valid_pulse	=> o_rx_valid_pulse,
			o_UART_RX_LED		=> o_UART_RX_LED
		);

	-- Clock generation
	clk_proc: process is
	begin
		while true loop
			i_clk <= '0';
			wait for CLK_HALF;
			i_clk <= '1';
			wait for CLK_HALF;
		end loop;
	end process clk_proc;

	-- Logs every pulse (byte + width in clocks) seen on o_rx_valid_pulse, for the
	-- whole simulation. See header NOTES for why this is a concurrent process rather
	-- than something the stimulus process polls inline.
	monitor_proc: process(i_clk) is
		variable v_prev_pulse : std_logic := '0';
		variable v_width      : integer := 0;
		variable v_idx        : integer := 0;
	begin
		if rising_edge(i_clk) then
			if o_rx_valid_pulse = '1' and v_prev_pulse = '0' then
				-- rising edge of the pulse: new log entry begins
				v_idx := mon_log_count;
				mon_log_byte(v_idx) <= o_rx_byte;
				v_width := 1;
			elsif o_rx_valid_pulse = '1' and v_prev_pulse = '1' then
				v_width := v_width + 1;
			elsif o_rx_valid_pulse = '0' and v_prev_pulse = '1' then
				-- falling edge: pulse just ended, finalize the entry
				mon_log_width(v_idx) <= v_width;
				mon_log_count <= mon_log_count + 1;
			end if;
			v_prev_pulse := o_rx_valid_pulse;
		end if;
	end process monitor_proc;

	-- Stimulus process
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

		-- Drives one full 8N1 frame on rx_line: start bit low, DATA_LENGTH data bits
		-- LSB first, stop bit high, each held for clks_per_bit clock cycles. Every
		-- normal-case send in this testbench builds on this procedure; test cases that
		-- need to break the frame (TC3's mid-byte config change, TC6's bad stop bit)
		-- drive the bits manually instead.
		procedure send_uart_byte(
			constant byte         : in  std_logic_vector(DATA_LENGTH-1 downto 0);
			constant clks_per_bit : in  positive;
			signal   rx_line      : out std_logic
		) is
		begin
			rx_line <= '0';  -- start bit
			wait for clks_per_bit * CLK_PERIOD;
			for i in 0 to DATA_LENGTH-1 loop
				rx_line <= byte(i);  -- data bit, LSB first
				wait for clks_per_bit * CLK_PERIOD;
			end loop;
			rx_line <= '1';  -- stop bit
			wait for clks_per_bit * CLK_PERIOD;
		end procedure send_uart_byte;

		-- Blocks until mon_log_count reaches target_count or timeout_cycles clocks
		-- pass, whichever comes first. A timeout just means the following check(s)
		-- against mon_log_count will fail with a clear count mismatch. It is not
		-- itself an assertion.
		procedure wait_for_log_count(
			constant target_count   : in integer;
			constant timeout_cycles : in integer
		) is
			variable v_cycles : integer := 0;
		begin
			while mon_log_count < target_count and v_cycles < timeout_cycles loop
				wait until rising_edge(i_clk);
				wait for 1 ns;  -- let monitor_proc's NBA update settle before re-reading
				v_cycles := v_cycles + 1;
			end loop;
		end procedure wait_for_log_count;

		-- Checks one logged entry: byte value, and that its pulse was exactly one
		-- clock wide.
		procedure check_received(
			constant idx      : in integer;
			constant expected : in std_logic_vector(DATA_LENGTH-1 downto 0);
			constant tc_label  : in string
		) is
		begin
			check(mon_log_byte(idx) = expected,
				tc_label & ": expected byte 0x" & to_hstring(expected) & ", got 0x" & to_hstring(mon_log_byte(idx)));
			check(mon_log_width(idx) = 1,
				tc_label & ": o_rx_valid_pulse must be exactly one clock wide, got " & integer'image(mon_log_width(idx)) & " clock(s)");
		end procedure check_received;

		-- TC1: basic reception at 921,600 (baud_sel "00", CPB 52)
		procedure tc1_basic_reception is
			constant CPB : positive := 52;
			type tc1_bytes_t is array(0 to 5) of std_logic_vector(DATA_LENGTH-1 downto 0);
			constant v_bytes : tc1_bytes_t := (x"00", x"FF", x"A5", x"5A", x"55", x"01");
			variable v_start : integer;
		begin
			i_baud_sel <= "00";
			wait until rising_edge(i_clk); wait for 1 ns;

			for i in v_bytes'range loop
				v_start := mon_log_count;
				send_uart_byte(v_bytes(i), CPB, i_UART_RX);
				wait_for_log_count(v_start + 1, 10*CPB + 30);
				check(mon_log_count = v_start + 1,
					"TC1 byte " & integer'image(i) & ": expected exactly 1 byte logged, got " & integer'image(mon_log_count - v_start));
				check_received(v_start, v_bytes(i), "TC1 byte " & integer'image(i));
				wait for 2*CPB*CLK_PERIOD;  -- idle gap between frames, keeps this TC distinct from TC4's back-to-back case
			end loop;
		end procedure tc1_basic_reception;

		-- TC2: all three baud rates (a representative byte at "01" and "10")
		procedure tc2_all_baud_rates is
			constant v_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := x"A5";
			variable v_start : integer;
		begin
			-- "01" -> 4 Mbaud, CPB 12
			i_baud_sel <= "01";
			wait until rising_edge(i_clk); wait for 1 ns;
			v_start := mon_log_count;
			send_uart_byte(v_byte, 12, i_UART_RX);
			wait_for_log_count(v_start + 1, 10*12 + 30);
			check(mon_log_count = v_start + 1, "TC2 baud ""01"" (CPB 12): expected exactly 1 byte logged, got " & integer'image(mon_log_count - v_start));
			check_received(v_start, v_byte, "TC2 baud ""01"" (CPB 12)");
			wait for 2*12*CLK_PERIOD;

			-- "10" -> 6 Mbaud, CPB 8. Least margin in the design: mid-bit sample point
			-- resolves to only 1/8 of a bit period.
			i_baud_sel <= "10";
			wait until rising_edge(i_clk); wait for 1 ns;
			v_start := mon_log_count;
			send_uart_byte(v_byte, 8, i_UART_RX);
			wait_for_log_count(v_start + 1, 10*8 + 30);
			check(mon_log_count = v_start + 1, "TC2 baud ""10"" (CPB 8): expected exactly 1 byte logged, got " & integer'image(mon_log_count - v_start));
			check_received(v_start, v_byte, "TC2 baud ""10"" (CPB 8)");
		end procedure tc2_all_baud_rates;

		-- TC3: bit period latched per byte. i_baud_sel changes mid-reception; the
		-- byte already in flight must still decode at the ORIGINAL rate (CPB 52).
		procedure tc3_bit_period_latched is
			constant v_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := x"C3";
			constant CPB : positive := 52;
			variable v_start : integer;
		begin
			i_baud_sel <= "00";
			wait until rising_edge(i_clk); wait for 1 ns;
			v_start := mon_log_count;

			-- Manually drive the frame at CPB=52 timing (mirrors send_uart_byte) so a
			-- baud_sel change can be injected partway through, after the start bit and
			-- 3 data bits.
			i_UART_RX <= '0';  -- start bit
			wait for CPB * CLK_PERIOD;
			for i in 0 to DATA_LENGTH-1 loop
				i_UART_RX <= v_byte(i);
				wait for CPB * CLK_PERIOD;
				if i = 2 then
					i_baud_sel <= "10";  -- config change mid-byte: must not affect the byte already in flight
				end if;
			end loop;
			i_UART_RX <= '1';  -- stop bit
			wait for CPB * CLK_PERIOD;

			wait_for_log_count(v_start + 1, 10*CPB + 30);
			check(mon_log_count = v_start + 1, "TC3: expected exactly 1 byte logged, got " & integer'image(mon_log_count - v_start));
			check_received(v_start, v_byte, "TC3 bit period latched per byte");

			i_baud_sel <= "00";
			wait for 2*CPB*CLK_PERIOD;  -- let the FSM settle back in idle before the next TC
		end procedure tc3_bit_period_latched;

		-- TC4: back-to-back bytes, no idle gap between stop bit and next start bit
		procedure tc4_back_to_back is
			constant CPB : positive := 52;
			variable v_start : integer;
		begin
			i_baud_sel <= "00";
			wait until rising_edge(i_clk); wait for 1 ns;
			v_start := mon_log_count;

			send_uart_byte(x"12", CPB, i_UART_RX);
			send_uart_byte(x"34", CPB, i_UART_RX);
			send_uart_byte(x"56", CPB, i_UART_RX);
			send_uart_byte(x"78", CPB, i_UART_RX);

			wait_for_log_count(v_start + 4, 4*(10*CPB + 30));
			check(mon_log_count = v_start + 4,
				"TC4 back-to-back: expected exactly 4 bytes logged with none dropped, got " & integer'image(mon_log_count - v_start));
			check_received(v_start + 0, x"12", "TC4 back-to-back byte 1");
			check_received(v_start + 1, x"34", "TC4 back-to-back byte 2");
			check_received(v_start + 2, x"56", "TC4 back-to-back byte 3");
			check_received(v_start + 3, x"78", "TC4 back-to-back byte 4");
		end procedure tc4_back_to_back;

		-- TC5: idle line produces no spurious pulse; a narrow glitch produces no byte
		procedure tc5_idle_and_false_start is
			constant CPB : positive := 52;
			variable v_start : integer;
		begin
			i_baud_sel <= "00";
			i_UART_RX <= '1';
			wait until rising_edge(i_clk); wait for 1 ns;
			v_start := mon_log_count;

			wait for 20*CPB*CLK_PERIOD;  -- long idle-high period (20 bit periods)
			check(mon_log_count = v_start,
				"TC5 idle line: no byte should be logged while idle high, got " & integer'image(mon_log_count - v_start) & " spurious byte(s)");

			-- narrow glitch, well under one bit period (52 clocks)
			i_UART_RX <= '0';
			wait for 2*CLK_PERIOD;
			i_UART_RX <= '1';
			wait for 10*CPB*CLK_PERIOD;  -- generous settle, covers the full start-bit validation window
			check(mon_log_count = v_start,
				"TC5 false start rejection: a narrow glitch must not produce a byte, got " & integer'image(mon_log_count - v_start) & " spurious byte(s)");
		end procedure tc5_idle_and_false_start;

		-- TC6: stop bit held low. uart_rx has no framing-error output.
		procedure tc6_bad_stop_bit is
			constant v_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := x"55";
			constant CPB : positive := 52;
			variable v_start : integer;
		begin
			i_baud_sel <= "00";
			wait until rising_edge(i_clk); wait for 1 ns;
			v_start := mon_log_count;

			i_UART_RX <= '0';  -- start bit
			wait for CPB * CLK_PERIOD;
			for i in 0 to DATA_LENGTH-1 loop
				i_UART_RX <= v_byte(i);
				wait for CPB * CLK_PERIOD;
			end loop;
			i_UART_RX <= '0';  -- stop bit FORCED low: framing error
			wait for CPB * CLK_PERIOD;
			i_UART_RX <= '1';  -- back to idle high

			wait for 10*CPB*CLK_PERIOD;  -- generous settle
			check(mon_log_count = v_start,
				"TC6 framing error: no o_rx_valid_pulse must fire when the stop bit samples low (uart_rx has no framing-error output, RTL silently drops the byte), got " &
				integer'image(mon_log_count - v_start) & " spurious byte(s)");
			check(o_rx_byte = v_byte,
				"TC6 framing error: o_rx_byte still holds the decoded (unconfirmed) value per RTL, expected 0x" & to_hstring(v_byte) & ", got 0x" & to_hstring(o_rx_byte));
		end procedure tc6_bad_stop_bit;

		-- TC7: 2FF synchroniser present. Reception still works with bit transitions
		-- placed asynchronously relative to i_clk's edges. No assertion here touches
		-- internal sync signals.
		procedure tc7_async_input is
			constant v_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := x"6D";
			constant CPB : positive := 52;
			variable v_start : integer;
		begin
			i_baud_sel <= "00";
			wait until rising_edge(i_clk); wait for 1 ns;
			v_start := mon_log_count;

			wait for CLK_PERIOD/3;  -- phase offset: every bit edge below lands off the clock edge

			send_uart_byte(v_byte, CPB, i_UART_RX);

			wait_for_log_count(v_start + 1, 10*CPB + 30);
			check(mon_log_count = v_start + 1, "TC7: expected exactly 1 byte logged, got " & integer'image(mon_log_count - v_start));
			check_received(v_start, v_byte, "TC7 async input through 2FF synchroniser");
		end procedure tc7_async_input;

	begin
		report "====================================================";
		report "uart_rx_tb starting";
		report "====================================================";

		-- Reset phase
		i_rst_n <= '0';
		wait until rising_edge(i_clk);
		wait until rising_edge(i_clk);
		i_rst_n <= '1';
		wait until rising_edge(i_clk);

		tc1_basic_reception;
		tc2_all_baud_rates;
		tc3_bit_period_latched;
		tc4_back_to_back;
		tc5_idle_and_false_start;
		tc6_bad_stop_bit;
		tc7_async_input;

		report "====================================================";
		report "uart_rx_tb summary: " & integer'image(v_checks) & " checks, " &
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
