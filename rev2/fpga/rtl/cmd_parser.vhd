-- ========================================
-- MODULE: cmd_parser.vhd
-- FUNCTION: decodes opcodes and outputs one-cycle command pulses (and config data)
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-12 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-07-28 (FSM, config outputs)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_rx_byte				8 bits 		<- uart_rx
-- i_rx_valid_pulse			1 bit		<- uart_rx
--
-- OUTPUTS					DATA		TO MODULE
-- o_capture_cmd_pulse		1 bit		-> analyzer_fsm
-- o_read_cmd_pulse			1 bit		-> analyzer_fsm
-- o_cmd_error_pulse		1 bit		-> analyzer_fsm
-- o_cfg_write_pulse		1 bit		-> config_regs
-- o_cfg_opcode				8 bits		-> config_regs
-- o_cfg_value				16 bits		-> config_regs
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)

-- ITERATIVE PROCESS NOTES:
-- For this first implementation, cmd_parser can update configuration whenever it receives a valid configuration command. Later, when integrating with analyzer_fsm, add: /i_config_write_allowed/. Then reject configuration changes during CAPTURE or SEND. Do not try to solve that before the basic parser works.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cmd_parser is
	generic (
		DATA_LENGTH : integer := 8;
		G_TIMEOUT_CYCLES : positive := 48_000  -- 48,000 cycles at 48 MHz = 1 ms
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;
		
		i_rx_byte				: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_rx_valid_pulse		: in  std_logic;
		
		o_capture_cmd_pulse		: out std_logic;
		o_read_cmd_pulse		: out std_logic;
		o_cmd_error_pulse		: out std_logic;
		
		o_cfg_write_pulse		: out std_logic;
		o_cfg_opcode			: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_cfg_value				: out std_logic_vector(2*DATA_LENGTH-1 downto 0)
	);
end entity cmd_parser;

architecture RTL of cmd_parser is	
	-- Constants representing command bytes
	constant CMD_CAPTURE 					: std_logic_vector(DATA_LENGTH-1 downto 0) := x"A0";
	constant CMD_READ 						: std_logic_vector(DATA_LENGTH-1 downto 0) := x"A1";
	
	constant CMD_UART_BAUD 					: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C0";
	constant CMD_CAPTURE_WIDTH 				: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C1";
	constant CMD_SAMP_RATE 					: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C2";
	constant CMD_CAPTURE_DEPTH				: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C3";
	constant CMD_TRIGGER_MODE 				: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C4";
	constant CMD_EDGE_TRIGGER_CH 			: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C5";
	constant CMD_EDGE_TRIGGER_TYPE 			: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C6";
	constant CMD_PATTERN_TRIGGER_PATTERN	: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C7";
	constant CMD_PATTERN_TRIGGER_MASK 		: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C8";
	constant CMD_TRIGGER_POSITION 			: std_logic_vector(DATA_LENGTH-1 downto 0) := x"C9";
	
	-- FSM type and signals
	type cmd_parser_state is (IDLE, WAIT_ARG_1, WAIT_ARG_2);
	signal r_state : cmd_parser_state := IDLE;
	
	-- Register signals	
	signal r_pending_cmd : std_logic_vector(DATA_LENGTH-1 downto 0);
	signal r_arg_1 : std_logic_vector(DATA_LENGTH-1 downto 0);
	
	signal r_timeout_count : integer range 0 to G_TIMEOUT_CYCLES - 1 := 0;
	
begin
	parser_proc : process(i_clk)
    begin
        if rising_edge(i_clk) then
            -- Pulse outputs default low every cycle.
            o_capture_cmd_pulse <= '0';
            o_read_cmd_pulse    <= '0';
            o_cmd_error_pulse   <= '0';
            o_cfg_write_pulse   <= '0';

            if i_rst_n = '0' then
                r_state         <= IDLE;
                r_pending_cmd   <= (others => '0');
                r_arg_1         <= (others => '0');
                r_timeout_count <= 0;
                o_cfg_opcode    <= (others => '0');
                o_cfg_value     <= (others => '0');
            else
                case r_state is
                    when IDLE =>
                        r_timeout_count <= 0;

                        if i_rx_valid_pulse = '1' then
                            case i_rx_byte is

                                when CMD_CAPTURE 	=> o_capture_cmd_pulse <= '1';

                                when CMD_READ 		=> o_read_cmd_pulse <= '1';

                                when CMD_UART_BAUD               |
                                     CMD_CAPTURE_WIDTH           |
                                     CMD_SAMP_RATE               |
                                     CMD_CAPTURE_DEPTH           |
                                     CMD_TRIGGER_MODE            |
                                     CMD_EDGE_TRIGGER_CH         |
                                     CMD_EDGE_TRIGGER_TYPE       |
                                     CMD_PATTERN_TRIGGER_PATTERN |
                                     CMD_PATTERN_TRIGGER_MASK    |
                                     CMD_TRIGGER_POSITION =>

                                    r_pending_cmd <= i_rx_byte;
                                    r_state       <= WAIT_ARG_1;

                                when others 		=> o_cmd_error_pulse <= '1';

                            end case;
                        end if;

                    when WAIT_ARG_1 =>
                        if i_rx_valid_pulse = '1' then
                            r_timeout_count <= 0;

                            if (r_pending_cmd = CMD_PATTERN_TRIGGER_PATTERN) or
                               (r_pending_cmd = CMD_PATTERN_TRIGGER_MASK) then

                                -- First byte is the high byte.
                                r_arg_1 <= i_rx_byte;
                                r_state <= WAIT_ARG_2;

                            else
                                -- One-byte configuration command.
                                o_cfg_opcode      <= r_pending_cmd;
                                o_cfg_value       <= x"00" & i_rx_byte;
                                o_cfg_write_pulse <= '1';
                                r_state <= IDLE;
                            end if;

                        elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
                            r_timeout_count  <= 0;
                            r_state          <= IDLE;
                            o_cmd_error_pulse <= '1';

                        else
                            r_timeout_count <= r_timeout_count + 1;
                        end if;

                    when WAIT_ARG_2 =>
                        if i_rx_valid_pulse = '1' then
                            r_timeout_count <= 0;

                            -- High byte arrived first, low byte arrives now.
                            o_cfg_opcode      <= r_pending_cmd;
                            o_cfg_value       <= r_arg_1 & i_rx_byte;
                            o_cfg_write_pulse <= '1';

                            r_state <= IDLE;

                        elsif r_timeout_count = G_TIMEOUT_CYCLES - 1 then
                            r_timeout_count   <= 0;
                            r_state           <= IDLE;
                            o_cmd_error_pulse <= '1';

                        else
                            r_timeout_count <= r_timeout_count + 1;
                        end if;
                end case;
            end if;
        end if;
    end process parser_proc;
	
end architecture RTL;
