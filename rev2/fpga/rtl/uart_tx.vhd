-- ========================================
-- MODULE: uart_tx.vhd
-- FUNCTION: converts data bytes going to the host into serial UART data
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-19 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-08-06 (rev2)
-- MODIFIED: 2026-08-12 (rev2) (runtime-selectable baud via i_baud_sel/uart_pkg; added FTDI transmit flow control)
-- MODIFIED: 2026-08-17 (rev2) (added o_tx_idle, ungated by flow control, as the baud changeover commit-point signal for config_regs)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_mux_tx_byte			8 bits 		<- tx_mux /// now: frame_tx
-- i_mux_tx_valid			1 bit		<- tx_mux /// now: frame_tx
-- i_baud_sel				2 bits		<- config_regs
-- i_usb_can_accept_tx_byte	1 bit		<- top (de-inverted from CTS#)
--
-- OUTPUTS					DATA		TO MODULE
-- o_uart_tx_ready			1 bit		-> tx_mux /// now: frame_tx
-- o_tx_idle				1 bit		-> config_regs
-- o_UART_TX				1 bit		-> top
-- o_UART_TX_LED			1 bit		-> top
--
-- NOTES
-- 8N1 UART --> start bit, data bits 0-7 (starting with LSB), stop bit --> 10 transmitted bits per byte --> "10 baud"
-- 1 baud = 1 symbol (1 bit for UART)
-- Bit period is no longer a compile-time constant. f_clks_per_bit (uart_pkg) maps i_baud_sel to a clocks-per-bit count; see uart_pkg.vhd NOTES for the rate table and error figures.
-- --> Each bit is transmitted for the latched clocks-per-bit count.
-- But UART usually tolerates +- 2-3% error
--
-- By the time i_tx_mux_valid reaches uart_tx, so has the data from send_engine or analyzer_fsm on the i_mux_tx_byte lines.
-- So by latching input byte/payload when in IDLE (uart_ready is high) and we see i_tx_mux_valid, we uphold the handshake agreement.
--
-- i_usb_can_accept_tx_byte only gates the transition out of TX_IDLE. Once a byte has started, it always runs to completion regardless of the flow-control line -- stopping mid-byte would put a malformed character on the wire. frame_tx, tx_mux, send_engine and resp_gen already hold valid/data across stalls and advance only on accept, so backpressure propagates up the existing ready/valid chain without any other module needing changes.
--
-- o_tx_idle is r_state = TX_IDLE only, with no dependence on i_usb_can_accept_tx_byte. o_uart_tx_ready cannot serve this purpose since it is gated by flow control: ready = '0' means either "sending a byte" or "FTDI is not accepting", and config_regs needs to tell those two cases apart to know when it is actually safe to change the baud divider.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- s_ : output-only signal 	(driven by a dedicated combinational/sync process)

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- Baud changeover sequencing (switching i_baud_sel safely) is config_regs' job, next pass -- not handled here.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.uart_pkg.ALL;

entity uart_tx is
	generic (
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;

		i_mux_tx_byte			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_mux_tx_valid			: in  std_logic;
		o_uart_tx_ready			: out std_logic;
		o_tx_idle				: out std_logic;  -- '1' when r_state = TX_IDLE, ungated by flow control

		-- config_regs
		i_baud_sel				: in  std_logic_vector(1 downto 0);

		-- top (USB flow control)
		i_usb_can_accept_tx_byte	: in  std_logic;

		o_UART_TX				: out std_logic;
		o_UART_TX_LED			: out std_logic
	);
end entity uart_tx;

architecture RTL of uart_tx is
	-- Internal uart_tx state machine
	type UART_TX_state_type is (TX_IDLE, TX_START_BIT, TX_DATA_BITS, TX_STOP_BIT);
	
	-- Register signals, next-state signals
	signal r_state, n_state : UART_TX_state_type := TX_IDLE;									-- internal state
	signal r_UART_TX, n_UART_TX : std_logic := '1';  											-- output
	signal r_UART_TX_LED, n_UART_TX_LED : std_logic := '0';										-- output
	signal r_tx_byte, n_tx_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');  -- for input latching

	-- Constants
	constant MAX_CLKS_PER_BIT : positive := 52;  -- largest value f_clks_per_bit can return; sizes the counters below

	-- Counter signals
	signal r_clk_counter, n_clk_counter : integer range 0 to MAX_CLKS_PER_BIT-1 := 0;  -- counts FPGA clock cycles in one UART bit period
	signal r_bit_counter, n_bit_counter : integer range 0 to DATA_LENGTH-1  := 0;  -- tracks data bits inside one data byte
	signal r_clks_per_bit, n_clks_per_bit : integer range 1 to MAX_CLKS_PER_BIT := MAX_CLKS_PER_BIT;  -- latched bit period for the byte in flight

	-- Registered signals for 2FF synchroniser on i_usb_can_accept_tx_byte
	signal r_usb_can_accept_sync_1 : std_logic := '0';
	signal s_usb_can_accept : std_logic := '0';

begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_state 	  <= TX_IDLE;
				r_UART_TX 	  <= '1';  -- UART is idle high
				r_UART_TX_LED <= '0';
				r_tx_byte 	  <= (others => '0');
				r_clk_counter <= 0;
				r_bit_counter <= 0;
				r_clks_per_bit <= MAX_CLKS_PER_BIT;
			else
				r_state 	  <= n_state;
				r_UART_TX 	  <= n_UART_TX;
				r_UART_TX_LED <= n_UART_TX_LED;
				r_tx_byte 	  <= n_tx_byte;
				r_clk_counter <= n_clk_counter;
				r_bit_counter <= n_bit_counter;
				r_clks_per_bit <= n_clks_per_bit;
			end if;
		end if;
	end process seq_proc;


	-- 2FF synchronizer on i_usb_can_accept_tx_byte (asynchronous to i_clk, same pattern as uart_rx's sync_proc)
	sync_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_usb_can_accept_sync_1 <= '0';
				s_usb_can_accept <= '0';
			else
				r_usb_can_accept_sync_1 <= i_usb_can_accept_tx_byte;
				s_usb_can_accept <= r_usb_can_accept_sync_1;
			end if;
		end if;
	end process sync_proc;


	-- Combinational process for dealing with UART TX internal FSM
	fsm_proc: process(all) is
	begin
		-- Defaults
		n_state 	   <= r_state;
		n_UART_TX 	   <= r_UART_TX;
		n_UART_TX_LED  <= r_UART_TX_LED;
		n_tx_byte 	   <= r_tx_byte;
		n_clk_counter  <= r_clk_counter;
		n_bit_counter  <= r_bit_counter;
		n_clks_per_bit <= r_clks_per_bit;

		case r_state is
			when TX_IDLE =>
				n_UART_TX <= '1';  -- force line high (UART is idle high)
				if i_mux_tx_valid = '1' and s_usb_can_accept = '1' then  -- valid high, USB can accept. tx_ready signal also high (only during IDLE)
					n_tx_byte <= i_mux_tx_byte;  -- latch input byte so it doesn't change during transmission
					n_clks_per_bit <= f_clks_per_bit(i_baud_sel);  -- latch bit period for the whole byte
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					n_UART_TX <= '0';  -- since r_UART_TX is registered, setting it here gives o_UART_TX = '0' from first clock in TX_START_BIT
					n_state <= TX_START_BIT;
				end if;

			when TX_START_BIT =>  -- hold '0' for r_clks_per_bit
				n_UART_TX <= '0';
				if r_clk_counter = r_clks_per_bit-1 then
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					n_UART_TX <= r_tx_byte(r_bit_counter);  -- preload first value so o_UART_TX becomes correct from first clock in DATA_BITS
					n_state <= TX_DATA_BITS;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;

			when TX_DATA_BITS =>  -- send bits 0..7, hold each for r_clks_per_bit
				n_UART_TX <= r_tx_byte(r_bit_counter);
				if r_clk_counter = r_clks_per_bit-1 then
					n_clk_counter <= 0;
					if r_bit_counter = DATA_LENGTH-1 then
						n_bit_counter <= 0;
						n_UART_TX <= '1';  -- preload stop bit so o_UART_TX becomes correct from first clock in TX_STOP_BIT
						n_state <= TX_STOP_BIT;
					else
						n_bit_counter <= r_bit_counter + 1;
						n_UART_TX <= r_tx_byte(r_bit_counter+1);  -- preload next data bit
					end if;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;

			when TX_STOP_BIT =>  -- hold '1' for r_clks_per_bit
				n_UART_TX <= '1';
				if r_clk_counter = r_clks_per_bit-1 then
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					n_UART_TX <= '1';  -- explicitly preloading IDLE HIGH
					n_UART_TX_LED <= not r_UART_TX_LED;  -- preload LED toggle so the registered output toggles when you reach TX_IDLE
					n_state <= TX_IDLE;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;
		end case;
	end process fsm_proc;


	-- Set outputs
	o_uart_tx_ready <= '1' when (r_state = TX_IDLE and s_usb_can_accept = '1') else '0';
	o_tx_idle <= '1' when r_state = TX_IDLE else '0';

	o_UART_TX <= r_UART_TX;
	o_UART_TX_LED <= r_UART_TX_LED;
	
	
end architecture RTL;
