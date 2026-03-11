-- ========================================
-- MODULE: tx_mux_tb.vhd
-- FUNCTION: TESTBENCH for entity which multiplexes data signals to uart_tx 
-- AUTHOR: Jakob Kieszek Ottesen
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
-- o_mux_tx_byte			8 bits	-> uart_tx
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
	constant CLK_FREQ   : real := 48e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;

    -- Signals to connect to DUT	
	signal i_clk					: std_logic := '0';
	signal i_rst					: std_logic := '0';
	signal i_fsm_tx_status_byte		: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal i_fsm_tx_start_pulse		: std_logic := '0';
	signal i_send_tx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal i_send_tx_start_pulse	: std_logic := '0';
	signal o_mux_tx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal o_mux_tx_start_pulse		: std_logic;

begin

    -- DUT Instantiation
    uut: tx_mux
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
            wait for CLK_PERIOD / 2;
            i_clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process is
    begin
        -- Reset phase
        wait for 2*CLK_PERIOD;
		i_rst <= '1';
		wait for 5*CLK_PERIOD;
		i_rst <= '0';
		wait until rising_edge(i_clk);
		
        -- Test case 1: start pulse received from analyzer_fsm (tx_mux should send status byte and start pulse to uart_tx)
        i_fsm_tx_status_byte <= x"55";
		i_fsm_tx_start_pulse <= '1';
        wait until rising_edge(i_clk);
		assert o_mux_tx_byte = x"55"
			report "Status byte (55) from fsm not sent to uart_tx"
			severity error;
		assert o_mux_tx_start_pulse = '1'
			report "Start pulse (o_mux_tx_start_pulse) not asserted"
			severity error;
		i_fsm_tx_start_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_mux_tx_start_pulse = '0'
			report "Start pulse (o_mux_tx_start_pulse) not deasserted after 1 cycle"
			severity error;

        -- Test case 2: start pulse received from send_engine (tx_mux should send data byte and start pulse to uart_tx)
        i_send_tx_byte <= x"A5";
		i_send_tx_start_pulse <= '1';
        wait until rising_edge(i_clk);
		assert o_mux_tx_byte = x"A5"
			report "Data byte (A5) from send_engine not sent to uart_tx"
			severity error;
		assert o_mux_tx_start_pulse = '1'
			report "Start pulse (o_mux_tx_start_pulse) not asserted"
			severity error;
		i_send_tx_start_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_mux_tx_start_pulse = '0'
			report "Start pulse (o_mux_tx_start_pulse) not deasserted after 1 cycle"
			severity error;
		
		-- Test case 3: no start pulse from analyzer_fsm or send_engine (o_mux_tx_start_pulse should be default low)
		i_fsm_tx_start_pulse <= '0';
		i_send_tx_start_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_mux_tx_start_pulse = '0'
			report "Start pulse (o_mux_tx_start_pulse) erroneously asserted"
			severity error;
			
		-- Test case 4: priority test. Start pulse from both analyzer_fsm and send_engine at the same time (should pick analyzer_fsm)
		i_fsm_tx_status_byte <= x"77";
		i_send_tx_byte <= x"A7";
		i_fsm_tx_start_pulse <= '1';
		i_send_tx_start_pulse <= '1';
		wait until rising_edge(i_clk);
		assert o_mux_tx_byte = x"77"
			report "Status byte (77) from fsm not sent to uart_tx"
			severity error;
		assert o_mux_tx_byte /= x"A7"
			report "Data byte (A7) from send_engine sent to uart_tx (when status byte (77) from analyzer_fsm should have been sent)"
			severity error;
		assert o_mux_tx_start_pulse = '1'
			report "Start pulse (o_mux_tx_start_pulse) not asserted"
			severity error;
		i_fsm_tx_start_pulse <= '0';
		i_send_tx_start_pulse <= '0';
		wait until rising_edge(i_clk);
		assert o_mux_tx_start_pulse = '0'
			report "Start pulse (o_mux_tx_start_pulse) not deasserted after 1 cycle"
			severity error;

        -- Finish simulation
        wait for 5*CLK_PERIOD;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
