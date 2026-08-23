-- ========================================
-- MODULE: capture_engine.vhd
-- FUNCTION: samples logic analyzer inputs at i_clk and writes to BRAM
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-31 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-08-03 (rev2)
-- MODIFIED: 2026-08-18 (rev2) (fixed illegal unsigned(x"FFFF") type conversion on n_trigger_index; GHDL rejects a bare bit-string literal as a conversion operand, Synplify silently accepted it)
-- MODIFIED: 2026-08-20 (rev2) (added a 2FF synchroniser on i_inputs; the write data, n_prev_sample, the edge comparison and the pattern compare all now read the synchronised value instead of the raw async port)
-- MODIFIED: 2026-08-20 (rev2) (r_pre_samples/r_post_samples/r_prefill_count/r_post_remaining were bare unconstrained integers, which Synplify synthesized as full 32-bit counters/comparators; constrained to their real maximum, 9216. r_prefill_count owned the worst critical path in P&R timing)
-- MODIFIED: 2026-08-21 (rev2) (r_prefill_count replaced with a down-counter r_prefill_remaining, latched from r_pre_samples per branch in IDLE and tested against 1, mirroring r_post_remaining's existing pattern -- PREFILL was comparing r_prefill_count against a live r_pre_samples-1 subtraction every cycle, which owned the residual critical path once the counter width itself was fixed)
-- MODIFIED: 2026-08-21 (rev2) (ARMED's edge-trigger detection reworked: r_prev_sample (16-bit, muxed by r_edge_trigger_ch inline in each of 3 edge-type branches) replaced with r_trig_ch_prev (1-bit register, exact same value/timing) and s_trig_ch_cur (1-bit, computed once instead of 3x inline). This removed a whole second 16-way mux that sat in series with r_edge_trigger_type/r_state and fed r_post_remaining's clock enable -- values and timing are unchanged, only how the same bits are obtained)
-- MODIFIED: 2026-08-23 (rev2) (reverted a same-day attempt to also decouple r_state/r_edge_trigger_type from r_post_remaining's enable via a dedicated r_in_post_trigger flag and registered edge-type flags -- both were provably equivalent in value/timing, but Synplify's optimizer fused the new registers into the SAME serial chain rather than parallelising them, measurably worsening Fmax/WNS. Back to the r_trig_ch_prev/s_trig_ch_cur-only state, which measured better. See TOP_TODO.md.)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_samp_tick				1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_capture_start_pulse	1 bit		<- analyzer_fsm
-- i_inputs					16 bits		<- top
--- CONFIG REGISTER VALUES
-- i_cfg_sample_rate_sel	2 bits		<- config_regs
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
-- o_raw_wr_data			16 bits		-> trace_buffer
-- o_capture_done_pulse		1 bit		-> analyzer_fsm
-- o_capture_sample_rate_sel	2 bits	-> send_engine
-- o_capture_trigger_mode		2 bits	-> send_engine
-- o_capture_trigger_index		16 bits	-> send_engine
-- o_capture_start_addr 	14 bits		-> send_engine
-- o_capture_sample_count	14 bits		-> send_engine
-- o_capture_width_sel		1 bit		-> send_engine, trace_buffer
--
-- NOTES
-- i_inputs is asynchronous to i_clk (16 logic analyzer pins, no relationship to the FPGA clock). sync_proc
-- synchronises all 16 bits together into r_inputs_sync_2 before any use, so the write data, s_trig_ch_cur/
-- r_trig_ch_prev, the edge comparison and the pattern compare all see the same resolved value -- a bit that
-- resolved differently across those consumers would produce a spurious trigger, indistinguishable from a
-- real event once captured.
-- This adds 2 clocks of latency uniformly across all 16 channels, so there is no relative skew between channels
-- and no effect on measured signal periods.
--
-- PREFIXES:
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- v_ : variable

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- Later, add an explicit ABORT command or optional host-configured trigger timeout. Do not treat “trigger has not happened” as an internal watchdog fault.
-- In IDLE, we have 2 comments about REJECTION of certain config values (relative to other config vals). For now, assume the configuration is valid and add assertions in simulation. Later, the controller/analyzer FSM should reject CAPTURE and send an error. --> Reject incompatible configurations before accepting CAPTURE
-- Export more captured metadata
-- Verify every mode with a dedicated testbench
-- Implement actual 8/16-bit RAM-bank mapping in trace_buffer
-- 2026-08-23: tried decoupling r_post_remaining's clock enable from r_state/r_edge_trigger_type via a
--   dedicated r_in_post_trigger flag and registered edge-type flags (rising/falling/either). Logically
--   proven equivalent (traced), but measured WORSE on P&R (Fmax dropped, WNS roughly doubled) because
--   Synplify's optimizer fused the new registers into the same serial chain instead of parallelising them
--   away from r_state's decode. Reverted. Lesson: "a register can't be flattened away" is true of the
--   register's existence, but says nothing about whether the tool will place its read in series or
--   parallel with everything else feeding the same destination -- that's still entirely up to the
--   optimizer, and isn't something the RTL's structure can force. Don't retry this exact approach without
--   a different lever (e.g. actual floorplanning/placement constraints, not just RTL restructuring).
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity capture_engine is
	generic (
		ADDR_LENGTH : integer := 14
	);
	port (
		i_clk					: in  std_logic;
		i_samp_tick				: in  std_logic;
		i_rst_n					: in  std_logic;
		i_capture_start_pulse	: in  std_logic;
		i_inputs				: in  std_logic_vector(15 downto 0);  -- 16 bits at compile time. during runtime host can choose first 8 bits

		i_cfg_sample_rate_sel	: in  std_logic_vector(1 downto 0);
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

		-- to send_engine
		o_capture_sample_rate_sel	: out std_logic_vector(1 downto 0);
		o_capture_trigger_mode		: out std_logic_vector(1 downto 0);
		o_capture_trigger_index		: out std_logic_vector(15 downto 0);			-- 0xFFFF for immediate capture
		o_capture_start_addr 	: out std_logic_vector(ADDR_LENGTH-1 downto 0);  	-- needed for chronological readout
		o_capture_sample_count	: out std_logic_vector(ADDR_LENGTH-1 downto 0);
		o_capture_width_sel		: out std_logic
	);
end entity capture_engine;

architecture RTL of capture_engine is
	-- Internal capture_engine state machine
	type capture_engine_state_type is (IDLE, LINEAR_CAPTURE, PREFILL, ARMED, POST_TRIGGER, DONE);

	-- Register signals, next-state signals
	signal r_state, n_state : capture_engine_state_type := IDLE;
	signal r_capture_done_pulse, n_capture_done_pulse : std_logic := '0';

	-- Latched config values
	signal r_sample_rate_sel, n_sample_rate_sel : std_logic_vector(1 downto 0) := "00";		-- default: 24MS/s
	signal r_capture_width_sel, n_capture_width_sel : std_logic := '0';  	-- default: narrow (8 bits)
	signal r_capture_depth_sel, n_capture_depth_sel : std_logic := '0';  	-- default: shallow (4096 bytes)
	signal r_trigger_mode, n_trigger_mode : std_logic_vector(1 downto 0) := "00"; 	-- default: immediate capture
	signal r_edge_trigger_ch, n_edge_trigger_ch : std_logic_vector(3 downto 0) := "0000";		-- default: channel 0
	signal r_edge_trigger_type, n_edge_trigger_type : std_logic_vector(1 downto 0) := "00";		-- default: rising edge
	signal r_pattern_value, n_pattern_value : std_logic_vector(15 downto 0) := x"0000";		-- default: 0b0000 0000 0000 0000
	signal r_pattern_mask, n_pattern_mask : std_logic_vector(15 downto 0) := x"FFFF";		-- default: 0b1111 1111 1111 1111
	signal r_trigger_pos, n_trigger_pos : std_logic_vector(1 downto 0) := "00"; 			-- default: 25% pre / 75% post trigger

	signal r_trigger_index, n_trigger_index : unsigned(15 downto 0) := (others => '0');  -- 0xFFFF for immediate capture
	signal r_start_addr, n_start_addr : unsigned(ADDR_LENGTH-1 downto 0) := (others => '0');  -- addr sent to send_engine to start reading from RAM
	signal r_last_addr, n_last_addr : unsigned(ADDR_LENGTH-1 downto 0) := to_unsigned(12288-1, ADDR_LENGTH);  -- how many addresses to fill in RAM (not actual end address)

	signal r_write_ptr, n_write_ptr : unsigned(ADDR_LENGTH-1 downto 0);
	-- Edge trigger detection reads only the one channel r_edge_trigger_ch selects. r_trig_ch_prev is that
	-- bit, registered once per sample tick (replaces muxing a full-width r_prev_sample by r_edge_trigger_ch
	-- at compare time); s_trig_ch_cur is the same channel's live bit, computed once as its own signal
	-- instead of being re-muxed inline in each of the three edge-type branches below. Together these removed
	-- a whole second 16-way mux (r_prev_sample's) from ARMED's trigger logic, which previously sat in series
	-- with r_edge_trigger_type/r_state and fed straight into r_post_remaining's clock enable -- the worst
	-- residual P&R critical path once the counters themselves were fixed. Values and timing are unchanged
	-- from the old r_prev_sample(ch)/r_inputs_sync_2(ch) reads -- same source, same gating, same cycle.
	signal r_trig_ch_prev, n_trig_ch_prev : std_logic := '0';
	signal s_trig_ch_cur : std_logic;
	-- 9216 is the true maximum across all depth/width/trigger_pos combinations (deep capture, 8-bit width,
	-- 75%/25% trigger pos: 12288 samples * 0.75 = 9216). All four counters below share that same bound
	-- since prefill_remaining mirrors pre_samples and post_remaining mirrors post_samples.
	signal r_pre_samples, n_pre_samples : integer range 0 to 9216 := 0; 		-- samples strictly before trigger
	signal r_post_samples, n_post_samples : integer range 0 to 9216 := 0;		-- trigger sample + samples after trigger
	signal r_prefill_remaining, n_prefill_remaining : integer range 0 to 9216 := 0;	-- samples left to prefill, including the one in flight; counts down from r_pre_samples, mirrors r_post_remaining's pattern
	signal r_post_remaining, n_post_remaining : integer range 0 to 9216 := 0;

	-- Registered signals for 2FF synchroniser on i_inputs
	signal r_inputs_sync_1 : std_logic_vector(15 downto 0) := (others => '0');
	signal r_inputs_sync_2 : std_logic_vector(15 downto 0) := (others => '0');

begin
	-- Sequential process to deal with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				-- reset logic
				r_state <= IDLE;
				r_capture_done_pulse <= '0';

				r_sample_rate_sel <= "00";
				r_capture_width_sel <= '0';
				r_capture_depth_sel <= '0';
				r_trigger_mode <= "00";
				r_edge_trigger_ch <= "0000";
				r_edge_trigger_type <= "00";
				r_pattern_value <= x"0000";
				r_pattern_mask <= x"FFFF";
				r_trigger_pos <= "00";

				r_trigger_index <= (others => '0');
				r_start_addr <= (others => '0');
				r_last_addr <= (others => '0');

				r_write_ptr <= (others => '0');
				r_trig_ch_prev <= '0';
				r_pre_samples <= 0;
				r_post_samples <= 0;
				r_prefill_remaining <= 0;
				r_post_remaining <= 0;
			else
				r_state <= n_state;
				r_capture_done_pulse <= n_capture_done_pulse;

				r_sample_rate_sel <= n_sample_rate_sel;
				r_capture_width_sel <= n_capture_width_sel;
				r_capture_depth_sel <= n_capture_depth_sel;
				r_trigger_mode <= n_trigger_mode;
				r_edge_trigger_ch <= n_edge_trigger_ch;
				r_edge_trigger_type <= n_edge_trigger_type;
				r_pattern_value <= n_pattern_value;
				r_pattern_mask <= n_pattern_mask;
				r_trigger_pos <= n_trigger_pos;

				r_trigger_index <= n_trigger_index;
				r_start_addr <= n_start_addr;
				r_last_addr <= n_last_addr;

				r_write_ptr <= n_write_ptr;
				r_trig_ch_prev <= n_trig_ch_prev;
				r_pre_samples <= n_pre_samples;
				r_post_samples <= n_post_samples;
				r_prefill_remaining <= n_prefill_remaining;
				r_post_remaining <= n_post_remaining;
			end if;
		end if;
	end process seq_proc;

	-- 2FF synchroniser on i_inputs. Free-runs every clock, NOT gated by i_samp_tick -- gating it would defeat the
	-- purpose, since a synchroniser has to resolve metastability on every clock edge, not just the edges the FSM
	-- happens to be sampling on.
	sync_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_inputs_sync_1 <= (others => '0');
				r_inputs_sync_2 <= (others => '0');
			else
				r_inputs_sync_1 <= i_inputs;
				r_inputs_sync_2 <= r_inputs_sync_1;
			end if;
		end if;
	end process sync_proc;

	-- Combinational process to deal with capture engine FSM logic
	fsm_proc: process(all) is
		variable v_next_ptr : unsigned(ADDR_LENGTH-1 downto 0);
	begin
		-- Defaults
		n_state <= r_state;
		n_capture_done_pulse <= '0';

		n_sample_rate_sel <= r_sample_rate_sel;
		n_capture_width_sel <= r_capture_width_sel;
		n_capture_depth_sel <= r_capture_depth_sel;
		n_trigger_mode <= r_trigger_mode;
		n_edge_trigger_ch <= r_edge_trigger_ch;
		n_edge_trigger_type <= r_edge_trigger_type;
		n_pattern_value <= r_pattern_value;
		n_pattern_mask <= r_pattern_mask;
		n_trigger_pos <= r_trigger_pos;

		n_trigger_index <= r_trigger_index;
		n_start_addr <= r_start_addr;
		n_last_addr <= r_last_addr;

		n_write_ptr <= r_write_ptr;
		n_trig_ch_prev <= r_trig_ch_prev;
		n_pre_samples <= r_pre_samples;
		n_post_samples <= r_post_samples;
		n_prefill_remaining <= r_prefill_remaining;
		n_post_remaining <= r_post_remaining;


		-- wraparound logic for write_ptr
		if r_write_ptr = r_last_addr then
			v_next_ptr := (others => '0');
		else
			v_next_ptr := r_write_ptr + 1;
		end if;


		case r_state is   -- IDLE, LINEAR_CAPTURE, ARMED, POST_TRIGGER, DONE
			when IDLE =>
				if i_capture_start_pulse = '1' then
					-- reset per-capture runtime state
					n_write_ptr      <= (others => '0');
					n_start_addr     <= (others => '0');
					n_trigger_index  <= x"FFFF";  -- 0xFFFF as trigger index for linear capture. Gets changed if FSM reaches ARMED state
					n_trig_ch_prev   <= '0';

					-- latch all relevant configuration values
					n_sample_rate_sel 	<= i_cfg_sample_rate_sel;
					n_capture_width_sel <= i_cfg_capture_width_sel;
					n_capture_depth_sel <= i_cfg_capture_depth_sel;
					n_trigger_mode		<= i_cfg_trigger_mode;
					if i_cfg_capture_width_sel = '0' then
						if i_cfg_edge_trigger_ch(3) = '1' then  -- i.e. >= 1000 (8)
							-- REJECT! cannot use channels 8-15 as edge trigger for 8 channel capture (ch0-ch7)
							-- default value "0000" will be kept
						else
							n_edge_trigger_ch	<= i_cfg_edge_trigger_ch;
						end if;
					else
						n_edge_trigger_ch	<= i_cfg_edge_trigger_ch;
					end if;
					n_edge_trigger_type <= i_cfg_edge_trigger_type;
					n_pattern_value		<= i_cfg_pattern_value;
					if i_cfg_capture_width_sel = '0' and i_cfg_pattern_mask(7 downto 0) = x"00" then
						-- REJECT! cannot use pattern mask 0 as any pattern would lead to trigger
					elsif i_cfg_capture_width_sel = '0' and i_cfg_pattern_mask(7 downto 0) /= x"00" then
						n_pattern_mask 	<= x"00" & i_cfg_pattern_mask(7 downto 0);
					else
						n_pattern_mask	<= i_cfg_pattern_mask;
					end if;
					n_trigger_pos		<= i_cfg_trigger_pos;

					-- set last addr (how many addresses to fill up in RAM), and pre/post samples given trigger pos
					if i_cfg_capture_depth_sel = '0' then		-- shallow capture (4096 bytes)
						if i_cfg_capture_width_sel = '0' then  	-- 1 byte (8 bits) per sample, i.e. 4096 samples
							n_last_addr <= to_unsigned(4095, ADDR_LENGTH);  -- 4096 samples, index one less
							case i_cfg_trigger_pos is
								when "00" =>  	-- 25% trigger pos
									n_pre_samples <= 1024;
									n_prefill_remaining <= 1024;
									n_post_samples <= 3072;
									n_post_remaining <= 3072;
								when "01" =>	-- 50% trigger pos
									n_pre_samples <= 2048;
									n_prefill_remaining <= 2048;
									n_post_samples <= 2048;
									n_post_remaining <= 2048;
								when others =>	-- 75% trigger pos
									n_pre_samples <= 3072;
									n_prefill_remaining <= 3072;
									n_post_samples <= 1024;
									n_post_remaining <= 1024;
							end case;
						else									-- 2 bytes (16 bits) per sample, i.e. 2048 samples
							n_last_addr <= to_unsigned(2047, ADDR_LENGTH);  -- 2048 samples, index one less
							case i_cfg_trigger_pos is
								when "00" =>  	-- 25% trigger pos
									n_pre_samples <= 512;
									n_prefill_remaining <= 512;
									n_post_samples <= 1536;
									n_post_remaining <= 1536;
								when "01" =>	-- 50% trigger pos
									n_pre_samples <= 1024;
									n_prefill_remaining <= 1024;
									n_post_samples <= 1024;
									n_post_remaining <= 1024;
								when others =>	-- 75% trigger pos
									n_pre_samples <= 1536;
									n_prefill_remaining <= 1536;
									n_post_samples <= 512;
									n_post_remaining <= 512;
							end case;
						end if;
					else										-- deep capture (12288 bytes)
						if i_cfg_capture_width_sel = '0' then  	-- 1 byte (8 bits) per sample, i.e. 12288 samples
							n_last_addr <= to_unsigned(12287, ADDR_LENGTH);  -- 12288 samples, index one less
							case i_cfg_trigger_pos is
								when "00" =>  	-- 25% trigger pos
									n_pre_samples <= 3072;
									n_prefill_remaining <= 3072;
									n_post_samples <= 9216;
									n_post_remaining <= 9216;
								when "01" =>	-- 50% trigger pos
									n_pre_samples <= 6144;
									n_prefill_remaining <= 6144;
									n_post_samples <= 6144;
									n_post_remaining <= 6144;
								when others =>	-- 75% trigger pos
									n_pre_samples <= 9216;
									n_prefill_remaining <= 9216;
									n_post_samples <= 3072;
									n_post_remaining <= 3072;
							end case;
						else									-- 2 bytes (16 bits) per sample, i.e. 6144 samples
							n_last_addr <= to_unsigned(6143, ADDR_LENGTH);  -- 6144 samples, index one less
							case i_cfg_trigger_pos is
								when "00" =>  	-- 25% trigger pos
									n_pre_samples <= 1536;
									n_prefill_remaining <= 1536;
									n_post_samples <= 4608;
									n_post_remaining <= 4608;
								when "01" =>	-- 50% trigger pos
									n_pre_samples <= 3072;
									n_prefill_remaining <= 3072;
									n_post_samples <= 3072;
									n_post_remaining <= 3072;
								when others =>	-- 75% trigger pos
									n_pre_samples <= 4608;
									n_prefill_remaining <= 4608;
									n_post_samples <= 1536;
									n_post_remaining <= 1536;
							end case;
						end if;
					end if;

					-- set write "pointer" to zero
					n_write_ptr <= (others => '0');

					-- trigger mode determines next state
					if i_cfg_trigger_mode = "00" then
						n_state <= LINEAR_CAPTURE;
					else
						n_state <= PREFILL;
					end if;
				end if;


			when LINEAR_CAPTURE =>
				if i_samp_tick = '1' then
					n_write_ptr <= v_next_ptr;

					if r_write_ptr = r_last_addr then
						-- Sample nr 4096 (index 4095) (or similar) just captured in last cycle
						n_start_addr <= (others => '0');  -- send_engine starts at addr 0 for linear captures
						n_state <= DONE;
					end if;
					-- write_ptr is updated outside the FSM so no need to increment manually
				end if;


			when PREFILL =>
				-- PREFILL writes exactly n_pre_samples before trigger evaluation is enabled. Guarantees pre-trigger history.
				if i_samp_tick = '1' then
					n_write_ptr <= v_next_ptr;
					n_trig_ch_prev <= s_trig_ch_cur;

					-- move to ARMED state once enough samples are gathered
					if r_prefill_remaining = 1 then
						n_state <= ARMED;
					else
						n_prefill_remaining <= r_prefill_remaining - 1;
					end if;
				end if;


			when ARMED =>
				if i_samp_tick = '1' then
					n_write_ptr <= v_next_ptr;
					n_trig_ch_prev <= s_trig_ch_cur;

					-- evaluate trigger condition
					if r_trigger_mode = "01" then  -- edge trigger
						if r_edge_trigger_type = "00" then  -- rising_edge
							if r_trig_ch_prev = '0' and s_trig_ch_cur = '1' then
								n_trigger_index <= to_unsigned(r_pre_samples, 16);  -- trigger occurs at index r_pre_samples
								n_post_remaining <= r_post_remaining - 1;  -- trigger address (at index r_pre_samples) is first post trigger value
								n_state <= POST_TRIGGER;
							end if;
						elsif r_edge_trigger_type = "01" then  -- falling_edge
							if r_trig_ch_prev = '1' and s_trig_ch_cur = '0' then
								n_trigger_index <= to_unsigned(r_pre_samples, 16);
								n_post_remaining <= r_post_remaining - 1;  -- trigger address is first post trigger value
								n_state <= POST_TRIGGER;
							end if;
						else  -- either
							if r_trig_ch_prev /= s_trig_ch_cur then
								n_trigger_index <= to_unsigned(r_pre_samples, 16);
								n_post_remaining <= r_post_remaining - 1;  -- trigger address is first post trigger value
								n_state <= POST_TRIGGER;
							end if;
						end if;
					elsif r_trigger_mode = "10" then  -- pattern trigger
						if (r_inputs_sync_2 and r_pattern_mask) = (r_pattern_value and r_pattern_mask) then
							n_trigger_index <= to_unsigned(r_pre_samples, 16);
							n_post_remaining <= r_post_remaining - 1;  -- trigger address is first post trigger value
							n_state <= POST_TRIGGER;
						end if;
					else
						-- error
					end if;
				end if;


			when POST_TRIGGER =>
				if i_samp_tick = '1' then
					n_write_ptr <= v_next_ptr;

					-- increment address pointer
					if r_post_remaining = 1 then
						n_post_remaining <= 0;
						n_start_addr <= v_next_ptr;
						n_state <= DONE;
					else
						n_post_remaining <= r_post_remaining - 1;
					end if;
				end if;


			when DONE =>
				n_capture_done_pulse <= '1';
				n_state <= IDLE;

		end case;
	end process fsm_proc;

	-- Live value of the channel r_edge_trigger_ch selects, computed once so it isn't re-muxed inline in
	-- each of the three edge-type branches in ARMED (see the r_trig_ch_prev/s_trig_ch_cur comment above).
	s_trig_ch_cur <= r_inputs_sync_2(to_integer(unsigned(r_edge_trigger_ch)));

	-- Set outputs
	o_raw_wr_en_pulse 		<= '1' when i_samp_tick = '1' and
		 (r_state = LINEAR_CAPTURE or
		  r_state = PREFILL or
		  r_state = ARMED or
		  r_state = POST_TRIGGER)
		else '0';  			-- store sample to RAM (occurs each wr_en_pulse) every samp_tick when not in IDLE
	o_raw_wr_addr 			<= std_logic_vector(r_write_ptr);
	o_raw_wr_data 			<= r_inputs_sync_2;
	o_capture_done_pulse	<= r_capture_done_pulse;

	o_capture_sample_rate_sel <= r_sample_rate_sel;
	o_capture_trigger_mode 	<= r_trigger_mode;
	o_capture_trigger_index	<= std_logic_vector(r_trigger_index);
	o_capture_start_addr 	<= std_logic_vector(r_start_addr);
	o_capture_sample_count	<= std_logic_vector(r_last_addr+1);
	o_capture_width_sel		<= r_capture_width_sel;

end architecture RTL;
