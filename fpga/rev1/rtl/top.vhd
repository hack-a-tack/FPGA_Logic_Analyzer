-- ========================================
-- MODULE: top.vhd
-- FUNCTION: ties all underlying modules together
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-14 (YYYY-MM-DD)
--
-- INPUTS 					DATA		TO INTERNAL MODULE
-- i_UART_RX				1 bit		-> uart_rx
-- i_ANALYZER_INPUTS		8 bits		-> capture_engine
-- i_RESET					1 bit		-> uart_rx | cmd_parser | analyzer_fsm | capture_engine | send_engine | tx_mux | uart_tx
--
-- OUTPUTS					DATA		FROM INTERNAL MODULE
-- o_UART_TX				1 bit		<- uart_tx
-- o_UART_TX_LED			1 bit		<- uart_tx
-- o_UART_RX_LED			1 bit		<- uart_rx
-- o_USER_LED				1 bit		<- analyzer_fsm
--
-- NOTES
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
	generic (
		CLK_FREQ_HZ : integer := 48_000_000;
		BAUD_RATE 	: integer := 921600;
		ADDR_LENGTH : integer := 12;
		NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 4096
		DATA_LENGTH : integer := 8		
	);
	port (
		i_UART_RX 			: in  std_logic;
		i_ANALYZER_INPUTS	: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_RESET  			: in  std_logic;
		o_UART_TX			: out std_logic;
		o_UART_TX_LED		: out std_logic;
		o_UART_RX_LED		: out std_logic;
		o_USER_LED			: out std_logic
	);
end entity top;
	
architecture STRUCTURE of top is
	----------------------
	-- INTERNAL SIGNALS --
	----------------------
	
	-- CLOCKING
	signal CLK 			: std_logic;
	signal SAMP_TICK 	: std_logic;
	
	-- RX: UART_RX --> CMD_PARSER --> ANALYZER_FSM
	signal RX_BYTE 			: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal RX_VALID_PULSE 	: std_logic;
	signal CAPTURE_PULSE 	: std_logic;
	signal READ_PULSE 		: std_logic;
	signal ERROR_PULSE 		: std_logic;
	
	-- DATA CAPTURE AND TRANSFER: ANALYZER_FSM <--> CAPTURE_ENGINE, SEND_ENGINE
	signal CAPTURE_START_PULSE 	: std_logic;
	signal CAPTURE_DONE_PULSE 	: std_logic;
	signal SEND_START_PULSE 	: std_logic;
	signal SEND_DONE_PULSE 		: std_logic;
	
	-- TX: UART_TX, TX_MUX <--> ANALYZER_FSM, SEND_ENGINE
	signal FSM_TX_STATUS_BYTE 	: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal FSM_TX_START_PULSE 	: std_logic;
	signal SEND_TX_BYTE 		: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal SEND_TX_START_PULSE 	: std_logic;
	signal MUX_TX_BYTE 			: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal MUX_TX_START_PULSE 	: std_logic;
	signal TX_BUSY 				: std_logic;
	
	-- RAM RELATED: TRACE_BUFFER <--> CAPTURE_ENGINE, SEND_ENGINE
	signal WR_EN_PULSE	: std_logic;
	signal WR_ADDR 		: std_logic_vector(ADDR_LENGTH-1 downto 0);
	signal WR_DATA 		: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal RD_DATA 		: std_logic_vector(DATA_LENGTH-1 downto 0);
	signal RD_ADDR 		: std_logic_vector(ADDR_LENGTH-1 downto 0);
	
