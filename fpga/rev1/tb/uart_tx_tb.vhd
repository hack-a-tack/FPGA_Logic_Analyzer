-- ========================================
-- MODULE: uart_tx_tb.vhd
-- FUNCTION: TESTBENCH for entity which converts data bytes into serial UART data
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-22 (YYYY-MM-DD)
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
-- --> Each bit has to be transmitted for CLKS_PER_BIT (~52) clock cycles ("bit period")
-- --> In the testbench, it makes sense to sample roughly in the middle of each bit period
-- Therefore, actual baud rate = 48e6/52 = 923076, not 921600 --> +0.16% error
-- But UART usually tolerates +- 2-3% error
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx_tb is
end entity uart_tx_tb;

architecture sim of uart_tx_tb is
    -- Component declaration (optional in VHDL-2008)
    component uart_tx
		generic (
			CLK_FREQ_HZ : integer := 48_000_000;
			BAUD_RATE 	: integer := 921600;
			DATA_LENGTH : integer := 8
		);
        port(			
			i_clk					: in  std_logic;
			i_rst					: in  std_logic;
			i_mux_tx_byte			: in  std_logic_vector(7 downto 0);
			i_mux_tx_start_pulse	: in  std_logic;
			o_tx_busy				: out std_logic;
			o_UART_TX				: out std_logic;
			o_UART_TX_LED			: out std_logic
        );
    end component;
	
	-- Constant declaration
	constant CLK_FREQ_HZ : integer := 48_000_000;
	constant BAUD_RATE 	: integer := 921600;
	constant DATA_LENGTH : integer := 8;
	
	constant CLK_FREQ   : real := 48.0e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  	-- 20833 ps (truncated)
	constant CLK_HALF : time := CLK_PERIOD / 2;			-- 10416 ps (truncated)
	constant CLK_ACTUAL : time := CLK_HALF * 2;			-- 20832 ps --> effectively
	constant CLKS_PER_BIT : integer := CLK_FREQ_HZ / BAUD_RATE;  -- integer / --> 52
	constant BIT_PERIOD : time := CLKS_PER_BIT * CLK_ACTUAL;

    -- Signals to connect to DUT	
	signal i_clk					: std_logic := '0';
	signal i_rst					: std_logic := '0';
	signal i_mux_tx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal i_mux_tx_start_pulse		: std_logic := '0';
	signal o_tx_busy				: std_logic;
	signal o_UART_TX				: std_logic;
	signal o_UART_TX_LED			: std_logic;
	
	-- Signals for easier troubleshooting
	signal test_id : integer := 0;  				-- increments with each test case
	signal uart_frame_status : std_logic := '0';	-- toggles with each full uart frame

