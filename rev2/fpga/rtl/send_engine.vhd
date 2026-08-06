-- ========================================
-- MODULE: send_engine.vhd
-- FUNCTION: streams captured data from BRAM to host via UART
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-16 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- LAST MODIFIED: 2026-05-15
-- MODIFIED: 2026-08-05 (rev2)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_send_start_pulse		1 bit		<- analyzer_fsm
-- i_send_tx_ready			1 bit		<- tx_mux
-- i_capture_start_addr 	14 bits		<- capture_engine
-- i_capture_sample_count	14 bits		<- capture_engine
-- i_capture_width_sel		1 bit		<- capture_engine
-- i_trigger_addr       	14 bits		<- capture_engine
-- i_ram_rd_data			16 bits		<- trace_buffer
--
-- OUTPUTS					DATA		TO MODULE
-- o_ram_rd_addr			14 bits		-> trace_buffer
-- o_send_tx_byte			8 bits		-> tx_mux
-- o_send_tx_valid			1 bit		-> tx_mux
-- o_send_active			1 bit		-> tx_mux
-- o_send_done_pulse		1 bit		-> analyzer_fsm
--
-- NOTES
-- send_engine owns the READ transfer:
--   1) sends HEADER byte 0x99
--   2) streams NUM_SAMPLES bytes from trace_buffer
--   3) pulses o_send_done_pulse when the final sample has been launched
--
-- trace_buffer is treated as synchronous-read RAM. o_ram_rd_addr is registered and driven
-- to trace_buffer before the corresponding i_ram_rd_data sample is launched to tx_mux.
-- WAIT_RAM provides the required latency stage so the selected RAM byte is valid
-- before SEND_SINGLE/DOUBLE_BYTE transmits it.
--
-- The RAM address is incremented only after the current byte has completed transmission.
-- When r_ram_rd_addr = LAST_ADDR and that byte has completed, send_engine asserts
-- o_send_done_pulse and returns to SEND_IDLE.

-- TX handshake: send_engine talks to tx_mux
-- o_send_tx_valid 	: "I have a byte ready"
-- o_send_tx_byte 	: byte associated with valid signal
-- i_send_tx_ready	: "byte accepted/ready this cycle"
-- Transfer occurs only when both valid and ready are '1'
-- Then one byte is sent from send_engine towards uart_tx via tx_mux
-- Otherwise the sender must hold the same byte, not advance FSM or increment counters.

-- i_capture_sample_count and i_capture_width_sel dictate number of bytes to send
-- if width_sel = '0', i.e. 8-channel mode: the latter 8 bits from i_ram_rd_data contains the byte we're looking for
-- if width_sel = '1', i.e. 16-channel mode: the full 16 bits from i_ram_rd_data contains the 2 bytes we're looking for
-- In total, we want to collect <i_capture_sample_count> number of samples (sets of 1 or 2 bytes) from trace_buffer.

-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- v_ : variable

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity send_engine is
	generic (
		ADDR_LENGTH : integer := 14
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;
		i_send_start_pulse		: in  std_logic;
		i_send_tx_ready			: in  std_logic;
		
		i_capture_start_addr 	: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
		i_capture_sample_count 	: in  std_logic_vector(ADDR_LENGTH-1 downto 0);
		i_capture_width_sel		: in  std_logic;
		i_trigger_addr		 	: in  std_logic_vector(ADDR_LENGTH-1 downto 0);  -- useful metadata for Python/waveform display, but not required to control RAM readout
		i_ram_rd_data			: in  std_logic_vector(15 downto 0);
		
		o_ram_rd_addr			: out std_logic_vector(ADDR_LENGTH-1 downto 0);
		o_send_tx_byte			: out std_logic_vector(7 downto 0);
		o_send_tx_valid			: out std_logic;
		o_send_active			: out std_logic;
		o_send_done_pulse		: out std_logic
	);
end entity send_engine;

