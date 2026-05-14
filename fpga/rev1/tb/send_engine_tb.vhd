-- ========================================
-- MODULE: send_engine_tb.vhd
-- FUNCTION: TESTBENCH for entity which streams captured data from BRAM to host
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-17 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
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
--
-- NOTES
-- o_ram_rd_addr (going to trace_buffer) is set at the same time as the tx_byte and tx_start_pulse (going to tx_mux).
-- BUT!: note that the ram_rd_addr is 1 cycle ahead and in the waveform will show address 1 when sample 0 was just sent to tx_mux
-- this is because the rd_addr is passed to trace_buffer slightly ahead of time so the associated data arrives at send_engine in time
-- ... for it to be sent to tx_mux
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
	constant NUM_SAMPLES : integer := 2**ADDR_LENGTH;
	constant DATA_LENGTH : integer := 8;
	constant CLK_FREQ   : real := 48.0e6;
	constant CLK_PERIOD : time := 1 sec / CLK_FREQ;  	-- 20833 ps (truncated)
	constant CLK_HALF : time := CLK_PERIOD / 2;			-- 10416 ps (truncated)
	constant CLK_ACTUAL : time := CLK_HALF * 2;			-- 20832 ps --> identical to 2 x CLK_HALF (used in clock generation)

    -- Signals to connect to DUT
	signal i_clk 					: std_logic := '0';
	signal i_rst 					: std_logic := '1';
	signal i_send_start_pulse		: std_logic := '0';
	signal i_tx_busy				: std_logic := '0';
	signal i_ram_rd_data			: std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal o_ram_rd_addr			: std_logic_vector(ADDR_LENGTH-1 downto 0);
	signal o_send_tx_byte			: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal o_send_tx_start_pulse	: std_logic;
	signal o_send_done_pulse		: std_logic;
	
	-- Other signals
	signal test_id : integer := 0;  -- keep track of test cases
	signal tick_count : integer := 0;  -- keeps track of number of samples read from RAM/sent to tx_mux
	
