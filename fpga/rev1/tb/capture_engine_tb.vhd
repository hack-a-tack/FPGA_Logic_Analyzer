-- ========================================
-- MODULE: capture_engine_tb.vhd
-- FUNCTION: TESTBENCH for entity that samples logic analyzer inputs and writes to BRAM
-- AUTHOR: Jakob Kieszek Ottesen
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_samp_tick				1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_capture_start_pulse	1 bit		<- analyzer_fsm
-- i_inputs					1 bit		<- top
--
-- OUTPUTS					DATA		TO MODULE
-- o_raw_wr_en_pulse		1 bit		-> top
-- o_raw_wr_addr			12 bits		-> top
-- o_raw_wr_data			8 bits		-> top
-- o_capture_done_pulse		1 bit		-> analyzer_fsm
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity capture_engine_tb is
end entity capture_engine_tb;

architecture sim of capture_engine_tb is
    -- Component declaration (optional in VHDL-2008)
    component capture_engine
        generic (
			ADDR_LENGTH : integer := 12;
			NUM_SAMPLES : integer := 2**ADDR_LENGTH;
			DATA_LENGTH : integer := 8
		);
		port (
			i_clk					: in  std_logic;
			i_samp_tick				: in  std_logic;
			i_rst					: in  std_logic;
			i_capture_start_pulse	: in  std_logic;
			i_inputs				: in  std_logic_vector(DATA_LENGTH-1 downto 0);
			o_raw_wr_en_pulse		: out std_logic;
			o_raw_wr_addr			: out std_logic_vector(ADDR_LENGTH-1 downto 0);
			o_raw_wr_data			: out std_logic_vector(DATA_LENGTH-1 downto 0);
			o_capture_done_pulse	: out std_logic
		);
    end component;
	
	-- Constant declaration
	constant ADDR_LENGTH : integer := 12;
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;

    -- Signals to connect to DUT
	signal i_clk 					: std_logic := '0';
	signal i_samp_tick 				: std_logic := '0';
	signal i_rst 					: std_logic := '0';
	signal i_capture_start_pulse	: std_logic := '0';
	signal i_inputs					: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal o_raw_wr_en_pulse		: std_logic := '0';
	signal o_raw_wr_addr			: std_logic_vector(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal o_raw_wr_data			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal o_capture_done_pulse		: std_logic := '0';
	
	-- Other signals
	signal tick_count : integer := 0;
	
begin
    -- DUT Instantiation
    uut: capture_engine
        port map (
            i_clk => i_clk,
			i_samp_tick => i_samp_tick,
			i_rst => i_rst,
			i_capture_start_pulse => i_capture_start_pulse,
			i_inputs => i_inputs,
			o_raw_wr_en_pulse => o_raw_wr_en_pulse,
			o_raw_wr_addr => o_raw_wr_addr,
			o_raw_wr_data => o_raw_wr_data,
			o_capture_done_pulse => o_capture_done_pulse
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
	
	
	tick_process: process is
	begin
		i_samp_tick <= '0';
		wait until rising_edge(i_clk);  -- align start
	
		while true loop
			i_samp_tick <= '1';
			wait until rising_edge(i_clk);  -- stays high for one full 48MHz cycle
			i_samp_tick <= '0';
			wait until rising_edge(i_clk);  -- stays low for one full 48MHz cycle
		end loop;
	end process;
	
	
	-- Tick counter (checking number of samples written to RAM)
	count_proc : process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				tick_count <= 0;
			else
				-- count *writes* (best proxy for “a sample was taken”)
				if o_raw_wr_en_pulse = '1' then
					tick_count <= tick_count + 1;
				end if;

				-- Assert wr_en only happens on samp_tick
				if o_raw_wr_en_pulse = '1' then
					assert i_samp_tick = '1'
						report "wr_en asserted when samp_tick = 0"
						severity error;
				end if;

				-- When done fires, check we wrote exactly NUM_SAMPLES
				if o_capture_done_pulse = '1' then
					assert tick_count = NUM_SAMPLES
						report "Expected NUM_SAMPLES (4096) writes, got " & integer'image(tick_count)
						severity error;
				end if;
			end if;
		end if;
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
		i_capture_start_pulse <= '1';
		wait until rising_edge(i_clk);
		i_capture_start_pulse <= '0';
		
		-- Wait for done
        wait until o_capture_done_pulse = '1' and rising_edge(i_clk);
		
		wait;  -- stop

        -- Finish simulation
        wait for 5*CLK_PERIOD;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
