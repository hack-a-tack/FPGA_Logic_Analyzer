-- ========================================
-- MODULE: capture_engine_tb.vhd
-- FUNCTION: TESTBENCH for entity that samples logic analyzer inputs and writes to BRAM
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-26 (YYYY-MM-DD)
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
	constant NUM_SAMPLES : integer := 2**ADDR_LENGTH;
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48.0e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  	-- 20833 ps (truncated)
	constant CLK_HALF : time := CLK_PERIOD / 2;			-- 10416 ps (truncated)
	constant CLK_ACTUAL : time := CLK_HALF * 2;			-- 20832 ps --> identical to 2 x CLK_HALF (used in clock generation)

    -- Signals to connect to DUT
	signal i_clk 					: std_logic := '0';
	signal i_samp_tick 				: std_logic := '0';
	signal i_rst 					: std_logic := '0';
	signal i_capture_start_pulse	: std_logic := '0';
	signal i_inputs					: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal o_raw_wr_en_pulse		: std_logic;
	signal o_raw_wr_addr			: std_logic_vector(ADDR_LENGTH-1 downto 0);
	signal o_raw_wr_data			: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal o_capture_done_pulse		: std_logic;
	
	-- Signals for easier troubleshooting
	signal test_id : integer := 0;  				-- increments with each test case
	signal tick_count : integer := 0;				-- keep count of samples written to RAM
	signal r_prev_tick : std_logic := '0';			-- samp tick must cause wr_en_pulse (i.e. r_prev_tick and wr_en_pulse coincide)
	signal capture_start_pulse_seen : std_logic := '0';
	signal seen_done_pulse : boolean := false;		-- verify occurence of done pulse
	
