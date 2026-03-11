-- ========================================
-- MODULE: uart_tx.vhd
-- FUNCTION: converts data bytes going to the host into serial UART data
-- AUTHOR: Jakob Kieszek Ottesen
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_mux_tx_byte			8 bits 		<- tx_mux
-- i_mux_tx_start_pulse		1 bit		<- tx_mux
--
-- OUTPUTS					DATA		TO MODULE
-- o_tx_busy				1 bit		-> analyzer_fsm ; send_engine
-- o_UART_TX				1 bit		-> top
-- o_UART_TX_LED			1 bit		-> top
--
-- NOTES
-- 8N1 UART --> start bit, data bits 0-7 (starting with LSB), stop bit --> 10 baud
-- 1 baud = 1 symbol (1 bit for UART)
-- CLKS_PER_BIT is of type integer. 48e6/921600 = 52.0833... = 52
-- --> Each bit has to be transmitted for CLKS_PER_BIT (~52) clock cycles
-- Therefore, actual baud rate = 48e6/52 = 923076, not 921600 --> +0.16% error
-- But UART usually tolerates +- 2-3% error
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

entity uart_tx is
	generic (
		CLK_FREQ_HZ : integer := 48_000_000;
		BAUD_RATE 	: integer := 921600;
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk					: in  std_logic;
		i_rst					: in  std_logic;
		i_mux_tx_byte			: in  std_logic_vector(7 downto 0);
		i_mux_tx_start_pulse	: in  std_logic;
		o_tx_busy				: out std_logic;
		o_UART_TX				: out std_logic;
		o_UART_TX_LED			: out std_logic
	);
end entity uart_tx;

architecture RTL of uart_tx is
	-- Internal uart_tx state machine
	type UART_TX_state_type is (TX_IDLE, TX_START_BIT, TX_DATA_BITS, TX_STOP_BIT);
	
	-- Register signals, next-state signals
	signal r_state, n_state : UART_TX_state_type := TX_IDLE;									-- internal state
	signal r_tx_busy, n_tx_busy : std_logic := '0';  											-- output
	signal r_UART_TX, n_UART_TX : std_logic := '0';  											-- output
	signal r_tx_byte, n_tx_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');  -- for input latching
	
	-- Counter signals
	signal r_clk_counter, n_clk_counter : integer := 0;  -- counts FPGA clock cycles in one UART bit period
	signal r_bit_counter, n_bit_counter : integer := 0;  -- tracks data bits inside one data byte
	
	-- Constants
	constant CLKS_PER_BIT : integer := CLK_FREQ_HZ / BAUD_RATE;
	
begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				r_state 	  <= TX_IDLE;
				r_tx_busy 	  <= '0';
				r_UART_TX 	  <= '1';  -- UART is idle high
				r_tx_byte 	  <= (others => '0');
				r_clk_counter <= 0;
				r_bit_counter <= 0;
			else
				r_state 	  <= n_state;
				r_tx_busy 	  <= n_tx_busy;
				r_UART_TX 	  <= n_UART_TX;
				r_tx_byte 	  <= n_tx_byte;
				r_clk_counter <= n_clk_counter;
				r_bit_counter <= n_bit_counter;
			end if;
		end if;
	end process seq_proc;
	
	
	-- Combinational process for dealing with UART TX internal FSM
	fsm_proc: process(all) is
	begin
		-- Defaults
		n_state 	   <= r_state;
		n_tx_busy 	   <= r_tx_busy;
		n_UART_TX 	   <= r_UART_TX;
		n_tx_byte 	   <= r_tx_byte;
		n_clk_counter  <= r_clk_counter;
		n_bit_counter  <= r_bit_counter;
	
		case r_state is
			when TX_IDLE =>
				n_tx_busy <= '0';
				n_UART_TX <= '1';  -- force line high (UART is idle high)
				if i_mux_tx_start_pulse = '1' then
					n_tx_byte <= i_mux_tx_byte;  -- latch input byte so it doesn't change during transmission
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					n_state <= TX_START_BIT;
				end if;
			
			when TX_START_BIT =>  -- hold '0' for CLKS_PER_BIT
				n_tx_busy <= '1';  -- assert busy flag so analyzer_fsm/send_engine waits
				n_UART_TX <= '0';
				if r_clk_counter = CLKS_PER_BIT-1 then
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					n_state <= TX_DATA_BITS;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;
				
			when TX_DATA_BITS =>  -- send bits 0..7, hold each for CLKS_PER_BIT
				n_tx_busy <= '1';
				n_UART_TX <= r_tx_byte(r_bit_counter);
				
				if r_clk_counter = CLKS_PER_BIT-1 then
					n_clk_counter <= 0;
					if r_bit_counter = DATA_LENGTH-1 then
						n_bit_counter <= 0;
						n_state <= TX_STOP_BIT;
					else
						n_bit_counter <= r_bit_counter + 1;
					end if;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;
			
			when TX_STOP_BIT =>  -- hold '1' for CLKS_PER_BIT
				n_tx_busy <= '1';
				n_UART_TX <= '1';
				if r_clk_counter = CLKS_PER_BIT-1 then
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					n_state <= TX_IDLE;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;
			
			when others =>
				null;
		end case;
	end process fsm_proc;
	
	
	-- Set outputs	
	o_tx_busy <= r_tx_busy;
	o_UART_TX <= r_UART_TX;
	o_UART_TX_LED <= r_tx_busy;
	
end architecture RTL;
