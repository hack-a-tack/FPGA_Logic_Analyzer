-- ========================================
-- MODULE: capture_engine.vhd
-- FUNCTION: samples logic analyzer inputs at i_clk and writes to BRAM
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-31 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-07-29 (rev2)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_samp_tick				1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_capture_start_pulse	1 bit		<- analyzer_fsm
-- i_inputs					16 bits		<- top
--- CONFIG REGISTER VALUES
-- i_cfg_capture_width_sel	1 bit		<- config_regs
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
-- o_capture_start_addr 	14 bits		-> send_engine
-- o_trigger_addr       	14 bits		-> send_engine
--
-- NOTES
-- Linear capture in rev1 wrote the first sample in IDLE state. This no longer applies here in rev2.
--
-- PREFIXES:
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- outputs that should be added: captured metadata such as capture width, depth, trigger position. Do not let send_engine use live configuration registers to describe an older capture
-- Later, add an explicit ABORT command or optional host-configured trigger timeout. Do not treat “trigger has not happened” as an internal watchdog fault.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity capture_engine is
	generic (
		ADDR_LENGTH : integer := 14;
		NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 16,384. 12,288 will be used if deep capture depth and 8 bit depth are chosen
		DATA_LENGTH : integer := 16
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
		o_capture_done_pulse	: out std_logic;
		
		o_capture_start_addr 	: out std_logic_vector(13 downto 0);  -- needed for chronological readout
		o_trigger_addr       	: out std_logic_vector(13 downto 0)
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
	
	signal r_capture_width_sel, n_capture_width_sel : std_logic := '0';  	-- default: narrow (8 bits)
	signal r_capture_depth_sel, n_capture_depth_sel : std_logic := '0';  	-- default: shallow (4096 bytes)
	signal r_trigger_mode, n_trigger_mode : std_logic_vector(1 downto 0) := "00"; 	-- default: immediate capture
	signal r_edge_trigger_ch, n_edge_trigger_ch : std_logic_vector(3 downto 0) := "0000";		-- default: channel 0
	signal r_edge_trigger_type, n_edge_trigger_type : std_logic_vector(1 downto 0) := "00";		-- default: rising edge
	signal r_pattern_value, n_pattern_value : std_logic_vector(15 downto 0) := x"0000";		-- default: 0b0000 0000 0000 0000
	signal r_pattern_mask, n_pattern_mask : std_logic_vector(15 downto 0) := x"FFFF";		-- default: 0b1111 1111 1111 1111
	signal r_trigger_pos, n_trigger_pos : std_logic_vector(1 downto 0) := "00"; 			-- default: 25% pre / 75% post trigger
	
	--------------- TBC
	
	signal r_last_addr, n_last_address : std_logic_vector(ADDR_LENGTH-1 downto 0) := std_logic_vector(to_unsigned(12288-1, ADDR_LENGTH));  -- last address to fill in RAM before returning to addr 0
	signal r_trigger_address, n_trigger_address : std_logic_vector(13 downto 0) := (others => '0');  -- address where trigger occurs
	
	signal r_total_count : integer range 0 to 12287 := 0;
	signal r_pre_count : integer range 0 to 12287 := 0;
	signal r_post_count : integer range 0 to 12287 := 0;
	
	signal r_total_samples : integer := 0;
	signal r_pre_samples : integer := 0; 		-- samples strictly before trigger
	signal r_post_samples : integer := 0;		-- trigger sample + samples after trigger
	
	-- separate counters == easier to verify logic
	r_write_ptr
	r_linear_sample_count
	r_prefill_count
	r_post_remaining
	r_prev_sample
	signal r_start_addr : std_logic_vector(13 downto 0) := (others => '0');
	r_trigger_addr
	
	signal r_prev_sample : std_logic_vector(15 downto 0) := (others => '0');
	
		
begin
	addr_proc : process(i_cfg_capture_depth_sel, i_cfg_capture_width_sel) is
	begin
		if i_cfg_capture_depth_sel = '0' then		-- shallow capture (4096 bytes)
			if i_cfg_capture_width_sel = '0' then  	-- 1 byte (8 bits) per sample, i.e. 4096 samples
				r_last_addr <= std_logic_vector(to_unsigned(4096-1, ADDR_LENGTH));;
			else									-- 2 bytes (16 bits) per sample, i.e. 2048 samples
				r_last_addr <= std_logic_vector(to_unsigned(2048-1, ADDR_LENGTH));;
			end if;
		else										-- deep capture (12288 bytes)
			if i_cfg_capture_width_sel = '0' then  	-- 1 byte (8 bits) per sample, i.e. 12288 samples
				r_last_addr <= std_logic_vector(to_unsigned(12288-1, ADDR_LENGTH));;
			else									-- 2 bytes (16 bits) per sample, i.e. 6144 samples
				r_last_addr <= std_logic_vector(to_unsigned(6144-1, ADDR_LENGTH));;
			end if;
		end if;
	end process addr_proc;
	
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
				
				r_capture_width_sel <= '0';
				r_capture_depth_sel <= '0';
				r_trigger_mode <= "00";
				r_edge_trigger_ch <= "0000";
				r_edge_trigger_type <= "00";
				r_pattern_value <= x"0000";
				r_pattern_mask <= x"FFFF";
				r_trigger_pos <= "00";
			else
				r_state <= n_state;
				r_raw_wr_en_pulse <= n_raw_wr_en_pulse;
				r_raw_wr_addr <= n_raw_wr_addr;
				r_raw_wr_data <= n_raw_wr_data;
				r_capture_done_pulse <= n_capture_done_pulse;
				
				r_capture_width_sel <= n_capture_width_sel;
				r_capture_depth_sel <= n_capture_depth_sel;
				r_trigger_mode <= n_trigger_mode;
				r_edge_trigger_ch <= n_edge_trigger_ch;
				r_edge_trigger_type <= n_edge_trigger_type;
				r_pattern_value <= n_pattern_value;
				r_pattern_mask <= n_pattern_mask;
				r_trigger_pos <= n_trigger_pos;
	
				
				
				-- TO BE CHANGED:
				if i_samp_tick = '1' then
					r_prev_sample <= i_inputs;
				end if;
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
		
		case r_state is   -- IDLE, LINEAR_CAPTURE, ARMED, POST_TRIGGER, DONE
			when IDLE =>
				if i_capture_start_pulse = '1' then
					-- latch all relevant configuration values
					n_capture_width_sel <= i_cfg_capture_width_sel;
					n_capture_depth_sel <= i_cfg_capture_depth_sel;
					n_trigger_mode		<= i_cfg_trigger_mode;
					if i_cfg_capture_width_sel = '0' then
						if i_cfg_edge_trigger_ch >= "1000" then
							-- REJECT! cannot use channels 8-15 as edge trigger for 8 channel capture (ch0-ch7)
						else
							n_edge_trigger_ch	<= i_cfg_edge_trigger_ch;
						end if;
					else
						n_edge_trigger_ch	<= i_cfg_edge_trigger_ch;
					end if;
					n_edge_trigger_type <= i_cfg_edge_trigger_type;
					n_pattern_value		<= i_cfg_pattern_value;
					if i_cfg_capture_width_sel = '0' then
						n_pattern_mask 	<= x"00" & i_cfg_pattern_mask(7 downto 0);
					else
						n_pattern_mask	<= i_cfg_pattern_mask;
					end if;
					n_trigger_pos		<= i_cfg_trigger_pos;
					
					
					-- calculate total/pre/post sample counts
					if i_cfg_capture_depth_sel = '0' then		-- shallow capture (4096 bytes)
						if i_cfg_capture_width_sel = '0' then  	-- 1 byte (8 bits) per sample, i.e. 4096 samples
							r_total_samples <= 4096;
							case i_cfg_trigger_pos is
								when "00" =>  	-- 25% trigger pos
									r_pre_samples <= 1024;
									r_post_samples <= 3072;
								when "01" =>	-- 50% trigger pos
									r_pre_samples <= 2048;
									r_post_samples <= 2048;
								when others =>	-- 75% trigger pos
									r_pre_samples <= 3072;
									r_post_samples <= 1024;
							end case;
						else									-- 2 bytes (16 bits) per sample, i.e. 2048 samples
							r_total_samples <= 2048;
							case i_cfg_trigger_pos is
								when "00" =>  	-- 25% trigger pos
									r_pre_samples <= 512;
									r_post_samples <= 1536;
								when "01" =>	-- 50% trigger pos
									r_pre_samples <= 1024;
									r_post_samples <= 1024;
								when others =>	-- 75% trigger pos
									r_pre_samples <= 1536;
									r_post_samples <= 512;
							end case;
						end if;
					else										-- deep capture (12288 bytes)
						if i_cfg_capture_width_sel = '0' then  	-- 1 byte (8 bits) per sample, i.e. 12288 samples
							r_total_samples <= 12288;
							case i_cfg_trigger_pos is
								when "00" =>  	-- 25% trigger pos
									r_pre_samples <= 3072;
									r_post_samples <= 9216;
								when "01" =>	-- 50% trigger pos
									r_pre_samples <= 6144;
									r_post_samples <= 6144;
								when others =>	-- 75% trigger pos
									r_pre_samples <= 9216;
									r_post_samples <= 3072;
							end case;
						else									-- 2 bytes (16 bits) per sample, i.e. 6144 samples
							r_total_samples <= 6144;
							case i_cfg_trigger_pos is
								when "00" =>  	-- 25% trigger pos
									r_pre_samples <= 1536;
									r_post_samples <= 4608;
								when "01" =>	-- 50% trigger pos
									r_pre_samples <= 3072;
									r_post_samples <= 3072;
								when others =>	-- 75% trigger pos
									r_pre_samples <= 4608;
									r_post_samples <= 1536;
							end case;
						end if;
					end if;
					
					-- set write "pointer" to zero
					n_raw_wr_addr <= (others => '0');
					
					-- trigger mode determines next state
					if i_cfg_trigger_mode = "00" then
						n_state <= LINEAR_CAPTURE;
					else
						n_state <= PREFILL;
					end if;			
				end if;
			
			when LINEAR_CAPTURE =>
				if i_samp_tick = '1' then
					n_raw_wr_data <= i_inputs;
					n_raw_wr_en_pulse <= '1';
					r_total_count <= r_total_count + 1;  -- MIGHT HAVE TO CHANGE TO n_ and r_ prefixes...
					
					if r_raw_wr_addr = r_total_samples then
						-- Sample nr 4096 (index 4095) (or sample nr 12288 (index 12287) etc.) just captured in last cycle
						n_raw_wr_addr <= (others => '0');
						n_state <= DONE;
					else
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
						-- WON'T THE ABOVE LINE MAKE IT SO THAT WE WRITE FIRST SAMPLE TO ADDRESS 1 INSTEAD OF 0?
					end if;
				end if;
			
			when PREFILL =>
				-- PREFILL writes exactly pre_count samples before trigger evaluation is enabled. Guarantees pre-trigger history.
				if i_samp_tick = '1' then
					n_raw_wr_data <= i_inputs;
					n_raw_wr_en_pulse <= '1';
					r_pre_count <= r_pre_count + 1;  -- MIGHT HAVE TO CHANGE TO n_ and r_ prefixes...
					r_prev_sample <= i_inputs;
					
					if r_raw_wr_addr = r_pre_samples then
						n_state <= ARMED;
					else
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
					end if;
				end if;
			
			when ARMED =>
				if i_samp_tick = '1' then
					-- write current sample				
					n_raw_wr_data <= i_inputs;
					n_raw_wr_en_pulse <= '1';
					
					-- evaluate trigger condition
					if r_trigger_mode = "01" then  -- edge trigger
						if r_edge_trigger_type = "00" then  -- rising_edge
							if r_prev_sample(to_integer(unsigned(r_edge_trigger_ch))) = '0' and i_inputs(to_integer(unsigned(r_edge_trigger_ch))) = '1' then
								n_trigger_address <= r_raw_wr_addr;  -- record trigger address
								r_post_count <= r_post_count + 1;  -- trigger address is first post trigger value
								n_state <= POST_TRIGGER;
							end if;
						elsif r_edge_trigger_type = "01" then  -- falling_edge
							if r_prev_sample(to_integer(unsigned(r_edge_trigger_ch))) = '1' and i_inputs(to_integer(unsigned(r_edge_trigger_ch))) = '0' then
								n_trigger_address <= r_raw_wr_addr;  -- record trigger address
								r_post_count <= r_post_count + 1;  -- trigger address is first post trigger value
								n_state <= POST_TRIGGER;
							end if;
						else  -- either
							if (r_prev_sample(to_integer((unsigned(r_edge_trigger_ch))) = '0' and i_inputs(to_integer(unsigned(r_edge_trigger_ch))) = '1') or
								(r_prev_sample(to_integer(unsigned(r_edge_trigger_ch))) = '1' and i_inputs(to_integer(unsigned(r_edge_trigger_ch))) = '0') then
								n_trigger_address <= r_raw_wr_addr;  -- record trigger address
								r_post_count <= r_post_count + 1;  -- trigger address is first post trigger value
								n_state <= POST_TRIGGER;
							end if;
						end if;
					elsif r_trigger_mode = "02" then  -- pattern trigger
						if (i_inputs and r_pattern_mask) = (r_pattern_value and r_pattern_mask) then
							n_trigger_address <= r_raw_wr_addr;  -- record trigger address
							r_post_count <= r_post_count + 1;  -- trigger address is first post trigger value
							n_state <= POST_TRIGGER;
						end if;
					else
						-- error
					end if;
					
					-- update previous sample
					r_prev_sample <= i_inputs;
					
					-- advance address pointer
					if r_raw_wr_addr = r_last_addr then
						n_raw_wr_addr <= (others => '0');
					else
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
					end if;
				end if;
			
			when POST_TRIGGER =>
				if i_samp_tick = '1' then
					-- write next sample
					n_raw_wr_data <= i_inputs;
					n_raw_wr_en_pulse <= '1';
					
					-- decrement post_remaining / increment post_count
					r_post_count <= r_post_count + 1;
					
					-- increment address pointer
					if r_post_count = r_post_samples then
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
						r_start_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
						n_state <= DONE;
					elsif r_raw_wr_addr = r_last_addr then
						n_raw_wr_addr <= (others => '0');
						r_post_count <= r_post_count + 1;
					else
						n_raw_wr_addr <= std_logic_vector(unsigned(r_raw_wr_addr)+1);
						r_post_count <= r_post_count + 1;
					end if;
				end if;
				
				-- if all post bytes are stored, then: n_state <= DONE;
			
			when DONE =>
				n_capture_done_pulse <= '1';
				n_state <= IDLE;
			
		end case;
	end process fsm_proc;


	-- Set outputs
	o_raw_wr_en_pulse 		<= r_raw_wr_en_pulse;
	o_raw_wr_addr 			<= r_raw_wr_addr;
	o_raw_wr_data 			<= r_raw_wr_data;
	o_capture_done_pulse	<= r_capture_done_pulse;
	
	o_capture_start_addr 	<= r_start_addr;
	o_trigger_addr       	<= r_trigger_addr;
	
end architecture RTL;
