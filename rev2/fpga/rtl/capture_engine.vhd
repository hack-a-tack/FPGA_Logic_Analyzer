-- ========================================
-- MODULE: capture_engine.vhd
-- FUNCTION: samples logic analyzer inputs at i_clk and writes to BRAM
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-31 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_samp_tick				1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_capture_start_pulse	1 bit		<- analyzer_fsm
-- i_inputs					16 bits		<- top
-- CONFIG REGISTER VALUES
-- i_cfg_uart_baud_rate    	2 bits		NOT NEEDED IN THIS MODULE?
-- i_cfg_capture_width_sel	1 bit		<- config_regs
-- i_cfg_sample_rate      	2 bits		NOT NEEDED IN THIS MODULE?
-- i_cfg_capture_depth_sel	1 bit		<- config_regs
-- i_cfg_trigger_mode		2 bits		<- config_regs
-- i_cfg_edge_trigger_ch	4 bits		<- config_regs
-- i_cfg_edge_trigger_type	2 bits		<- config_regs
-- i_cfg_pattern_value		16 bits		<- config_regs
-- i_cfg_pattern_mask		16 bits		<- config_regs
-- i_cfg_trigger_pos		2 bits		<- config_regs
--
-- OUTPUTS					DATA		TO MODULE
-- o_raw_wr_en_pulse		1 bit		-> trace_buffer
-- o_raw_wr_addr			14 bits		-> trace_buffer
-- o_raw_wr_data			8 bits		-> trace_buffer
-- o_capture_done_pulse		1 bit		-> analyzer_fsm
--
-- NOTES
-- Linear capture: First sample is written to RAM address 0 during state IDLE. The rest is sent in LINEAR_CAPTURE.
--
-- PREFIXES:
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity capture_engine is
	generic (
		ADDR_LENGTH : integer := 14;
		NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 16,384. 12,288 will be used if deep capture depth is chosen
		DATA_LENGTH : integer := 16				  -- or should this be 16?
	);
	port (
		i_clk					: in  std_logic;
		i_samp_tick				: in  std_logic;
		i_rst_n					: in  std_logic;
		i_capture_start_pulse	: in  std_logic;
		i_inputs				: in  std_logic_vector(15 downto 0);  -- 16 bits at compile time. during runtime host can choose first 8 bits
		
		i_cfg_capture_width_sel	: in  std_logic; 
		i_cfg_capture_depth_sel	: in  std_logic;
		i_cfg_trigger_mode		: in  std_logic_vector(1 downto 0);
		i_cfg_edge_trigger_ch	: in  std_logic_vector(3 downto 0);
		i_cfg_edge_trigger_type	: in  std_logic_vector(1 downto 0);
		i_cfg_pattern_value		: in  std_logic_vector(15 downto 0);
		i_cfg_pattern_mask		: in  std_logic_vector(15 downto 0);
		i_cfg_trigger_pos		: in  std_logic_vector(1 downto 0);
		
		o_raw_wr_en_pulse		: out std_logic;
		o_raw_wr_addr			: out std_logic_vector(ADDR_LENGTH-1 downto 0);
		o_raw_wr_data			: out std_logic_vector(15 downto 0);
		o_capture_done_pulse	: out std_logic
	);
end entity capture_engine;

architecture RTL of capture_engine is
	-- Internal capture_engine state machine
	type capture_engine_state_type is (IDLE, LINEAR_CAPTURE, PREFILL, ARMED, POST_TRIGGER, DONE);
	
	-- Register signals, next-state signals
	signal r_state, n_state : capture_engine_state_type := IDLE;
	signal r_raw_wr_en_pulse, n_raw_wr_en_pulse : std_logic := '0';
	signal r_raw_wr_addr, n_raw_wr_addr : std_logic_vector(ADDR_LENGTH-1 downto 0) := (others => '0');
	signal r_raw_wr_data, n_raw_wr_data : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal r_capture_done_pulse, n_capture_done_pulse : std_logic := '0';
	
	signal prev_sample, curr_sample : std_logic_vector(15 downto 0) := (others => '0');
	signal r_trigger_address, n_trigger_address : std_logic_vector(13 downto 0) := (others => '0');
	
	-- LAST_ADDR must be a signal (or variable) so it can change depending on capture depth in config_regs
	signal LAST_ADDR : std_logic_vector(ADDR_LENGTH-1 downto 0) := std_logic_vector(to_unsigned(4096-1, ADDR_LENGTH));
	
	-- counters
	signal total_sample_count : integer range 0 to LAST_ADDR := 0;
	signal post_trigger_count : integer range 0 to LAST_ADDR := 0;
	
	
