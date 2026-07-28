-- ========================================
-- MODULE: config_regs.vhd
-- FUNCTION: keeps track of logic analyzer configurations from the host
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-07-28 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- i_clk					1 bit		<- clocking
-- i_rst_n					1 bit		<- top
-- i_cfg_write_pulse		1 bit		<- cmd_parser
-- i_cfg_opcode				8 bits		<- cmd_parser
-- i_cfg_value				16 bits		<- cmd_parser
--
-- OUTPUTS					DATA		TO MODULE
-- o_cfg_uart_baud_rate    	2 bits		->
-- o_cfg_capture_width_sel	1 bit
-- o_cfg_sample_rate      	2 bits
-- o_cfg_capture_depth_sel	1 bit
-- o_cfg_trigger_mode		2 bits
-- o_cfg_edge_trigger_ch	4 bits
-- o_cfg_edge_trigger_type	2 bits
-- o_cfg_pattern_value		16 bits
-- o_cfg_pattern_mask		16 bits
-- o_cfg_trigger_pos		2 bits
-- o_cfg_ack_pulse			1 bit		-> cmd_parser
-- o_cfg_error_pulse		1 bit		-> cmd_parser
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)

-- ITERATIVE PROCESS NOTES:
-- There is more to updating UART BAUD RATE than updating an internal register... TBC
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity config_regs is
	generic (
	);
	port (
		i_clk					: in  std_logic;
		i_rst_n					: in  std_logic;
		
		i_cfg_write_pulse		: in  std_logic;
		i_cfg_opcode			: in  std_logic_vector(7 downto 0);
		i_cfg_value				: in  std_logic_vector(15 downto 0)
		
		o_cfg_uart_baud_rate    : out std_logic_vector(1 downto 0);
		o_cfg_capture_width_sel : out std_logic;
		o_cfg_sample_rate       : out std_logic_vector(1 downto 0);
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

architecture RTL of cmd_parser is
	-- Constants representing config opcodes	
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
	
	-- Register signals
	signal r_uart_baud_rate					: std_logic_vector(1 downto 0) := "00";
	signal r_capture_width_sel				: std_logic := '0';
	signal r_sample_rate					: std_logic_vector(1 downto 0) := "00";
	signal r_capture_depth_sel					: std_logic := '0';
	signal r_trigger_mode 					: std_logic_vector(1 downto 0) := "00";
	signal r_edge_trigger_ch				: std_logic_vector(3 downto 0) := "0000";
	signal r_edge_trigger_type				: std_logic_vector(1 downto 0) := "00";
	signal r_pattern_trigger_value			: std_logic_vector(15 downto 0) := x"0000";
	signal r_pattern_trigger_mask			: std_logic_vector(15 downto 0) := x"FFFF";
	signal r_trigger_pos					: std_logic_vector(1 downto 0) := "00";
		
begin
	seq_proc : process(i_clk)
	begin
		if rising_edge(i_clk) then
			if i_rst_n = '0' then
				r_uart_baud_rate        <= "00";     -- 921600
				r_capture_width_sel     <= '0';      -- 8 channels
				r_sample_rate           <= "00";     -- 24 MS/s
				r_capture_depth_sel     <= '0';      -- shallow capture (4096 S)
				r_trigger_mode          <= "00";     -- immediate
				r_edge_trigger_ch       <= "0000";   -- CH0
				r_edge_trigger_type     <= "00";     -- rising
				r_pattern_trigger_value <= x"0000";  -- trigger value is 0x0000
				r_pattern_trigger_mask  <= x"FFFF";  -- all channels are part of the pattern
				r_trigger_pos           <= "00";     -- 25%

				r_cfg_ack_pulse         <= '0';
				r_cfg_error_pulse       <= '0';
			else
				-- Default pulses low
				r_cfg_ack_pulse   <= '0';
				r_cfg_error_pulse <= '0';
						
				if i_cfg_write_pulse = '1' then
					case i_cfg_opcode is
						when CMD_UART_BAUD =>
							if i_cfg_value(7 downto 0) = x"00" or
								i_cfg_value(7 downto 0) = x"01" or
								i_cfg_value(7 downto 0) = x"02" then
								
								r_uart_baud_rate <= i_cfg_value(1 downto 0);
								r_cfg_ack_pulse <= '1';  -- ACK pulse to cmd_parser
							else
								r_cfg_error_pulse <= '1';  -- ERROR pulse to cmd_parser
							end if;
						
						when CMD_CAPTURE_WIDTH =>
							if i_cfg_value(7 downto 0) = x"00" or
								i_cfg_value(7 downto 0) = x"01" then
								
								r_capture_width_sel <= i_cfg_value(0);
								r_cfg_ack_pulse <= '1';
							else
								r_cfg_error_pulse <= '1';
							end if;
							
						when CMD_SAMP_RATE =>
							if i_cfg_value(7 downto 0) = x"00" or
								i_cfg_value(7 downto 0) = x"01" or
								i_cfg_value(7 downto 0) = x"02" then
								
								r_sample_rate <= i_cfg_value(1 downto 0);
								r_cfg_ack_pulse <= '1';
							else
								r_cfg_error_pulse <= '1';
							end if;
						
						when CMD_CAPTURE_DEPTH =>
							if i_cfg_value(7 downto 0) = x"00" or
								i_cfg_value(7 downto 0) = x"01" then
								
								r_capture_depth_sel <= i_cfg_value(0);
								r_cfg_ack_pulse <= '1';
							else
								r_cfg_error_pulse <= '1';
							end if;
							
						when CMD_TRIGGER_MODE =>
							if i_cfg_value(7 downto 0) = x"00" or
								i_cfg_value(7 downto 0) = x"01" or
								i_cfg_value(7 downto 0) = x"02" then
																		
								r_trigger_mode <= i_cfg_value(1 downto 0);
								r_cfg_ack_pulse <= '1';
							else
								r_cfg_error_pulse <= '1';
							end if;
							
						when CMD_EDGE_TRIGGER_CH =>
							if i_cfg_value(7 downto 0) >= x"00" and i_cfg_value(7 downto 0) <= x"0F" then
																	
								r_edge_trigger_ch <= i_cfg_value(3 downto 0);
								r_cfg_ack_pulse <= '1';
							else
								r_cfg_error_pulse <= '1';
							end if;
							
						when CMD_EDGE_TRIGGER_TYPE =>
							if i_cfg_value(7 downto 0) = x"00" or
								i_cfg_value(7 downto 0) = x"01" or
								i_cfg_value(7 downto 0) = x"02" then
																		
								r_edge_trigger_type <= i_cfg_value(1 downto 0);
								r_cfg_ack_pulse <= '1';
							else
								r_cfg_error_pulse <= '1';
							end if;
							
						when CMD_PATTERN_TRIGGER_PATTERN =>
							r_pattern_trigger_value <= i_cfg_value;
							r_cfg_ack_pulse <= '1';
							
						when CMD_PATTERN_TRIGGER_MASK =>
							if i_cfg_value(15 downto 0) = x"0000" then
								r_cfg_error_pulse <= '1';
							else
								r_pattern_trigger_mask <= i_cfg_value;
								r_cfg_ack_pulse <= '1';
							end if;
							
						when CMD_TRIGGER_POSITION =>
							if i_cfg_value(7 downto 0) = x"00" or
								i_cfg_value(7 downto 0) = x"01" or
								i_cfg_value(7 downto 0) = x"02" then
								
								r_trigger_pos <= i_cfg_value(1 downto 0);
								r_cfg_ack_pulse <= '1';
							else
								r_cfg_error_pulse <= '1';
							end if;

						when others =>
							r_cfg_error_pulse <= '1';  -- ERROR. Unrecognised opcode

					end case;
				end if;
			end if;
		end if;
	end process seq_proc;
	
	o_cfg_uart_baud_rate    <= r_uart_baud_rate;
	o_cfg_capture_width_sel	<= r_capture_width_sel;
	o_cfg_sample_rate       <= r_sample_rate;
	o_cfg_capture_depth_sel <= r_capture_depth_sel;
	o_cfg_trigger_mode      <= r_trigger_mode;
	o_cfg_edge_trigger_ch   <= r_edge_trigger_ch;
	o_cfg_edge_trigger_type <= r_edge_trigger_type;
	o_cfg_pattern_value     <= r_pattern_trigger_value;
	o_cfg_pattern_mask      <= r_pattern_trigger_mask;
	o_cfg_trigger_pos       <= r_trigger_pos;
	
	o_cfg_ack_pulse         <= r_cfg_ack_pulse;
	o_cfg_error_pulse       <= r_cfg_error_pulse;
	
end architecture RTL;
