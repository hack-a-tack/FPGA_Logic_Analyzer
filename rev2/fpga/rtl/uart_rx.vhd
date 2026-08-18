-- ========================================
-- MODULE: uart_rx.vhd
-- FUNCTION: converts serial UART data from the host into data bytes
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-22 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-08-12 (rev2) (runtime-selectable baud via i_baud_sel/uart_pkg; renamed i_rst to i_rst_n to match house standard)
-- MODIFIED: 2026-08-18 (rev2) (repointed from uart_pkg to la_pkg; uart_pkg.vhd deleted, was a near-duplicate of la_pkg's f_clks_per_bit)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_UART_RX				1 bit 		<- top
-- i_baud_sel				2 bits		<- config_regs
--
-- OUTPUTS					DATA		TO MODULE
-- o_rx_byte				8 bits		-> cmd_parser
-- o_rx_valid_pulse			1 bit		-> cmd_parser
-- o_UART_RX_LED			1 bit		-> top
--
-- NOTES
-- 8N1 UART --> start bit, data bits 0-7 (starting with LSB), stop bit --> 10 baud
-- 1 baud = 1 symbol (1 bit for UART)
-- Bit period is no longer a compile-time constant. f_clks_per_bit (la_pkg) maps i_baud_sel to a clocks-per-bit count; see la_pkg.vhd NOTES for the rate table and error figures.
-- --> Each bit is readable for the latched clocks-per-bit count.
-- --> Bits should ideally be sampled near the middle of each bit period.
-- --> But you cannot move on to the next bit - start/data/stop bit - until a full bit period has passed.
-- --> ... Why? Because UART is asynchronous and relies on RX and FX communicating at the same speed; instead of with a clock (USART)
-- --> Note that the input is synchronised (2FF) before use
-- But UART usually tolerates +- 2-3% error
-- At "10" (6 Mbaud) the period is only 8 clocks, so the mid-bit sample point resolves to 1/8 of a bit, and one clock of start-detection jitter is 12.5% of a bit period. Combined oscillator error must stay under roughly 3.9% for the stop bit to sample correctly. SB_HFOSC's PVT tolerance is the dominant term here -- the FT2232H side is crystal-derived and negligible. 6 Mbaud needs hardware characterisation before being treated as supported.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.la_pkg.ALL;

entity uart_rx is
	generic (
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;
		i_UART_RX				: in  std_logic;

		-- config_regs
		i_baud_sel				: in  std_logic_vector(1 downto 0);

		o_rx_byte				: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_rx_valid_pulse		: out std_logic;
		o_UART_RX_LED			: out std_logic
	);
end entity uart_rx;

architecture RTL of uart_rx is
	-- Internal uart_rx state machine
	type UART_RX_state_type is (RX_IDLE, RX_START_BIT, RX_DATA_BITS, RX_STOP_BIT);
	
	-- Register signals, next-state signals
	signal r_state, n_state : UART_RX_state_type := RX_IDLE;									-- internal state
	signal r_rx_byte, n_rx_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');  -- output
	signal r_rx_valid_pulse, n_rx_valid_pulse : std_logic := '0';								-- output
	signal r_UART_RX_LED, n_UART_RX_LED : std_logic := '0';										-- output	
	signal r_valid_start, n_valid_start : std_logic := '0';										-- flag for start_bit
	signal r_valid_stop, n_valid_stop : std_logic := '0';										-- flag for stop_bit
	
	-- Registered signals for 2FF synchroniser
	signal r_rx_sync_1 : std_logic := '1';
	signal r_rx_sync_2 : std_logic := '1';
	
	-- Constants
	constant MAX_CLKS_PER_BIT : positive := 52;  -- largest value f_clks_per_bit can return; sizes the counters below

	-- Counter signals
	signal r_clk_counter, n_clk_counter : integer range 0 to MAX_CLKS_PER_BIT-1 := 0;  -- counts FPGA clock cycles in one UART bit period
	signal r_bit_counter, n_bit_counter : integer range 0 to DATA_LENGTH-1  := 0;  -- tracks data bits inside one data byte
	signal r_clks_per_bit, n_clks_per_bit : integer range 1 to MAX_CLKS_PER_BIT := MAX_CLKS_PER_BIT;  -- latched bit period for the byte in flight

begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then  -- rst is active low (DIP switch)
				r_state 	  	 <= RX_IDLE;
				r_rx_byte 		 <= (others => '0');
				r_rx_valid_pulse <= '0';
				r_UART_RX_LED 	 <= '0';
				r_valid_start	 <= '0';
				r_valid_stop     <= '0';
				r_clk_counter 	 <= 0;
				r_bit_counter 	 <= 0;
				r_clks_per_bit   <= MAX_CLKS_PER_BIT;
			else
				r_state 	  	 <= n_state;
				r_rx_byte 		 <= n_rx_byte;
				r_rx_valid_pulse <= n_rx_valid_pulse;
				r_UART_RX_LED 	 <= n_UART_RX_LED;
				r_valid_start	 <= n_valid_start;
				r_valid_stop     <= n_valid_stop;
				r_clk_counter 	 <= n_clk_counter;
				r_bit_counter 	 <= n_bit_counter;
				r_clks_per_bit   <= n_clks_per_bit;
			end if;
		end if;
	end process seq_proc;


	-- 2FF synchronizer on input from bridge IC
	sync_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_rx_sync_1 <= '1';  -- IDLE HIGH
				r_rx_sync_2 <= '1';  -- IDLE HIGH
			else
				r_rx_sync_1 <= i_UART_RX;
				r_rx_sync_2 <= r_rx_sync_1;
			end if;
		end if;
	end process sync_proc;
	
	
	-- Combinational process for dealing with UART RX internal FSM
	fsm_proc: process(all) is
	begin
		-- Defaults
		n_state 	   	 	<= r_state;
		n_rx_byte 		 	<= r_rx_byte;
		n_rx_valid_pulse 	<= '0';
		n_UART_RX_LED 	 	<= r_UART_RX_LED;
		n_valid_start		<= r_valid_start;
		n_valid_stop		<= r_valid_stop;
		n_clk_counter  	 	<= r_clk_counter;
		n_bit_counter  	 	<= r_bit_counter;
		n_clks_per_bit		<= r_clks_per_bit;

		case r_state is
			when RX_IDLE =>
				if r_rx_sync_2 = '0' then  -- detect start bit '0'
					n_clks_per_bit <= f_clks_per_bit(i_baud_sel);  -- latch bit period for the whole byte, on start-bit detection
					n_state <= RX_START_BIT;
				end if;

			when RX_START_BIT =>  -- '0' for r_clks_per_bit
				if r_clk_counter = r_clks_per_bit/2 then
					-- wait half a bit period and sample again to verify start bit '0' present
					if r_rx_sync_2 = '0' then
						-- start bit confirmed, toggle flag so state can be properly updated at the end of bit period
						n_valid_start <= '1';
					else
						n_valid_start <= '0';  -- remains unchanged
					end if;
					n_clk_counter <= r_clk_counter + 1;
				elsif r_clk_counter = r_clks_per_bit-1 then
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					if r_valid_start = '1' then
						n_valid_start <= '0';
						n_state <= RX_DATA_BITS;
					else
						n_state <= RX_IDLE;
					end if;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;

			when RX_DATA_BITS =>  -- bits 0..7, each sampled near the middle of a bit period
				if r_clk_counter = r_clks_per_bit/2 then
					n_rx_byte(r_bit_counter) <= r_rx_sync_2;  -- bit indexing to build up rx_byte
					n_clk_counter <= r_clk_counter + 1;
				elsif r_clk_counter = r_clks_per_bit-1 then
					n_clk_counter <= 0;
					if r_bit_counter = DATA_LENGTH-1 then
						n_bit_counter <= 0;
						n_state <= RX_STOP_BIT;
					else
						n_bit_counter <= r_bit_counter + 1;
					end if;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;

			when RX_STOP_BIT =>  -- '1' for r_clks_per_bit
				if r_clk_counter = r_clks_per_bit/2 then
					if r_rx_sync_2 = '1' then
						-- stop bit detected, toggle flag so state can be properly updated at the end of bit period
						n_valid_stop <= '1';
					else
						n_valid_stop <= '0';  -- remainas unchanged
					end if;
					n_clk_counter <= r_clk_counter + 1;
				elsif r_clk_counter = r_clks_per_bit-1 then
					if r_valid_stop = '1' then  -- valid pulse and LED toggle only happens if stop bit was detected
						n_valid_stop <= '0';
						n_rx_valid_pulse <= '1';
						n_UART_RX_LED <= not r_UART_RX_LED;
					end if;
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					n_state <= RX_IDLE;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;
		end case;
	end process fsm_proc;
	
	
	-- Set outputs	
	o_rx_byte <= r_rx_byte;
	o_rx_valid_pulse <= r_rx_valid_pulse;
	o_UART_RX_LED <= r_UART_RX_LED;
	
end architecture RTL;