begin

    -- DUT Instantiation
    dut: uart_tx
		generic map (
			CLK_FREQ_HZ => CLK_FREQ_HZ,
			BAUD_RATE => BAUD_RATE,
			DATA_LENGTH => DATA_LENGTH 
		)
        port map (			
			i_clk => i_clk,
			i_rst => i_rst,
			i_mux_tx_byte => i_mux_tx_byte,
			i_mux_tx_start_pulse => i_mux_tx_start_pulse,
			o_tx_busy => o_tx_busy,
			o_UART_TX => o_UART_TX,
			o_UART_TX_LED => o_UART_TX_LED
        );

    -- Clock generation
    clk_process: process is
    begin
        while true loop
            i_clk <= '0';
            wait for CLK_HALF;
            i_clk <= '1';
            wait for CLK_HALF;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process is
	
		procedure process_uart_frame (
			received_byte : in std_logic_vector(DATA_LENGTH-1 downto 0);
			start_pulse_val : in std_logic;
			signal tx_line : out std_logic
		) is
		begin
			-- TBC
		end procedure;
		
	
    begin
        -- Reset phase
		wait until rising_edge(i_clk);
		i_rst <= '1';
		wait until rising_edge(i_clk);
		i_rst <= '0';
		wait until rising_edge(i_clk);
		
		-- Test case 1: TX_IDLE state. UART should be IDLE high and busy signal should be low
		test_id <= 1; wait for 0 ps;
		assert o_tx_busy = '0'
			report "TC1: UART module is busy in state IDLE"
			severity error;
		assert o_UART_TX = '1'
			report "TC1: UART not idle high..."
			severity error;
		wait until rising_edge(i_clk);
			
        -- Test case 2: START BIT ('0')
		-- (start pulse -->) TX_START_BIT state. o_tx_busy should go high, start bit low
		test_id <= 2;
		i_mux_tx_byte <= x"AA";  -- x"AA" = b"1010 1010"
		i_mux_tx_start_pulse <= '1';
		wait until rising_edge(i_clk);  -- accounts for state register delay (IDLE --> START BIT)
		i_mux_tx_start_pulse <= '0';  -- hold the start_pulse HIGH only for one clock cycle
		wait until rising_edge(i_clk);
		assert o_tx_busy = '1'
			report "TC2: Busy signal not asserted high. State TX_START_BIT not reached"
			severity error;
		assert o_UART_TX = '0'  -- start bit
			report "TC2: uart_tx not transmitting start bit '0'"
			severity error;
		wait for BIT_PERIOD/2;  -- set up for sampling (asserting) at the centre of each bit period
		assert o_tx_busy = '1'
			report "TC2: Busy signal not asserted high. State TX_START_BIT not reached"
			severity error;
		assert o_UART_TX = '0'  -- start bit
			report "TC2: uart_tx not transmitting start bit '0'"
			severity error;
		i_mux_tx_byte <= x"FF";  -- x"AA" should be latched, so x"77" should not be seen from o_UART_TX waveform/bit sequence
		wait for BIT_PERIOD;
		
		-- Test case 3: DATA BIT 0
		-- TX_DATA_BITS state. Bit 0 (LSB) of AA is '0'
		test_id <= 3;
		wait for 0 ps;
		assert o_tx_busy = '1'
			report "TC3: Busy signal not asserted high. Indicates we're still in state TX_IDLE"
			severity error;
		assert o_UART_TX = '0'
			report "TC3: uart_tx first, LSB data bit '1', when '0' expected"
			severity error;
		wait for BIT_PERIOD;
		
		-- Test case 4: DATA BIT 1
		-- TX_DATA_BITS state. Bit 1 (second LSB) of AA is '1'
		test_id <= 4;
		wait for 0 ps;
		assert o_tx_busy = '1'
			report "TC4: Busy signal not asserted high. Indicates we're still in state TX_IDLE"
			severity error;
		assert o_UART_TX = '1'
			report "TC4: uart_tx second, LSB data bit '0', when '1' expected"
			severity error;
		wait for 6*BIT_PERIOD;
		
		-- Test case 5: DATA BIT 7
		-- TX_DATA_BITS state. Bit 7 (MSB; eigth LSB) of AA is '1'
		test_id <= 5;
		wait for 0 ps;
		assert o_tx_busy = '1'
			report "TC5: Busy signal not asserted high. Indicates we're still in state TX_IDLE"
			severity error;
		assert o_UART_TX = '1'
			report "TC5: uart_tx MSB (eight LSB) is '0', when '1' was expected"
			severity error;
		wait for BIT_PERIOD;
		
		-- Test case 6: STOP BIT ('1')
		test_id <= 6;
		wait for 0 ps;
		assert o_tx_busy = '1'
			report "TC6: Busy signal not asserted high. Indicates we're still in state TX_IDLE"
			severity error;
		assert o_UART_TX = '1'
			report "TC6: uart_tx not transmitting stop bit '1'"
			severity error;
		wait for BIT_PERIOD/2;
		uart_frame_status <= not uart_frame_status;
		wait for BIT_PERIOD/2;
		
		-- Test case 7: TX_IDLE state
		test_id <= 7;
		wait for 0 ps;
		assert o_tx_busy = '0'
			report "TC7: Busy signal not deasserted. Indicates we're not back in TX_IDLE state"
			severity error;
		assert o_UART_TX = '1'
			report "TC7: uart_tx not outputting IDLE HIGH ('1')"
			severity error;
		
        -- Finish simulation
        wait for 10*CLK_ACTUAL;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
