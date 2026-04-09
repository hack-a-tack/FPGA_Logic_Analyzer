-- ========================================
-- MODULE: top_tb.vhd
-- FUNCTION: TESTBENCH for top level entity which ties all underlying modules together
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-09 (YYYY-MM-DD)
--
-- INPUTS 					DATA		TO INTERNAL MODULE
-- i_RESET					1 bit		-> uart_rx | cmd_parser | analyzer_fsm | capture_engine | send_engine | tx_mux | uart_tx
-- i_LA0					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA1					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA2					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA3					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA4					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA5					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA6					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA7					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_UART_RX				1 bit		-> uart_rx
--
-- OUTPUTS					DATA		FROM INTERNAL MODULE
-- o_UART_TX				1 bit		<- uart_tx
-- o_UART_TX_LED			1 bit		<- uart_tx
-- o_UART_RX_LED			1 bit		<- uart_rx
-- o_USER_LED				1 bit		<- analyzer_fsm
--
-- NOTES
-- i_LA0 through i_LA7 get assembled into std_logic_vector of length 8 "ANALYZER_INPUTS" before it's sent to -> capture_engine
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_tb is
end entity top_tb;

architecture sim of top_tb is
    -- Component declaration (optional in VHDL-2008)
    component top
		generic(
			CLK_FREQ_HZ : integer := 48_000_000;
			BAUD_RATE 	: integer := 921600;
			ADDR_LENGTH : integer := 12;
			NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 4096
			DATA_LENGTH : integer := 8
		);
        port(			
			i_RESET  			: in  std_logic;
			i_LA0				: in  std_logic;
			i_LA1				: in  std_logic;
			i_LA2				: in  std_logic;
			i_LA3				: in  std_logic;
			i_LA4				: in  std_logic;
			i_LA5				: in  std_logic;
			i_LA6				: in  std_logic;
			i_LA7				: in  std_logic;
			i_UART_RX 			: in  std_logic;
			o_UART_TX			: out std_logic;
			o_UART_TX_LED		: out std_logic;
			o_UART_RX_LED		: out std_logic;
			o_USER_LED			: out std_logic
        );
    end component;
	
	-- Constant declaration
	constant CLK_FREQ_HZ : integer := 48_000_000;
	constant BAUD_RATE 	: integer := 921600;
	constant ADDR_LENGTH : integer := 12;
	constant NUM_SAMPLES : integer := 2**ADDR_LENGTH;
	constant DATA_LENGTH : integer := 8;
	
	constant CLK_FREQ   : real := 48.0e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  	-- 20833 ps (truncated)
	constant CLK_HALF : time := CLK_PERIOD / 2;			-- 10416 ps (truncated)
	constant CLK_ACTUAL : time := CLK_HALF * 2;			-- 20832 ps --> identical to 2 x CLK_HALF (used in clock generation)

	constant CLKS_PER_BIT : integer := CLK_FREQ_HZ / BAUD_RATE;  -- ~52 [*CLK_ACTUAL --> bit period]
	constant BIT_PERIOD : time := 1 sec / BAUD_RATE;
	constant HALF_BIT_P : time := BIT_PERIOD / 2;

    -- Signals to connect to DUT
	signal i_RESET 			: std_logic := '0';
	signal i_LA0 			: std_logic := '0';
	signal i_LA1 			: std_logic := '0';
	signal i_LA2 			: std_logic := '0';
	signal i_LA3 			: std_logic := '0';
	signal i_LA4 			: std_logic := '0';
	signal i_LA5 			: std_logic := '0';
	signal i_LA6 			: std_logic := '0';
	signal i_LA7 			: std_logic := '0';
	signal i_UART_RX 		: std_logic := '1';  -- idle high
	signal o_UART_TX 		: std_logic;
	signal o_UART_TX_LED 	: std_logic;
	signal o_UART_RX_LED 	: std_logic;
	signal o_USER_LED 		: std_logic;
	
	-- Other signals
	signal test_id : integer := 0;  -- keep track of test cases
	signal tx_count : integer := 0;  -- keep track of reconstructed bytes on o_UART_TX line

	type log_type is array(20 downto 0) of std_logic_vector(DATA_LENGTH-1 downto 0);  -- 20 x 8
	signal tx_log : log_type;  -- store reconstructed bytes on o_UART_TX line

