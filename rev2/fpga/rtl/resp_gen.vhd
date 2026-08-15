-- ========================================
-- MODULE: resp_gen.vhd
-- FUNCTION: queues status/error events from analyzer_fsm and serializes each into a 2-byte (code, detail) payload for frame_tx
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-08-12 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_resp_req				1 bit		<- analyzer_fsm (one cycle)
-- i_resp_type				8 bits		<- analyzer_fsm (0x02 status, 0x03 error)
-- i_resp_code				8 bits		<- analyzer_fsm (0x55 ACK, 0x77 DONE, 0xEE ERROR, 0xDD watchdog)
-- i_resp_detail			8 bits		<- analyzer_fsm (offending/acknowledged opcode, 0x00 if n/a)
-- i_resp_grant				1 bit		<- frame_tx
-- i_frame_done_pulse		1 bit		<- frame_tx
-- i_pl_ready				1 bit		<- tx_mux
--
-- OUTPUTS					DATA		TO MODULE
-- o_resp_overflow			1 bit		-> ??? (debug/observability output; not currently consumed)
-- o_resp_frame_req			1 bit		-> frame_tx
-- o_resp_frame_len			16 bits		-> frame_tx
-- o_resp_frame_type		8 bits		-> frame_tx
-- o_pl_byte				8 bits		-> tx_mux
-- o_pl_valid				1 bit		-> tx_mux
--
-- NOTES
-- resp_gen is the response-side counterpart to send_engine: frame_tx is payload-agnostic (type/len/bytes only), so
-- something has to own status semantics and serialize them into payload bytes. That is this module. Port names on
-- the frame_tx side (o_resp_frame_req/len/type, i_resp_grant, i_frame_done_pulse) mirror frame_tx.vhd's own
-- i_resp_frame_req/len/type, o_resp_grant, o_frame_done_pulse one-for-one.
--
-- This module also fixes a real bug: analyzer_fsm currently gates its whole command decode on
-- "if r_fsm_tx_valid = '1' then ... else case r_state is", so any one-cycle pulse (cfg_ack, cfg_error, cmd_error,
-- capture/read cmd) arriving while a response is in flight is silently lost -- the host then waits forever for an
-- ACK that will never come. A framed response is 10 bytes rather than 1, widening that window from ~10.8us to
-- ~108us at 921600 baud. resp_gen queues requests so they are deferred rather than dropped; see ITERATIVE PROCESS
-- NOTES (a) for the analyzer_fsm rework this still requires.
--
-- Every response is exactly 2 payload bytes: code, then detail. o_resp_frame_len is therefore the constant
-- x"0002". Fixed length keeps this module and frame_tx trivial, and the detail byte -- which raw 0x55/0xEE never
-- had -- tells the host WHICH command was accepted or rejected, removing a class of ambiguity when responses and
-- captures interleave during soak testing.
--
-- QUEUE: circular buffer, QUEUE_DEPTH entries of (type & code & detail), packed into one array. Head/tail pointers
-- plus an explicit count register -- the full/empty pointer-equality trick is deliberately not used; the count is
-- clearer and cheaper to assert on. A push and a pop can happen in the same clock cycle (a new request arriving
-- while IDLE dequeues the previous one); the count update is written as a single expression covering all four
-- push/pop combinations, not as separate nested ifs, so the simultaneous case is not silently wrong.
--
-- Overflow: if i_resp_req arrives while the queue is full, the new request is DROPPED and r_overflow is set '1'
-- permanently until reset. An existing queued entry is never overwritten -- a silently replaced response would be
-- indistinguishable from a lost one on the wire.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- v_ : variable

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- (a) analyzer_fsm must be reworked in a follow-up pass to drive i_resp_req/i_resp_type/i_resp_code/i_resp_detail
--     and to stop gating its command decode on TX state -- that gate is the bug this module exists to route around.
-- (b) config_regs ack/error currently reaches this module via analyzer_fsm, so there is a single requester today
--     and no arbitration is needed inside resp_gen itself.
-- (c) QUEUE_DEPTH=4 assumes the host follows request/response and waits for each ACK. A host that blasts config
--     commands without waiting can outrun the response path roughly 5:1 at 921600 baud and will eventually set
--     o_resp_overflow.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity resp_gen is
	generic (
		DATA_LENGTH : integer := 8;
		QUEUE_DEPTH : integer := 4			-- must be a power of two
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;

		-- request in (from analyzer_fsm)
		i_resp_req				: in  std_logic;								-- one cycle
		i_resp_type				: in  std_logic_vector(DATA_LENGTH-1 downto 0);	-- 0x02 status, 0x03 error
		i_resp_code				: in  std_logic_vector(DATA_LENGTH-1 downto 0);	-- 0x55 ACK, 0x77 DONE, 0xEE ERROR, 0xDD watchdog
		i_resp_detail			: in  std_logic_vector(DATA_LENGTH-1 downto 0);	-- offending/acknowledged opcode, 0x00 if n/a
		o_resp_overflow			: out std_logic;								-- sticky, see NOTES

		-- frame descriptor out (to frame_tx)
		o_resp_frame_req		: out std_logic;
		o_resp_frame_len		: out std_logic_vector(15 downto 0);
		o_resp_frame_type		: out std_logic_vector(DATA_LENGTH-1 downto 0);
		i_resp_grant			: in  std_logic;
		i_frame_done_pulse		: in  std_logic;

		-- payload out (to tx_mux)
		o_pl_byte				: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_pl_valid				: out std_logic;
		i_pl_ready				: in  std_logic
	);
end entity resp_gen;

