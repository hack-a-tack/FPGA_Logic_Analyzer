-- ========================================
-- MODULE: send_engine.vhd
-- FUNCTION: streams captured data from BRAM to host via UART
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-16 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- LAST MODIFIED: 2026-05-15
-- MODIFIED: 2026-08-03 (rev2)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_send_start_pulse		1 bit		<- analyzer_fsm
-- i_tx_busy				1 bit		<- uart_tx
-- i_capture_start_addr 	14 bits		<- capture_engine
-- i_capture_sample_count	14 bits		<- capture_engine
-- i_capture_width_sel		1 bit		<- capture_engine
-- i_trigger_addr       	14 bits		<- capture_engine
-- i_ram_rd_data			16 bits		<- trace_buffer
--
-- OUTPUTS					DATA		TO MODULE
-- o_ram_rd_addr			14 bits		-> trace_buffer
-- o_send_tx_byte			8 bits		-> tx_mux
-- o_send_tx_start_pulse	1 bit		-> tx_mux
-- o_send_done_pulse		1 bit		-> analyzer_fsm
--
-- NOTES
-- send_engine owns the READ transfer:
--   1) sends HEADER byte 0x99
--   2) streams NUM_SAMPLES bytes from trace_buffer
--   3) pulses o_send_done_pulse when the final sample has been launched
--
-- trace_buffer is treated as synchronous-read RAM. o_ram_rd_addr is registered and driven
-- to trace_buffer before the corresponding i_ram_rd_data byte is launched to tx_mux.
-- SEND_SET_ADDR provides the required latency stage so the selected RAM byte is valid
-- before SEND_DATA_START transmits it.
--
-- After each o_send_tx_start_pulse, send_engine waits for i_tx_busy to go high and then
-- low again before launching the next byte. This avoids dropped/duplicated bytes caused by
-- registered tx_mux/uart_tx feedback latency.
--
-- The RAM address is incremented only after the current byte has completed transmission.
-- When r_ram_rd_addr = LAST_ADDR and that byte has completed, send_engine asserts
-- o_send_done_pulse and returns to SEND_IDLE.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- IMPLEMENT TX HANDSHAKE and remove most of the FSM states
-- TBD: wraparound read behaviour
-- send_engine must include a RAM-read wait/pipeline state.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity send_engine is
	generic (
		ADDR_LENGTH : integer := 14;
		NUM_SAMPLES : integer := 2**ADDR_LENGTH
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;
		i_send_start_pulse		: in  std_logic;
		i_tx_busy				: in  std_logic;
		
		i_capture_start_addr 	: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
		i_capture_sample_count 	: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
		i_capture_width_sel		: in  std_logic;
		i_trigger_addr		 	: in  std_logic_vector(ADDR_LENGTH-1 downto 0);  -- useful metadata for Python/waveform display, but not required to control RAM readout
		i_ram_rd_data			: in  std_logic_vector(15 downto 0);
		
		o_ram_rd_addr			: out std_logic_vector(ADDR_LENGTH-1 downto 0);
		o_send_tx_byte			: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_send_tx_start_pulse	: out std_logic;
		o_send_done_pulse		: out std_logic
	);
end entity send_engine;

