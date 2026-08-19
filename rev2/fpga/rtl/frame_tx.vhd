-- ========================================
-- MODULE: frame_tx.vhd
-- FUNCTION: wraps payload byte stream from send_engine or resp_gen. (Also owns the CRC engine and sequence counter)
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-08-13 (YYYY-MM-DD)
-- MODIFIED: 2026-08-19 (rev2) (migrated to la_pkg: crc16_next and the SYNC0/SYNC1/VERSION/FRAME_TYPE_CAPTURE constants deleted, replaced with la_pkg's crc16_next/C_SYNC0/C_SYNC1/C_PROTO_VER/C_TYPE_CAPTURE/C_CRC_INIT)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_send_frame_req			1 bit		<- send_engine
-- i_send_frame_len			16 bits		<- send_engine
-- i_resp_frame_req			1 bit		<- resp_gen
-- i_resp_frame_len			16 bits		<- resp_gen
-- i_resp_frame_type		8 bits		<- resp_gen
-- i_pl_byte				8 bits		<- tx_mux
-- i_pl_valid				1 bit		<- tx_mux
-- i_tx_ready				1 bit		<- uart_tx
--
-- OUTPUTS					DATA		TO MODULE
-- o_pl_ready				1 bit		-> tx_mux
-- o_grant_sel				1 bit		-> tx_mux
-- o_send_grant				1 bit		-> send_engine
-- o_resp_grant				1 bit		-> resp_gen
-- o_frame_done_pulse		1 bit		-> send_engine, resp_gen
-- o_tx_byte				8 bits		-> uart_tx
-- o_tx_valid				1 bit		-> uart_tx
--
-- NOTES
-- Frame format: SYNC0=0xA5, SYNC1=0x5A, VERSION=0x01, TYPE, SEQ, LEN_L, LEN_H, <payload, LEN bytes>, CRC16_L, CRC16_H
-- LEN is the payload length in bytes, little-endian, EXCLUDING header and CRC.
-- CRC-16/CCITT-FALSE: poly 0x1021, init 0xFFFF, no reflection, xorout 0x0000.
-- CRC covers VERSION through the final payload byte only -- it excludes SYNC0/SYNC1 and the two CRC bytes themselves.
-- CRC is transmitted low byte then high byte, and is NOT itself folded into the CRC.
--
-- frame_tx is the single point in the design where FPGA->host framing happens. send_engine and resp_gen supply payload
-- bytes only; they never see SYNC/VERSION/SEQ/LEN/CRC. resp_gen has arbitration priority over send_engine in IDLE.
-- The grant (r_grant_sel, and the derived o_send_grant/o_resp_grant) is latched once per frame in IDLE and held for
-- every remaining state until COMPLETE -- a request from the other producer while a frame is in flight is simply not
-- sampled, since i_send_frame_req/i_resp_frame_req are only read in the IDLE branch of fsm_proc.
--
-- i_pl_valid may legitimately drop mid-frame (e.g. send_engine deasserts it during its WAIT_RAM cycles). PAYLOAD
-- holds in place when that happens: o_tx_valid follows i_pl_valid low, no CRC update, no counter advance, no state
-- change, and the grant stays asserted throughout.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- v_ : variable

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- (a) send_engine's own framing (SYNC/VERSION/SEQ/LEN/CRC) is to be stripped in a follow-up pass, with its 7 metadata
--     bytes demoted to the first 7 payload bytes handed to frame_tx instead.
-- o_frame_done_pulse fans out to both send_engine.i_frame_done_pulse and resp_gen.i_frame_done_pulse once
--     top.vhd is rewired -- not analyzer_fsm, which never sees frame-level completion directly.
-- (c) tx_mux is not yet updated for this module -- it becomes a combinational 2:1 payload mux (send_engine vs.
--     resp_gen) selected by o_grant_sel, feeding i_pl_byte/i_pl_valid and returning o_pl_ready.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.la_pkg.ALL;

entity frame_tx is
	generic (
		DATA_LENGTH : integer := 8
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;

		-- frame requests
		i_send_frame_req		: in  std_logic;								-- held high for whole frame
		i_send_frame_len		: in  std_logic_vector(15 downto 0);
		i_resp_frame_req		: in  std_logic;
		i_resp_frame_len		: in  std_logic_vector(15 downto 0);
		i_resp_frame_type		: in  std_logic_vector(DATA_LENGTH-1 downto 0);	-- 0x02 status, 0x03 error

		-- payload stream in, from tx_mux
		i_pl_byte				: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_pl_valid				: in  std_logic;
		o_pl_ready				: out std_logic;

		-- grant, to tx_mux and producers
		o_grant_sel				: out std_logic;								-- '0' resp, '1' send
		o_send_grant			: out std_logic;
		o_resp_grant			: out std_logic;
		o_frame_done_pulse		: out std_logic;								-- one cycle after CRC_H accepted

		-- downstream, to uart_tx
		o_tx_byte				: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_tx_valid				: out std_logic;
		i_tx_ready				: in  std_logic
	);
end entity frame_tx;

architecture RTL of frame_tx is
	-- Internal frame_tx state machine
	type frame_tx_state_type is (IDLE, HEADER, PAYLOAD, CRC_L, CRC_H, COMPLETE);
	signal r_state, n_state : frame_tx_state_type := IDLE;

	-- Register signals, next-state signals
	signal r_header_index, n_header_index : integer range 0 to 6 := 0;					-- byte index within the 7-byte header (SYNC0..LEN_H)
	signal r_pl_count, n_pl_count : unsigned(15 downto 0) := (others => '0');			-- payload bytes accepted so far
	signal r_frame_len, n_frame_len : unsigned(15 downto 0) := (others => '0');			-- latched LEN for this frame
	signal r_frame_type, n_frame_type : std_logic_vector(DATA_LENGTH-1 downto 0) := (others => '0');	-- latched TYPE for this frame
	signal r_grant_sel, n_grant_sel : std_logic := '0';									-- '0' resp, '1' send; latched for whole frame
	signal r_seq_counter, n_seq_counter : unsigned(7 downto 0) := (others => '0');		-- persists across frames, wraps 0xFF -> 0x00
	signal r_crc, n_crc : std_logic_vector(15 downto 0) := (others => '0');
	signal r_frame_done_pulse, n_frame_done_pulse : std_logic := '0';						-- output

begin
	-- Sequential process for dealing with clocking
	seq_proc: process(i_clk) is
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_state 			<= IDLE;
				r_header_index 		<= 0;
				r_pl_count 			<= (others => '0');
				r_frame_len 		<= (others => '0');
				r_frame_type 		<= (others => '0');
				r_grant_sel 		<= '0';
				r_seq_counter 		<= (others => '0');
				r_crc 				<= (others => '0');
				r_frame_done_pulse 	<= '0';
			else
				r_state 			<= n_state;
				r_header_index 		<= n_header_index;
				r_pl_count 			<= n_pl_count;
				r_frame_len 		<= n_frame_len;
				r_frame_type 		<= n_frame_type;
				r_grant_sel 		<= n_grant_sel;
				r_seq_counter 		<= n_seq_counter;
				r_crc 				<= n_crc;
				r_frame_done_pulse 	<= n_frame_done_pulse;
			end if;
		end if;
	end process seq_proc;


	-- Combinational process for dealing with frame_tx FSM and (since the tx byte/valid/ready/grant outputs must
	-- react combinationally, in the same cycle, to r_state and to the live payload/ready inputs) for driving the
	-- output ports directly.
	fsm_proc: process(all) is
		variable v_hdr_byte : std_logic_vector(DATA_LENGTH-1 downto 0);	-- byte selected by r_header_index this cycle
	begin
		-- Defaults
		n_state 			<= r_state;
		n_header_index 		<= r_header_index;
		n_pl_count 			<= r_pl_count;
		n_frame_len 		<= r_frame_len;
		n_frame_type 		<= r_frame_type;
		n_grant_sel 		<= r_grant_sel;
		n_seq_counter 		<= r_seq_counter;
		n_crc 				<= r_crc;
		n_frame_done_pulse 	<= '0';

		o_tx_byte 		<= (others => '0');
		o_tx_valid 		<= '0';
		o_pl_ready 		<= '0';
		o_grant_sel 	<= r_grant_sel;
		o_send_grant 	<= '0';
		o_resp_grant 	<= '0';

		case r_state is
			when IDLE =>
				-- resp_gen has priority over send_engine
				if i_resp_frame_req = '1' then
					n_grant_sel    <= '0';
					n_frame_type   <= i_resp_frame_type;
					n_frame_len    <= unsigned(i_resp_frame_len);
					n_crc          <= C_CRC_INIT;
					n_header_index <= 0;
					n_pl_count     <= (others => '0');
					n_state        <= HEADER;
				elsif i_send_frame_req = '1' then
					n_grant_sel    <= '1';
					n_frame_type   <= C_TYPE_CAPTURE;
					n_frame_len    <= unsigned(i_send_frame_len);
					n_crc          <= C_CRC_INIT;
					n_header_index <= 0;
					n_pl_count     <= (others => '0');
					n_state        <= HEADER;
				end if;

			when HEADER =>
				case r_header_index is
					when 0      => v_hdr_byte := C_SYNC0;
					when 1      => v_hdr_byte := C_SYNC1;
					when 2      => v_hdr_byte := C_PROTO_VER;
					when 3      => v_hdr_byte := r_frame_type;
					when 4      => v_hdr_byte := std_logic_vector(r_seq_counter);
					when 5      => v_hdr_byte := std_logic_vector(r_frame_len(7 downto 0));
					when others => v_hdr_byte := std_logic_vector(r_frame_len(15 downto 8));	-- index 6
				end case;

				o_tx_byte    <= v_hdr_byte;
				o_tx_valid   <= '1';
				o_send_grant <= r_grant_sel;
				o_resp_grant <= not r_grant_sel;

				if i_tx_ready = '1' then	-- header byte accepted
					if r_header_index >= 2 then	-- VERSION onward; SYNC0/SYNC1 excluded from CRC
						n_crc <= crc16_next(r_crc, v_hdr_byte);
					end if;

					if r_header_index = 6 then
						if r_frame_len = 0 then
							n_state <= CRC_L;
						else
							n_state <= PAYLOAD;
						end if;
					else
						n_header_index <= r_header_index + 1;
					end if;
				end if;

			when PAYLOAD =>
				o_tx_byte    <= i_pl_byte;
				o_tx_valid   <= i_pl_valid;
				o_pl_ready   <= i_tx_ready;
				o_send_grant <= r_grant_sel;
				o_resp_grant <= not r_grant_sel;

				if i_pl_valid = '1' and i_tx_ready = '1' then	-- payload byte accepted
					n_crc <= crc16_next(r_crc, i_pl_byte);

					if r_pl_count = r_frame_len - 1 then
						n_state <= CRC_L;
					else
						n_pl_count <= r_pl_count + 1;
					end if;
				end if;
				-- else: i_pl_valid dropped (e.g. producer's WAIT_RAM cycle) -- hold. o_tx_valid follows
				-- i_pl_valid low, CRC/counters/state are untouched, and the grant stays asserted above.

			when CRC_L =>
				o_tx_byte    <= r_crc(7 downto 0);
				o_tx_valid   <= '1';
				o_send_grant <= r_grant_sel;
				o_resp_grant <= not r_grant_sel;

				if i_tx_ready = '1' then	-- CRC low byte accepted; not folded into the CRC
					n_state <= CRC_H;
				end if;

			when CRC_H =>
				o_tx_byte    <= r_crc(15 downto 8);
				o_tx_valid   <= '1';
				o_send_grant <= r_grant_sel;
				o_resp_grant <= not r_grant_sel;

				if i_tx_ready = '1' then	-- CRC high byte accepted; frame fully transmitted
					n_seq_counter <= r_seq_counter + 1;
					n_state       <= COMPLETE;
				end if;

			when COMPLETE =>
				n_frame_done_pulse <= '1';
				n_state            <= IDLE;
				-- grants and o_tx_valid already default to '0' above -- dropped this cycle

		end case;
	end process fsm_proc;


	-- Set outputs
	o_frame_done_pulse <= r_frame_done_pulse;

end architecture RTL;
