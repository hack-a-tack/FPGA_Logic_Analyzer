-- ========================================
-- MODULE: send_engine_tb.vhd
-- FUNCTION: TESTBENCH for entity which streams captured data from BRAM to host
-- AUTHOR: Jakob Kieszek Ottesen
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_send_start_pulse		1 bit		<- analyzer_fsm
-- i_tx_busy				1 bit		<- uart_tx
-- i_ram_rd_data			8 bits		<- top
--
-- OUTPUTS					DATA		TO MODULE
-- o_ram_rd_addr			12 bits		-> top
-- o_send_tx_byte			8 bits		-> tx_mux
-- o_send_tx_start_pulse	1 bit		-> tx_mux
-- o_send_done_pulse		1 bit		-> analyzer_fsm
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity send_engine_tb is
end entity send_engine_tb;

architecture sim of send_engine_tb is
    -- Component declaration (optional in VHDL-2008)
    component send_engine
        generic (
			ADDR_LENGTH : integer := 12;
			NUM_SAMPLES : integer := 2**ADDR_LENGTH;
			DATA_LENGTH : integer := 8
		);
		port (
			i_clk					: in  std_logic;
			i_rst					: in  std_logic;
			i_send_start_pulse		: in  std_logic;
			i_tx_busy				: in  std_logic;
			i_ram_rd_data			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
			o_ram_rd_addr			: out std_logic_vector(ADDR_LENGTH-1 downto 0);
			o_send_tx_byte			: out std_logic_vector(DATA_LENGTH-1 downto 0);
			o_send_tx_start_pulse	: out std_logic;
			o_send_done_pulse		: out std_logic
		);
    end component;
	
	-- Constant declaration
	constant ADDR_LENGTH : integer := 12;
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;

    -- Signals to connect to DUT
	signal i_clk 					: std_logic := '0';
	signal i_rst 					: std_logic := '0';
	signal i_send_start_pulse		: std_logic := '0';
	signal i_tx_busy				: std_logic := '0';
	signal i_ram_rd_data			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal o_ram_rd_addr			: std_logic_vector(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal o_send_tx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal o_send_tx_start_pulse	: std_logic := '0';
	signal o_send_done_pulse		: std_logic := '0';
	
	-- Other signals
	signal tick_count : integer := 0;
	
begin
    -- DUT Instantiation
    uut: send_engine
        port map (
            i_clk => i_clk,
			i_rst => i_rst,
			i_send_start_pulse => i_send_start_pulse,
			i_tx_busy => i_tx_busy,
			i_ram_rd_data => i_ram_rd_data,
			o_ram_rd_addr => o_ram_rd_addr,
			o_send_tx_byte => o_send_tx_byte,
			o_send_tx_start_pulse => o_send_tx_start_pulse,
			o_send_done_pulse => o_send_done_pulse
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
        -- Reset
		i_rst <= '1';
		wait for 5*CLK_PERIOD;
		i_rst <= '0';
		wait until rising_edge(i_clk);
		
        -- Capture start pulse
		i_send_start_pulse <= '1';
		wait until rising_edge(i_clk);
		i_send_start_pulse <= '0';
		
		-- Wait for header
		i_tx_busy <= '0';
		wait until rising_edge(i_clk) and o_send_tx_start_pulse = '1';
		assert o_send_tx_byte = x"99"
			report "Status code 0x99 does not get transmitted as header"
			severity error;
					
		-- Wait for done
        wait until rising_edge(i_clk) and o_send_done_pulse = '1';
		
		wait;  -- stop

        -- Finish simulation
        wait for 5*CLK_PERIOD;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