begin
    -- DUT Instantiation
    dut: capture_engine
		generic map (
			ADDR_LENGTH => ADDR_LENGTH,
			NUM_SAMPLES => NUM_SAMPLES,
			DATA_LENGTH => DATA_LENGTH
		)
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
            wait for CLK_HALF;
            i_clk <= '1';
            wait for CLK_HALF;
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
				-- update r_prev_tick
				r_prev_tick <= i_samp_tick;
				
				-- count *writes* (best proxy for “a sample was taken”)
				if o_raw_wr_en_pulse = '1' or i_capture_start_pulse = '1' then
					tick_count <= tick_count + 1;
				end if;

				-- Assert wr_en only happens on samp_tick
				if o_raw_wr_en_pulse = '1' then
					assert (r_prev_tick = '1') or (capture_start_pulse_seen = '1')
						report "wr_en asserted without preceding samp_tick or capture_start"
						severity error;
				end if;

				-- When done fires, check we wrote exactly NUM_SAMPLES
				if o_capture_done_pulse = '1' then
					assert tick_count = NUM_SAMPLES+1  -- +1 because check is conducted for "index 4096" / after the 4096th sample
						report "Expected NUM_SAMPLES (4097) writes, got " & integer'image(tick_count)
						severity error;
				end if;
			end if;
		end if;
	end process;


    -- Stimulus process
    stim_proc: process is
    begin
        -- Reset
        wait until rising_edge(i_clk);
		i_rst <= '1';
		wait until rising_edge(i_clk);
		i_rst <= '0';
		wait until rising_edge(i_clk);
		
        -- Test case 1: Capture start pulse. State IDLE.
		test_id <= 1;
		i_inputs <= x"A1";
		i_capture_start_pulse <= '1';
		wait until rising_edge(i_clk);
		i_capture_start_pulse <= '0';
		capture_start_pulse_seen <= '1';
		assert o_raw_wr_en_pulse = '0'
			report "TC1: Write enable pulse is high, but we're still in state IDLE"
			severity error;
		assert o_raw_wr_addr = x"000"
			report "TC1: RAM write address not set to 0x000"
			severity error;
		assert o_capture_done_pulse	= '0'
			report "TC1: Capture done pulse registered despite state IDLE"
			severity error;
		wait until rising_edge(i_clk);
		capture_start_pulse_seen <= '0';
	
		-- Test case 2: State CAPTURE_RUN. First few samples. addr and wr_data should only change when i_samp_tick is high
		test_id <= 2;
		wait until rising_edge(i_clk) and i_samp_tick = '1';
		wait until rising_edge(i_clk) and i_samp_tick = '0';
		assert o_raw_wr_en_pulse = '1'
			report "TC2(Sample " & integer'image(tick_count) & "): Write enable pulse is NOT high, but it should be registered"
			severity error;
		assert o_raw_wr_data = x"A1"
			report "TC2(Sample " & integer'image(tick_count) & "): Data sent to trace_buffer (RAM) not equal to inputs (A1)"
			severity error;
		assert o_raw_wr_addr = x"001"
			report "TC2(Sample " & integer'image(tick_count) & "): Address not 1 for data sample with index 1"
			severity error;
		assert o_capture_done_pulse	= '0'
			report "TC2(Sample " & integer'image(tick_count) & "): Capture done pulse registered despite early in state RUN"
			severity error;
		
		-- this section coincides with rising edge and high i_samp_tick (change expected)
		i_inputs <= x"A9";
		wait until rising_edge(i_clk) and i_samp_tick = '1';  -- output signals are registered and so are not updated until next rising i_clk
		wait until rising_edge(i_clk) and i_samp_tick = '0';  -- now output signals are updated
		assert o_raw_wr_en_pulse = '1'
			report "TC2(Sample " & integer'image(tick_count) & "): Write enable pulse is NOT high, but it should be..."
			severity error;
		assert o_raw_wr_data = x"A9"
			report "TC2(Sample " & integer'image(tick_count) & "): Data sent to trace_buffer (RAM) not equal to inputs (A9)"
			severity error;
		assert o_raw_wr_addr = x"002"
			report "TC2(Sample " & integer'image(tick_count) & "): Address not 2 for data sample with index 2"
			severity error;
		assert o_capture_done_pulse	= '0'
			report "TC2(Sample " & integer'image(tick_count) & "): Capture done pulse registered despite early in state RUN"
			severity error;
			
		-- TODO/CHATGPT: is there a smooth way to check that the address actually increments? and that the i_inputs change?
		
		-- Test case 3: stop condition. Done pulse after NUM_SAMPLES
		test_id <= 3;
		for i in 0 to NUM_SAMPLES+10 loop  -- NUM_ADDRESSES addresses to fill up + some margin
			wait until rising_edge(i_clk) and i_samp_tick = '0';
			
			if o_raw_wr_addr = std_logic_vector(to_unsigned(NUM_SAMPLES-1, ADDR_LENGTH)) then
				wait until rising_edge(i_clk) and i_samp_tick = '0';  -- outputs have been set
				assert o_capture_done_pulse = '1'
					report "TC3(Sample " & integer'image(tick_count) & "): Capture done pulse not asserting after sample with index 4095"
					severity error;
				if o_capture_done_pulse = '1' then
					seen_done_pulse <= true;
				end if;
			elsif o_raw_wr_addr = std_logic_vector(to_unsigned(0, ADDR_LENGTH)) then  -- back to IDLE
				assert o_capture_done_pulse = '0'
					report "TC3(Sample " & integer'image(tick_count) & "): Capture done pulse does not deassert after 1 clock cycle"
					severity error;
			end if;
		end loop;
			
		assert seen_done_pulse = true  -- existence check
			report "TC3(Sample " & integer'image(tick_count) & "): Capture done pulse not seen within timeout window"
			severity error;
			
		-- Test case 4: no sample tick = no progress
		-- test_id <= 4;
		
		-- Test case 5: restart behaviour
		-- test_id <= 5;
		
        -- Finish simulation
        wait for 10*CLK_ACTUAL;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
