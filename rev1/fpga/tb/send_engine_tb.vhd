-- ========================================
-- MODULE: send_engine_tb.vhd
-- FUNCTION: TESTBENCH for entity which streams captured data from BRAM to host
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-17 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- LAST MODIFIED: 2026-05-16
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst					1 bit		<- top
-- i_send_start_pulse		1 bit		<- analyzer_fsm
-- i_tx_busy				1 bit		<- uart_tx
-- i_ram_rd_data			8 bits		<- trace_buffer
--
-- OUTPUTS					DATA		TO MODULE
-- o_ram_rd_addr			12 bits		-> trace_buffer
-- o_send_tx_byte			8 bits		-> tx_mux
-- o_send_tx_start_pulse	1 bit		-> tx_mux
-- o_send_done_pulse		1 bit		-> analyzer_fsm
--
-- NOTES
-- TC0/TC1 cover the core rev1 send_engine contract.
-- Extra edge-case tests can be added if this module changes again.
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
	constant ADDR_LENGTH : integer := 3;
	constant NUM_SAMPLES : integer := 2**ADDR_LENGTH;   -- 8; 4096 samples is overkill for basic unit testing
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
	
	-- TX monitor signals
	signal tx_count        : integer range 0 to NUM_SAMPLES + 2 := 0;
	signal seen_done       : std_logic := '0';
	signal extra_tx_after_done : std_logic := '0';
	
	-- Other signals
	signal test_id : integer := 0;  -- keep track of test cases
	signal tick_count : integer := 0;  -- keeps track of number of samples read from RAM/sent to tx_mux
	
	-- TX monitor helper function
	function expected_tx_byte(index : integer) return std_logic_vector is
	begin
		if index = 0 then
			return x"99"; -- HEADER
		else
			-- Payload byte index 1 maps to RAM addr 0 -> 0x10
			return std_logic_vector(to_unsigned(16 + (index - 1), DATA_LENGTH));
		end if;
	end function;

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
	-- Drives clk input
    clk_process: process is
    begin
        while true loop
            i_clk <= '0';
            wait for CLK_HALF;
            i_clk <= '1';
            wait for CLK_HALF;
        end loop;
    end process;
	
	
	-- Mock synchronous trace_buffer read path
	-- Drives i_ram_rd_data
	-- Data updates 1 clock after o_ram_rd_addr changes.
	-- Pattern:
	--   addr 0 -> 0x10
	--   addr 1 -> 0x11
	--   ...
	--   addr 7 -> 0x17
	mock_ram_proc : process(i_clk) is
		variable addr_i : integer;
	begin
		if rising_edge(i_clk) then
			if i_rst = '0' then
				i_ram_rd_data <= (others => '0');  -- 0x00
			else
				addr_i := to_integer(unsigned(o_ram_rd_addr));
				i_ram_rd_data <= std_logic_vector(to_unsigned(16 + addr_i, DATA_LENGTH));
			end if;
		end if;
	end process mock_ram_proc;
	
	
	-- tx_busy behaviour.
	-- Drives i_tx_busy. Why? to model tx_mux/uart_tx feedback latency
	uart_busy_model_proc : process is
	begin
		i_tx_busy <= '0';

		wait until i_rst = '1';

		while true loop
			wait until rising_edge(i_clk) and o_send_tx_start_pulse = '1';

			-- Model registered tx_mux/uart_tx latency before busy is visible
			wait until rising_edge(i_clk);
			wait until rising_edge(i_clk);

			i_tx_busy <= '1';

			-- Model UART being busy for some cycles.
			-- Keep short in unit TB; this is not a UART timing test.
			for i in 0 to 5 loop
				wait until rising_edge(i_clk);
			end loop;

			i_tx_busy <= '0';
		end loop;
	end process;
	
	
	-- TX monitor (does not drive anything; it only checks)
	-- Every time o_send_tx_start_pulse = 1, o_send_tx_byte must contain the next expected byte.
	-- Monitors: o_send_tx_byte, o_send_tx_start_pulse, o_send_done_pulse
	tx_monitor_proc : process is
	begin
		wait until i_rst = '1';

		while true loop
			wait until rising_edge(i_clk);
			wait for 1 ns; -- let registered DUT outputs settle in simulation

			if o_send_tx_start_pulse = '1' then
				if seen_done = '1' then
					extra_tx_after_done <= '1';
					assert false
						report "TX monitor: extra tx_start observed after send_done"
						severity error;
				end if;

				-- if tx_count already > NUM_SAMPLES, it's at least NUM_SAMPLES + 1 and we add +1 at the end of the if statement
				assert tx_count <= NUM_SAMPLES
					report "TX monitor: too many transmitted bytes. tx_count=" & integer'image(tx_count)
					severity error;

				assert o_send_tx_byte = expected_tx_byte(tx_count)
					report "TX monitor: wrong byte at tx_count=" & integer'image(tx_count) &
						   ". Expected 0x" & integer'image(to_integer(unsigned(expected_tx_byte(tx_count)))) &
						   ", got 0x" & integer'image(to_integer(unsigned(o_send_tx_byte)))
					severity error;

				tx_count <= tx_count + 1;
			end if;

			if o_send_done_pulse = '1' then
				seen_done <= '1';

				assert tx_count = NUM_SAMPLES + 1  -- should have sent 8 RAM samples + 0x99 header by now
					report "TX monitor: send_done asserted at wrong tx_count. Expected " &
						   integer'image(NUM_SAMPLES + 1) & ", got " & integer'image(tx_count)
					severity error;
			end if;
		end loop;
	end process tx_monitor_proc;
	
	
	-- Stimulus process
	-- Drives remaining input signals: i_rst, i_send_start_pulse
	-- Monitors remaining output signals: o_ram_rd_addr, (o_send_tx_start_pulse, o_send_done_pulse)
	stim_proc: process is
	begin
		--------------------------------------------------------------------
		-- TC0: Reset behaviour
		--------------------------------------------------------------------
		test_id <= 0;

		wait until rising_edge(i_clk);
		i_rst <= '0';

		wait until rising_edge(i_clk);
		wait for 1 ns;

		assert o_ram_rd_addr = (o_ram_rd_addr'range => '0')
			report "TC0: Ram address not 0 in reset"
			severity error;

		assert o_send_tx_byte = (o_send_tx_byte'range => '0')
			report "TC0: TX byte not 0 in reset"
			severity error;

		assert o_send_tx_start_pulse = '0'
			report "TC0: TX start pulse not 0 in reset"
			severity error;

		assert o_send_done_pulse = '0'
			report "TC0: done pulse not 0 in reset"
			severity error;

		--------------------------------------------------------------------
		-- Release reset
		--------------------------------------------------------------------
		i_rst <= '1';
		wait until rising_edge(i_clk);
		wait for 1 ns;

		--------------------------------------------------------------------
		-- TC1: Full normal transfer (main test)
		-- Expected TX sequence:
		--   0x99, 0x10, 0x11, ... 0x17
		-- TX monitor checks byte order automatically.
		--------------------------------------------------------------------
		test_id <= 1;

		i_send_start_pulse <= '1';
		wait until rising_edge(i_clk);
		i_send_start_pulse <= '0';

		-- Wait for transfer completion
		wait until rising_edge(i_clk) and o_send_done_pulse = '1';
		wait for 1 ns;

		assert tx_count = NUM_SAMPLES + 1
			report "TC1: wrong TX count at done. Expected " &
				   integer'image(NUM_SAMPLES + 1) & ", got " & integer'image(tx_count)
			severity error;

		assert o_ram_rd_addr = (o_ram_rd_addr'range => '0')
			report "TC1: RAM address did not return to 0 after transfer"
			severity error;

		-- Done should deassert after one clock
		wait until rising_edge(i_clk);
		wait for 1 ns;

		assert o_send_done_pulse = '0'
			report "TC1: done pulse did not deassert after 1 clock"
			severity error;

		-- No extra tx_start after done
		for i in 0 to 10 loop
			wait until rising_edge(i_clk);
			wait for 1 ns;

			assert o_send_tx_start_pulse = '0'
				report "TC1: extra tx_start observed after done"
				severity error;
		end loop;

		--------------------------------------------------------------------
		-- Finish simulation
		--------------------------------------------------------------------
		wait for 10 * CLK_ACTUAL;
		assert false report "Simulation finished: TC0 + TC1 passed" severity failure;
	end process;

end architecture sim;
