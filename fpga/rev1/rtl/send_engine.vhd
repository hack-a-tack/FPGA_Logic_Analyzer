-- ========================================
-- MODULE: send_engine.vhd
-- FUNCTION: streams captured data from BRAM to host via UART
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-16 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
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
-- o_ram_rd_addr (-> trace_buffer) is set at the same time as the tx_byte and tx_start_pulse (-> tx_mux) [SEND_DATA].
-- BUT!: note that the ram_rd_addr is 1 cycle ahead and in the waveform will show address 1 when sample 0 was just sent to tx_mux
-- this is because the rd_addr is passed to trace_buffer slightly ahead of time so the associated data arrives at send_engine in time
-- ... for it to be sent to tx_mux.
-- state [SEND_SET_ADDR] is used so trace_buffer has time to load ram data (associated with o_ram_rd_addr) onto the i_ram_rd_data line.
-- state [SEND_HOLD] is used to stall one more clock cycle, such that i_tx_busy (from uart_tx) has time to reach send_engine before
-- ... we prematurely skip to the next ram address before uart_tx actually sending the previous one
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity send_engine is
	generic (
		ADDR_LENGTH : integer := 12;
		NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 4096
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
end entity send_engine;

architecture RTL of send_engine is
	-- Internal send_engine state machine
	type send_engine_state_type is (SEND_IDLE, SEND_HEADER, SEND_SET_ADDR, SEND_HOLD, SEND_DATA);
	
	-- Register signals, next-state signals
	signal r_state, n_state : send_engine_state_type := SEND_IDLE;
	
	signal r_ram_rd_addr, n_ram_rd_addr : std_logic_vector(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal r_send_tx_byte, n_send_tx_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal r_send_tx_start_pulse, n_send_tx_start_pulse : std_logic := '0';
	signal r_send_done_pulse, n_send_done_pulse : std_logic := '0';
		
	-- Define constants
	constant LAST_ADDR : std_logic_vector(ADDR_LENGTH-1 downto 0) := std_logic_vector(to_unsigned(NUM_SAMPLES-1, ADDR_LENGTH));
	
begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '0' then
				-- reset logic
				r_state <= SEND_IDLE;
				r_ram_rd_addr <= (others => '0');
				r_send_tx_byte <= (others => '0');
				r_send_tx_start_pulse <= '0';
				r_send_done_pulse <= '0';
			else
				r_state <= n_state;
				r_ram_rd_addr <= n_ram_rd_addr;
				r_send_tx_byte <= n_send_tx_byte;
				r_send_tx_start_pulse <= n_send_tx_start_pulse;
				r_send_done_pulse <= n_send_done_pulse;
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
	
		case r_state is
			when SEND_IDLE => 
				if i_send_start_pulse = '1' then
					n_ram_rd_addr <= (others => '0');
					n_state <= SEND_HEADER;
				end if;
			
			when SEND_HEADER =>
				if i_tx_busy = '0' then
					n_send_tx_byte <= x"99";  -- send 0x99 (1001 1001) status code (header)
					n_send_tx_start_pulse <= '1';
					n_state <= SEND_SET_ADDR;
				end if;
				
			when SEND_SET_ADDR =>
				-- synchronous RAM latency stage (1 clock to produce valid i_ram_rd_data after o_ram_rd_addr changes)
				n_state <= SEND_HOLD;
				
				
			-- Rev1 workaround (with extra intermediary clock cycle) tolerates only bounded busy-feedback latency
			-- duplicate sends still possible if busy feedback is delayed too many cycles
			-- Rev2 will replace this with explicit handshake
			when SEND_HOLD =>
				-- add one clock cycle for updated i_tx_busy flag to reach send_engine before new transfer is initiated.
				-- without this the module sends 2 start pulses every time tx_busy goes low because it doesn't toggle fast enough.
				-- but the uart_tx module only takes one byte (and sets busy high) so essentially half the samples never get transmitted.
				n_state <= SEND_DATA;
			
			when SEND_DATA =>
				if i_tx_busy = '0' then
					n_send_tx_byte <= i_ram_rd_data;
					n_send_tx_start_pulse <= '1';
					
					if r_ram_rd_addr = LAST_ADDR then
						-- Last sample (nr 4096, index 4095) just launched to tx_path
						n_send_done_pulse <= '1';
						n_ram_rd_addr <= (others => '0');
						n_state <= SEND_IDLE;
					else
						n_ram_rd_addr <= std_logic_vector(unsigned(r_ram_rd_addr) + 1);
						n_state <= SEND_SET_ADDR;
					end if;
				end if;				
		end case;
	end process fsm_proc;
	
	
	-- Set outputs
	o_ram_rd_addr <= r_ram_rd_addr;
	o_send_tx_byte <= r_send_tx_byte;
	o_send_tx_start_pulse <= r_send_tx_start_pulse;
	o_send_done_pulse <= r_send_done_pulse;
	
end architecture RTL;
