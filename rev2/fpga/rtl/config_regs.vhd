-- ========================================
-- MODULE: config_regs.vhd
-- FUNCTION: keeps track of logic analyzer configurations from the host
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-07-28 (YYYY-MM-DD)
-- MODIFIED: 2026-08-17 (rev2) (baud changeover sequencing: commit-point gating via uart_tx/resp_gen idle signals, confirm-or-revert timer; uart baud register/output renamed baud_sel to match uart_tx/uart_rx)
-- MODIFIED: 2026-08-19 (rev2) (migrated to la_pkg: the ten local CMD_* config-opcode constants deleted, replaced with la_pkg's C_CMD_*)
-- MODIFIED: 2026-08-21 (rev2) (r_confirm_count -- a single ~25-bit counter incrementing every clock -- replaced with a two-stage prescaler (1ms, 16 bits) driving a millisecond counter (500, 9 bits), both using the count-down-to-1 pattern. Same total duration, verified cycle-for-cycle equivalent; two short carry chains instead of one long one)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_cfg_write_pulse		1 bit		<- cmd_parser
-- i_cfg_opcode				8 bits		<- cmd_parser
-- i_cfg_value				16 bits		<- cmd_parser
-- i_config_write_allowed	1 bit		<- analyzer_fsm
-- i_tx_idle				1 bit		<- uart_tx
-- i_resp_idle				1 bit		<- resp_gen
-- i_rx_byte_valid_pulse	1 bit		<- rx_frame_parser (o_rx_valid_pulse)
--
-- OUTPUTS					DATA		TO MODULE
-- o_cfg_uart_baud_sel     	2 bits		-> uart_tx, uart_rx
-- o_cfg_capture_width_sel	1 bit		-> capture_engine
-- o_cfg_sample_rate_sel   	2 bits		-> clocking, capture_engine
-- o_cfg_capture_depth_sel	1 bit		-> capture_engine
-- o_cfg_trigger_mode		2 bits		-> capture_engine
-- o_cfg_edge_trigger_ch	4 bits		-> capture_engine
-- o_cfg_edge_trigger_type	2 bits		-> capture_engine
-- o_cfg_pattern_value		16 bits		-> capture_engine
-- o_cfg_pattern_mask		16 bits		-> capture_engine
-- o_cfg_trigger_pos		2 bits		-> capture_engine
-- o_cfg_ack_pulse			1 bit		-> analyzer_fsm
-- o_cfg_error_pulse		1 bit		-> analyzer_fsm
--
-- NOTES
-- state-based rejection precedes value validation so a single command yields a single error,
-- and writes remain legal in DATA_READY (analyzer_fsm).
--
-- Baud changeover commit point is "response path drained (i_resp_idle) AND uart_tx idle (i_tx_idle)", not
-- i_frame_done_pulse. resp_gen is FIFO, so if anything was queued ahead of the C0 ACK, the first frame to complete
-- is not the one being waited on -- waiting for the whole response path to drain is the only unambiguous signal.
--
-- i_tx_idle is used rather than uart_tx's ready signal because ready is now gated by FTDI flow control: ready = '0'
-- means either "sending a byte" or "FTDI is not accepting", and committing a baud change on the second case would
-- switch the divider while a byte is still queued. i_tx_idle is driven purely from uart_tx's state, ungated.
--
-- The confirm-or-revert timer exists because there is no ABORT and no runtime reset: without it, a switch the host
-- never completes would otherwise require pressing CRESET_B and reconfiguring the FPGA. The timer turns that into a
-- hiccup instead -- G_BAUD_CONFIRM_CYCLES of silence reverts automatically.
--
-- The host must implement the mirror image of this FSM: switch its port rate, send a probe, and revert to the
-- previous rate if no response arrives within roughly 1 second. Both sides reverting independently, without needing
-- to coordinate the revert itself, is what makes the link self-healing.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
--
-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.la_pkg.ALL;

entity config_regs is
	generic (
		G_BAUD_CONFIRM_CYCLES : positive := 24_000_000   -- 500 ms at 48 MHz
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;

		i_cfg_write_pulse		: in  std_logic;
		i_cfg_opcode			: in  std_logic_vector(7 downto 0);
		i_cfg_value				: in  std_logic_vector(15 downto 0);

		i_config_write_allowed 	: in  std_logic;

		-- uart_tx / resp_gen (baud changeover commit point)
		i_tx_idle				: in  std_logic;
		i_resp_idle				: in  std_logic;

		-- rx_frame_parser (baud changeover confirmation)
		i_rx_byte_valid_pulse	: in  std_logic;

		o_cfg_uart_baud_sel     : out std_logic_vector(1 downto 0);
		o_cfg_capture_width_sel : out std_logic;
		o_cfg_sample_rate_sel   : out std_logic_vector(1 downto 0);
		o_cfg_capture_depth_sel : out std_logic;
		o_cfg_trigger_mode      : out std_logic_vector(1 downto 0);
		o_cfg_edge_trigger_ch   : out std_logic_vector(3 downto 0);
		o_cfg_edge_trigger_type : out std_logic_vector(1 downto 0);
		o_cfg_pattern_value     : out std_logic_vector(15 downto 0);
		o_cfg_pattern_mask      : out std_logic_vector(15 downto 0);
		o_cfg_trigger_pos       : out std_logic_vector(1 downto 0);

		o_cfg_ack_pulse         : out std_logic;
		o_cfg_error_pulse       : out std_logic
	);
end entity config_regs;

architecture RTL of config_regs is
	-- Register signals (non-baud config)
	signal r_capture_width_sel				: std_logic := '0';
	signal r_sample_rate_sel				: std_logic_vector(1 downto 0) := "00";
	signal r_capture_depth_sel				: std_logic := '0';
	signal r_trigger_mode 					: std_logic_vector(1 downto 0) := "00";
	signal r_edge_trigger_ch				: std_logic_vector(3 downto 0) := "0000";
	signal r_edge_trigger_type				: std_logic_vector(1 downto 0) := "00";
	signal r_pattern_trigger_value			: std_logic_vector(15 downto 0) := x"0000";
	signal r_pattern_trigger_mask			: std_logic_vector(15 downto 0) := x"FFFF";
	signal r_trigger_pos					: std_logic_vector(1 downto 0) := "00";

	-- Pulse outputs from the non-baud (legacy) opcode handling above, driven directly in seq_proc (no r_/n_ split,
	-- matching this module's existing single-process style). OR'd with the baud FSM's own pulses at the bottom of
	-- this file -- the two paths are mutually exclusive per write (C_CMD_UART_BAUD is a no-op in seq_proc, see below).
	signal r_legacy_ack_pulse				: std_logic := '0';
	signal r_legacy_error_pulse				: std_logic := '0';

	-- Baud changeover FSM: separate from, and concurrent with, the register handling above.
	type baud_state_type is (BAUD_IDLE, BAUD_PENDING, BAUD_CONFIRM);
	signal r_baud_state, n_baud_state : baud_state_type := BAUD_IDLE;

	signal r_baud_sel, n_baud_sel : std_logic_vector(1 downto 0) := "00";							-- live value driving uart_tx / uart_rx
	signal r_pending_baud, n_pending_baud : std_logic_vector(1 downto 0) := "00";					-- validated, not yet applied
	signal r_prev_baud, n_prev_baud : std_logic_vector(1 downto 0) := "00";							-- value to restore on revert

	-- Two-stage confirm-or-revert timer: a 1ms prescaler drives a millisecond counter, instead of one
	-- ~25-bit counter incrementing every clock. Same total duration (verified cycle-for-cycle against
	-- the single-counter version: both revert on exactly clock G_BAUD_CONFIRM_CYCLES after the commit
	-- point), two short carry chains instead of one long one. Precision is unaffected -- this is a
	-- timeout, not a measurement. Assumes G_BAUD_CONFIRM_CYCLES is a multiple of C_PRESCALE_CYCLES;
	-- if not, C_CONFIRM_MS truncates and the actual timeout is short by under 1ms.
	constant C_PRESCALE_CYCLES : positive := C_SYS_CLK_HZ / 1000;				-- cycles per 1 ms (48,000 at 48 MHz)
	constant C_CONFIRM_MS      : positive := G_BAUD_CONFIRM_CYCLES / C_PRESCALE_CYCLES;	-- ms to wait for confirmation (500)
	signal r_ms_prescaler, n_ms_prescaler : integer range 0 to C_PRESCALE_CYCLES-1 := 0;	-- counts down every clock; reaching 0 ticks the ms counter
	signal r_confirm_ms_remaining, n_confirm_ms_remaining : integer range 0 to C_CONFIRM_MS := 0;	-- ms left before revert, including the one in flight

	signal r_baud_ack_pulse, n_baud_ack_pulse : std_logic := '0';									-- pulse output
	signal r_baud_error_pulse, n_baud_error_pulse : std_logic := '0';								-- pulse output

begin
	seq_proc : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_capture_width_sel     <= '0';      -- 8 channels
				r_sample_rate_sel       <= "00";     -- 24 MS/s
				r_capture_depth_sel     <= '0';      -- shallow capture (4096 bytes)
				r_trigger_mode          <= "00";     -- immediate
				r_edge_trigger_ch       <= "0000";   -- CH0
				r_edge_trigger_type     <= "00";     -- rising
				r_pattern_trigger_value <= x"0000";  -- trigger value is 0x0000
				r_pattern_trigger_mask  <= x"FFFF";  -- all channels are part of the pattern
				r_trigger_pos           <= "00";     -- 25%

				r_legacy_ack_pulse		<= '0';
				r_legacy_error_pulse 	<= '0';
			else
				r_legacy_ack_pulse   <= '0';
				r_legacy_error_pulse <= '0';

				if i_config_write_allowed = '0' and i_cfg_write_pulse = '1' then
					r_legacy_error_pulse <= '1';
				elsif i_cfg_write_pulse = '1' then
					case i_cfg_opcode is
						when C_CMD_UART_BAUD =>
							null;  -- routed to the baud changeover FSM below, not handled here

						when C_CMD_CAPTURE_WIDTH =>
							case i_cfg_value(7 downto 0) is
								when x"00" | x"01" =>
									r_capture_width_sel <= i_cfg_value(0);
									r_legacy_ack_pulse  <= '1';

								when others =>
									r_legacy_error_pulse <= '1';
							end case;

						when C_CMD_SAMP_RATE =>
							case i_cfg_value(7 downto 0) is
								when x"00" | x"01" | x"02" =>
									r_sample_rate_sel 	<= i_cfg_value(1 downto 0);
									r_legacy_ack_pulse  <= '1';

								when others =>
									r_legacy_error_pulse <= '1';
							end case;

						when C_CMD_CAPTURE_DEPTH =>
							case i_cfg_value(7 downto 0) is
								when x"00" | x"01" =>
									r_capture_depth_sel <= i_cfg_value(0);
									r_legacy_ack_pulse  <= '1';

								when others =>
									r_legacy_error_pulse <= '1';
							end case;

						when C_CMD_TRIGGER_MODE =>
							case i_cfg_value(7 downto 0) is
								when x"00" | x"01" | x"02" =>
									r_trigger_mode     <= i_cfg_value(1 downto 0);
									r_legacy_ack_pulse <= '1';

								when others =>
									r_legacy_error_pulse <= '1';
							end case;

						when C_CMD_EDGE_TRIG_CH =>
							if i_cfg_value(7 downto 4) = "0000" then
								r_edge_trigger_ch  <= i_cfg_value(3 downto 0);
								r_legacy_ack_pulse <= '1';
							else
								r_legacy_error_pulse <= '1';
							end if;

						when C_CMD_EDGE_TRIG_TYPE =>
							case i_cfg_value(7 downto 0) is
								when x"00" | x"01" | x"02" =>
									r_edge_trigger_type <= i_cfg_value(1 downto 0);
									r_legacy_ack_pulse  <= '1';

								when others =>
									r_legacy_error_pulse <= '1';
							end case;

						when C_CMD_PATTERN_VALUE =>
							r_pattern_trigger_value <= i_cfg_value;
							r_legacy_ack_pulse <= '1';

						when C_CMD_PATTERN_MASK =>
							if i_cfg_value /= x"0000" then
								r_pattern_trigger_mask <= i_cfg_value;
								r_legacy_ack_pulse <= '1';
							else
								r_legacy_error_pulse <= '1';
							end if;

						when C_CMD_TRIGGER_POSITION =>
							case i_cfg_value(7 downto 0) is
								when x"00" | x"01" | x"02" =>
									r_trigger_pos      <= i_cfg_value(1 downto 0);
									r_legacy_ack_pulse <= '1';

								when others =>
									r_legacy_error_pulse <= '1';
							end case;

						when others =>
							r_legacy_error_pulse <= '1';  -- ERROR. Unrecognised opcode

					end case;
				end if;
			end if;
		end if;
	end process seq_proc;


	-- Baud changeover FSM sequential process
	baud_seq_proc : process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_baud_state       <= BAUD_IDLE;
				r_baud_sel         <= "00";
				r_pending_baud     <= "00";
				r_prev_baud        <= "00";
				r_ms_prescaler        <= 0;
				r_confirm_ms_remaining <= 0;
				r_baud_ack_pulse   <= '0';
				r_baud_error_pulse <= '0';
			else
				r_baud_state       <= n_baud_state;
				r_baud_sel         <= n_baud_sel;
				r_pending_baud     <= n_pending_baud;
				r_prev_baud        <= n_prev_baud;
				r_ms_prescaler         <= n_ms_prescaler;
				r_confirm_ms_remaining <= n_confirm_ms_remaining;
				r_baud_ack_pulse   <= n_baud_ack_pulse;
				r_baud_error_pulse <= n_baud_error_pulse;
			end if;
		end if;
	end process baud_seq_proc;


	-- Baud changeover FSM combinational process
	baud_fsm_proc : process(all) is
	begin
		-- Defaults
		n_baud_state       <= r_baud_state;
		n_baud_sel         <= r_baud_sel;
		n_pending_baud      <= r_pending_baud;
		n_prev_baud         <= r_prev_baud;
		n_ms_prescaler         <= r_ms_prescaler;
		n_confirm_ms_remaining <= r_confirm_ms_remaining;
		n_baud_ack_pulse    <= '0';  -- pulse output, default low
		n_baud_error_pulse  <= '0';  -- pulse output, default low

		case r_baud_state is
			when BAUD_IDLE =>
				if i_config_write_allowed = '1' and i_cfg_write_pulse = '1' and i_cfg_opcode = C_CMD_UART_BAUD then
					-- analyzer_fsm in IDLE or DATA_READY so config_write allowed; cmd_parser sent valid opcode (and args); opcode concerns change of baud rate
					case i_cfg_value(7 downto 0) is
						when x"00" | x"01" | x"02" =>
							n_pending_baud   <= i_cfg_value(1 downto 0);
							n_prev_baud      <= r_baud_sel;
							n_baud_ack_pulse <= '1';
							n_baud_state     <= BAUD_PENDING;

						when others =>
							n_baud_error_pulse <= '1';
					end case;
				end if;

			when BAUD_PENDING =>
				if i_config_write_allowed = '1' and i_cfg_write_pulse = '1' and i_cfg_opcode = C_CMD_UART_BAUD then
					n_baud_error_pulse <= '1';  -- a second changeover on top of an unconfirmed one has no defined meaning
				end if;
				if i_resp_idle = '1' and i_tx_idle = '1' then
					-- commit point: response path drained and the ACK frame has fully left uart_tx
					n_baud_sel      <= r_pending_baud;
					n_ms_prescaler         <= C_PRESCALE_CYCLES - 1;
					n_confirm_ms_remaining <= C_CONFIRM_MS;
					n_baud_state    <= BAUD_CONFIRM;
				end if;

			when BAUD_CONFIRM =>
				if i_config_write_allowed = '1' and i_cfg_write_pulse = '1' and i_cfg_opcode = C_CMD_UART_BAUD then
					n_baud_error_pulse <= '1';
				end if;
				if i_rx_byte_valid_pulse = '1' then
					-- a validated byte (full frame with valid CRC, etc.) proves the host is talking to us at the new rate
					n_baud_state <= BAUD_IDLE;
				elsif r_ms_prescaler = 0 then
					-- one more millisecond elapsed
					n_ms_prescaler <= C_PRESCALE_CYCLES - 1;
					if r_confirm_ms_remaining = 1 then
						-- no confirmation within C_CONFIRM_MS: revert
						n_baud_sel         <= r_prev_baud;
						n_baud_error_pulse <= '1';  -- goes out at the restored rate, so a host that also reverted will see it
						n_baud_state       <= BAUD_IDLE;
					else
						n_confirm_ms_remaining <= r_confirm_ms_remaining - 1;
					end if;
				else
					n_ms_prescaler <= r_ms_prescaler - 1;
				end if;
		end case;
	end process baud_fsm_proc;

	o_cfg_uart_baud_sel     <= r_baud_sel;
	o_cfg_capture_width_sel	<= r_capture_width_sel;
	o_cfg_sample_rate_sel   <= r_sample_rate_sel;
	o_cfg_capture_depth_sel <= r_capture_depth_sel;
	o_cfg_trigger_mode      <= r_trigger_mode;
	o_cfg_edge_trigger_ch   <= r_edge_trigger_ch;
	o_cfg_edge_trigger_type <= r_edge_trigger_type;
	o_cfg_pattern_value     <= r_pattern_trigger_value;
	o_cfg_pattern_mask      <= r_pattern_trigger_mask;
	o_cfg_trigger_pos       <= r_trigger_pos;

	o_cfg_ack_pulse   <= r_legacy_ack_pulse or r_baud_ack_pulse;
	o_cfg_error_pulse <= r_legacy_error_pulse or r_baud_error_pulse;

end architecture RTL;