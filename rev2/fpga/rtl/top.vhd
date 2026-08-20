-- ========================================
-- MODULE: top.vhd
-- FUNCTION: ties all underlying modules together
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-05-25 (YYYY-MM-DD)
-- MODIFIED: 2026-06-06
-- MODIFIED: 2026-08-19 (rev2 integration: full rewrite against the current rev2 module set; see TOP_TODO.md)
--
-- INPUTS 					DATA		TO INTERNAL MODULE
-- i_LA0					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA1					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA2					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA3					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA4					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA5					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA6					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA7					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA8					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA9					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA10					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA11					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA12					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA13					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA14					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_LA15					1 bit		-> capture_engine (transmitted as 16-bit ANALYZER_INPUTS, inverted)
-- i_UART_RX				1 bit		-> uart_rx
-- i_FTDI_CTS_N				1 bit		-> top (de-inverted to s_usb_can_accept_tx_byte, then uart_tx)
--
-- OUTPUTS					DATA		FROM INTERNAL MODULE
-- o_UART_TX				1 bit		<- uart_tx
-- o_UART_TX_LED			1 bit		<- uart_tx
-- o_UART_RX_LED			1 bit		<- uart_rx
-- o_USER_LED				1 bit		<- analyzer_fsm
-- o_DBG0					1 bit		<- clocking (SAMP_TICK)
-- o_DBG1					1 bit		<- frame_tx (FRAME_DONE_PULSE)
-- o_DBG2					1 bit		<- resp_gen (RESP_OVERFLOW)
-- o_DBG3					1 bit		<- send_engine (SEND_FRAME_REQ)
-- o_FTDI_RTS_N				1 bit		<- top (tied asserted, see NOTES)
--
-- NOTES
-- There is no runtime reset pin on Rev2. i_RESET (Rev1) was wired to CRESET_B, which is a dedicated configuration
-- pin: pressing it reconfigures the FPGA rather than delivering a reset to user logic. Treating it as a VHDL reset
-- input was the Rev1 confusion this rewrite drops. Instead, r_rst_pipe generates an internal startup reset:
-- 4 clocks after configuration, s_rst_n rises and stays high. Pressing CRESET_B reconfigures the FPGA, which
-- restarts this sequence from scratch, so there is no separate runtime reset path to maintain.
--
-- s_rst_n is routed to every module that has an i_rst_n port. Two modules do not: clocking.vhd has no clock/reset
-- port at all (it free-runs from SB_HFOSC and only needs defined power-on values, which its signal initialisers
-- already provide), and tx_mux.vhd is purely combinational (no i_clk either). Neither omission is a defect; there
-- is simply nothing in either module for a reset to do.
--
-- ANALYZER_INPUTS inverts all 16 channels. Three SN74LVC14A Schmitt-trigger buffers on the board invert, and this
-- normalises once at the top-level boundary so all downstream RTL reasons in terms of true external logic state.
-- If this inversion is lost, every capture returns inverted data and every pattern trigger matches the complement
-- of what was asked for -- and the trigger logic would be the first thing wrongly blamed. Verify explicitly.
--
-- FTDI flow control: i_FTDI_CTS_N is active low; s_usb_can_accept_tx_byte <= not i_FTDI_CTS_N de-inverts it to
-- uart_tx's meaning-based input. o_FTDI_RTS_N is tied asserted ('0') rather than driven from any module: rx_frame_parser
-- buffers a whole frame before releasing it, and host->FPGA traffic is a few bytes per command, so the FPGA can
-- always accept. This is deliberate, not an oversight.
--
-- trace_buffer.i_capture_width_sel is driven from capture_engine.o_capture_width_sel (the value LATCHED for the
-- capture in progress), not directly from config_regs.o_cfg_capture_width_sel (the live, currently-configured
-- value). config_regs accepts config writes again once a capture reaches DATA_READY, so if trace_buffer read the
-- live value, a host that reconfigures capture width between a CAPTURE and the following READ would desync
-- trace_buffer's bank decoding from how the data was actually written. capture_engine.o_capture_width_sel already
-- exists for exactly this reason and fans out to both send_engine and trace_buffer -- see capture_engine.vhd's own
-- OUTPUTS table and trace_buffer.vhd's own INPUTS table, both of which already document the source as
-- capture_engine, not config_regs.
--
-- rx_frame_parser G_BYPASS is TRUE for bring-up: the host-side Python does not frame commands yet, so bypass keeps
-- the link usable (raw byte passthrough, no framing, no CRC) while that work is pending. THIS MUST BECOME FALSE
-- BEFORE RELEASE -- do not ship bypass mode.
--
-- PREFIXES
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- s_ : output-only signal 	(driven by a dedicated process/concurrent statement in this file, not by a submodule)
--
-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use WORK.la_pkg.ALL;