architecture RTL of send_engine is
	-- Internal send_engine state machine
	-- Rule: Never launch byte N+1 until byte N has made tx_busy go high and then low again.
	-- UART is slow anyway: 1 byte ≈ 10.85 us ≈ 521 FPGA clocks. Adding a few FPGA clocks per byte is irrelevant.
	-- Rev2 will add explicit handshaking
	type send_engine_state_type is (		
		SEND_IDLE,
		SEND_HEADER_START,
		SEND_HEADER_WAIT_BUSY_HIGH,
		SEND_HEADER_WAIT_BUSY_LOW,
		SEND_SET_ADDR,
		SEND_DATA_START,
		SEND_DATA_WAIT_BUSY_HIGH,
		SEND_DATA_WAIT_BUSY_LOW,
		SEND_DONE
	);
	
	-- Register signals, next-state signals
	signal r_state, n_state : send_engine_state_type := SEND_IDLE;
	
	signal r_ram_rd_addr, n_ram_rd_addr : std_logic_vector(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal r_send_tx_byte, n_send_tx_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal r_send_tx_start_pulse, n_send_tx_start_pulse : std_logic := '0';
	signal r_send_done_pulse, n_send_done_pulse : std_logic := '0';
	
	signal r_samples_sent, n_samples_sent : integer := 0;
		
begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				-- reset logic
				r_state <= SEND_IDLE;
				r_ram_rd_addr <= (others => '0');
				r_send_tx_byte <= (others => '0');
				r_send_tx_start_pulse <= '0';
				r_send_done_pulse <= '0';
				
				r_samples_sent <= 0;
			else
				r_state <= n_state;
				r_ram_rd_addr <= n_ram_rd_addr;
				r_send_tx_byte <= n_send_tx_byte;
				r_send_tx_start_pulse <= n_send_tx_start_pulse;
				r_send_done_pulse <= n_send_done_pulse;
				
				r_samples_sent <= n_samples_sent;
			end if;
		end if;
	end process seq_proc;
	
	
	-- Combinational process for dealing with send engine FSM
	fsm_proc: process(all) is
	begin
		-- Defaults
		n_state <= r_state;
		n_ram_rd_addr <= r_ram_rd_addr;
		n_send_tx_byte <= r_send_tx_byte;
		n_send_tx_start_pulse <= '0';
		n_send_done_pulse <= '0';
		n_samples_sent <= r_samples_sent;
	
		case r_state is
			when SEND_IDLE => 
				if i_send_start_pulse = '1' then
					n_ram_rd_addr <= i_capture_start_addr;  -- important for wraparound read. start reading from RAM at start_addr received from capture_engine
					n_state <= SEND_HEADER_START;
				end if;
			
			when SEND_HEADER_START =>
				if i_tx_busy = '0' then
					n_send_tx_byte <= x"99";  -- send 0x99 (1001 1001) status code (header)
					n_send_tx_start_pulse <= '1';  -- launch HEADER byte
					n_state <= SEND_HEADER_WAIT_BUSY_HIGH;
				end if;
				
			when SEND_HEADER_WAIT_BUSY_HIGH =>
				if i_tx_busy = '1' then
					n_state <= SEND_HEADER_WAIT_BUSY_LOW;
				end if;
			
			when SEND_HEADER_WAIT_BUSY_LOW =>
				if i_tx_busy = '0' then
					n_state <= SEND_SET_ADDR;
				end if;
				
			when SEND_SET_ADDR =>
				-- synchronous RAM latency stage (1 clock to produce valid i_ram_rd_data after o_ram_rd_addr changes)
				n_state <= SEND_DATA_START;
				
			when SEND_DATA_START =>
				if i_tx_busy = '0' then
					n_send_tx_byte <= i_ram_rd_data(7 downto 0);
					n_send_tx_start_pulse <= '1';
					if i_capture_width_sel = '1' then
						-- WILL HAVE TO SEND 2 BYTES IF WIDE CAPTURE WIDTH SELECTED...
						-- go to state where you send another byte (i_ram_rd_data(15 downto 8) or something)
					end if;
					n_samples_sent <= r_samples_sent + 1;
					n_state <= SEND_DATA_WAIT_BUSY_HIGH;
				end if;
			
			when SEND_DATA_WAIT_BUSY_HIGH =>
				if i_tx_busy = '1' then
					n_state <= SEND_DATA_WAIT_BUSY_LOW;
				end if;
				
			when SEND_DATA_WAIT_BUSY_LOW =>
				if i_tx_busy = '0' then
					if r_samples_sent = to_integer(unsigned(i_capture_sample_count)) then
						n_state <= SEND_DONE;
					else
						if unsigned(r_ram_rd_addr) = unsigned(i_capture_sample_count) then
							n_ram_rd_addr <= (others => '0');
						else
							n_ram_rd_addr <= std_logic_vector(unsigned(r_ram_rd_addr) + 1);
						end if;
						n_state <= SEND_SET_ADDR;
					end if;
				end if;		
			
			when SEND_DONE =>
				n_send_done_pulse <= '1';
				n_state <= SEND_IDLE;
				
		end case;
	end process fsm_proc;
	
	
	-- Set outputs
	o_ram_rd_addr <= r_ram_rd_addr;
	o_send_tx_byte <= r_send_tx_byte;
	o_send_tx_start_pulse <= r_send_tx_start_pulse;
	o_send_done_pulse <= r_send_done_pulse;
	
end architecture RTL;
