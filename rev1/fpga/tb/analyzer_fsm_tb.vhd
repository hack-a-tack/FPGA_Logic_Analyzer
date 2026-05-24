-- ========================================
-- MODULE: analyzer_fsm_tb.vhd
-- FUNCTION: TESTBENCH for controlling entity of logic analyzer state machine
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-12 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_cmd_error_pulse		1 bit		<- cmd_parser
-- i_capture_cmd_pulse		1 bit		<- cmd_parser
-- i_capture_done_pulse		1 bit		<- capture_engine
-- i_read_cmd_pulse			1 bit		<- cmd_parser
-- i_send_done_pulse		1 bit		<- send_engine
--
-- OUTPUTS					DATA		TO MODULE
-- o_capture_start_pulse	1 bit		-> capture_engine
-- o_send_start_pulse		1 bit		-> send_engine
-- o_fsm_tx_status_byte		8 bits		-> tx_mux
-- o_fsm_tx_start_pulse		1 bit		-> tx_mux
-- o_USER_LED				1 bit		-> top
--
-- NOTES
-- Status bytes from analyzer_fsm are prioritised over data from send_engine, because they're singular bytes and come rarely.
-- Thus, analyzer_fsm sends data to tx_mux regardless of uart_tx state (busy/ready)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity analyzer_fsm_tb is
end entity analyzer_fsm_tb;

architecture sim of analyzer_fsm_tb is
    -- Component declaration (optional in VHDL-2008)
    component analyzer_fsm
		generic(
			DATA_LENGTH : integer := 8
		);
        port(
            i_clk 					: in  std_logic;
			i_rst 					: in  std_logic;
			i_cmd_error_pulse		: in  std_logic;
			i_capture_cmd_pulse		: in  std_logic;
			i_capture_done_pulse	: in  std_logic;
			i_read_cmd_pulse		: in  std_logic;
			i_send_done_pulse		: in  std_logic;
			o_capture_start_pulse	: out std_logic;
			o_send_start_pulse		: out std_logic;
			o_fsm_tx_status_byte	: out std_logic_vector(DATA_LENGTH-1 downto 0);
			o_fsm_tx_start_pulse	: out std_logic;
			o_USER_LED				: out std_logic
        );
    end component;
	
	-- Constant declaration
	constant CLK_FREQ_HZ : integer := 48_000_000;
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48.0e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  	-- 20833 ps (truncated)
	constant CLK_HALF : time := CLK_PERIOD / 2;			-- 10416 ps (truncated)
	constant CLK_ACTUAL : time := CLK_HALF * 2;			-- 20832 ps --> identical to 2 x CLK_HALF (used in clock generation)

    -- Signals to connect to DUT
	signal i_clk 					: std_logic := '0';
	signal i_rst 					: std_logic := '1';
	signal i_cmd_error_pulse		: std_logic := '0';
	signal i_capture_cmd_pulse		: std_logic := '0';
	signal i_capture_done_pulse		: std_logic := '0';
	signal i_read_cmd_pulse			: std_logic := '0';
	signal i_send_done_pulse		: std_logic := '0';
	signal o_capture_start_pulse	: std_logic;
	signal o_send_start_pulse		: std_logic;
	signal o_fsm_tx_status_byte		: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal o_fsm_tx_start_pulse		: std_logic;
	signal o_USER_LED				: std_logic;
	
	-- Signals for easier troubleshooting
	signal test_id : integer := 0;  				-- increments with each test case
	signal seen_dd_pulse : boolean := false;		-- goes 'true' if Watchdog triggers
	
	-- Watchdog limits
	constant WD_LIMIT_CAPTURE 	: unsigned(21 downto 0) := to_unsigned(100_000, 22);		-- CAPTURE timeout after 100k samples
	constant WD_LIMIT_SEND		: unsigned(21 downto 0) := to_unsigned(4_000_000, 22);  	-- SEND timeout after 4M samples

