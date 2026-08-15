-- ========================================
-- MODULE: rx_frame_parser.vhd
-- FUNCTION: validates and unwraps host->FPGA command frames (sync/version/type/seq/len/CRC) before handing raw command bytes to cmd_parser
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-08-15 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_rx_byte				8 bits		<- uart_rx
-- i_rx_valid_pulse			1 bit		<- uart_rx
--
-- OUTPUTS					DATA		TO MODULE
-- o_rx_byte				8 bits		-> cmd_parser
-- o_rx_valid_pulse			1 bit		-> cmd_parser
-- o_frame_error_pulse		1 bit		-> analyzer_fsm
-- o_frame_error_code		8 bits		-> analyzer_fsm
-- o_seq_gap_pulse			1 bit		-> analyzer_fsm
--
-- NOTES
-- rx_frame_parser is the receive-side mirror of frame_tx: SYNC0=0xA5, SYNC1=0x5A, VERSION=0x01, TYPE=0x10 (COMMAND),
-- SEQ, LEN_L, LEN_H, <payload, LEN bytes>, CRC16_L, CRC16_H. 
--
-- cmd_parser never sees a byte from a frame that failed validation.
--
-- BUFFER-THEN-RELEASE: payload bytes are accumulated into r_payload_buf and only emitted (in EMIT) after the CRC
-- compare succeeds -- they are never forwarded as they arrive. This is only affordable because host->FPGA payloads
-- are tiny (<= 3 bytes today; G_MAX_PAYLOAD caps the buffer at 8). Forwarding early would let a command execute
-- before its CRC is checked, which makes the CRC decorative.
--
-- SEQUENCE HANDLING: each transmitter owns its own counter; this module only verifies continuity, not content. The
-- first frame accepted after reset adopts whatever SEQ it carries. After that, SEQ must be previous+1 (0xFF->0x00
-- wraps). A gap pulses o_seq_gap_pulse and adopts the new value, but the frame is still released: a gap means an
-- earlier frame was lost, not that this one is invalid, and refusing a good command because an older one vanished
-- would turn one lost frame into a stuck host. Gap detection happens only once the CRC has already passed (in
-- CRC_H, on the transition into EMIT), so a corrupted SEQ byte inside a rejected frame can never trigger a
-- spurious gap pulse.
--
-- G_BYPASS=true generates a transparent passthrough (o_rx_byte<=i_rx_byte, o_rx_valid_pulse<=i_rx_valid_pulse, FSM
-- entirely absent, error outputs tied low), so top.vhd can be brought up before the host-side Python emits framed
-- commands. There is deliberately no auto-detection between raw and framed input: a legal pattern-mask argument
-- pair (C8 A5 5A) is byte-identical to a sync pair, so sniffing would silently corrupt configuration.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- v_ : variable

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- (a) analyzer_fsm needs two new inputs to surface o_frame_error_pulse/o_frame_error_code and o_seq_gap_pulse as
--     ERROR responses through resp_gen -- it does not consume them yet.
-- (b) the host-side Python must frame its commands before G_BYPASS is set false -- this is a flag day, not a
--     gradual migration.
-- (c) framing overhead is 9 bytes per command, ~98us at 921600 baud, negligible against a 133ms capture transfer.
-- (d) crc16_next is now duplicated in frame_tx.vhd and here; both copies should be lifted into a shared package.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity rx_frame_parser is
	generic (
		DATA_LENGTH      : integer  := 8;
		G_MAX_PAYLOAD    : positive := 8;			-- reject LEN above this
		G_TIMEOUT_CYCLES : positive := 48_000;		-- 1 ms at 48 MHz, mid-frame stall
		G_BYPASS         : boolean  := false		-- see NOTES
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;

		i_rx_byte				: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_rx_valid_pulse		: in  std_logic;

		-- Outputs to cmd_parser
		o_rx_byte				: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_rx_valid_pulse		: out std_logic;

		-- Outputs to analyzer_fsm
		o_frame_error_pulse		: out std_logic;
		o_frame_error_code		: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_seq_gap_pulse			: out std_logic
	);
end entity rx_frame_parser;

