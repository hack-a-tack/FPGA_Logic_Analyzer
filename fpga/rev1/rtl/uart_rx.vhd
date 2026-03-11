-- ========================================
-- MODULE: uart_rx.vhd
-- FUNCTION: converts serial UART data from the host into data bytes
-- AUTHOR: Jakob Kieszek Ottesen
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_UART_RX				1 bit 		<- top
--
-- OUTPUTS					DATA		TO MODULE
-- o_rx_byte				8 bits		-> cmd_parser
-- o_rx_valid_pulse			1 bit		-> cmd_parser
-- o_UART_RX_LED			1 bit		-> top
--
-- NOTES
-- 8N1 UART --> start bit, data bits 0-7 (starting with LSB), stop bit --> 10 baud
-- 1 baud = 1 symbol (1 bit for UART)
-- CLKS_PER_BIT is of type integer. 48e6/921600 = 52.0833... = 52
-- --> Each bit is readable for CLKS_PER_BIT (~52) clock cycles
-- --> Bits should ideally be sampled near the middle of each bit period
-- --> Note that the input is synchronised (2FF) before use
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

entity uart_rx is
	generic (
		CLK_FREQ_HZ : integer := 48_000_000;
		BAUD_RATE 	: integer := 921600;
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk					: in  std_logic;
		i_rst					: in  std_logic;
		i_UART_RX				: in  std_logic;
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
	
	-- Registered signals for 2FF synchroniser
	signal r_rx_sync_1 : std_logic := '1';
	signal r_rx_sync_2 : std_logic := '1';
	
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
				r_state 	  	 <= RX_IDLE;
				r_rx_byte 		 <= (others => '0');
				r_rx_valid_pulse <= '0';
				r_UART_RX_LED 	 <= '0';
				r_clk_counter 	 <= 0;
				r_bit_counter 	 <= 0;
			else
				r_state 	  	 <= n_state;
				r_rx_byte 		 <= n_rx_byte;
				r_rx_valid_pulse <= n_rx_valid_pulse;
				r_UART_RX_LED 	 <= n_UART_RX_LED;
				r_clk_counter 	 <= n_clk_counter;
				r_bit_counter 	 <= n_bit_counter;
			end if;
		end if;
	end process seq_proc;
	
	
	-- 2FF synchronizer on input from bridge IC
	sync_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				r_rx_sync_1 <= '1';  -- IDLE high
				r_rx_sync_2 <= '1';  -- IDLE high
			else
				r_rx_sync_1 <= i_UART_RX;
				r_rx_sync_2 <= r_rx_sync_1;
			end if;
		end if;
	end process sync_proc;
	
	
	-- Combinational process for dealing with UART TX internal FSM
	fsm_proc: process(all) is
	begin
		-- Defaults
		n_state 	   	 	<= r_state;
		n_rx_byte 		 	<= r_rx_byte;
		n_rx_valid_pulse 	<= '0';
		n_UART_RX_LED 	 	<= r_UART_RX_LED;
		n_clk_counter  	 	<= r_clk_counter;
		n_bit_counter  	 	<= r_bit_counter;
	
		case r_state is
			when RX_IDLE =>
				if r_rx_sync_2 = '0' then  -- detect start bit '0'
					n_state <= RX_START_BIT;
				end if;
			
			when RX_START_BIT =>  -- '0' for CLKS_PER_BIT
				if r_clk_counter = CLKS_PER_BIT/2 then
					-- wait half a bit period and sample again to verify start bit '0' present
					if r_rx_sync_2 = '0' then
						-- start bit confirmed
					else
						n_clk_counter <= 0;
						n_bit_counter <= 0;
						n_state <= RX_IDLE;
					end if;
					n_clk_counter <= r_clk_counter + 1;
				elsif r_clk_counter = CLKS_PER_BIT-1 then
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					if r_rx_sync_2 = '0' then
						n_state <= RX_DATA_BITS;
					else
						n_state <= RX_IDLE;
					end if;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;
				
			when RX_DATA_BITS =>  -- bits 0..7, each sampled near the middle of a bit period
				if r_clk_counter = CLKS_PER_BIT/2 then
					n_rx_byte(r_bit_counter) <= r_rx_sync_2;  -- bit indexing to build up rx_byte
					n_clk_counter <= r_clk_counter + 1;
				elsif r_clk_counter = CLKS_PER_BIT-1 then
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
			
			when RX_STOP_BIT =>  -- '1' for CLKS_PER_BIT
				if r_clk_counter = CLKS_PER_BIT/2 then
					if r_rx_sync_2 = '1' then
						-- stop bit detected
					else
						n_clk_counter <= 0;
						n_bit_counter <= 0;
						n_state <= RX_IDLE;
					end if;
					n_clk_counter <= r_clk_counter + 1;
				elsif r_clk_counter = CLKS_PER_BIT-1 then
					if r_rx_sync_2 = '1' then  -- stop bit must be detected for valid pulse and LED toggle
						n_rx_valid_pulse <= '1';
						n_UART_RX_LED <= not r_UART_RX_LED;
					end if;
					n_clk_counter <= 0;
					n_bit_counter <= 0;
					n_state <= RX_IDLE;
				else
					n_clk_counter <= r_clk_counter + 1;
				end if;
			
			when others =>
				null;
		end case;
	end process fsm_proc;
	
	
	-- Set outputs	
	o_rx_byte <= r_rx_byte;
	o_rx_valid_pulse <= r_rx_valid_pulse;
	o_UART_RX_LED <= r_UART_RX_LED;
	
end architecture RTL;