begin

    -- DUT Instantiation
    dut: analyzer_fsm
		generic map (
			DATA_LENGTH => DATA_LENGTH
		)
        port map (
            i_clk => i_clk,
			i_rst => i_rst,
			i_cmd_error_pulse => i_cmd_error_pulse,
			i_capture_cmd_pulse => i_capture_cmd_pulse,
			i_capture_done_pulse => i_capture_done_pulse,
			i_read_cmd_pulse => i_read_cmd_pulse,
			i_send_done_pulse => i_send_done_pulse,
			o_capture_start_pulse => o_capture_start_pulse,
			o_send_start_pulse => o_send_start_pulse,
			o_fsm_tx_status_byte => o_fsm_tx_status_byte,
			o_fsm_tx_start_pulse => o_fsm_tx_start_pulse,
			o_USER_LED => o_USER_LED
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
    begin
        -- Reset phase
        wait until rising_edge(i_clk);
		i_rst <= '0';
		wait until rising_edge(i_clk);
		i_rst <= '1';
		wait until rising_edge(i_clk);
		
        -- Test case 1: command error received from cmd_parser (should send EE to tx_mux)
		test_id <= 1;
        i_cmd_error_pulse <= '1';
        wait until rising_edge(i_clk);
		i_cmd_error_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_fsm_tx_start_pulse = '1'
			report "TC1: Start pulse not sent to tx_mux"
			severity error;
		assert o_fsm_tx_status_byte = x"EE"
			report "TC1: Status code not updated to 0xEE"
			severity error;
		wait until rising_edge(i_clk);

        -- Test case 2: CAPTURE command from host(cmd_parser) (should prompt capture_engine to start capturing data)
		test_id <= 2;
        i_capture_cmd_pulse <= '1';
        wait until rising_edge(i_clk);
		i_capture_cmd_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_capture_start_pulse = '1'
			report "TC2: Start pulse not sent to capture_engine"
			severity error;
		assert o_fsm_tx_start_pulse = '1'
			report "TC2: Start pulse not sent to tx_mux"
			severity error;
		assert o_fsm_tx_status_byte = x"55"
			report "TC2: Status code not updated to 0x55"
			severity error;
		wait until rising_edge(i_clk);
		
		-- Test case 3: data capture complete
		test_id <= 3;
        i_capture_done_pulse <= '1';
        wait until rising_edge(i_clk);
		i_capture_done_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_fsm_tx_start_pulse = '1'
			report "TC3: Start pulse not sent to tx_mux"
			severity error;
		assert o_fsm_tx_status_byte = x"77"
			report "TC3: Status code not updated to 0x77"
			severity error;
		wait until rising_edge(i_clk);
		
		-- Test case 4: READ command from host (should prompt data transfer) 
        test_id <= 4;
		i_read_cmd_pulse <= '1';
        wait until rising_edge(i_clk);
		i_read_cmd_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_send_start_pulse = '1'
			report "TC4: Start pulse not sent to send_engine"
			severity error;
		wait until rising_edge(i_clk);
		
		-- Test case 5: data transfer complete (FSM goes to IDLE [state is internal signal], nothing to assert)
		test_id <= 5;
        i_send_done_pulse <= '1';
        wait until rising_edge(i_clk);
		i_send_done_pulse <= '0';
		wait until rising_edge(i_clk);
		
		-- Test case 6: 0xDD error if Watchdog triggers
		-- force FSM into CAPTURE/SEND and then never assert capture_done_pulse / send_done_pulse
		test_id <= 6;
		i_capture_cmd_pulse <= '1';
		wait until rising_edge(i_clk);
		i_capture_cmd_pulse <= '0';
		wait until rising_edge(i_clk);  -- wait extra clock to avoid assert within for loop to trigger due to 0x55 status byte
		for i in 0 to to_integer(WD_LIMIT_CAPTURE+10) loop  -- CAP_LIM 100_000 = 100k*20.8ns = ~2.08ms + margin
			wait until rising_edge(i_clk);
			
			if o_fsm_tx_start_pulse = '1' then
				assert o_fsm_tx_status_byte = x"DD"  -- consistency check. status_byte must be 0xDD in same cycle as start pulse is 1
					report "TC6a: Watchdog pulse asserted but status byte != 0xDD (Watchdog error)"
					severity error;
				if o_fsm_tx_status_byte = x"DD" then
					seen_dd_pulse <= true;
				end if;
			end if;
		end loop;
		assert seen_dd_pulse = true  -- existence check
			report "TC6a: Watchdog DD pulse not seen within timeout window"
			severity error;
		
		-- send command to verify FSM still functioning after Watchdog timeout
		i_capture_cmd_pulse <= '1';
		wait until rising_edge(i_clk);
		i_capture_cmd_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_capture_start_pulse = '1'
			report "TC6a: Start pulse not sent to capture_engine"
			severity error;
		assert o_fsm_tx_start_pulse = '1'
			report "TC6a: Start pulse not sent to tx_mux"
			severity error;
		assert o_fsm_tx_status_byte = x"55"
			report "TC6a: Status code not updated to 0x55"
			severity error;
		seen_dd_pulse <= false;  -- reset seen_dd_pulse to prepare for second test
		wait until rising_edge(i_clk);
		
		-- make Watchdog trigger again, to make sure it works
		for i in 0 to to_integer(WD_LIMIT_CAPTURE+10) loop
			wait until rising_edge(i_clk);
			if o_fsm_tx_start_pulse = '1' then
				assert o_fsm_tx_status_byte = x"DD"
					report "TC6b: Watchdog pulse asserted but status byte != 0xDD (Watchdog error)"
					severity error;
				if o_fsm_tx_status_byte = x"DD" then
					seen_dd_pulse <= true;
				end if;
			end if;
		end loop;
		assert seen_dd_pulse = true
			report "TC6b: Watchdog DD pulse not seen within timeout window"
			severity error;

        -- Finish simulation
		wait for 10*CLK_ACTUAL;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
