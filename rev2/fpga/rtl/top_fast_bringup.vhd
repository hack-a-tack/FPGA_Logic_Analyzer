-- ========================================
-- MODULE: top_fast_bringup.vhd
-- FUNCTION: dummy module for testing board programming. NOT YET USED OR FULLY IMPLEMENTED.
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-09-09 (YYYY-MM-DD). UNLESS FURTHER DEVELOPMENT IS DONE, THIS FILE WILL BE REMOVED BEFORE RELEASE.
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
--
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
		o_DBG3				: out std_logic
	);
end entity top;

architecture STRUCTURE of top is

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