entity top is
	generic (
		C_BYTE_WIDTH    : integer := 8;		-- UART/protocol byte path
		C_CAPTURE_WIDTH : integer := 16;		-- parallel capture word
		C_ADDR_LENGTH   : integer := 14		-- 12288 logical samples
	);
	port (
		i_LA0				: in  std_logic;
		i_LA1				: in  std_logic;
		i_LA2				: in  std_logic;
		i_LA3				: in  std_logic;
		i_LA4				: in  std_logic;
		i_LA5				: in  std_logic;
		i_LA6				: in  std_logic;
		i_LA7				: in  std_logic;
		i_LA8				: in  std_logic;
		i_LA9				: in  std_logic;
		i_LA10				: in  std_logic;
		i_LA11				: in  std_logic;
		i_LA12				: in  std_logic;
		i_LA13				: in  std_logic;
		i_LA14				: in  std_logic;
		i_LA15				: in  std_logic;
		i_UART_RX 			: in  std_logic;

		-- FTDI FT2232H flow control
		i_FTDI_CTS_N		: in  std_logic;	-- active low
		o_FTDI_RTS_N		: out std_logic;	-- active low

		o_UART_TX			: out std_logic;
		o_UART_TX_LED		: out std_logic;
		o_UART_RX_LED		: out std_logic;
		o_USER_LED			: out std_logic;
		o_DBG0				: out std_logic;
		o_DBG1				: out std_logic;
		o_DBG2				: out std_logic;
		o_DBG3				: out std_logic
	);
end entity top;