architecture RTL of rx_frame_parser is
begin

	-- Transparent passthrough: no FSM, no framing.
	BYPASS_GEN: if G_BYPASS generate
		o_rx_byte           <= i_rx_byte;
		o_rx_valid_pulse    <= i_rx_valid_pulse;
		o_frame_error_pulse <= '0';
		o_frame_error_code  <= (others => '0');
		o_seq_gap_pulse     <= '0';
	end generate BYPASS_GEN;

	FSM_GEN: if not G_BYPASS generate
		-- Internal rx_frame_parser state machine
		type rx_frame_parser_state_type is (
			HUNT_SYNC0,
			HUNT_SYNC1,
			VERSION,
			FRAME_TYPE,
			SEQ,
			LEN_L,
			LEN_H,
			PAYLOAD,
			CRC_L,
			CRC_H,
			EMIT
		);
		signal r_state, n_state : rx_frame_parser_state_type := HUNT_SYNC0;

		-- Register signals, next-state signals
		signal r_rx_byte, n_rx_byte : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');				-- output
		signal r_rx_valid_pulse, n_rx_valid_pulse : std_logic := '0';												-- output
		signal r_frame_error_pulse, n_frame_error_pulse : std_logic := '0';										-- output
		signal r_frame_error_code, n_frame_error_code : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');	-- output
		signal r_seq_gap_pulse, n_seq_gap_pulse : std_logic := '0';												-- output

		signal r_crc, n_crc : std_logic_vector(15 downto 0) := (others => '0');
		signal r_rx_crc, n_rx_crc : std_logic_vector(15 downto 0) := (others => '0');		-- CRC received via CRC_L/CRC_H
		signal r_len, n_len : unsigned(15 downto 0) := (others => '0');					-- assembled from LEN_L/LEN_H

		-- Payload buffer
		type payload_buf_type is array (0 to G_MAX_PAYLOAD-1) of std_logic_vector(DATA_LENGTH-1 downto 0);
		signal r_payload_buf, n_payload_buf : payload_buf_type := (others => (others => '0'));
		signal r_payload_total, n_payload_total : integer range 0 to G_MAX_PAYLOAD := 0;	-- validated LEN
		signal r_payload_idx, n_payload_idx : integer range 0 to G_MAX_PAYLOAD := 0;		-- fill index in PAYLOAD, emit index in EMIT

		-- Sequence tracking
		signal r_seq_rx, n_seq_rx : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');		-- SEQ byte received this frame
		signal r_seq_expected, n_seq_expected : unsigned(DATA_LENGTH-1 downto 0) := (others => '0');	-- next SEQ expected
		signal r_seq_locked, n_seq_locked : std_logic := '0';		-- '0' until the first frame is accepted after reset

		-- Timeout
		signal r_timeout_count, n_timeout_count : integer range 0 to G_TIMEOUT_CYCLES - 1 := 0;

		-- Constants used for static frame fields
		constant SYNC0               : std_logic_vector(DATA_LENGTH-1 downto 0) := x"A5";
		constant SYNC1               : std_logic_vector(DATA_LENGTH-1 downto 0) := x"5A";
		constant VERSION_EXPECTED    : std_logic_vector(DATA_LENGTH-1 downto 0) := x"01";
		constant FRAME_TYPE_COMMAND  : std_logic_vector(DATA_LENGTH-1 downto 0) := x"10";

		-- Rejection codes
		constant ERR_BAD_VERSION   : std_logic_vector(DATA_LENGTH-1 downto 0) := x"01";
		constant ERR_BAD_TYPE      : std_logic_vector(DATA_LENGTH-1 downto 0) := x"02";
		constant ERR_BAD_LENGTH    : std_logic_vector(DATA_LENGTH-1 downto 0) := x"03";
		constant ERR_CRC_MISMATCH  : std_logic_vector(DATA_LENGTH-1 downto 0) := x"04";
		constant ERR_TIMEOUT       : std_logic_vector(DATA_LENGTH-1 downto 0) := x"05";

		-- CRC FUNCTION (copied verbatim from frame_tx.vhd -- see ITERATIVE PROCESS NOTES (d))
		function crc16_next(
			crc_in  : std_logic_vector(15 downto 0);
			data_in : std_logic_vector(7 downto 0)
		) return std_logic_vector is
			variable v_crc : unsigned(15 downto 0);
		begin
			v_crc := unsigned(crc_in) xor
					 shift_left(resize(unsigned(data_in), 16), 8);

			for i in 0 to 7 loop
				if v_crc(15) = '1' then
					v_crc := shift_left(v_crc, 1) xor x"1021";
				else
					v_crc := shift_left(v_crc, 1);
				end if;
			end loop;

			return std_logic_vector(v_crc);
		end function;

	begin
		-- Sequential process for dealing with clocking
		seq_proc: process(i_clk) is
		begin
			if rising_edge(i_clk) then
				if i_rst_n = '0' then
					r_state 				<= HUNT_SYNC0;
					r_rx_byte 				<= (others => '0');
					r_rx_valid_pulse 		<= '0';
					r_frame_error_pulse 	<= '0';
					r_frame_error_code 		<= (others => '0');
					r_seq_gap_pulse 		<= '0';
					r_crc 					<= (others => '0');
					r_rx_crc 				<= (others => '0');
					r_len 					<= (others => '0');
					r_payload_buf 			<= (others => (others => '0'));
					r_payload_total 		<= 0;
					r_payload_idx 			<= 0;
					r_seq_rx 				<= (others => '0');
					r_seq_expected 			<= (others => '0');
					r_seq_locked 			<= '0';
					r_timeout_count 		<= 0;
				else
					r_state 				<= n_state;
					r_rx_byte 				<= n_rx_byte;
					r_rx_valid_pulse 		<= n_rx_valid_pulse;
					r_frame_error_pulse 	<= n_frame_error_pulse;
					r_frame_error_code 		<= n_frame_error_code;
					r_seq_gap_pulse 		<= n_seq_gap_pulse;
					r_crc 					<= n_crc;
					r_rx_crc 				<= n_rx_crc;
					r_len 					<= n_len;
					r_payload_buf 			<= n_payload_buf;
					r_payload_total 		<= n_payload_total;
					r_payload_idx 			<= n_payload_idx;
					r_seq_rx 				<= n_seq_rx;
					r_seq_expected 			<= n_seq_expected;
					r_seq_locked 			<= n_seq_locked;
					r_timeout_count 		<= n_timeout_count;
				end if;
			end if;
		end process seq_proc;


		-- Combinational process for dealing with rx_frame_parser FSM
		fsm_proc: process(all) is
			variable v_len    : unsigned(15 downto 0);
			variable v_rx_crc : std_logic_vector(15 downto 0);
		begin
			-- Defaults
			n_state 				<= r_state;
			n_rx_byte 				<= r_rx_byte;
			n_rx_valid_pulse 		<= '0';					-- pulse output, default low
			n_frame_error_pulse 	<= '0';					-- pulse output, default low
			n_frame_error_code 	<= r_frame_error_code;	-- held, not self-clearing
			n_seq_gap_pulse 		<= '0';					-- pulse output, default low
			n_crc 					<= r_crc;
			n_rx_crc 				<= r_rx_crc;
			n_len 					<= r_len;
			n_payload_buf 			<= r_payload_buf;
			n_payload_total 		<= r_payload_total;
			n_payload_idx 			<= r_payload_idx;
			n_seq_rx 				<= r_seq_rx;
			n_seq_expected 			<= r_seq_expected;
			n_seq_locked 			<= r_seq_locked;
			n_timeout_count 		<= r_timeout_count;

			case r_state is
				when HUNT_SYNC0 =>
					-- No timeout while hunting -- idle is the normal state between commands.
					if i_rx_valid_pulse = '1' then
						if i_rx_byte = SYNC0 then
							n_state <= HUNT_SYNC1;
						end if;
					end if;

				when HUNT_SYNC1 =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						if i_rx_byte = SYNC1 then
							n_crc         <= x"FFFF";
							n_payload_idx <= 0;
							n_state       <= VERSION;
						elsif i_rx_byte = SYNC0 then
							null;	-- stay in HUNT_SYNC1: e.g. A5 A5 5A must still resolve to a valid sync pair
						else
							n_state <= HUNT_SYNC0;
						end if;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when VERSION =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						n_crc <= crc16_next(r_crc, i_rx_byte);
						if i_rx_byte = VERSION_EXPECTED then
							n_state <= FRAME_TYPE;
						else
							n_state              <= HUNT_SYNC0;
							n_frame_error_pulse  <= '1';
							n_frame_error_code   <= ERR_BAD_VERSION;
						end if;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when FRAME_TYPE =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						n_crc <= crc16_next(r_crc, i_rx_byte);
						if i_rx_byte = FRAME_TYPE_COMMAND then
							n_state <= SEQ;
						else
							n_state              <= HUNT_SYNC0;
							n_frame_error_pulse  <= '1';
							n_frame_error_code   <= ERR_BAD_TYPE;
						end if;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when SEQ =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						n_crc     <= crc16_next(r_crc, i_rx_byte);
						n_seq_rx  <= i_rx_byte;
						n_state   <= LEN_L;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when LEN_L =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						n_crc <= crc16_next(r_crc, i_rx_byte);
						n_len(7 downto 0) <= unsigned(i_rx_byte);
						n_state <= LEN_H;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when LEN_H =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						n_crc <= crc16_next(r_crc, i_rx_byte);
						n_len(15 downto 8) <= unsigned(i_rx_byte);

						v_len := unsigned(i_rx_byte) & r_len(7 downto 0);	-- assemble full LEN this cycle: LEN_L was the low byte

						if v_len = 0 or v_len > to_unsigned(G_MAX_PAYLOAD, 16) then
							n_state              <= HUNT_SYNC0;
							n_frame_error_pulse  <= '1';
							n_frame_error_code   <= ERR_BAD_LENGTH;
						else
							n_payload_total <= to_integer(v_len);
							n_payload_idx   <= 0;
							n_state         <= PAYLOAD;
						end if;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when PAYLOAD =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						n_crc <= crc16_next(r_crc, i_rx_byte);
						n_payload_buf(r_payload_idx) <= i_rx_byte;

						if r_payload_idx = r_payload_total - 1 then
							n_payload_idx <= 0;
							n_state       <= CRC_L;
						else
							n_payload_idx <= r_payload_idx + 1;
						end if;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when CRC_L =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						n_rx_crc(7 downto 0) <= i_rx_byte;		-- CRC bytes are not folded into the CRC
						n_state <= CRC_H;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when CRC_H =>
					if i_rx_valid_pulse = '1' then
						n_timeout_count <= 0;
						n_rx_crc(15 downto 8) <= i_rx_byte;

						v_rx_crc := i_rx_byte & r_rx_crc(7 downto 0);	-- assemble received CRC: CRC_L was the low byte

						if v_rx_crc = r_crc then
							-- Sequence check happens only once CRC has passed, so a corrupted SEQ byte inside a
							-- rejected frame can never trigger a spurious gap pulse.
							if r_seq_locked = '0' then
								n_seq_locked   <= '1';
								n_seq_expected <= unsigned(r_seq_rx) + 1;
							elsif unsigned(r_seq_rx) = r_seq_expected then
								n_seq_expected <= r_seq_expected + 1;
							else
								-- gap: an earlier frame was lost. Adopt the new value and still release this one.
								n_seq_expected  <= unsigned(r_seq_rx) + 1;
								n_seq_gap_pulse <= '1';
							end if;

							n_payload_idx <= 0;
							n_state       <= EMIT;
						else
							n_state              <= HUNT_SYNC0;
							n_frame_error_pulse  <= '1';
							n_frame_error_code   <= ERR_CRC_MISMATCH;
						end if;
					elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
						n_timeout_count      <= 0;
						n_state              <= HUNT_SYNC0;
						n_frame_error_pulse  <= '1';
						n_frame_error_code   <= ERR_TIMEOUT;
					else
						n_timeout_count <= r_timeout_count + 1;
					end if;

				when EMIT =>
					n_rx_byte        <= r_payload_buf(r_payload_idx);
					n_rx_valid_pulse <= '1';

					if r_payload_idx = r_payload_total - 1 then
						n_state <= HUNT_SYNC0;
					else
						n_payload_idx <= r_payload_idx + 1;
					end if;

			end case;
		end process fsm_proc;


		-- Set outputs
		o_rx_byte 				<= r_rx_byte;
		o_rx_valid_pulse 		<= r_rx_valid_pulse;
		o_frame_error_pulse 	<= r_frame_error_pulse;
		o_frame_error_code 	<= r_frame_error_code;
		o_seq_gap_pulse 		<= r_seq_gap_pulse;

	end generate FSM_GEN;

end architecture RTL;
