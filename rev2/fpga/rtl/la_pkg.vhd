-- ========================================
-- MODULE: la_pkg.vhd
-- FUNCTION: single source of truth for protocol/framing constants and functions shared across modules (baud timing, CRC, frame layout, opcodes, response codes)
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-08-26 (YYYY-MM-DD)
--
-- NOTES
-- This package is a single source of truth for protocol framing and shared functions. 
-- Adding a frame type, opcode, or response code means editing this file and nothing else.
--
-- t_byte is fixed at 8 bits deliberately. Modules carry a DATA_LENGTH generic, but a UART byte is 8 bits by
-- definition and every constant in this package is a wire-format value, not a module-parameterised one.
--
-- CRC-16/CCITT-FALSE: poly 0x1021, init 0xFFFF, no reflection, xorout 0x0000.
--
-- Frame types (C_TYPE_*) are the TYPE header byte frame_tx/rx_frame_parser put on the wire.
-- Response codes (C_CODE_*) are resp_gen/analyzer_fsm's CODE byte within a STATUS/ERROR response payload. A different field,
-- carried inside the payload of a C_TYPE_STATUS/C_TYPE_ERROR frame, not the frame TYPE itself.
--
-- All status/error codes are accompanied by a detail byte, which is the opcode being acknowledged or rejected. 
-- The detail byte of error code 0xEF is the frame-error subcode (see 6. FRAME ERROR SUBCODES).
-- Wherever no detail byte is relevant, 0x00 is used.
--
-- PREFIXES
-- t_ : type/subtype
-- f_ : function
-- C_ : constant
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package la_pkg is

	-- 1. SUBTYPE
	subtype t_byte is std_logic_vector(7 downto 0);

	-- 2. CLOCK / BAUD
	constant C_SYS_CLK_HZ : positive := 48_000_000;

	function f_clks_per_bit(baud_sel : std_logic_vector(1 downto 0)) return positive;

	-- 3. CRC
	constant C_CRC_INIT : std_logic_vector(15 downto 0) := x"FFFF";

	function crc16_next(crc : std_logic_vector(15 downto 0); data : t_byte) return std_logic_vector;

	-- 4. FRAME CONSTANTS (SYNC0, SYNC1 and VER are same across all frames)
	constant C_SYNC0     : t_byte := x"A5";
	constant C_SYNC1     : t_byte := x"5A";
	constant C_PROTO_VER : t_byte := x"01";

	-- Frame types (the wire TYPE header byte)
	constant C_TYPE_CAPTURE : t_byte := x"01";  -- FPGA -> host, capture-data frame
	constant C_TYPE_STATUS  : t_byte := x"02";  -- FPGA -> host, status frame
	constant C_TYPE_ERROR   : t_byte := x"03";  -- FPGA -> host, error frame
	constant C_TYPE_COMMAND : t_byte := x"10";  -- host -> FPGA, command frame

	-- 5. RESPONSE CODES (the CODE byte within a STATUS/ERROR response payload)
	constant C_CODE_ACK         : t_byte := x"55";  -- status | ACK : accepted, not completed
	constant C_CODE_SEQ_GAP     : t_byte := x"66";  -- status | sequence gap on host -> FPGA frame
	constant C_CODE_DONE        : t_byte := x"77";  -- status | DONE : capture completed
	constant C_CODE_WATCHDOG    : t_byte := x"DD";  -- error | watchdog timeout
	constant C_CODE_ERROR       : t_byte := x"EE";  -- error | general error
	constant C_CODE_FRAME_ERROR : t_byte := x"EF";  -- error | frame rejected (detail byte carries the subcode)

	-- 6. FRAME ERROR SUBCODES (detail byte accompanying C_CODE_FRAME_ERROR)
	constant C_FERR_VERSION : t_byte := x"01";
	constant C_FERR_TYPE    : t_byte := x"02";
	constant C_FERR_LENGTH  : t_byte := x"03";
	constant C_FERR_CRC     : t_byte := x"04";
	constant C_FERR_TIMEOUT : t_byte := x"05";

	-- 7. OPCODES
	constant C_CMD_CAPTURE          : t_byte := x"A0";
	constant C_CMD_READ             : t_byte := x"A1";
	constant C_CMD_UART_BAUD        : t_byte := x"C0";
	constant C_CMD_CAPTURE_WIDTH    : t_byte := x"C1";
	constant C_CMD_SAMP_RATE        : t_byte := x"C2";
	constant C_CMD_CAPTURE_DEPTH    : t_byte := x"C3";
	constant C_CMD_TRIGGER_MODE     : t_byte := x"C4";
	constant C_CMD_EDGE_TRIG_CH     : t_byte := x"C5";
	constant C_CMD_EDGE_TRIG_TYPE   : t_byte := x"C6";
	constant C_CMD_PATTERN_VALUE    : t_byte := x"C7";
	constant C_CMD_PATTERN_MASK     : t_byte := x"C8";
	constant C_CMD_TRIGGER_POSITION : t_byte := x"C9";

	-- 8. FRAME GEOMETRY
	constant C_FRAME_OVERHEAD   : integer := 9;  -- 2 sync + version + type + seq + 2 len + 2 crc
	constant C_META_BYTES       : integer := 7;  -- capture metadata, first 7 payload bytes
	constant C_RESP_PAYLOAD_LEN : integer := 2;  -- response payload: code + detail

end package la_pkg;

package body la_pkg is

	function f_clks_per_bit(baud_sel : std_logic_vector(1 downto 0)) return positive is
	begin
		case baud_sel is
			when "00"   => return 52;  -- 921,600 nominal, actual 923,077, +0.16%
			when "01"   => return 12;  -- 4 Mbaud, exact
			when "10"   => return 8;   -- 6 Mbaud, exact
			when others => return 52;  -- safe fallback to the compatibility rate
		end case;
	end function f_clks_per_bit;


	function crc16_next(crc : std_logic_vector(15 downto 0); data : t_byte) return std_logic_vector is
		variable v_crc : unsigned(15 downto 0);
	begin
		v_crc := unsigned(crc) xor
				 shift_left(resize(unsigned(data), 16), 8);

		for i in 0 to 7 loop
			if v_crc(15) = '1' then
				v_crc := shift_left(v_crc, 1) xor x"1021";
			else
				v_crc := shift_left(v_crc, 1);
			end if;
		end loop;

		return std_logic_vector(v_crc);
	end function crc16_next;

end package body la_pkg;
