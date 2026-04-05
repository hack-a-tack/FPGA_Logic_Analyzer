-- ========================================
-- MODULE: tx_mux_tb.vhd
-- FUNCTION: TESTBENCH for entity which multiplexes data signals to uart_tx 
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-05 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_fsm_tx_status_byte		8 bits 		<- analyzer_fsm
-- i_fsm_tx_start_pulse		1 bit		<- analyzer_fsm
-- i_send_tx_byte			8 bits		<- send_engine
-- i_send_tx_start_pulse	1 bit		<- send_engine
--
-- OUTPUTS					DATA		TO MODULE
-- o_mux_tx_byte			8 bits		-> uart_tx
-- o_mux_tx_start_pulse		1 bit		-> uart_tx
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tx_mux_tb is
end entity tx_mux_tb;

architecture sim of tx_mux_tb is
    -- Component declaration (optional in VHDL-2008)
    component tx_mux
		generic(
			DATA_LENGTH : integer := 8
		);
        port(			
			i_clk					: in  std_logic;
			i_rst					: in  std_logic;
			i_fsm_tx_status_byte	: in  std_logic_vector(DATA_LENGTH-1 downto 0);
			i_fsm_tx_start_pulse	: in  std_logic;
			i_send_tx_byte			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
			i_send_tx_start_pulse	: in  std_logic;
			o_mux_tx_byte			: out std_logic_vector(DATA_LENGTH-1 downto 0);
			o_mux_tx_start_pulse	: out std_logic
        );
    end component;
	
	-- Constant declaration
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48.0e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  	-- 20833 ps (truncated)
	constant CLK_HALF : time := CLK_PERIOD / 2;			-- 10416 ps (truncated)
	constant CLK_ACTUAL : time := CLK_HALF * 2;			-- 20832 ps --> identical to 2 x CLK_HALF (used in clock generation)

    -- Signals to connect to DUT	
	signal i_clk					: std_logic := '0';
	signal i_rst					: std_logic := '0';
	signal i_fsm_tx_status_byte		: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal i_fsm_tx_start_pulse		: std_logic := '0';
	signal i_send_tx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal i_send_tx_start_pulse	: std_logic := '0';
	signal o_mux_tx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal o_mux_tx_start_pulse		: std_logic;
	
	-- Other signals
	signal test_id : integer := 0;  -- keep track of test cases

begin

    -- DUT Instantiation
    dut: tx_mux
		generic map (
			DATA_LENGTH => DATA_LENGTH
		)
        port map (			
			i_clk => i_clk,
			i_rst => i_rst,
			i_fsm_tx_status_byte => i_fsm_tx_status_byte,
			i_fsm_tx_start_pulse => i_fsm_tx_start_pulse,
			i_send_tx_byte => i_send_tx_byte,
			i_send_tx_start_pulse => i_send_tx_start_pulse,
			o_mux_tx_byte => o_mux_tx_byte,
			o_mux_tx_start_pulse => o_mux_tx_start_pulse
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
		i_rst <= '1';
		wait until rising_edge(i_clk);
		i_rst <= '0';
		wait until rising_edge(i_clk);
		
        -- Test case 1: start pulse received from analyzer_fsm (tx_mux should output status byte + start pulse)
        test_id <= 1;
		i_fsm_tx_status_byte <= x"55";
		i_fsm_tx_start_pulse <= '1';
        wait until rising_edge(i_clk);
		wait for 0 ns;
		i_fsm_tx_start_pulse <= '0';
		wait for 0 ns;
		assert o_mux_tx_byte = x"55"
			report "TC1: Status byte (55) from fsm not sent to uart_tx"
			severity error;
		assert o_mux_tx_start_pulse = '1'
			report "TC1: Start pulse (o_mux_tx_start_pulse) not asserted"
			severity error;
		wait until rising_edge(i_clk);
		wait for 0 ns;  -- wait for r_ signals to update
		wait for 0 ns;  -- wait for o_ signals to update 
		assert o_mux_tx_start_pulse = '0'
			report "TC1: Start pulse (o_mux_tx_start_pulse) not deasserted after 1 cycle"
			severity error;

        -- Test case 2: start pulse received from send_engine (tx_mux should output data byte + start pulse)
        wait until rising_edge(i_clk);
		test_id <= 2;
		i_send_tx_byte <= x"A5";
		i_send_tx_start_pulse <= '1';
        wait until rising_edge(i_clk);
		wait for 0 ns;
		i_send_tx_start_pulse <= '0';
		wait for 0 ns;
		assert o_mux_tx_byte = x"A5"
			report "TC2: Data byte (A5) from send_engine not sent to uart_tx"
			severity error;
		assert o_mux_tx_start_pulse = '1'
			report "TC2: Start pulse (o_mux_tx_start_pulse) not asserted"
			severity error;
		wait until rising_edge(i_clk);
		wait for 0 ns;
		wait for 0 ns;
		assert o_mux_tx_start_pulse = '0'
			report "TC2: Start pulse (o_mux_tx_start_pulse) not deasserted after 1 cycle"
			severity error;
		
		-- Test case 3: no start pulse from analyzer_fsm or send_engine (o_mux_tx_start_pulse should be default low)
		wait until rising_edge(i_clk);
		test_id <= 3;
		wait until rising_edge(i_clk);
		i_fsm_tx_start_pulse <= '0';
		i_send_tx_start_pulse <= '0';
		wait for 0 ns;
		assert o_mux_tx_start_pulse = '0'
			report "TC3: Start pulse (o_mux_tx_start_pulse) erroneously asserted"
			severity error;
			
		-- Test case 4: priority test. Start pulse from both analyzer_fsm and send_engine at the same time (should pick analyzer_fsm)
		wait until rising_edge(i_clk);
		test_id <= 4;
		i_fsm_tx_status_byte <= x"77";
		i_send_tx_byte <= x"A7";
		i_fsm_tx_start_pulse <= '1';
		i_send_tx_start_pulse <= '1';
		wait until rising_edge(i_clk);
		wait for 0 ns;
		i_fsm_tx_start_pulse <= '0';
		i_send_tx_start_pulse <= '0';
		wait for 0 ns;
		assert o_mux_tx_byte = x"77"
			report "TC4: Status byte (77) from fsm not sent to uart_tx"
			severity error;
		assert o_mux_tx_byte /= x"A7"
			report "TC4: Data byte (A7) from send_engine sent to uart_tx (when status byte (77) from analyzer_fsm should have been sent)"
			severity error;
		assert o_mux_tx_start_pulse = '1'
			report "TC4: Start pulse (o_mux_tx_start_pulse) not asserted"
			severity error;
		wait until rising_edge(i_clk);
		wait for 0 ns;
		wait for 0 ns;
		assert o_mux_tx_start_pulse = '0'
			report "TC4: Start pulse (o_mux_tx_start_pulse) not deasserted after 1 cycle"
			severity error;

        -- Finish simulation
        wait for 10*CLK_ACTUAL;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