begin
    -- DUT Instantiation
    dut: send_engine
		generic map (
			ADDR_LENGTH => ADDR_LENGTH,
			NUM_SAMPLES => NUM_SAMPLES,
			DATA_LENGTH => DATA_LENGTH
		)
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
            wait for CLK_HALF;
            i_clk <= '1';
            wait for CLK_HALF;
        end loop;
    end process;
	
	
	-- Tick counter (checking number of samples written to RAM)
	count_proc : process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '0' then
				tick_count <= 0;
			else
				-- count increments when start_pulse (along with data_byte) is sent to tx
				if o_send_tx_start_pulse = '1' then
					tick_count <= tick_count + 1;
				end if;

				-- When done fires, check we transmitted exactly NUM_SAMPLES (+1 because tx_start_pulse also for 0x99 header byte BUT -1 because the final tick_count is registered first in one more clock cycle)
				if o_send_done_pulse = '1' then
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
        wait until rising_edge(i_clk);
		i_rst <= '0';
		wait until rising_edge(i_clk);
		i_rst <= '1';
		wait until rising_edge(i_clk);
		
		-- Test case 1: Header byte
		test_id <= 1;
		i_send_start_pulse <= '1';
		i_tx_busy <= '0';
		i_ram_rd_data <= x"CC";  -- 1100 1100
		wait until rising_edge(i_clk);
		i_send_start_pulse <= '0';
		wait until rising_edge(i_clk) and o_send_tx_start_pulse = '1';  -- right after, we're in SEND_SET_ADDR and can read signals
		assert o_ram_rd_addr = x"000"
			report "TC1(Sample " & integer'image(tick_count) & "): Ram address not 0 in state SEND_SET_ADDR"
			severity error;
		assert o_send_tx_byte = x"99"
			report "TC1(Sample " & integer'image(tick_count) & "): Byte sent to tx is not 0x99"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC1(Sample " & integer'image(tick_count) & "): tx_start_pulse not observed high while in state SEND_SET_ADDR"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC1(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while in state SEND_HEADER. Observed in SEND_SET_ADDR"
			severity error;
			
		-- Test case 2: check that start pulse is only high for 1 clock cycle
		test_id <= 2;
		wait until rising_edge(i_clk);  -- right after, we're in state SEND_HOLD
		assert o_ram_rd_addr = x"000"
			report "TC2(Sample " & integer'image(tick_count) & "): Ram address updated in state SEND_SET_ADDR, now in state SEND_HOLD"
			severity error;
		assert o_send_tx_byte = x"99"
			report "TC2(Sample " & integer'image(tick_count) & "): Tx byte updated while in state SEND_SET_ADDR"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC2(Sample " & integer'image(tick_count) & "): Start pulse high but should be reset to '0' when just arrived in SEND_HOLD state"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC2(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while in state SEND_SET_ADDR (now SEND_HOLD)"
			severity error;
			
		wait until rising_edge(i_clk);  -- right after, we're in state SEND_DATA
		assert o_ram_rd_addr = x"000"
			report "TC2(Sample " & integer'image(tick_count) & "): Ram address updated in state SEND_HOLD, now in state SEND_DATA"
			severity error;
		assert o_send_tx_byte = x"99"
			report "TC2(Sample " & integer'image(tick_count) & "): Tx byte updated while in state SEND_HOLD"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC2(Sample " & integer'image(tick_count) & "): Start pulse high but should be reset to '0' when just arrived in SEND_DATA state"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC2(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while in state SEND_HOLD (now SEND_DATA)"
			severity error;
		
		-- Test case 3: first few data bytes
		test_id <= 3;
		wait until rising_edge(i_clk);  -- finished first cycle in state SEND_DATA, then in SEND_SET_ADDR for 1 cycle
		assert o_ram_rd_addr = x"001"
			report "TC3(Sample " & integer'image(tick_count) & "): Ram address not updated to 1 after 1 clock cycle in SEND_DATA state"
			severity error;
		assert o_send_tx_byte = x"CC"
			report "TC3(Sample " & integer'image(tick_count) & "): Data not equal to CC"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC3(Sample " & integer'image(tick_count) & "): Start pulse not high when sending 1st data byte in state SEND_DATA..."
			severity error;
		assert o_send_done_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high prematurely (still sending data)"
			severity error;
			
		wait until rising_edge(i_clk);  -- finished first cycle in state SEND_SET_ADDR, then in SEND_HOLD for 1 cycle
		assert o_ram_rd_addr = x"001"
			report "TC3(Sample " & integer'image(tick_count) & "): Ram address not updated to 1 after 1 clock cycle in SEND_SET_ADDR state"
			severity error;
		assert o_send_tx_byte = x"CC"
			report "TC3(Sample " & integer'image(tick_count) & "): Data not equal to CC"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): Start pulse still high (2nd clock cycle) after state SEND_SET_ADDR..."
			severity error;
		assert o_send_done_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high prematurely (still sending data)"
			severity error;
			
		i_ram_rd_data <= x"AA";  -- 1010 1010
		wait until rising_edge(i_clk);  -- finished in SEND_HOLD, start second cycle in state SEND_DATA
		assert o_ram_rd_addr = x"001"
			report "TC3(Sample " & integer'image(tick_count) & "): Ram address updated while in SEND_HOLD"
			severity error;
		assert o_send_tx_byte = x"CC"
			report "TC3(Sample " & integer'image(tick_count) & "): RAM data updated while in SEND_HOLD"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): Start pulse asserted high while in SEND_HOLD"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while in SEND_HOLD"
			severity error;
			
		wait until rising_edge(i_clk);  -- finished 2nd cycle in state SEND_DATA, then in SEND_SET_ADDR for 1 cycle
		assert o_ram_rd_addr = x"002"
			report "TC3(Sample " & integer'image(tick_count) & "): Ram address not updated to 2 after 2nd clock cycle in SEND_DATA state"
			severity error;
		assert o_send_tx_byte = x"AA"
			report "TC3(Sample " & integer'image(tick_count) & "): Ram data not updated to AA"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC3(Sample " & integer'image(tick_count) & "): Start pulse not asserted high while in SEND_DATA"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while still sending data"
			severity error;
			
		wait until rising_edge(i_clk);  -- finished 2nd cycle in state SEND_SET_ADDR, then in SEND_HOLD for 1 cycle
		assert o_ram_rd_addr = x"002"
			report "TC3(Sample " & integer'image(tick_count) & "): Ram address not 2 after 2nd clock cycle in SEND_SET_ADDR state"
			severity error;
		assert o_send_tx_byte = x"AA"
			report "TC3(Sample " & integer'image(tick_count) & "): Data not equal to AA"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): Start pulse high when it should have gone low at the end of state SEND_SET_ADDR (ie now)..."
			severity error;
		assert o_send_done_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high prematurely (still sending data)"
			severity error;
			
		wait until rising_edge(i_clk);  -- finished in SEND_HOLD, start 3rd cycle in state SEND_DATA
		assert o_ram_rd_addr = x"002"
			report "TC3(Sample " & integer'image(tick_count) & "): Ram address updated while in SEND_HOLD"
			severity error;
		assert o_send_tx_byte = x"AA"
			report "TC3(Sample " & integer'image(tick_count) & "): RAM data updated while in SEND_HOLD"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): Start pulse asserted high while in SEND_HOLD"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC3(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while in SEND_HOLD (so seen now in state SEND_DATA)"
			severity error;
		
		-- Test case 4: stop condition. Done pulse after NUM_SAMPLES
		test_id <= 4;
		for i in 0 to (NUM_SAMPLES * 3)+10 loop  -- NUM_SAMPLES addresses to fill up (3 clocks per sample) + some margin
			wait until rising_edge(i_clk);
			
			if o_ram_rd_addr = std_logic_vector(to_unsigned(NUM_SAMPLES-1, ADDR_LENGTH)) then
				wait until rising_edge(i_clk) and o_send_done_pulse = '1';
				wait until rising_edge(i_clk);
				assert o_ram_rd_addr = x"000"
					report "TC4(Sample " & integer'image(tick_count) & "): read address does not return to 0 after 4095"
					severity error;
				assert o_send_done_pulse = '0'
					report "TC4(Sample " & integer'image(tick_count) & "): send_done_pulse does not deassert after 1 clock cycle"
					severity error;
			end if;
		end loop;
		
		-- Test case 5: tx busy goes HIGH.
		-- Test case 5a: tx busy goes high for SEND_HEADER state
		test_id <= 5;
		i_send_start_pulse <= '1';
		i_tx_busy <= '1';
		i_ram_rd_data <= x"33";  -- 0011 0011
		wait until rising_edge(i_clk);
		i_send_start_pulse <= '0';
		wait until rising_edge(i_clk);  -- arrive in SEND_HEADER (will remain here until tx_busy goes low)
		wait until rising_edge(i_clk);  -- tx_byte and tx_start_pulse should not have been updated
		assert o_send_tx_byte = x"AA"
			report "TC5a(Sample " & integer'image(tick_count) & "): Data byte has been updated but tx is busy"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5a(Sample " & integer'image(tick_count) & "): tx_start_pulse asserted high despite tx busy"
			severity error;
			
		-- wait a few more clock cycles
		wait until rising_edge(i_clk);  -- tx_byte and tx_start_pulse should not have been updated
		assert o_send_tx_byte = x"AA"
			report "TC5a(Sample " & integer'image(tick_count) & "): Data byte has been updated but tx is busy"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5a(Sample " & integer'image(tick_count) & "): tx_start_pulse asserted high despite tx busy"
			severity error;
			
		wait until rising_edge(i_clk);  -- tx_byte and tx_start_pulse should not have been updated
		assert o_send_tx_byte = x"AA"
			report "TC5a(Sample " & integer'image(tick_count) & "): Data byte has been updated but tx is busy"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5a(Sample " & integer'image(tick_count) & "): tx_start_pulse asserted high despite tx busy"
			severity error;
		
		wait until rising_edge(i_clk);  -- tx_byte and tx_start_pulse should not have been updated
		assert o_send_tx_byte = x"AA"
			report "TC5a(Sample " & integer'image(tick_count) & "): Data byte has been updated but tx is busy"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5a(Sample " & integer'image(tick_count) & "): tx_start_pulse asserted high despite tx busy"
			severity error;
			
		-- Test case 5b: data transmitted normally when tx busy is low
		i_tx_busy <= '0';
		wait until rising_edge(i_clk);  -- goes to SEND_SET_ADDR after rising edge
		wait for 1 ns;
		assert o_send_tx_byte = x"99"
			report "TC5b(Sample " & integer'image(tick_count) & "): Header byte not sent despite tx_busy being low"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC5b(Sample " & integer'image(tick_count) & "): tx_start_pulse not asserted high despite tx busy being low"
			severity error;
			
		wait until rising_edge(i_clk);  -- goes to SEND_HOLD after rising edge
		wait for 1 ns;
		assert o_send_tx_byte = x"99"
			report "TC5b(Sample " & integer'image(tick_count) & "): Header byte not sent despite tx_busy being low"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): tx_start_pulse not deasserted yet"
			severity error;
			
		wait until rising_edge(i_clk);  -- goes to SEND_DATA after rising edge
		wait for 1 ns;  -- let outputs get set
		assert o_send_tx_byte = x"99"
			report "TC5b(Sample " & integer'image(tick_count) & "): Header byte not sent despite tx_busy being low"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): tx_start_pulse not asserted yet"
			severity error;
		
		wait until rising_edge(i_clk);  -- finished first cycle in state SEND_DATA, then in SEND_SET_ADDR for 1 cycle
		wait for 1 ns;  -- let outputs get set
		assert o_ram_rd_addr = x"001"
			report "TC5b(Sample " & integer'image(tick_count) & "): Ram address not updated to 1 after 1 clock cycle in SEND_DATA state"
			severity error;
		assert o_send_tx_byte = x"33"
			report "TC5b(Sample " & integer'image(tick_count) & "): Data not equal to 33"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC5b(Sample " & integer'image(tick_count) & "): Start pulse not high when sending 1st data byte in state SEND_DATA..."
			severity error;
		assert o_send_done_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high prematurely (still sending data)"
			severity error;
			
		wait until rising_edge(i_clk);  -- finished first cycle in state SEND_SET_ADDR, then in SEND_HOLD for 1 cycle
		wait for 1 ns;  -- let outputs get set
		assert o_ram_rd_addr = x"001"
			report "TC5b(Sample " & integer'image(tick_count) & "): Ram address not 1 in state SEND_HOLD"
			severity error;
		assert o_send_tx_byte = x"33"
			report "TC5b(Sample " & integer'image(tick_count) & "): Data not equal to 33"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): Start pulse high when in state SEND_HOLD"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high prematurely (still sending data)"
			severity error;
			
		i_ram_rd_data <= x"AA";  -- 1010 1010
		wait until rising_edge(i_clk);  -- finished in SEND_HOLD, start second cycle in state SEND_DATA
		wait for 1 ns;  -- let outputs get set
		assert o_ram_rd_addr = x"001"
			report "TC5b(Sample " & integer'image(tick_count) & "): Ram address updated while in SEND_HOLD"
			severity error;
		assert o_send_tx_byte = x"33"
			report "TC5b(Sample " & integer'image(tick_count) & "): RAM data updated while in SEND_HOLD"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): Start pulse asserted high while in SEND_HOLD"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while in SEND_HOLD"
			severity error;
			
		wait until rising_edge(i_clk);  -- finished 2nd cycle in state SEND_DATA, then in SEND_SET_ADDR for 1 cycle
		wait for 1 ns;  -- let outputs get set
		assert o_ram_rd_addr = x"002"
			report "TC5b(Sample " & integer'image(tick_count) & "): Ram address not updated to 2 after 2nd clock cycle in SEND_DATA state"
			severity error;
		assert o_send_tx_byte = x"AA"
			report "TC5b(Sample " & integer'image(tick_count) & "): Ram data not updated to AA"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC5b(Sample " & integer'image(tick_count) & "): Start pulse not asserted high while in SEND_DATA"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while still sending data"
			severity error;
			
		wait until rising_edge(i_clk);  -- finished 2nd cycle in state SEND_SET_ADDR, then in SEND_HOLD for 1 cycle
		wait for 1 ns;  -- let outputs get set
		assert o_ram_rd_addr = x"002"
			report "TC5b(Sample " & integer'image(tick_count) & "): Ram address not 1 in state SEND_HOLD"
			severity error;
		assert o_send_tx_byte = x"AA"
			report "TC5b(Sample " & integer'image(tick_count) & "): Data not equal to AA"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): Start pulse high when in state SEND_HOLD"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC5b(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high prematurely (still sending data)"
			severity error;
		
		-- Test case 5c: data bytes should not be transmitted when tx is busy
		wait until rising_edge(i_clk);  -- finished in SEND_HOLD, start third cycle in state SEND_DATA
		i_tx_busy <= '1';
		i_ram_rd_data <= x"28";
		wait until rising_edge(i_clk);  -- finished in SEND_HOLD, start fourth cycle in state SEND_DATA
		wait for 1 ns;  -- let outputs get set
		assert o_ram_rd_addr = x"002"
			report "TC5c(Sample " & integer'image(tick_count) & "): Ram address updated while in SEND_HOLD"
			severity error;
		assert o_send_tx_byte = x"AA"
			report "TC5c(Sample " & integer'image(tick_count) & "): RAM data updated while in SEND_HOLD"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC5c(Sample " & integer'image(tick_count) & "): Start pulse asserted high while in SEND_HOLD"
			severity error;
		assert o_send_done_pulse = '0'
			report "TC5c(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high while in SEND_HOLD"
			severity error;
		
		for i in 0 to 10 loop
			wait until rising_edge(i_clk);  -- finished 4th...14th "cycle" in state SEND_DATA, should still be in SEND_DATA afterwards
			wait for 1 ns;  -- let outputs get set
			assert o_ram_rd_addr = x"002"
				report "TC5c(Sample " & integer'image(tick_count) & "): Ram address updated despite tx_busy being high"
				severity error;
			assert o_send_tx_byte = x"AA"
				report "TC5c(Sample " & integer'image(tick_count) & "): Ram data updated despite tx_busy being high"
				severity error;
			assert o_send_tx_start_pulse = '0'
				report "TC5c(Sample " & integer'image(tick_count) & "): Start pulse asserted high despite tx_busy being high"
				severity error;
			assert o_send_done_pulse = '0'
				report "TC5c(Sample " & integer'image(tick_count) & "): send_done_pulse asserted high despite tx_busy being high"
				severity error;
		end loop;
		
		-- Test case 6: tx_busy LOW asserts HIGH 2 clocks after send_engine start_pulse
		test_id <= 6;
		i_tx_busy <= '0';
		wait until rising_edge(i_clk);  -- arrive in SEND_SET_ADDR | tx_busy been 0 for 1 clock cycle
		wait for 1 ns;
		assert o_send_tx_byte = x"28"
			report "TC6(Sample " & integer'image(tick_count) & "): byte not sent despite tx_busy being low"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC6(Sample " & integer'image(tick_count) & "): tx_start_pulse not asserted high despite tx busy being low"
			severity error;
			
		wait until rising_edge(i_clk);  -- arrive in SEND_HOLD | tx_busy been 0 for 2 clock cycle
		wait for 1 ns;
		assert o_send_tx_byte = x"28"
			report "TC6(Sample " & integer'image(tick_count) & "): byte not x28 as expected"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC6(Sample " & integer'image(tick_count) & "): start pulse asserted while in SEND_HOLD"
			severity error;
			
		i_tx_busy <= '1';  -- tx busy goes high, 2 clock cycles after it was set low (standard behaviour)
		i_ram_rd_data <= x"59";  -- we should not see this data byte or another start pulse in test case 6!
		
		wait until rising_edge(i_clk);  -- arrive in SEND_DATA
		wait for 1 ns;
		assert o_send_tx_byte = x"28"
			report "TC6(Sample " & integer'image(tick_count) & "): byte not x28 as expected"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC6(Sample " & integer'image(tick_count) & "): tx_start_pulse asserted high while in previous state (SEND_HOLD)"
			severity error;
		
		-- no changes should occur with o_send_tx_byte and o_send_tx_start_pulse as long as tx_busy is high
		wait until rising_edge(i_clk);
		assert o_send_tx_byte = x"28"
			report "TC6(Sample " & integer'image(tick_count) & "): byte not x28 as expected"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC6(Sample " & integer'image(tick_count) & "): tx_start_pulse asserted high while in SEND_DATA (but tx_busy is high)"
			severity error;
			
		wait until rising_edge(i_clk);
		assert o_send_tx_byte = x"28"
			report "TC6(Sample " & integer'image(tick_count) & "): byte not x28 as expected"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC6(Sample " & integer'image(tick_count) & "): tx_start_pulse asserted high while in SEND_DATA (but tx_busy is high)"
			severity error;
			
		wait until rising_edge(i_clk);
		assert o_send_tx_byte = x"28"
			report "TC6(Sample " & integer'image(tick_count) & "): byte not x28 as expected"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC6(Sample " & integer'image(tick_count) & "): tx_start_pulse asserted high while in SEND_DATA (but tx_busy is high)"
			severity error;
		
		-- Test case 7: tx_busy LOW asserts HIGH 4 clocks after send_engine start_pulse. Expecting: double start_pulse
		test_id <= 7;
		i_tx_busy <= '0';
		wait until rising_edge(i_clk);  -- arrive in SEND_SET_ADDR | tx_busy been 0 for 1 clock cycle
		wait for 1 ns;
		assert o_send_tx_byte = x"59"
			report "TC7(Sample " & integer'image(tick_count) & "): byte not sent despite tx_busy being low"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC7(Sample " & integer'image(tick_count) & "): tx_start_pulse not asserted high despite tx busy being low"
			severity error;
		
		-- trace_buffer would set i_ram_rd_data during the SEND_SET_ADDR state
		i_ram_rd_data <= x"73";  -- we should see this data byte and another start pulse at the end of TC7 as tx_busy goes high
		wait until rising_edge(i_clk);  -- arrive in SEND_HOLD | tx_busy been 0 for 2 clock cycles
		wait for 1 ns;
		assert o_send_tx_byte = x"59"
			report "TC7(Sample " & integer'image(tick_count) & "): byte not x59 as expected"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC7(Sample " & integer'image(tick_count) & "): start pulse asserted while in SEND_HOLD"
			severity error;
			
		wait until rising_edge(i_clk);  -- arrive in SEND_DATA | tx_busy been 0 for 3 clock cycles
		wait for 1 ns;
		assert o_send_tx_byte = x"59"
			report "TC7(Sample " & integer'image(tick_count) & "): byte not sent despite tx_busy being low"
			severity error;
		assert o_send_tx_start_pulse = '0'
			report "TC7(Sample " & integer'image(tick_count) & "): tx_start_pulse not asserted high while in previous state (SEND_HOLD)"
			severity error;
			
		wait until rising_edge(i_clk);  -- arrive in SEND_SET_ADDR | now faulty/additional send should become visible
		-- now it's 4 clocks of i_tx_busy technically! the DUT cares about what i_tx_busy is during the WHOLE SEND_DATA evaluation window
		i_tx_busy <= '1';  -- tx busy goes high, 4 clock cycles after it was set low (delayed/unusual toggle behaviour)
		wait for 1 ns;
		assert o_send_tx_byte = x"73"
			report "TC7(Sample " & integer'image(tick_count) & "): byte not updated to 73"
			severity error;
		assert o_send_tx_start_pulse = '1'
			report "TC7(Sample " & integer'image(tick_count) & "): tx_start_pulse not asserted high despite tx_busy taking 3 (not 2) clock cycles to toggle"
			severity error;
		

        -- Finish simulation
        wait for 10*CLK_ACTUAL;
        assert false report "Simulation finished" severity failure;
    end process;

end architecture sim;