begin
	E1: entity WORK.clocking(RTL)
		port map (
			o_clk 		=> CLK,
			o_samp_tick => SAMP_TICK
		);
	
	E2: entity WORK.uart_rx(RTL)
		generic map (
			CLK_FREQ_HZ => CLK_FREQ_HZ,
			BAUD_RATE 	=> BAUD_RATE,
			DATA_LENGTH => DATA_LENGTH
		)
		port map (
			i_clk 				=> CLK,
			i_rst 				=> i_RESET,
			i_UART_RX 			=> i_UART_RX,
			o_rx_byte 			=> RX_BYTE,
			o_rx_valid_pulse 	=> RX_VALID_PULSE,
			o_UART_RX_LED 		=> o_UART_RX_LED
		);
		
	E3: entity WORK.cmd_parser(RTL)
		generic map (
			DATA_LENGTH	=> DATA_LENGTH
		)
		port map (
			i_clk 				=> CLK,
			i_rst 				=> i_RESET,
			i_rx_byte 			=> RX_BYTE,
			i_rx_valid_pulse 	=> RX_VALID_PULSE,
			o_capture_cmd_pulse => CAPTURE_PULSE,
			o_read_cmd_pulse 	=> READ_PULSE,
			o_cmd_error_pulse 	=> ERROR_PULSE
		);
		
	E4: entity WORK.analyzer_fsm(RTL)
		generic map (
			DATA_LENGTH	=> DATA_LENGTH
		)
		port map (
			i_clk 					=> CLK,
			i_samp_tick 			=> SAMP_TICK,
			i_rst 					=> i_RESET,
			i_cmd_error_pulse 		=> ERROR_PULSE,
			i_capture_cmd_pulse 	=> CAPTURE_PULSE,
			i_capture_done_pulse 	=> CAPTURE_DONE_PULSE,
			i_read_cmd_pulse 		=> READ_PULSE,
			i_send_done_pulse 		=> SEND_DONE_PULSE,
			i_tx_busy 				=> TX_BUSY,
			o_capture_start_pulse 	=> CAPTURE_START_PULSE,
			o_send_start_pulse 		=> SEND_START_PULSE,
			o_fsm_tx_status_byte 	=> FSM_TX_STATUS_BYTE,
			o_fsm_tx_start_pulse 	=> FSM_TX_START_PULSE,
			o_USER_LED 				=> o_USER_LED
		);
		
	E5: entity WORK.capture_engine(RTL)
		generic map (
			ADDR_LENGTH	=> ADDR_LENGTH,
			NUM_SAMPLES => NUM_SAMPLES,
			DATA_LENGTH	=> DATA_LENGTH
		)
		port map (
			i_clk 					=> CLK,
			i_samp_tick 			=> SAMP_TICK,
			i_rst 					=> i_RESET,
			i_capture_start_pulse 	=> CAPTURE_START_PULSE,
			i_inputs 				=> i_ANALYZER_INPUTS,
			o_raw_wr_en_pulse		=> WR_EN_PULSE,
			o_raw_wr_addr			=> WR_ADDR,
			o_raw_wr_data			=> WR_DATA,
			o_capture_done_pulse 	=> CAPTURE_DONE_PULSE
		);
		
	E6: entity WORK.send_engine(RTL)
		generic map (
			ADDR_LENGTH	=> ADDR_LENGTH,
			NUM_SAMPLES => NUM_SAMPLES,
			DATA_LENGTH	=> DATA_LENGTH
		)
		port map (
			i_clk					=> CLK,
			i_rst					=> i_RESET,
			i_send_start_pulse		=> SEND_START_PULSE,
			i_tx_busy				=> TX_BUSY,
			i_ram_rd_data			=> RD_DATA,
			o_ram_rd_addr			=> RD_ADDR,
			o_send_tx_byte			=> SEND_TX_BYTE,
			o_send_tx_start_pulse	=> SEND_TX_START_PULSE,
			o_send_done_pulse		=> SEND_DONE_PULSE
		);
		
	E7: entity WORK.trace_buffer(RTL)
		generic map (
			ADDR_LENGTH	=> ADDR_LENGTH,
			NUM_SAMPLES => NUM_SAMPLES,
			DATA_LENGTH	=> DATA_LENGTH
		)
		port map (
			i_clk				=> CLK,
			i_rst				=> i_RESET,
			i_ram_wr_en_pulse	=> WR_EN_PULSE,
			i_ram_wr_addr		=> WR_ADDR,
			i_ram_wr_data		=> WR_DATA,
			i_ram_rd_addr		=> RD_ADDR,
			o_ram_rd_data		=> RD_DATA
		);
		
	E8: entity WORK.tx_mux(RTL)
		generic map (
			DATA_LENGTH	=> DATA_LENGTH
		)
		port map (
			i_clk					=> CLK,
			i_rst					=> i_RESET,
			i_fsm_tx_status_byte	=> FSM_TX_STATUS_BYTE,
			i_fsm_tx_start_pulse	=> FSM_TX_START_PULSE,
			i_send_tx_byte			=> SEND_TX_BYTE,
			i_send_tx_start_pulse	=> SEND_TX_START_PULSE,
			o_mux_tx_byte			=> MUX_TX_BYTE,
			o_mux_tx_start_pulse	=> MUX_TX_START_PULSE
		);
		
	E9: entity WORK.uart_tx(RTL)
		generic map (
			CLK_FREQ_HZ => CLK_FREQ_HZ,
			BAUD_RATE 	=> BAUD_RATE,
			DATA_LENGTH => DATA_LENGTH
		)
		port map (
			i_clk					=> CLK,
			i_rst					=> i_RESET,
			i_mux_tx_byte			=> MUX_TX_BYTE,
			i_mux_tx_start_pulse	=> MUX_TX_START_PULSE,
			o_tx_busy				=> TX_BUSY,
			o_UART_TX				=> o_UART_TX,
			o_UART_TX_LED			=> o_UART_TX_LED
		);

end architecture STRUCTURE;