architecture RTL of send_engine is
	-- Internal send_engine state machine
	-- Note that UART is slow: 1 byte ≈ 10.85 us ≈ 521 FPGA clocks @ 921600 baud, 24MHz.
	-- @ 6Mbaud, 24MHz: 1 byte (+1start,1stop bit) ≈ 1.67 us = 40 FPGA clocks
	-- I.e. Adding a few FPGA clocks per byte is irrelevant at low baud rate, but becomes more tricky at higher bauds and lower sampling rates
	type send_engine_state_type is (
		IDLE,
		SEND_HEADER,
		WAIT_RAM,
		SEND_LOW_BYTE,
		SEND_HIGH_BYTE,
		DONE
	);
	
	-- Register signals, next-state signals
	signal r_state, n_state : send_engine_state_type := IDLE;
	
	-- values to latch before send operation begins
	--signal r_capture_start_addr, n_capture_start_addr : unsigned(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal r_sample_count, n_sample_count : unsigned(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal r_capture_width_sel, n_capture_width_sel : std_logic := '0';
	--signal r_trigger_addr, n_trigger_addr : unsigned(ADDR_LENGTH-1 downto 0) := (others => '0');  -- useful metadata for Python/waveform display, but not required to control RAM readout
	signal r_sample_index, n_sample_index : unsigned(ADDR_LENGTH-1 downto 0) := (others => '0');  -- index of sample currently being transmitted
	
	signal r_ram_rd_addr, n_ram_rd_addr : unsigned(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal r_send_done_pulse, n_send_done_pulse : std_logic := '0';
		
begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				-- reset logic
				r_state <= IDLE;
				r_sample_count <= (others => '0');
				r_capture_width_sel <= '0';
				r_sample_index <= (others => '0');
				r_ram_rd_addr <= (others => '0');
				r_send_done_pulse <= '0';
			else
				r_state <= n_state;
				r_sample_count <= n_sample_count;
				r_capture_width_sel <= n_capture_width_sel;
				r_sample_index <= n_sample_index;
				r_ram_rd_addr <= n_ram_rd_addr;
				r_send_done_pulse <= n_send_done_pulse;
			end if;
		end if;
	end process seq_proc;
	
	
	-- Combinational process for dealing with send engine FSM
	fsm_proc: process(all) is
		variable v_next_addr : unsigned(ADDR_LENGTH-1 downto 0);
	begin
		-- Defaults
		n_state <= r_state;
		n_ram_rd_addr <= r_ram_rd_addr;
		n_sample_count <= r_sample_count;
		n_sample_index <= r_sample_index;
		n_capture_width_sel <= r_capture_width_sel;
		n_send_done_pulse <= '0';
		
		-- Calculate the next circular-buffer address
        if r_sample_count /= to_unsigned(0, ADDR_LENGTH) and r_ram_rd_addr = r_sample_count - 1 then
            v_next_addr := (others => '0');
        else
            v_next_addr := r_ram_rd_addr + 1;
        end if;
	
		case r_state is
			when IDLE => 
				if i_send_start_pulse = '1' then
					-- latch metadata at the start of the send proceure (host READ cmd)
					n_ram_rd_addr <= unsigned(i_capture_start_addr);  -- important for wraparound read. start reading from RAM at correct start_addr
					n_sample_count <= unsigned(i_capture_sample_count);
					n_capture_width_sel <= i_capture_width_sel;
					n_sample_index <= (others => '0');
					n_state <= SEND_HEADER;
				end if;
				
			when SEND_HEADER =>
				-- header is accepted when valid and ready are both high
				if i_send_tx_ready = '1' Then
					n_state <= WAIT_RAM;
				end if;
	
			when WAIT_RAM =>
				-- One-cycle synchronous RAM read latency (1 clock to produce valid i_ram_rd_data after o_ram_rd_addr changes)
				n_state <= SEND_LOW_BYTE;
				
			when SEND_LOW_BYTE =>
				if i_send_tx_ready = '1' then
					if i_capture_width_sel = '1' then  -- 16bit sample: low-byte accepted, send high byte
						n_state 		<= SEND_HIGH_BYTE;
					elsif r_sample_index = r_sample_count - 1 then  -- final 8bit sample accepted
						n_state 		<= DONE;
					else  -- move to next 8bit sample
						n_sample_index 	<= r_sample_index + 1;
						n_ram_rd_addr 	<= v_next_addr;
						n_state 		<= WAIT_RAM;
					end if;
				end if;
			
			when SEND_HIGH_BYTE =>
				if r_sample_index = r_sample_count - 1 then  -- final 16bit sample accepted
					n_state 		<= DONE;
				else  -- current 16bit sample is complete
					n_sample_index 	<= r_sample_index + 1;
					n_ram_rd_addr 	<= v_next_addr;
					n_state 		<= WAIT_RAM;
				end if;
			
			when DONE =>
				n_send_done_pulse 	<= '1';
				n_state 			<= IDLE;
				
		end case;
	end process fsm_proc;
	
	
	output_proc : process(all) is
	begin
		o_send_tx_valid <= '0';
		o_send_tx_byte <= (others => '0');
		
		case r_state is
			when SEND_HEADER =>
				o_send_tx_valid <= '1'
				n_send_tx_byte <= x"99";  -- send 0x99 (1001 1001) status code (header)
			
			when SEND_LOW_BYTE =>
                o_send_tx_valid <= '1';
                o_send_tx_byte  <= i_ram_rd_data(7 downto 0);

            when SEND_HIGH_BYTE =>
                o_send_tx_valid <= '1';
                o_send_tx_byte  <= i_ram_rd_data(15 downto 8);

            when others =>
                null;
		end case;
	end process output_proc;
	
	-- Set remaining outputs
	o_ram_rd_addr 		<= std_logic_vector(r_ram_rd_addr);
	o_send_done_pulse 	<= r_send_done_pulse;
	o_send_active 		<= '1' when r_state /= IDLE and r_state /= DONE else '0';
	
end architecture RTL;
