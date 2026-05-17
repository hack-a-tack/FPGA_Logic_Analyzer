-- ========================================
-- MODULE: top.vhd
-- FUNCTION: ties all underlying modules together
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-24 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
--
-- INPUTS 					DATA		TO INTERNAL MODULE
-- i_RESET					1 bit		-> uart_rx | cmd_parser | analyzer_fsm | capture_engine | send_engine | tx_mux | uart_tx
-- i_LA0					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA1					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA2					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA3					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA4					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA5					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA6					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_LA7					1 bit		-> capture_engine (transmitted as 8-bit ANALYZER_INPUTS)
-- i_UART_RX				1 bit		-> uart_rx
--
-- OUTPUTS					DATA		FROM INTERNAL MODULE
-- o_UART_TX				1 bit		<- uart_tx
-- o_UART_TX_LED			1 bit		<- uart_tx
-- o_UART_RX_LED			1 bit		<- uart_rx
-- o_USER_LED				1 bit		<- analyzer_fsm
--
-- NOTES
-- i_LA0 through i_LA7 get assembled into std_logic_vector of length 8 "ANALYZER_INPUTS" before it's sent to -> capture_engine
-- Since i_RESET is connected to CRESET_B going to the DIP switch, it's active low. I.e. reset when i_RESET = '0'
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top is
	generic (
		CLK_FREQ_HZ : integer := 48_000_000;
		BAUD_RATE 	: integer := 921600;
		ADDR_LENGTH : integer := 12;
		NUM_SAMPLES : integer := 2**ADDR_LENGTH;  -- 4096
		DATA_LENGTH : integer := 8
	);
	port (
		i_RESET  			: in  std_logic;
		i_LA0				: in  std_logic;
		i_LA1				: in  std_logic;
		i_LA2				: in  std_logic;
		i_LA3				: in  std_logic;
		i_LA4				: in  std_logic;
		i_LA5				: in  std_logic;
		i_LA6				: in  std_logic;
		i_LA7				: in  std_logic;
		i_UART_RX 			: in  std_logic;
		o_UART_TX			: out std_logic;
		o_UART_TX_LED		: out std_logic;
		o_UART_RX_LED		: out std_logic;
		o_USER_LED			: out std_logic;
		o_DEBUG_1			: out std_logic;	-- added for DEBUGGING
		o_DEBUG_2			: out std_logic  	-- added for DEBUGGING
	);
end entity top;
	
architecture STRUCTURE of top is
	----------------------
	-- INTERNAL SIGNALS --
	----------------------
	
	-- CLOCKING
	signal CLK 			: std_logic;											-- driven by clocking
	signal SAMP_TICK 	: std_logic;											-- driven by clocking
	signal samp_div_cnt : unsigned(3 downto 0);									-- used for DEBUGGING
	
	-- SAMPLING
	signal ANALYZER_INPUTS	: std_logic_vector(DATA_LENGTH-1 downto 0);			-- driven by top
	
	-- RX: UART_RX --> CMD_PARSER --> ANALYZER_FSM
	signal RX_BYTE 			: std_logic_vector(DATA_LENGTH-1 downto 0);			-- driven by uart_rx
	signal RX_VALID_PULSE 	: std_logic;										-- driven by uart_rx
	signal CAPTURE_PULSE 	: std_logic;										-- driven by cmd_parser
	signal READ_PULSE 		: std_logic;										-- driven by cmd_parser
	signal ERROR_PULSE 		: std_logic;										-- driven by cmd_parser
	
	-- DATA CAPTURE AND TRANSFER: ANALYZER_FSM <--> CAPTURE_ENGINE, SEND_ENGINE
	signal CAPTURE_START_PULSE 	: std_logic;									-- driven by analyzer_fsm
	signal CAPTURE_DONE_PULSE 	: std_logic;									-- driven by capture_engine
	signal SEND_START_PULSE 	: std_logic;									-- driven by analyzer_fsm
	signal SEND_DONE_PULSE 		: std_logic;									-- driven by send_engine
	
	-- TX: UART_TX, TX_MUX <--> ANALYZER_FSM, SEND_ENGINE
	signal FSM_TX_STATUS_BYTE 	: std_logic_vector(DATA_LENGTH-1 downto 0);		-- driven by analyzer_fsm
	signal FSM_TX_START_PULSE 	: std_logic;									-- driven by analyzer_fsm
	signal SEND_TX_BYTE 		: std_logic_vector(DATA_LENGTH-1 downto 0);		-- driven by send_engine
	signal SEND_TX_START_PULSE 	: std_logic;									-- driven by send_engine
	signal MUX_TX_BYTE 			: std_logic_vector(DATA_LENGTH-1 downto 0);		-- driven by tx_mux
	signal MUX_TX_START_PULSE 	: std_logic;									-- driven by tx_mux
	signal TX_BUSY 				: std_logic;									-- driven by uart_tx
	signal UART_TX_INT 			: std_logic;									-- create net for additional DEBUG output
	
	-- RAM RELATED: TRACE_BUFFER <--> CAPTURE_ENGINE, SEND_ENGINE
	signal WR_EN_PULSE	: std_logic;											-- driven by capture_engine
	signal WR_ADDR 		: std_logic_vector(ADDR_LENGTH-1 downto 0);				-- driven by capture_engine
	signal WR_DATA 		: std_logic_vector(DATA_LENGTH-1 downto 0);				-- driven by capture_engine
	signal RD_DATA 		: std_logic_vector(DATA_LENGTH-1 downto 0);				-- driven by trace_buffer
	signal RD_ADDR 		: std_logic_vector(ADDR_LENGTH-1 downto 0);				-- driven by send_engine
	
begin
	ANALYZER_INPUTS <= i_LA7 & i_LA6 & i_LA5 & i_LA4 & i_LA3 & i_LA2 & i_LA1 & i_LA0;

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
			i_rst 					=> i_RESET,
			i_cmd_error_pulse 		=> ERROR_PULSE,
			i_capture_cmd_pulse 	=> CAPTURE_PULSE,
			i_capture_done_pulse 	=> CAPTURE_DONE_PULSE,
			i_read_cmd_pulse 		=> READ_PULSE,
			i_send_done_pulse 		=> SEND_DONE_PULSE,
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
			i_inputs 				=> ANALYZER_INPUTS,
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
		
	----------------------------
	-- DEBUG SECTION
	----------------------------
	DEBUG_PROC : process(CLK)
	begin
		if rising_edge(CLK) then
			if i_RESET = '0' then
				samp_div_cnt <= (others => '0');
			elsif SAMP_TICK = '1' then
				samp_div_cnt <= samp_div_cnt + 1;
			end if;
		end if;
	end process;
	
	o_DEBUG_1 <= SAMP_TICK;	 					-- raw sample tick, expected ~24 MHz
	o_DEBUG_2 <= std_logic(samp_div_cnt(3));  	-- sample tick / 16, expected ~1.5 MHz
	----------------------------

end architecture STRUCTURE;