begin
    -- DUT Instantiation
    dut: top
		generic map (
			CLK_FREQ_HZ => CLK_FREQ_HZ,
			BAUD_RATE	=> BAUD_RATE,
			ADDR_LENGTH => ADDR_LENGTH,
			NUM_SAMPLES => NUM_SAMPLES,
			DATA_LENGTH => DATA_LENGTH
		)
        port map (
			i_RESET => i_RESET,
			i_LA0 => i_LA0,
			i_LA1 => i_LA1, 
			i_LA2 => i_LA2,
			i_LA3 => i_LA3,
			i_LA4 => i_LA4,
			i_LA5 => i_LA5,
			i_LA6 => i_LA6,
			i_LA7 => i_LA7,
			i_UART_RX => i_UART_RX,
			o_UART_TX => o_UART_TX,
			o_UART_TX_LED => o_UART_TX_LED,
			o_UART_RX_LED => o_UART_RX_LED,
			o_USER_LED => o_USER_LED
        );
	

	-- Monitor process to keep track of o_UART_TX status/error/data bytes concurrently with incoming i_UART_RX data
	monitor_proc : process is
		variable reconstr_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	begin
		while true loop
			wait until o_UART_TX = '0' for 5 ms;  -- start bit (with 5ms timeout so no potential failure can cause sim to hang)
			assert o_UART_TX = '0'
				report "MONITOR PROCESS: timeout waiting for start bit"
				severity error;
			
			-- reconstruct 1 byte
			-- start bit
			wait for HALF_BIT_P;  -- read bit value roughly at midpoint
			assert o_UART_TX = '0'
				report "MONITOR PROCESS: start bit not '0'"
				severity error;
			
			-- data bits
			for i in 0 to 7 loop
				wait for BIT_PERIOD;
				reconstr_byte(i) := o_UART_TX;
			end loop;
			
			-- store into tx_log if valid stop bit
			wait for BIT_PERIOD;
			assert o_UART_TX = '1'  -- stop bit
				report "MONITOR PROCESS: stop bit not '1'"
				severity error;
			
			wait for HALF_BIT_P;  -- wait with updating the log until end of bit period (in line with o_UART_TX_LED)
			tx_log(tx_count) <= reconstr_byte;
			tx_count <= tx_count + 1;
		end loop;
	
	end process;
	

    -- Stimulus process
    stim_proc: process is

		procedure uart_send_byte(  -- drives i_UART_RX
			signal rx_line : out std_logic;  -- for reusability. we will output to i_UART_RX for all test cases
			byte : std_logic_vector(DATA_LENGTH-1 downto 0);
			idle_bits_before_start : boolean
		) is
		begin
			if idle_bits_before_start = true then
				rx_line <= '1';  -- idle high
				wait for 2*BIT_PERIOD;  -- keep high for 2 bit periods before start bit (reduce flaky edge cases)
			end if;
			
			rx_line <= '0';  -- start bit
			wait for BIT_PERIOD;
			rx_line <= byte(0);  -- data bit 0, LSB
			wait for BIT_PERIOD;
			rx_line <= byte(1);  -- data bit 1, LSB --> MSB
			wait for BIT_PERIOD;
			rx_line <= byte(2);  -- data bit 2, LSB --> MSB
			wait for BIT_PERIOD;
			rx_line <= byte(3);  -- data bit 3, LSB --> MSB
			wait for BIT_PERIOD;
			rx_line <= byte(4);  -- data bit 4, LSB --> MSB
			wait for BIT_PERIOD;
			rx_line <= byte(5);  -- data bit 5, LSB --> MSB
			wait for BIT_PERIOD;
			rx_line <= byte(6);  -- data bit 6, LSB --> MSB
			wait for BIT_PERIOD;
			rx_line <= byte(7);  -- data bit 7, MSB
			wait for BIT_PERIOD;
			rx_line <= '1';  -- stop bit
			wait for BIT_PERIOD;
		end procedure uart_send_byte;
		
		procedure uart_expect_byte(  -- samples o_UART_TX (at mid-bit)
			signal tx_line : in std_logic;  -- tx_line is connected to o_UART_TX in all test cases
			test_case : integer;
			run_number : integer;
			expected : std_logic_vector(DATA_LENGTH-1 downto 0)
		) is
		begin
			wait until tx_line = '0' for 5 ms;  -- start bit (with 5ms timeout so no potential failure can cause sim to hang)
			wait for HALF_BIT_P;  -- read bit value roughly at midpoint
			assert tx_line = '0'  -- start bit
				report "TC" & integer'image(test_case) & "/Run#" & integer'image(run_number) & ": timeout waiting for start bit"
				severity error;
			
			for i in 0 to 7 loop
				wait for BIT_PERIOD;
				assert tx_line = expected(i)  -- data bit i, LSB --> MSB
					report "TC" & integer'image(test_case) & "/Run#" & integer'image(run_number) & ": data bit " & integer'image(i) & " not as expected"
					severity error;
			end loop;
			
			wait for BIT_PERIOD;
			assert tx_line = '1'  -- stop bit
				report "TC" & integer'image(test_case) & "/Run#" & integer'image(run_number) & ": (stop bit) expected '1' | not observed"
				severity error;
			wait for HALF_BIT_P;
		end procedure uart_expect_byte;
	
    begin
		--------------------------------------------------------
		-- Reset phase
		--------------------------------------------------------
        wait for CLK_ACTUAL;
		i_RESET <= '1';
		wait for CLK_ACTUAL;
		i_RESET <= '0';
		wait for CLK_ACTUAL;
		
		
		--------------------------------------------------------
		-- Test case 1: verify UART_TX idles high post-reset
		--------------------------------------------------------
		test_id <= 1;
		-- if UART_TX goes low for start bit, it will stay low for ~1 bit, so half-bit sampling will catch it
		for i in 0 to 20 loop  -- sample every half bit period for 10 bits.
			wait for HALF_BIT_P;
			assert o_UART_TX = '1'
				report "TC1: expected idle high UART_TX after reset | not observed"
				severity error;
		end loop;
		
		
		--------------------------------------------------------
		-- Test case 2: CAPTURE command end-to-end (bit-level)
		--------------------------------------------------------
		wait for CLK_ACTUAL;
		test_id <= 2;
		uart_send_byte(i_UART_RX, "10100000", true);  -- send CAPTURE opcode x"A0" = b"1010 0000" to UART_RX line
		
		-- set inputs to be sampled (4096 samples @ 24MHz should take roughly 170 us + overhead)
		i_LA0 <= '1';
		i_LA1 <= '1';
		i_LA2 <= '1';
		i_LA3 <= '1';
		i_LA4 <= '0';
		i_LA5 <= '0';
		i_LA6 <= '0';
		i_LA7 <= '0';
		
		-- wait for rx_valid pulse to be assigned/go high
		-- wait for cmd pulse from cmd_parser to go high
		-- status byte x"55" and start pulse sent to tx_mux // capture_engine starts up
		-- byte and start pulse passed on to uart_tx module
		
		-- Should see status code x"55" = b"0101 0101" (OK) from UART_TX line
		-- (note that UART byte time is ~10.85 us. 10 bits * 1.085us bit period)
		uart_expect_byte(o_UART_TX, test_id, 0, "01010101");
		
		-- data capture --> lasts (CLK_ACTUAL*2) * 4096 --> 170.7us --> 169.85us (+10.85 for completed UART frame)
		-- Should see status code x"77" = b"0111 0111" (DONE) from UART_TX line
		uart_expect_byte(o_UART_TX, test_id, 1, "01110111");
		
		
		--------------------------------------------------------
		-- Test case 3: READ command end-to-end
		--------------------------------------------------------
		wait for CLK_ACTUAL;
		test_id <= 3;
		uart_send_byte(i_UART_RX, "10100001", true);  -- send READ opcode x"A1" = b"1010 0001" to UART_RX line
		
		-- Should see status code x"99" = b"1001 1001" (HEADER for data payload) from UART_TX line
		uart_expect_byte(o_UART_TX, test_id, 2, "10011001");
		
		-- Then, 4096 data bytes should be sent (all of which should be "0000 1111"), check first few
		-- 1st data byte
		uart_expect_byte(o_UART_TX, test_id, 3, "00001111");
		
		-- 2nd data byte
		uart_expect_byte(o_UART_TX, test_id, 4, "00001111");
		
		-- 3rd data byte
		uart_expect_byte(o_UART_TX, test_id, 5, "00001111");
		
		
		--------------------------------------------------------
		-- Test case 4: back-to-back commands with no idle gaps
		--------------------------------------------------------
		-- reset before TC4 to avoid waiting ~45 ms of sim time
		wait for CLK_ACTUAL;
		i_RESET <= '1';
		wait for CLK_ACTUAL;
		i_RESET <= '0';
		wait for CLK_ACTUAL;
		test_id <= 4;
		
		-- set inputs to be sampled (4096 samples @ 24MHz should take roughly 170 us + overhead)
		i_LA0 <= '1';  -- LSB
		i_LA1 <= '1';
		i_LA2 <= '0';
		i_LA3 <= '0';
		i_LA4 <= '1';
		i_LA5 <= '1';
		i_LA6 <= '0';
		i_LA7 <= '0';  -- MSB
		
		--------------------------------------------------------
		-- 4a: back-to-back commands from state IDLE (analyzer_fsm)
		-- IDLE |--> READ --> UNKOWN COMMAND
		--------------------------------------------------------
		uart_send_byte(i_UART_RX, "10100001", true);  	-- xA1 READ frame. Expect xEE response (data not ready)
		uart_send_byte(i_UART_RX, "10100010", false);  	-- xA2 UNKOWN COMMAND frame. Expect xEE response (opcode not recognized)
		
		wait until tx_count = 8;
		assert tx_log(6) = "11101110"		-- xEE error code (data not ready)
			report "TC4a: 1st response after back-to-backs (from IDLE) is not xEE"
			severity error;
		assert tx_log(7) = "11101110"		-- xEE error code (opcode not recognized)
			report "TC4a: 2nd response after back-to-backs (from IDLE) is not xEE"
			severity error;
		
		--------------------------------------------------------
		-- 4b: back-to-back commands from state CAPTURE (analyzer_fsm)
		-- IDLE --> CAPTURE |--> READ --> CAPTURE --> UNKOWN COMMAND
		--------------------------------------------------------
		uart_send_byte(i_UART_RX, "10100000", false);  	-- send CAPTURE frame. Expect x55 OK, then after 160us more, expect x77 DONE (comes last). 
		uart_send_byte(i_UART_RX, "10100001", false);  	-- send READ frame immediately after. Expect xEE (data not ready)
		uart_send_byte(i_UART_RX, "10100000", false);  	-- send CAPTURE frame immediately after. Expect xEE (already capturing)
		uart_send_byte(i_UART_RX, "10100010", false);  	-- send UNKOWN COMMAND frame immediately after. Expect xEE (opcode not recognized)
		
		wait until tx_count = 13;
		assert tx_log(8) = "01010101"		-- x55 status code
			report "TC4b: 1st response after back-to-backs (from CAPTURE) is not status code x55"
			severity error;
		assert tx_log(9) = "11101110"		-- xEE error code (data not ready @ READ command)
			report "TC4b: 2nd response after back-to-backs (from CAPTURE) is not error code xEE"
			severity error;
		assert tx_log(10) = "11101110"		-- xEE error code (already capturing data)
			report "TC4b: 3rd response after back-to-backs (from CAPTURE) is not error code xEE"
			severity error;
		assert tx_log(11) = "11101110"		-- xEE error code (opcode not recognized)
			report "TC4b: 4th response after back-to-backs (from CAPTURE) is not error code xEE"
			severity error;
		assert tx_log(12) = "01110111"		-- x77 status code (capture complete)
			report "TC4b: 5th response after back-to-backs (from CAPTURE) is not status code x77"
			severity error;
		
		--------------------------------------------------------
		-- 4c: back-to-back commands from state DONE (analyzer_fsm)
		-- DONE |--> UNKOWN COMMAND --> CAPTURE (brings us back to DONE again) then |--> READ
		--------------------------------------------------------
		uart_send_byte(i_UART_RX, "10100010", false);  	-- send UNKOWN COMMAND frame immediately. Expect xEE (opcode not recognized)
		uart_send_byte(i_UART_RX, "10100000", false);  	-- send CAPTURE frame. Expect x55, then ~170us later: x77 and back to DONE.
		
		wait until tx_count = 16;
		assert tx_log(13) = "11101110"		-- xEE error code (opcode not recognized)
			report "TC4c: 1st response after back-to-backs (from DONE) is not error code xEE"
			severity error;
		assert tx_log(14) = "01010101"		-- x55 status code
			report "TC4c: 2nd response after back-to-backs (from DONE) is not status code x55"
			severity error;
		assert tx_log(15) = "01110111"		-- x77 status code (capture complete)
			report "TC4c: 3rd response after back-to-backs (from DONE) is not status code x77"
			severity error;
			
		uart_send_byte(i_UART_RX, "10100001", false);  	-- send READ frame immediately. Expect x99, then x33 data bytes
		
		wait until tx_count = 20;
		assert tx_log(16) = "10011001"		-- x99 status code
			report "TC4c: 4th response after back-to-backs (from DONE) is not status code x99"
			severity error;
		assert tx_log(17) = "00110011"		-- 1st data byte (x33)
			report "TC4c: 5th response after back-to-backs (from DONE) is not data byte x33"
			severity error;
		assert tx_log(18) = "00110011"		-- 2nd data byte (x33)
			report "TC4c: 6th response after back-to-backs (from DONE) is not data byte x33"
			severity error;
		assert tx_log(19) = "00110011"		-- 3rd data byte (x33)
			report "TC4c: 7th response after back-to-backs (from DONE) is not data byte x33"
			severity error;
		
		
		--------------------------------------------------------
		-- Test case 5: bad UART frame resilience
		--------------------------------------------------------
		-- reset before TC5 to avoid waiting ~45 ms of sim time
		wait for CLK_ACTUAL;
		i_RESET <= '1';
		wait for CLK_ACTUAL;
		i_RESET <= '0';
		wait for CLK_ACTUAL;
		test_id <= 5;
		
		i_UART_RX <= '1';  -- idle high
		wait for 2*BIT_PERIOD;  -- keep high for 2 bit periods before start bit (reduce flaky edge cases)
		
		-- Drive start + data bits for opcode (CAPTURE = A0), but stop bit invalid (0)
		i_UART_RX <= '0';  -- start bit
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 0, LSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 1, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 2, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 3, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 4, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '1';  -- data bit 5, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 6, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '1';  -- data bit 7, MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- INVALID stop bit
		wait for BIT_PERIOD;
		
		-- uart_rx module should be in state RX_IDLE, RX_LED should not toggle, TX should not send 0x55 status byte
		i_UART_RX <= '1';  -- idle high
		wait for HALF_BIT_P;
		assert o_UART_TX = '1'  -- UART_TX should remain idle high
			report "TC5: o_UART_TX went low (start bit) after invalid stop bit"
			severity error;
		
		wait for 10*BIT_PERIOD;  -- keep high for 10 bit periods before start bit (observe that o_UART_TX stays idle high)
		
		-- Drive start + data bits for opcode (CAPTURE), and valid stop bit (1)
		i_UART_RX <= '0';  -- start bit
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 0, LSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 1, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 2, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 3, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 4, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '1';  -- data bit 5, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '0';  -- data bit 6, LSB --> MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '1';  -- data bit 7, MSB
		wait for BIT_PERIOD;
		i_UART_RX <= '1';  -- VALID stop bit
		wait for BIT_PERIOD;
		
		wait until tx_count = 21;
		assert tx_log(20) = "01010101"
			report "TC5: x55 NOT received after valid CAPTURE frame"
			severity error;
		
		
		--------------------------------------------------------
        -- Finish simulation
		--------------------------------------------------------
        wait for 10*CLK_ACTUAL;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
