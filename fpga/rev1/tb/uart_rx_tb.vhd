-- ========================================
-- MODULE: uart_rx_tb.vhd
-- FUNCTION: TESTBENCH for entity which converts serial UART data into data bytes
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-21 (YYYY-MM-DD)
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
-- Waveform shows o_rx_valid_pulse rising 3 cycles after uart_frame_status toggles.
-- Still correct with 4 wait statements, just note that the waveform is measuring from a later reference point
-- ... than "the moment the last bit was driven".
-- ... Lag #3 (FSM state register / counter) has been absorbed into the stop bit period itself.
-- ... It's not visible after uart_frame_status.
-- ... The DUT has already been processing that stop bit during the final BIT_PERIOD clocks (of the procedure).
-- Using "wait for 0 ps" to add delta cycle and get past coincident edge of DUT, given 0 drift in clock periods.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx_tb is
end entity uart_rx_tb;

architecture sim of uart_rx_tb is
    -- Component declaration (optional in VHDL-2008)
    component uart_rx
		generic (
			CLK_FREQ_HZ : integer := 48_000_000;
			BAUD_RATE 	: integer := 921600;
			DATA_LENGTH : integer := 8
		);
        port(
			i_clk					: in  std_logic;
			i_rst					: in  std_logic;
			i_UART_RX				: in  std_logic;
			o_rx_byte				: out std_logic_vector(DATA_LENGTH-1 downto 0);
			o_rx_valid_pulse		: out std_logic;
			o_UART_RX_LED			: out std_logic
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
	signal i_UART_RX				: std_logic := '1';
	signal o_rx_byte				: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal o_rx_valid_pulse			: std_logic;
	signal o_UART_RX_LED			: std_logic;
	
	-- Signals for easier troubleshooting
	signal test_id : integer := 0;  				-- increments with each test case
	signal uart_frame_status : std_logic := '0';	-- toggles with each full uart frame

begin

    -- DUT Instantiation
    uut: uart_rx
		generic map (
			CLK_FREQ_HZ => CLK_FREQ_HZ,
			BAUD_RATE => BAUD_RATE,
			DATA_LENGTH => DATA_LENGTH 
		)
        port map (			
			i_clk => i_clk,
			i_rst => i_rst,
			i_UART_RX => i_UART_RX,
			o_rx_byte => o_rx_byte,
			o_rx_valid_pulse => o_rx_valid_pulse,
			o_UART_RX_LED => o_UART_RX_LED
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
	
		procedure send_uart_frame (
			data 			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
			stop_bit 		: in  std_logic;
			signal rx_line 	: out std_logic
		) is
		begin
			rx_line <= '0';  -- start bit
			wait for BIT_PERIOD;
			for i in 0 to DATA_LENGTH-1 loop
				rx_line <= data(i);  -- data bit, LSB --> MSB
				wait for BIT_PERIOD;
			end loop;
			rx_line <= stop_bit;  -- stop bit
			wait for BIT_PERIOD;
			rx_line <= '1';  -- default to IDLE HIGH after UART frame
			uart_frame_status <= not uart_frame_status;
		end procedure;
		
    begin
        -- Reset phase
        wait for CLK_ACTUAL;
		i_rst <= '1';
		wait for CLK_ACTUAL;
		i_rst <= '0';
		wait until rising_edge(i_clk);
		
		-- Test case 1: UART should be idle high in state RX_IDLE
		test_id <= 1; wait for 0 ps;
		assert i_UART_RX = '1'
			report "TC1: uart_rx module reading '0' from host when '1' is expected (RX_IDLE)"
			severity error;
		assert o_rx_valid_pulse = '0'
			report "TC1: RX valid pulse high, but module supposed to be in state RX_IDLE"
			severity error;
		wait until rising_edge(i_clk);
			
        -- Test case 2: uart_rx should output reconstructed byte and valid pulse when 1 full UART frame is received
		-- Start bit '0'; data bits "1010 1010" (0xAA); stop bit '1'
		test_id <= 2; 
		wait until rising_edge(i_clk);  -- alignment wait
		send_uart_frame(data => x"AA", stop_bit => '1', rx_line => i_UART_RX);
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (IDLE --> START_BIT, then CLKS_PER_BIT cycles per state)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"AA"
			report "TC2: reconstructed byte does not match expected value xAA"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC2: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC2: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
		wait until rising_edge(i_clk);
				
		-- Test case 3: start-bit validation. FSM should return to idle, i_rx not pulled low long enough to be valid start bit
		test_id <= 3;
		wait until rising_edge(i_clk);
		i_UART_RX <= '0';
		wait for 2*CLK_ACTUAL;
		i_UART_RX <= '1';
		wait for 8*BIT_PERIOD;
		wait for 0 ps;
		--wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC3: valid pulse went high despite start bit only being low for 2 clock cycles"
			severity error;
		assert o_rx_byte = x"AA"
			report "TC3: rx byte does not match expected value xAA and must have been updated despite short start bit"
			severity error;
		wait until rising_edge(i_clk);
		
		-- Test case 4: bad stop bit. uart_rx should not give valid pulse
		-- Start bit '0'; data bits "0101 0101" (0x55); stop bit FORCED '0'
		test_id <= 4;
		wait until rising_edge(i_clk);
		send_uart_frame(data => x"55", stop_bit => '0', rx_line => i_UART_RX);
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"55"
			report "TC4: reconstructed byte does not match expected value x55"
			severity error;
		assert o_rx_valid_pulse = '0'
			report "TC4: valid pulse goes high despite stop bit forced low"
			severity error;
		wait until rising_edge(i_clk);
		
		-- Test case 5a: back-to-back frames, frame 1
		-- Start bit '0'; data bits "0111 0111" (0x77); stop bit '1'
		test_id <= 5;
		wait until rising_edge(i_clk);
		send_uart_frame(data => x"77", stop_bit => '1', rx_line => i_UART_RX);
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"77"
			report "TC5a: reconstructed byte does not match expected value x77"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC5a: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC5a: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
		
		-- Test case 5b: back-to-back frames, frame 2
		-- Start bit '0'; data bits "1000 1000" (0x88); stop bit '1'
		send_uart_frame(data => x"88", stop_bit => '1', rx_line => i_UART_RX);
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"88"
			report "TC5b: reconstructed byte does not match expected value x88"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC5b: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC5b: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
		wait until rising_edge(i_clk);
		
		-- Test case 6: idle gap robustness. Long idle high periods before/after frame should not trigger receiver module
		test_id <= 6;
		wait until rising_edge(i_clk);
		i_UART_RX <= '1';  -- IDLE high
		wait for 10*BIT_PERIOD;
		wait until rising_edge(i_clk);
		assert o_rx_byte = x"88"
			report "TC6: received byte no longer x88 despite IDLE HIGH"
			severity error;
		assert o_rx_valid_pulse = '0'
			report "TC6: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
		
		-- Start bit '0'; data bits "0001 0001" (0x11); stop bit '1'
		send_uart_frame(data => x"11", stop_bit => '1', rx_line => i_UART_RX);
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"11"
			report "TC6: reconstructed byte does not match expected value x11"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC6: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC6: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
		wait for 2*BIT_PERIOD;  -- i_UART_RX still high (i.e. IDLE HIGH)
		wait until rising_edge(i_clk);
		assert o_rx_byte = x"11"
			report "TC6: reconstructed byte does not match expected value x11"
			severity error;
		wait until rising_edge(i_clk);
			
		-- Test case 7: stress test (6 data bytes back-to-back)
		test_id <= 7;
		wait until rising_edge(i_clk);
		
		send_uart_frame(data => x"55", stop_bit => '1', rx_line => i_UART_RX);  -- "0101 0101" (0x55)
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"55"
			report "TC7a: reconstructed byte does not match expected value x55"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC7a: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC7a: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
			
		send_uart_frame(data => x"A3", stop_bit => '1', rx_line => i_UART_RX);  -- "1010 0011" (0xA3)
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"A3"
			report "TC7b: reconstructed byte does not match expected value xA3"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC7b: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC7b: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
			
		send_uart_frame(data => x"00", stop_bit => '1', rx_line => i_UART_RX);  -- "0000 0000" (0x00)
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"00"
			report "TC7c: reconstructed byte does not match expected value x00"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC7c: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC7c: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
			
		send_uart_frame(data => x"FF", stop_bit => '1', rx_line => i_UART_RX);  -- "1111 1111" (0xFF)
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"FF"
			report "TC7d: reconstructed byte does not match expected value xFF"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC7d: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC7d: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
			
		send_uart_frame(data => x"19", stop_bit => '1', rx_line => i_UART_RX);  -- "0001 1001" (0x19)
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"19"
			report "TC7e: reconstructed byte does not match expected value x19"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC7e: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC7e: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
			
		send_uart_frame(data => x"C7", stop_bit => '1', rx_line => i_UART_RX);  -- "1100 0111" (0xC7)
		wait for 0 ps;  				-- add delta cycle to prevent reprocessing coincident clock edges
		wait until rising_edge(i_clk);  -- accounts for 1st stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for 2nd stage in 2FF
		wait until rising_edge(i_clk);  -- accounts for state register delay (once, then each state lasts CLKS_PER_BIT cycles)
		wait until rising_edge(i_clk);  -- accounts for delay with registered output signals
		assert o_rx_byte = x"C7"
			report "TC7f: reconstructed byte does not match expected value xC7"
			severity error;
		assert o_rx_valid_pulse = '1'
			report "TC7f: o_rx_valid_pulse is not high after full UART frame is received"
			severity error;
		wait until rising_edge(i_clk);
		assert o_rx_valid_pulse = '0'
			report "TC7f: o_rx_valid_pulse is '1', did not match expected value '0'"
			severity error;
		
        -- Finish simulation
        wait for 10*CLK_ACTUAL;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