begin
	addr_proc : process(i_cfg_capture_depth_sel, i_cfg_capture_width_sel) is
	begin
		if i_cfg_capture_depth_sel = '0' then		-- shallow capture (4096 bytes)
			if i_cfg_capture_width_sel = '0' then  	-- 1 byte (8 bits) per sample, i.e. 4096 samples
				LAST_ADDR <= std_logic_vector(to_unsigned(4096-1, ADDR_LENGTH));;
			else									-- 2 bytes (16 bits) per sample, i.e. 2048 samples
				LAST_ADDR <= std_logic_vector(to_unsigned(2047-1, ADDR_LENGTH));;
			end if;
		else										-- deep capture (12288 bytes)
			if i_cfg_capture_width_sel = '0' then  	-- 1 byte (8 bits) per sample, i.e. 12288 samples
				LAST_ADDR <= std_logic_vector(to_unsigned(12288-1, ADDR_LENGTH));;
			else									-- 2 bytes (16 bits) per sample, i.e. 6144 samples
				LAST_ADDR <= std_logic_vector(to_unsigned(6144-1, ADDR_LENGTH));;
			end if;
		end if;
	end process addr_proc;
	
	-- Combinatorial process to update current and previous samples
	samp_proc : process(i_samp_tick) is
	begin
		curr_sample <= i_inputs;
		prev_sample <= curr_sample;
	end process samp_proc;

	-- Sequential process to deal with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				-- reset logic
				r_state <= IDLE;
				r_raw_wr_en_pulse <= '0';
				r_raw_wr_addr <= (others => '0');
				r_raw_wr_data <= (others => '0');
				r_capture_done_pulse <= '0';
				r_trigger_address <= (others => '0');
			else
				r_state <= n_state;
				r_raw_wr_en_pulse <= n_raw_wr_en_pulse;
				r_raw_wr_addr <= n_raw_wr_addr;
				r_raw_wr_data <= n_raw_wr_data;
				r_capture_done_pulse <= n_capture_done_pulse;
				r_trigger_address <= n_trigger_address;
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
		n_trigger_address <= r_trigger_address;
		
		case r_state is   -- IDLE, LINEAR_CAPTURE, ARMED, POST_TRIGGER, DONE
			when IDLE =>
				if i_capture_start_pulse = '1' then
					-- trigger mode determines next state
					if i_cfg_trigger_mode = "00" then
						-- write first sample to address 0 (same as rev1)
						n_raw_wr_addr <= (others => '0');
						n_raw_wr_data <= i_inputs;
						n_raw_wr_en_pulse <= '1';
						
						n_state <= LINEAR_CAPTURE;
					else
						n_state <= ARMED;
					end if;			
				end if;
			
			when LINEAR_CAPTURE =>
				if i_samp_tick = '1' then
					n_raw_wr_data <= i_inputs;
					n_raw_wr_en_pulse <= '1';
					
					if r_raw_wr_addr = LAST_ADDR then
						-- Sample nr 4096 (index 4095) (or sample nr 12288 (index 12287)) just captured in last cycle
						n_capture_done_pulse <= '1';
						n_raw_wr_addr <= (others => '0');
						n_state <= IDLE;
					else
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
					end if;
				end if;
			
			when PREFILL =>
				-- PREFILL writes exactly pre_count samples before trigger evaluation is enabled. Guarantees pre-trigger history.
				-- pre_count  = samples strictly before trigger
				-- post_count = trigger sample + samples after trigger
			
			when ARMED =>
				-- fill up circular capture buffer (size is determined by LAST_ADDR which is determined by capture depth)				
				if i_samp_tick = '1' then
					n_raw_wr_data <= i_inputs;
					n_raw_wr_en_pulse <= '1';
					
					if r_raw_wr_addr = LAST_ADDR then
						n_raw_wr_addr <= (others => '0');
					else
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
					end if;
				end if;
				
				-- wait for trigger condition
				if i_cfg_trigger_mode = "01" then  -- edge trigger
					if i_cfg_edge_trigger_type = "00" then  -- rising_edge
						if prev_sample(unsigned(i_cfg_edge_trigger_ch)) = '0' and curr_sample(unsigned(i_cfg_edge_trigger_ch)) = '1' then
							n_trigger_address <= r_raw_wr_addr;  -- record trigger address
							n_state <= POST_TRIGGER;
						end if;
					elsif i_cfg_edge_trigger_type = "01" then  -- falling_edge
						if prev_sample(unsigned(i_cfg_edge_trigger_ch)) = '1' and curr_sample(unsigned(i_cfg_edge_trigger_ch)) = '0' then
							n_trigger_address <= r_raw_wr_addr;  -- record trigger address
							n_state <= POST_TRIGGER;
						end if;
					else  -- either
						if (prev_sample(unsigned(i_cfg_edge_trigger_ch)) = '0' and curr_sample(unsigned(i_cfg_edge_trigger_ch)) = '1') or
							(prev_sample(unsigned(i_cfg_edge_trigger_ch)) = '1' and curr_sample(unsigned(i_cfg_edge_trigger_ch)) = '0') then
							n_trigger_address <= r_raw_wr_addr;  -- record trigger address
							n_state <= POST_TRIGGER;
						end if;
					end if;
					
				elsif i_cfg_trigger_mode = "02" then  -- pattern trigger
					if (curr_sample & i_cfg_pattern_mask) = (i_cfg_pattern_value & i_cfg_pattern_mask) then
						n_trigger_address <= r_raw_wr_addr;  -- record trigger address
						n_state <= POST_TRIGGER;
					end if;
				else
					-- error
				end if;
				
				-- SHOULD A TIMEOUT FEATURE BE ADDED?
				
			
			when POST_TRIGGER =>
				-- perform capture (remember to factor in trigger position)
				if i_cfg_capture_depth_sel = "00" then  -- 4096 bytes
					if i_cfg_trigger_pos = "00" then		-- 25%
						-- 1024 bytes pre-trigger | trigger byte | 3071 bytes post
						if post_trigger_count = 3071 then
							n_state <= DONE;
						end if;
					elsif i_cfg_trigger_pos = "01" then		-- 50%
						-- 2048 bytes pre-trigger | trigger byte | 2047 bytes post
						if post_trigger_count = 2047 then
							n_state <= DONE;
						end if;
					else									-- 75%
						-- 3072 bytes pre-trigger | trigger byte | 1023 bytes post
						if post_trigger_count = 1023 then
							n_state <= DONE;
						end if;
					end if;
				else 									-- 12288 bytes
					if i_cfg_trigger_pos = "00" then		-- 25%
						-- 3072 bytes pre-trigger | trigger byte | 9215 bytes post
						if post_trigger_count = 9215 then
							n_state <= DONE;
						end if;
					elsif i_cfg_trigger_pos = "01" then		-- 50%
						-- 6144 bytes pre-trigger | trigger byte | 6143 bytes post
						if post_trigger_count = 6143 then
							n_state <= DONE;
						end if;
					else									-- 75%
						-- 9216 bytes pre-trigger | trigger byte | 3071 bytes post
						if post_trigger_count = 3071 then
							n_state <= DONE;
						end if;
					end if;
				end if;
					
				
				if i_samp_tick = '1' then
					n_raw_wr_data <= i_inputs;
					n_raw_wr_en_pulse <= '1';
					
					if r_raw_wr_addr = LAST_ADDR then
						n_raw_wr_addr <= (others => '0');
					else
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
						post_trigger_count <= post_trigger_count + 1;
					end if;
				end if;
				
				-- if all post bytes are stored, then: n_state <= DONE;
			
			when DONE =>
				-- ... might have to sort last sample
				n_state <= IDLE;
			
		end case;
	end process fsm_proc;


	-- Set outputs
	o_raw_wr_en_pulse <= r_raw_wr_en_pulse;
	o_raw_wr_addr <= r_raw_wr_addr;
	o_raw_wr_data <= r_raw_wr_data;
	o_capture_done_pulse <= r_capture_done_pulse;
	
end architecture RTL;
