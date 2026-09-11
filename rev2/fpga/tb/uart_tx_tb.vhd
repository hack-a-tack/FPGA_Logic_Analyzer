-- ========================================
-- MODULE: uart_tx_tb.vhd
-- FUNCTION: TESTBENCH for entity which converts data bytes going to the host into serial UART data
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-09-04 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_mux_tx_byte			8 bits		<- frame_tx
-- i_mux_tx_valid			1 bit		<- frame_tx
-- i_baud_sel				2 bits		<- config_regs
-- i_usb_can_accept_tx_byte	1 bit		<- top (de-inverted from CTS#)
--
-- OUTPUTS					DATA		TO MODULE
-- o_uart_tx_ready			1 bit		-> frame_tx
-- o_tx_idle				1 bit		-> config_regs
-- o_UART_TX				1 bit		-> top
-- o_UART_TX_LED			1 bit		-> top
--
-- NOTES
-- Rev2's uart_tx replaced rev1's start-pulse handshake (i_mux_tx_start_pulse /
-- o_tx_busy) with an explicit valid/ready pair (i_mux_tx_valid / o_uart_tx_ready),
-- and dropped the CLK_FREQ_HZ/BAUD_RATE generics in favour of runtime-selectable
-- i_baud_sel (same la_pkg.f_clks_per_bit mapping as uart_rx: "00"->52 clocks,
-- "01"->12 clocks, "10"->8 clocks). Rev2 also added USB flow control
-- (i_usb_can_accept_tx_byte, 2FF-synchronised the same way uart_rx synchronises its
-- input) and a second status output, o_tx_idle, that is NOT gated by flow control.
-- See the RTL's own header NOTES for why config_regs needs a flow-control-independent
-- "idle" signal distinct from o_uart_tx_ready.
--
-- This testbench therefore focuses on what actually changed in rev2, not a generic
-- re-test of 8N1 framing (uart_rx_tb already covers bit-level UART mechanics in
-- detail; the transmit side is the same shift-out logic in reverse).
--
-- TEST CASES
-- TC1: initial/reset state. Idle high, o_tx_idle and o_uart_tx_ready both '1' (flow
--      control asserted throughout), LED starts '0'.
-- TC2: basic valid/ready handshake and correct byte transmission at the default baud
--      (baud_sel "00", CPB 52), several bytes with idle gaps between them.
-- TC3: all three baud rates. A representative byte repeated at "01" (CPB 12) and "10"
--      (CPB 8). CPB 8 (= 8 clocks per bit) has the least margin in the design.
-- TC4: bit period latched per byte. i_baud_sel changes while a byte is mid-transmission
--      (after the start bit and 3 data bits, still at the ORIGINAL CPB=52 rate).
--      Confirms r_clks_per_bit is latched at TX_IDLE->TX_START_BIT and not re-read live.
-- TC5: flow control gates only the TX_IDLE->TX_START_BIT transition. With
--      i_usb_can_accept_tx_byte deasserted, a byte presented as valid must sit pending
--      (line stays idle high, o_uart_tx_ready stays '0') until flow control returns,
--      at which point it is accepted and transmitted correctly.
-- TC6: flow control does NOT abort a byte already in flight. Once a byte has started,
--      withdrawing i_usb_can_accept_tx_byte mid-byte must not corrupt or stop it.
--      Per the RTL's own NOTES, stopping mid-byte would put a malformed character on
--      the wire, so the flow-control line is only sampled again once back in TX_IDLE.
-- TC7: o_tx_idle vs o_uart_tx_ready distinction. With the DUT parked in TX_IDLE and
--      flow control withheld, o_tx_idle must read '1' (state really is idle) while
--      o_uart_tx_ready reads '0' (not safe to hand it a byte). config_regs and
--      frame_tx are different consumers that need to tell these two apart.
-- TC8: back-to-back bytes. As soon as one byte completes and flow control is still
--      asserted, o_uart_tx_ready must rise again immediately in TX_IDLE with no
--      forced idle gap, and the next byte transmits correctly.
--
-- PREFIXES
-- v_ : variable
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.la_pkg.ALL;

entity uart_tx_tb is
end entity uart_tx_tb;

architecture sim of uart_tx_tb is
	constant DATA_LENGTH : integer := 8;

	constant CLK_PERIOD : time := 1 sec / C_SYS_CLK_HZ;  -- 20.833 ns (~48 MHz)
	constant CLK_HALF   : time := CLK_PERIOD / 2;

	signal i_clk					: std_logic := '0';
	signal i_rst_n					: std_logic := '1';
	signal i_mux_tx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal i_mux_tx_valid			: std_logic := '0';
	signal o_uart_tx_ready			: std_logic;
	signal o_tx_idle				: std_logic;
	signal i_baud_sel				: std_logic_vector(1 downto 0) := "00";
	signal i_usb_can_accept_tx_byte	: std_logic := '1';
	signal o_UART_TX				: std_logic;
	signal o_UART_TX_LED			: std_logic;

begin

	dut: entity WORK.uart_tx(RTL)
		generic map (
			DATA_LENGTH => DATA_LENGTH
		)
		port map (
			i_clk						=> i_clk,
			i_rst_n						=> i_rst_n,
			i_mux_tx_byte				=> i_mux_tx_byte,
			i_mux_tx_valid				=> i_mux_tx_valid,
			o_uart_tx_ready				=> o_uart_tx_ready,
			o_tx_idle					=> o_tx_idle,
			i_baud_sel					=> i_baud_sel,
			i_usb_can_accept_tx_byte	=> i_usb_can_accept_tx_byte,
			o_UART_TX					=> o_UART_TX,
			o_UART_TX_LED				=> o_UART_TX_LED
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

		-- Advances exactly n clock edges, then settles one delta so registered DUT
		-- outputs can be sampled safely afterward.
		procedure advance_clocks(
			constant n : in integer
		) is
		begin
			for i in 1 to n loop
				wait until rising_edge(i_clk);
			end loop;
			wait for 1 ns;  -- sidesteps counting deltas exactly: simulation time can't advance from t to t+1ns while there are still pending events scheduled at t, so by the time the process resumes, every delta-cycle cascade triggered by that clock edge has necessarily finished
		end procedure advance_clocks;

		-- Drives one valid/ready handshake for one byte, then checks the resulting
		-- serial frame on o_UART_TX bit-by-bit at the given bit rate: start bit low,
		-- DATA_LENGTH data bits LSB first, stop bit high, each held for clks_per_bit
		-- clock cycles, followed by a return to TX_IDLE. Assumes the DUT is already in
		-- TX_IDLE with flow control asserted when called.
		procedure send_and_check_uart_byte(
			constant byte         : in std_logic_vector(DATA_LENGTH-1 downto 0);
			constant clks_per_bit : in positive;
			constant tc_label     : in string
		) is
		begin
			i_mux_tx_byte  <= byte;
			i_mux_tx_valid <= '1';

			-- handshake fires the first clock edge both valid and ready are seen high
			wait until rising_edge(i_clk) and o_uart_tx_ready = '1';
			i_mux_tx_valid <= '0';  -- one-cycle handshake: drop valid once accepted

			-- next edge: DUT is in TX_START_BIT, o_UART_TX already preloaded to '0'
			advance_clocks(1);
			check(o_UART_TX = '0', tc_label & ": start bit must be '0'");

			for i in 0 to DATA_LENGTH-1 loop
				advance_clocks(clks_per_bit);
				check(o_UART_TX = byte(i),
					tc_label & ": data bit " & integer'image(i) & " mismatch, expected " &
					std_logic'image(byte(i)) & ", got " & std_logic'image(o_UART_TX));
			end loop;

			advance_clocks(clks_per_bit);
			check(o_UART_TX = '1', tc_label & ": stop bit must be '1'");

			advance_clocks(clks_per_bit);
			check(o_tx_idle = '1', tc_label & ": must return to TX_IDLE once the stop bit completes");
		end procedure send_and_check_uart_byte;

		-- TC1: initial/reset state
		procedure tc1_initial_state is
		begin
			check(o_UART_TX = '1', "TC1: o_UART_TX must be idle high after reset");
			check(o_tx_idle = '1', "TC1: o_tx_idle must be '1' after reset (TX_IDLE)");
			check(o_uart_tx_ready = '1', "TC1: o_uart_tx_ready must be '1' after reset with flow control asserted");
			check(o_UART_TX_LED = '0', "TC1: o_UART_TX_LED must start '0' after reset");
		end procedure tc1_initial_state;

		-- TC2: basic transmission at the default baud rate
		procedure tc2_basic_transmission is
			constant CPB : positive := 52;
			type tc2_bytes_t is array(0 to 3) of std_logic_vector(DATA_LENGTH-1 downto 0);
			constant v_bytes : tc2_bytes_t := (x"00", x"FF", x"A5", x"AA");
		begin
			for i in v_bytes'range loop
				send_and_check_uart_byte(v_bytes(i), CPB, "TC2 byte " & integer'image(i));
				advance_clocks(2*CPB);  -- idle gap between frames
			end loop;
		end procedure tc2_basic_transmission;

		-- TC3: all three baud rates
		procedure tc3_all_baud_rates is
			constant v_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := x"A5";
		begin
			i_baud_sel <= "01";  -- 4 Mbaud, CPB 12
			advance_clocks(1);
			send_and_check_uart_byte(v_byte, 12, "TC3 baud ""01"" (CPB 12)");
			advance_clocks(2*12);

			i_baud_sel <= "10";  -- 6 Mbaud, CPB 8 -- least margin in the design
			advance_clocks(1);
			send_and_check_uart_byte(v_byte, 8, "TC3 baud ""10"" (CPB 8)");
			advance_clocks(2*8);

			i_baud_sel <= "00";  -- restore default for subsequent test cases
			advance_clocks(1);
		end procedure tc3_all_baud_rates;

		-- TC4: bit period latched per byte
		procedure tc4_bit_period_latched_per_byte is
			constant CPB : positive := 52;
			constant v_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := x"C3";
		begin
			i_baud_sel <= "00";
			advance_clocks(1);

			i_mux_tx_byte  <= v_byte;
			i_mux_tx_valid <= '1';
			wait until rising_edge(i_clk) and o_uart_tx_ready = '1';
			i_mux_tx_valid <= '0';
			advance_clocks(1);
			check(o_UART_TX = '0', "TC4: start bit must be '0'");

			for i in 0 to DATA_LENGTH-1 loop
				advance_clocks(CPB);
				check(o_UART_TX = v_byte(i),
					"TC4: data bit " & integer'image(i) & " mismatch (config change mid-byte must not affect the byte already in flight)");
				if i = 2 then
					i_baud_sel <= "10";  -- config change mid-byte: must not affect the byte already in flight
				end if;
			end loop;

			advance_clocks(CPB);
			check(o_UART_TX = '1', "TC4: stop bit must still be '1' at the ORIGINAL rate (CPB 52)");

			advance_clocks(CPB);
			check(o_tx_idle = '1', "TC4: must return to TX_IDLE after the byte completes");

			i_baud_sel <= "00";  -- restore default
			advance_clocks(3);
		end procedure tc4_bit_period_latched_per_byte;

		-- TC5: flow control gates only the TX_IDLE -> TX_START_BIT transition
		procedure tc5_flow_control_gates_idle_only is
			constant CPB : positive := 52;
			constant v_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := x"3C";
		begin
			i_usb_can_accept_tx_byte <= '0';
			advance_clocks(3);  -- let the 2FF sync settle
			check(o_tx_idle = '1', "TC5: DUT must remain in TX_IDLE while flow control is deasserted");
			check(o_uart_tx_ready = '0', "TC5: o_uart_tx_ready must be '0' while flow control is deasserted, even though idle");

			i_mux_tx_byte  <= v_byte;
			i_mux_tx_valid <= '1';
			advance_clocks(10);  -- valid held, but must not be accepted without flow control
			check(o_UART_TX = '1', "TC5: line must stay idle high; a pending valid byte must not start transmitting without flow control");
			check(o_tx_idle = '1', "TC5: must still be in TX_IDLE with flow control withheld");

			-- flow control returns: the already-pending valid byte must now be accepted
			i_usb_can_accept_tx_byte <= '1';
			wait until rising_edge(i_clk) and o_uart_tx_ready = '1';
			i_mux_tx_valid <= '0';
			advance_clocks(1);
			check(o_UART_TX = '0', "TC5: start bit must be '0' once flow control allows the pending byte through");

			for i in 0 to DATA_LENGTH-1 loop
				advance_clocks(CPB);
				check(o_UART_TX = v_byte(i), "TC5: data bit " & integer'image(i) & " mismatch after flow-control-gated start");
			end loop;

			advance_clocks(CPB);
			check(o_UART_TX = '1', "TC5: stop bit must be '1'");

			advance_clocks(CPB);
			check(o_tx_idle = '1', "TC5: must return to TX_IDLE after the byte completes");
		end procedure tc5_flow_control_gates_idle_only;

		-- TC6: flow control does not abort a byte already in flight
		procedure tc6_flow_control_mid_byte_no_abort is
			constant CPB : positive := 52;
			constant v_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := x"96";
		begin
			i_usb_can_accept_tx_byte <= '1';
			i_mux_tx_byte  <= v_byte;
			i_mux_tx_valid <= '1';
			wait until rising_edge(i_clk) and o_uart_tx_ready = '1';
			i_mux_tx_valid <= '0';
			advance_clocks(1);
			check(o_UART_TX = '0', "TC6: start bit must be '0'");

			-- withdraw flow control partway through the byte: must NOT abort transmission
			i_usb_can_accept_tx_byte <= '0';

			for i in 0 to DATA_LENGTH-1 loop
				advance_clocks(CPB);
				check(o_UART_TX = v_byte(i),
					"TC6: data bit " & integer'image(i) & " must still transmit correctly despite flow control dropping mid-byte");
			end loop;

			advance_clocks(CPB);
			check(o_UART_TX = '1', "TC6: stop bit must still complete as '1' despite flow control dropping mid-byte");

			advance_clocks(CPB);
			check(o_tx_idle = '1', "TC6: must return to TX_IDLE after the byte completes");
			check(o_uart_tx_ready = '0', "TC6: o_uart_tx_ready must stay '0' in TX_IDLE since flow control is still withheld");

			i_usb_can_accept_tx_byte <= '1';  -- restore for subsequent test cases
			advance_clocks(3);
		end procedure tc6_flow_control_mid_byte_no_abort;

		-- TC7: o_tx_idle vs o_uart_tx_ready distinction
		procedure tc7_tx_idle_vs_ready_distinction is
		begin
			i_usb_can_accept_tx_byte <= '0';
			advance_clocks(3);
			check(o_tx_idle = '1', "TC7: o_tx_idle must read '1' in TX_IDLE regardless of flow control");
			check(o_uart_tx_ready = '0',
				"TC7: o_uart_tx_ready must read '0' while flow control is withheld, even though o_tx_idle is '1' -- config_regs and frame_tx need to tell these apart");

			i_usb_can_accept_tx_byte <= '1';
			advance_clocks(3);
			check(o_tx_idle = '1', "TC7: o_tx_idle remains '1' once flow control returns");
			check(o_uart_tx_ready = '1', "TC7: o_uart_tx_ready must read '1' once flow control returns and the DUT is idle");
		end procedure tc7_tx_idle_vs_ready_distinction;

		-- TC8: back-to-back bytes, no forced idle gap
		procedure tc8_back_to_back is
			constant CPB : positive := 52;
		begin
			send_and_check_uart_byte(x"11", CPB, "TC8 back-to-back byte 1");
			send_and_check_uart_byte(x"22", CPB, "TC8 back-to-back byte 2");
			send_and_check_uart_byte(x"33", CPB, "TC8 back-to-back byte 3");
		end procedure tc8_back_to_back;

	begin
		report "====================================================";
		report "uart_tx_tb starting";
		report "====================================================";

		-- Reset phase
		i_usb_can_accept_tx_byte <= '1';
		i_rst_n <= '0';
		wait until rising_edge(i_clk);
		wait until rising_edge(i_clk);
		i_rst_n <= '1';
		advance_clocks(3);  -- let the 2FF flow-control sync settle before TC1

		tc1_initial_state;
		tc2_basic_transmission;
		tc3_all_baud_rates;
		tc4_bit_period_latched_per_byte;
		tc5_flow_control_gates_idle_only;
		tc6_flow_control_mid_byte_no_abort;
		tc7_tx_idle_vs_ready_distinction;
		tc8_back_to_back;

		report "====================================================";
		report "uart_tx_tb summary: " & integer'image(v_checks) & " checks, " &
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