architecture RTL of resp_gen is
	-- Internal resp_gen state machine
	type resp_gen_state_type is (IDLE, REQUEST, SEND_CODE, SEND_DETAIL, WAIT_DONE);
	signal r_state, n_state : resp_gen_state_type := IDLE;

	-- Queue storage: each entry is (type & code & detail) packed into one vector
	type queue_mem_type is array (0 to QUEUE_DEPTH-1) of std_logic_vector(3*DATA_LENGTH-1 downto 0);
	signal r_queue, n_queue : queue_mem_type := (others => (others => '0'));

	-- Queue pointers / count
	signal r_head, n_head : integer range 0 to QUEUE_DEPTH-1 := 0;
	signal r_tail, n_tail : integer range 0 to QUEUE_DEPTH-1 := 0;
	signal r_count, n_count : integer range 0 to QUEUE_DEPTH := 0;
	signal r_overflow, n_overflow : std_logic := '0';

	-- Active (popped) response being sent
	signal r_active_type, n_active_type : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal r_active_code, n_active_code : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');
	signal r_active_detail, n_active_detail : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');

begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_state 			<= IDLE;
				r_queue 			<= (others => (others => '0'));
				r_head 				<= 0;
				r_tail 				<= 0;
				r_count 			<= 0;
				r_overflow 			<= '0';
				r_active_type 		<= (others => '0');
				r_active_code 		<= (others => '0');
				r_active_detail 	<= (others => '0');
			else
				r_state 			<= n_state;
				r_queue 			<= n_queue;
				r_head 				<= n_head;
				r_tail 				<= n_tail;
				r_count 			<= n_count;
				r_overflow 			<= n_overflow;
				r_active_type 		<= n_active_type;
				r_active_code 		<= n_active_code;
				r_active_detail 	<= n_active_detail;
			end if;
		end if;
	end process seq_proc;


	-- Combinational process for dealing with the queue and the resp_gen FSM. Also drives o_pl_byte/o_pl_valid
	-- directly, since those must react combinationally, in the same cycle, to i_pl_ready.
	fsm_proc: process(all) is
		variable v_full, v_push, v_pop : boolean;
		variable v_count_delta : integer range -1 to 1;
	begin
		-- Defaults
		n_state 			<= r_state;
		n_queue 			<= r_queue;
		n_head 				<= r_head;
		n_tail 				<= r_tail;
		n_count 			<= r_count;
		n_overflow 			<= r_overflow;
		n_active_type 		<= r_active_type;
		n_active_code 		<= r_active_code;
		n_active_detail 	<= r_active_detail;

		o_pl_byte  <= (others => '0');
		o_pl_valid <= '0';

		-- Queue push/pop bookkeeping. Push is evaluated unconditionally (not inside the case below) so a request
		-- is accepted into the queue in EVERY state, including mid-frame -- deferring rather than dropping it is
		-- the entire point of this module. Pop only ever happens from IDLE.
		v_full := (r_count = QUEUE_DEPTH);
		v_push := (i_resp_req = '1') and not v_full;
		v_pop  := (r_state = IDLE) and (r_count /= 0);

		if v_push then
			n_queue(r_tail) <= i_resp_type & i_resp_code & i_resp_detail;
			if r_tail = QUEUE_DEPTH - 1 then
				n_tail <= 0;
			else
				n_tail <= r_tail + 1;
			end if;
		elsif i_resp_req = '1' then	-- i_resp_req='1' and v_full: queue full, drop and flag (sticky)
			n_overflow <= '1';
		end if;

		if v_pop then
			if r_head = QUEUE_DEPTH - 1 then
				n_head <= 0;
			else
				n_head <= r_head + 1;
			end if;
		end if;

		-- Single expression covering all four push/pop combinations: net zero on simultaneous push+pop,
		-- so a request arriving on the same cycle IDLE dequeues the previous one is not lost or double-counted.
		if v_push and v_pop then
			v_count_delta := 0;
		elsif v_push then
			v_count_delta := 1;
		elsif v_pop then
			v_count_delta := -1;
		else
			v_count_delta := 0;
		end if;
		n_count <= r_count + v_count_delta;

		case r_state is
			when IDLE =>
				if v_pop then
					n_active_type   <= r_queue(r_head)(3*DATA_LENGTH-1 downto 2*DATA_LENGTH);
					n_active_code   <= r_queue(r_head)(2*DATA_LENGTH-1 downto DATA_LENGTH);
					n_active_detail <= r_queue(r_head)(DATA_LENGTH-1 downto 0);
					n_state <= REQUEST;
				end if;

			when REQUEST =>
				-- o_resp_frame_req/o_resp_frame_type/o_resp_frame_len are driven combinationally below from
				-- r_active_type / r_state, so they are already correct here -- not assigned in this branch.
				if i_resp_grant = '1' then
					n_state <= SEND_CODE;
				end if;

			when SEND_CODE =>
				o_pl_byte  <= r_active_code;
				o_pl_valid <= '1';
				if i_pl_ready = '1' then	-- code byte accepted
					n_state <= SEND_DETAIL;
				end if;

			when SEND_DETAIL =>
				o_pl_byte  <= r_active_detail;
				o_pl_valid <= '1';
				if i_pl_ready = '1' then	-- detail byte accepted; frame_tx still owes two CRC bytes
					n_state <= WAIT_DONE;
				end if;

			when WAIT_DONE =>
				-- o_resp_frame_req stays asserted (state /= IDLE, see below) until frame_tx finishes the CRC.
				if i_frame_done_pulse = '1' then
					n_state <= IDLE;
				end if;

		end case;
	end process fsm_proc;


	-- Set outputs
	o_resp_overflow		<= r_overflow;

	o_resp_frame_req	<= '0' when r_state = IDLE else '1';
	o_resp_frame_len	<= x"0002";
	o_resp_frame_type	<= r_active_type;

end architecture RTL;