architecture STRUCTURE of top is
	----------------------
	-- INTERNAL SIGNALS --
	----------------------

	-- STARTUP RESET
	signal r_rst_pipe	: std_logic_vector(3 downto 0) := (others => '0');		-- driven by top
	signal s_rst_n		: std_logic;											-- driven by top

	-- CLOCKING
	signal CLK 			: std_logic;											-- driven by clocking
	signal SAMP_TICK 	: std_logic;											-- driven by clocking

	-- SAMPLING
	signal ANALYZER_INPUTS	: std_logic_vector(C_CAPTURE_WIDTH-1 downto 0);		-- driven by top (LVC14 inversion)

	-- FTDI FLOW CONTROL
	signal s_usb_can_accept_tx_byte : std_logic;									-- driven by top (de-inverted from i_FTDI_CTS_N)

	-- RX: UART_RX --> RX_FRAME_PARSER --> CMD_PARSER --> CONFIG_REGS, ANALYZER_FSM
	signal RX_BYTE 				: std_logic_vector(C_BYTE_WIDTH-1 downto 0);	-- driven by uart_rx
	signal RX_VALID_PULSE 			: std_logic;									-- driven by uart_rx
	signal FRAME_RX_BYTE 			: std_logic_vector(C_BYTE_WIDTH-1 downto 0);	-- driven by rx_frame_parser
	signal FRAME_RX_VALID_PULSE 	: std_logic;									-- driven by rx_frame_parser
	signal FRAME_ERROR_PULSE 		: std_logic;									-- driven by rx_frame_parser
	signal FRAME_ERROR_CODE 		: std_logic_vector(C_BYTE_WIDTH-1 downto 0);	-- driven by rx_frame_parser
	signal SEQ_GAP_PULSE 			: std_logic;									-- driven by rx_frame_parser
	signal CAPTURE_PULSE 			: std_logic;									-- driven by cmd_parser
	signal READ_PULSE 				: std_logic;									-- driven by cmd_parser
	signal ERROR_PULSE 				: std_logic;								-- driven by cmd_parser
	signal CMD_OPCODE 				: std_logic_vector(C_BYTE_WIDTH-1 downto 0);	-- driven by cmd_parser
	signal CFG_WRITE_PULSE 			: std_logic;								-- driven by cmd_parser
	signal CFG_OPCODE 				: std_logic_vector(C_BYTE_WIDTH-1 downto 0);	-- driven by cmd_parser
	signal CFG_VALUE 				: std_logic_vector(2*C_BYTE_WIDTH-1 downto 0);	-- driven by cmd_parser

	-- CONFIG_REGS <--> ANALYZER_FSM
	signal CFG_ACK_PULSE 			: std_logic;									-- driven by config_regs
	signal CFG_ERROR_PULSE 			: std_logic;								-- driven by config_regs
	signal CONFIG_WRITE_ALLOWED 	: std_logic;									-- driven by analyzer_fsm

	-- CONFIG_REGS --> CLOCKING, CAPTURE_ENGINE, TRACE_BUFFER, UART_RX, UART_TX
	signal CFG_UART_BAUD_SEL 		: std_logic_vector(1 downto 0);				-- driven by config_regs
	signal CFG_SAMPLE_RATE_SEL 		: std_logic_vector(1 downto 0);			-- driven by config_regs
	signal CFG_CAPTURE_WIDTH_SEL 	: std_logic;									-- driven by config_regs (to capture_engine ONLY -- see NOTES)
	signal CFG_CAPTURE_DEPTH_SEL 	: std_logic;									-- driven by config_regs
	signal CFG_TRIGGER_MODE 		: std_logic_vector(1 downto 0);				-- driven by config_regs
	signal CFG_EDGE_TRIGGER_CH 		: std_logic_vector(3 downto 0);			-- driven by config_regs
	signal CFG_EDGE_TRIGGER_TYPE 	: std_logic_vector(1 downto 0);				-- driven by config_regs
	signal CFG_PATTERN_VALUE 		: std_logic_vector(15 downto 0);				-- driven by config_regs
	signal CFG_PATTERN_MASK 		: std_logic_vector(15 downto 0);				-- driven by config_regs
	signal CFG_TRIGGER_POS 			: std_logic_vector(1 downto 0);			-- driven by config_regs

	-- Baud changeover commit point: config_regs <-- uart_tx, resp_gen, rx_frame_parser
	signal UART_TX_IDLE 			: std_logic;									-- driven by uart_tx
	signal RESP_IDLE 				: std_logic;									-- driven by resp_gen

	-- DATA CAPTURE AND TRANSFER: ANALYZER_FSM <--> CAPTURE_ENGINE, SEND_ENGINE
	signal CAPTURE_START_PULSE 	: std_logic;									-- driven by analyzer_fsm
	signal CAPTURE_DONE_PULSE 	: std_logic;										-- driven by capture_engine
	signal SEND_START_PULSE 	: std_logic;										-- driven by analyzer_fsm
	signal SEND_DONE_PULSE 		: std_logic;									-- driven by send_engine

	-- ANALYZER_FSM --> RESP_GEN
	signal RESP_REQ 		: std_logic;											-- driven by analyzer_fsm
	signal RESP_TYPE 		: std_logic_vector(C_BYTE_WIDTH-1 downto 0);			-- driven by analyzer_fsm
	signal RESP_CODE 		: std_logic_vector(C_BYTE_WIDTH-1 downto 0);			-- driven by analyzer_fsm
	signal RESP_DETAIL 		: std_logic_vector(C_BYTE_WIDTH-1 downto 0);		-- driven by analyzer_fsm
	signal RESP_OVERFLOW 	: std_logic;											-- driven by resp_gen

	-- RAM RELATED: CAPTURE_ENGINE <--> TRACE_BUFFER <--> SEND_ENGINE
	signal WR_EN_PULSE	: std_logic;												-- driven by capture_engine
	signal WR_ADDR 		: std_logic_vector(C_ADDR_LENGTH-1 downto 0);			-- driven by capture_engine
	signal WR_DATA 		: std_logic_vector(C_CAPTURE_WIDTH-1 downto 0);		-- driven by capture_engine
	signal RD_DATA 		: std_logic_vector(C_CAPTURE_WIDTH-1 downto 0);		-- driven by trace_buffer
	signal RD_ADDR 		: std_logic_vector(C_ADDR_LENGTH-1 downto 0);			-- driven by send_engine

	-- CAPTURE_ENGINE --> SEND_ENGINE (capture metadata)
	signal CAPTURE_SAMPLE_RATE_SEL	: std_logic_vector(1 downto 0);				-- driven by capture_engine
	signal CAPTURE_TRIGGER_MODE 	: std_logic_vector(1 downto 0);				-- driven by capture_engine
	signal CAPTURE_TRIGGER_INDEX 	: std_logic_vector(15 downto 0);				-- driven by capture_engine
	signal CAPTURE_START_ADDR 		: std_logic_vector(C_ADDR_LENGTH-1 downto 0);	-- driven by capture_engine
	signal CAPTURE_SAMPLE_COUNT 	: std_logic_vector(C_ADDR_LENGTH-1 downto 0);	-- driven by capture_engine
	signal CAPTURE_WIDTH_SEL 		: std_logic;									-- driven by capture_engine (latched; to send_engine AND trace_buffer, see NOTES)

	-- TX: SEND_ENGINE, RESP_GEN --> TX_MUX --> FRAME_TX --> UART_TX
	signal SEND_PL_BYTE 	: std_logic_vector(C_BYTE_WIDTH-1 downto 0);			-- driven by send_engine
	signal SEND_PL_VALID 	: std_logic;											-- driven by send_engine
	signal SEND_PL_READY 	: std_logic;											-- driven by tx_mux
	signal RESP_PL_BYTE 	: std_logic_vector(C_BYTE_WIDTH-1 downto 0);			-- driven by resp_gen
	signal RESP_PL_VALID 	: std_logic;											-- driven by resp_gen
	signal RESP_PL_READY 	: std_logic;											-- driven by tx_mux
	signal GRANT_SEL 		: std_logic;											-- driven by frame_tx
	signal MUX_PL_BYTE 		: std_logic_vector(C_BYTE_WIDTH-1 downto 0);		-- driven by tx_mux
	signal MUX_PL_VALID 	: std_logic;											-- driven by tx_mux
	signal MUX_PL_READY 	: std_logic;											-- driven by frame_tx

	signal SEND_FRAME_REQ 	: std_logic;											-- driven by send_engine
	signal SEND_FRAME_LEN 	: std_logic_vector(15 downto 0);						-- driven by send_engine
	signal SEND_GRANT 		: std_logic;											-- driven by frame_tx
	signal RESP_FRAME_REQ 	: std_logic;											-- driven by resp_gen
	signal RESP_FRAME_LEN 	: std_logic_vector(15 downto 0);						-- driven by resp_gen
	signal RESP_FRAME_TYPE 	: std_logic_vector(C_BYTE_WIDTH-1 downto 0);		-- driven by resp_gen
	signal RESP_GRANT 		: std_logic;											-- driven by frame_tx
	signal FRAME_DONE_PULSE	: std_logic;										-- driven by frame_tx (fans out to send_engine AND resp_gen)

	signal TX_BYTE 			: std_logic_vector(C_BYTE_WIDTH-1 downto 0);		-- driven by frame_tx
	signal TX_VALID 		: std_logic;											-- driven by frame_tx
	signal UART_TX_READY 	: std_logic;											-- driven by uart_tx

