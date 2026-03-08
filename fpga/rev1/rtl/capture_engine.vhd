-- ========================================
-- MODULE: capture_engine.vhd
-- FUNCTION: samples logic analyzer inputs at i_clk and writes to BRAM
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
--
-- PREFIXES:
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity capture_engine is
	generic (
		ADDR_LENGTH : integer := 12;
		NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 4096
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
end entity capture_engine;

architecture RTL of capture_engine is
	-- Internal capture_engine state machine
	type capture_engine_state_type is (CAPTURE_IDLE, CAPTURE_RUN);
	
	-- Register signals, next-state signals
	signal r_state, n_state : capture_engine_state_type := CAPTURE_IDLE;
	signal r_raw_wr_en_pulse, n_raw_wr_en_pulse : std_logic := '0';
	signal r_raw_wr_addr, n_raw_wr_addr : std_logic_vector(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal r_raw_wr_data, n_raw_wr_data : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal r_capture_done_pulse, n_capture_done_pulse : std_logic := '0';
	
	-- Define constants
	constant LAST_ADDR : std_logic_vector(ADDR_LENGTH-1 downto 0) := std_logic_vector(to_unsigned(NUM_SAMPLES-1, ADDR_LENGTH));
	
begin
	-- Sequential process to deal with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst = '1' then
				-- reset logic
				r_state <= CAPTURE_IDLE;
				r_raw_wr_en_pulse <= '0';
				r_raw_wr_addr <= (others => '0');
				r_raw_wr_data <= (others => '0');
				r_capture_done_pulse <= '0';
			else
				r_state <= n_state;
				r_raw_wr_en_pulse <= n_raw_wr_en_pulse;
				r_raw_wr_addr <= n_raw_wr_addr;
				r_raw_wr_data <= n_raw_wr_data;
				r_capture_done_pulse <= n_capture_done_pulse;
			end if;
		end if;
	end process seq_proc;


	-- Combinational process to deal with capture engine FSM logic
	fsm_proc: process(all) is
	begin
		-- Defaults
		n_state <= r_state;
		n_raw_wr_en_pulse <= '0';
		n_raw_wr_addr <= r_raw_wr_addr;
		n_raw_wr_data <= r_raw_wr_data;
		n_capture_done_pulse <= '0';
		
		case r_state is
			when CAPTURE_IDLE =>
				if i_capture_start_pulse = '1' then
					n_raw_wr_addr <= (others => '0');
					n_state <= CAPTURE_RUN;
				end if;
			
			when CAPTURE_RUN =>
				if i_samp_tick = '1' then
					n_raw_wr_en_pulse <= '1';
					n_raw_wr_data <= i_inputs;
					
					if r_raw_wr_addr = LAST_ADDR then
						-- Sample nr 4096 (index 4095) just captured
						n_capture_done_pulse <= '1';
						n_raw_wr_addr <= (others => '0');
						n_state <= CAPTURE_IDLE;
					else
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
					end if;
				end if;
			
			when others =>
				null;
		end case;
	end process fsm_proc;


	-- Set outputs
	o_raw_wr_en_pulse <= r_raw_wr_en_pulse;
	o_raw_wr_addr <= r_raw_wr_addr;
	o_raw_wr_data <= r_raw_wr_data;
	o_capture_done_pulse <= r_capture_done_pulse;
	
end architecture RTL;