begin
	-- Startup reset: no runtime reset pin exists on Rev2 (see NOTES). 4 clocks after configuration, s_rst_n rises
	-- and stays high until the next CRESET_B reconfiguration restarts the sequence.
	rst_pipe_proc: process(CLK) is
	begin
		if rising_edge(CLK) then
			r_rst_pipe <= r_rst_pipe(2 downto 0) & '1';
		end if;
	end process rst_pipe_proc;
	s_rst_n <= r_rst_pipe(3);

	-- LVC14 inversion: normalise all 16 channels once, at the boundary. See NOTES.
	ANALYZER_INPUTS <= 	(not i_LA15) &
						(not i_LA14) &
						(not i_LA13) &
						(not i_LA12) &
						(not i_LA11) &
						(not i_LA10) &
						(not i_LA9) &
						(not i_LA8) &
						(not i_LA7) &
						(not i_LA6) &
						(not i_LA5) &
						(not i_LA4) &
						(not i_LA3) &
						(not i_LA2) &
						(not i_LA1) &
						(not i_LA0);

	-- FTDI flow control: de-invert CTS#; tie RTS# asserted. See NOTES.
	s_usb_can_accept_tx_byte <= not i_FTDI_CTS_N;
	o_FTDI_RTS_N <= '0';	-- tied asserted: the FPGA can always accept (rx_frame_parser buffers a whole frame; host->FPGA traffic is a few bytes per command)

	-- Debug header outputs
	o_DBG0 <= SAMP_TICK;
	o_DBG1 <= FRAME_DONE_PULSE;
	o_DBG2 <= RESP_OVERFLOW;
	o_DBG3 <= SEND_FRAME_REQ;

	E1: entity WORK.clocking(RTL)
		port map (
			i_cfg_sample_rate_sel	=> CFG_SAMPLE_RATE_SEL,
			o_clk 					=> CLK,
			o_samp_tick 			=> SAMP_TICK
		);

	E2: entity WORK.uart_rx(RTL)
		generic map (
			DATA_LENGTH => C_BYTE_WIDTH
		)
		port map (
			i_clk 				=> CLK,
			i_rst_n 			=> s_rst_n,
			i_UART_RX 			=> i_UART_RX,
			i_baud_sel			=> CFG_UART_BAUD_SEL,
			o_rx_byte 			=> RX_BYTE,
			o_rx_valid_pulse 	=> RX_VALID_PULSE,
			o_UART_RX_LED 		=> o_UART_RX_LED
		);

	E3: entity WORK.rx_frame_parser(RTL)
		generic map (
			DATA_LENGTH      => C_BYTE_WIDTH,
			G_MAX_PAYLOAD    => 8,
			G_TIMEOUT_CYCLES => 48_000,
			G_BYPASS         => true	-- MUST become false before release, see NOTES
		)
		port map (
			i_clk					=> CLK,
			i_rst_n					=> s_rst_n,
			i_rx_byte				=> RX_BYTE,
			i_rx_valid_pulse		=> RX_VALID_PULSE,
			o_rx_byte				=> FRAME_RX_BYTE,
			o_rx_valid_pulse		=> FRAME_RX_VALID_PULSE,
			o_frame_error_pulse	=> FRAME_ERROR_PULSE,
			o_frame_error_code		=> FRAME_ERROR_CODE,
			o_seq_gap_pulse			=> SEQ_GAP_PULSE
		);

	E4: entity WORK.cmd_parser(RTL)
		generic map (
			DATA_LENGTH		 => C_BYTE_WIDTH,
			G_TIMEOUT_CYCLES => 48_000
		)
		port map (
			i_clk 				=> CLK,
			i_rst_n 			=> s_rst_n,
			i_rx_byte 			=> FRAME_RX_BYTE,
			i_rx_valid_pulse 	=> FRAME_RX_VALID_PULSE,
			o_capture_cmd_pulse => CAPTURE_PULSE,
			o_read_cmd_pulse 	=> READ_PULSE,
			o_cmd_error_pulse 	=> ERROR_PULSE,
			o_cmd_opcode		=> CMD_OPCODE,
			o_cfg_write_pulse	=> CFG_WRITE_PULSE,
			o_cfg_opcode		=> CFG_OPCODE,
			o_cfg_value			=> CFG_VALUE
		);

	E5: entity WORK.config_regs(RTL)
		generic map (
			G_BAUD_CONFIRM_CYCLES => 24_000_000
		)
		port map (
			i_clk					=> CLK,
			i_rst_n					=> s_rst_n,
			i_cfg_write_pulse		=> CFG_WRITE_PULSE,
			i_cfg_opcode			=> CFG_OPCODE,
			i_cfg_value				=> CFG_VALUE,
			i_config_write_allowed	=> CONFIG_WRITE_ALLOWED,
			i_tx_idle				=> UART_TX_IDLE,
			i_resp_idle				=> RESP_IDLE,
			i_rx_byte_valid_pulse	=> FRAME_RX_VALID_PULSE,
			o_cfg_uart_baud_sel		=> CFG_UART_BAUD_SEL,
			o_cfg_capture_width_sel	=> CFG_CAPTURE_WIDTH_SEL,
			o_cfg_sample_rate_sel	=> CFG_SAMPLE_RATE_SEL,
			o_cfg_capture_depth_sel	=> CFG_CAPTURE_DEPTH_SEL,
			o_cfg_trigger_mode		=> CFG_TRIGGER_MODE,
			o_cfg_edge_trigger_ch	=> CFG_EDGE_TRIGGER_CH,
			o_cfg_edge_trigger_type	=> CFG_EDGE_TRIGGER_TYPE,
			o_cfg_pattern_value		=> CFG_PATTERN_VALUE,
			o_cfg_pattern_mask		=> CFG_PATTERN_MASK,
			o_cfg_trigger_pos		=> CFG_TRIGGER_POS,
			o_cfg_ack_pulse			=> CFG_ACK_PULSE,
			o_cfg_error_pulse		=> CFG_ERROR_PULSE
		);

	E6: entity WORK.analyzer_fsm(RTL)
		generic map (
			DATA_LENGTH	=> C_BYTE_WIDTH
		)
		port map (
			i_clk 					=> CLK,
			i_rst_n 				=> s_rst_n,
			i_cmd_error_pulse 		=> ERROR_PULSE,
			i_capture_cmd_pulse 	=> CAPTURE_PULSE,
			i_capture_done_pulse 	=> CAPTURE_DONE_PULSE,
			i_read_cmd_pulse 		=> READ_PULSE,
			i_send_done_pulse 		=> SEND_DONE_PULSE,
			i_cfg_ack_pulse			=> CFG_ACK_PULSE,
			i_cfg_error_pulse		=> CFG_ERROR_PULSE,
			o_config_write_allowed	=> CONFIG_WRITE_ALLOWED,
			i_cmd_opcode			=> CMD_OPCODE,
			i_frame_error_pulse		=> FRAME_ERROR_PULSE,
			i_frame_error_code		=> FRAME_ERROR_CODE,
			i_seq_gap_pulse			=> SEQ_GAP_PULSE,
			o_capture_start_pulse 	=> CAPTURE_START_PULSE,
			o_send_start_pulse 		=> SEND_START_PULSE,
			o_resp_req				=> RESP_REQ,
			o_resp_type				=> RESP_TYPE,
			o_resp_code				=> RESP_CODE,
			o_resp_detail			=> RESP_DETAIL,
			o_USER_LED 				=> o_USER_LED
		);

	E7: entity WORK.capture_engine(RTL)
		generic map (
			ADDR_LENGTH	=> C_ADDR_LENGTH
		)
		port map (
			i_clk 					=> CLK,
			i_samp_tick 			=> SAMP_TICK,
			i_rst_n 				=> s_rst_n,
			i_capture_start_pulse 	=> CAPTURE_START_PULSE,
			i_inputs 				=> ANALYZER_INPUTS,
			i_cfg_sample_rate_sel	=> CFG_SAMPLE_RATE_SEL,
			i_cfg_capture_width_sel	=> CFG_CAPTURE_WIDTH_SEL,
			i_cfg_capture_depth_sel	=> CFG_CAPTURE_DEPTH_SEL,
			i_cfg_trigger_mode		=> CFG_TRIGGER_MODE,
			i_cfg_edge_trigger_ch	=> CFG_EDGE_TRIGGER_CH,
			i_cfg_edge_trigger_type	=> CFG_EDGE_TRIGGER_TYPE,
			i_cfg_pattern_value		=> CFG_PATTERN_VALUE,
			i_cfg_pattern_mask		=> CFG_PATTERN_MASK,
			i_cfg_trigger_pos		=> CFG_TRIGGER_POS,
			o_raw_wr_en_pulse		=> WR_EN_PULSE,
			o_raw_wr_addr			=> WR_ADDR,
			o_raw_wr_data			=> WR_DATA,
			o_capture_done_pulse 	=> CAPTURE_DONE_PULSE,
			o_capture_sample_rate_sel	=> CAPTURE_SAMPLE_RATE_SEL,
			o_capture_trigger_mode		=> CAPTURE_TRIGGER_MODE,
			o_capture_trigger_index		=> CAPTURE_TRIGGER_INDEX,
			o_capture_start_addr		=> CAPTURE_START_ADDR,
			o_capture_sample_count		=> CAPTURE_SAMPLE_COUNT,
			o_capture_width_sel		=> CAPTURE_WIDTH_SEL
		);

	E8: entity WORK.trace_buffer(RTL)
		generic map (
			ADDR_LENGTH	=> C_ADDR_LENGTH
		)
		port map (
			i_clk				=> CLK,
			i_rst_n				=> s_rst_n,
			i_capture_width_sel	=> CAPTURE_WIDTH_SEL,	-- from capture_engine (latched), NOT config_regs
			i_ram_wr_en_pulse	=> WR_EN_PULSE,
			i_ram_wr_addr		=> WR_ADDR,
			i_ram_wr_data		=> WR_DATA,
			i_ram_rd_addr		=> RD_ADDR,
			o_ram_rd_data		=> RD_DATA
		);

	E9: entity WORK.send_engine(RTL)
		generic map (
			ADDR_LENGTH	=> C_ADDR_LENGTH,
			DATA_LENGTH	=> C_BYTE_WIDTH
		)
		port map (
			i_clk						=> CLK,
			i_rst_n						=> s_rst_n,
			i_send_start_pulse			=> SEND_START_PULSE,
			i_capture_sample_rate_sel	=> CAPTURE_SAMPLE_RATE_SEL,
			i_capture_trigger_mode		=> CAPTURE_TRIGGER_MODE,
			i_capture_trigger_index		=> CAPTURE_TRIGGER_INDEX,
			i_capture_start_addr		=> CAPTURE_START_ADDR,
			i_capture_sample_count		=> CAPTURE_SAMPLE_COUNT,
			i_capture_width_sel			=> CAPTURE_WIDTH_SEL,
			i_ram_rd_data				=> RD_DATA,
			o_ram_rd_addr				=> RD_ADDR,
			o_send_frame_req			=> SEND_FRAME_REQ,
			o_send_frame_len			=> SEND_FRAME_LEN,
			i_send_grant				=> SEND_GRANT,
			i_frame_done_pulse			=> FRAME_DONE_PULSE,
			o_pl_byte					=> SEND_PL_BYTE,
			o_pl_valid					=> SEND_PL_VALID,
			i_pl_ready					=> SEND_PL_READY,
			o_send_done_pulse			=> SEND_DONE_PULSE
		);

	E10: entity WORK.resp_gen(RTL)
		generic map (
			DATA_LENGTH => C_BYTE_WIDTH,
			QUEUE_DEPTH => 4
		)
		port map (
			i_clk				=> CLK,
			i_rst_n				=> s_rst_n,
			i_resp_req			=> RESP_REQ,
			i_resp_type			=> RESP_TYPE,
			i_resp_code			=> RESP_CODE,
			i_resp_detail		=> RESP_DETAIL,
			o_resp_overflow		=> RESP_OVERFLOW,
			o_resp_frame_req	=> RESP_FRAME_REQ,
			o_resp_frame_len	=> RESP_FRAME_LEN,
			o_resp_frame_type	=> RESP_FRAME_TYPE,
			i_resp_grant		=> RESP_GRANT,
			i_frame_done_pulse	=> FRAME_DONE_PULSE,
			o_pl_byte			=> RESP_PL_BYTE,
			o_pl_valid			=> RESP_PL_VALID,
			i_pl_ready			=> RESP_PL_READY,
			o_resp_idle			=> RESP_IDLE
		);

	E11: entity WORK.tx_mux(RTL)
		generic map (
			DATA_LENGTH	=> C_BYTE_WIDTH
		)
		port map (
			i_resp_pl_byte		=> RESP_PL_BYTE,
			i_resp_pl_valid		=> RESP_PL_VALID,
			o_resp_pl_ready		=> RESP_PL_READY,
			i_send_pl_byte		=> SEND_PL_BYTE,
			i_send_pl_valid		=> SEND_PL_VALID,
			o_send_pl_ready		=> SEND_PL_READY,
			i_grant_sel			=> GRANT_SEL,
			i_pl_ready			=> MUX_PL_READY,
			o_pl_byte			=> MUX_PL_BYTE,
			o_pl_valid			=> MUX_PL_VALID
		);

	E12: entity WORK.frame_tx(RTL)
		generic map (
			DATA_LENGTH	=> C_BYTE_WIDTH
		)
		port map (
			i_clk				=> CLK,
			i_rst_n				=> s_rst_n,
			i_send_frame_req	=> SEND_FRAME_REQ,
			i_send_frame_len	=> SEND_FRAME_LEN,
			i_resp_frame_req	=> RESP_FRAME_REQ,
			i_resp_frame_len	=> RESP_FRAME_LEN,
			i_resp_frame_type	=> RESP_FRAME_TYPE,
			i_pl_byte			=> MUX_PL_BYTE,
			i_pl_valid			=> MUX_PL_VALID,
			o_pl_ready			=> MUX_PL_READY,
			o_grant_sel			=> GRANT_SEL,
			o_send_grant		=> SEND_GRANT,
			o_resp_grant		=> RESP_GRANT,
			o_frame_done_pulse	=> FRAME_DONE_PULSE,
			o_tx_byte			=> TX_BYTE,
			o_tx_valid			=> TX_VALID,
			i_tx_ready			=> UART_TX_READY
		);

	E13: entity WORK.uart_tx(RTL)
		generic map (
			DATA_LENGTH => C_BYTE_WIDTH
		)
		port map (
			i_clk						=> CLK,
			i_rst_n						=> s_rst_n,
			i_mux_tx_byte				=> TX_BYTE,
			i_mux_tx_valid				=> TX_VALID,
			o_uart_tx_ready				=> UART_TX_READY,
			o_tx_idle					=> UART_TX_IDLE,
			i_baud_sel					=> CFG_UART_BAUD_SEL,
			i_usb_can_accept_tx_byte	=> s_usb_can_accept_tx_byte,
			o_UART_TX					=> o_UART_TX,
			o_UART_TX_LED				=> o_UART_TX_LED
		);

end architecture STRUCTURE;
