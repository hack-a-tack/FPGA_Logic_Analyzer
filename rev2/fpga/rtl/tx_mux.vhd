-- ========================================
-- MODULE: tx_mux.vhd
-- FUNCTION: multiplexes data signals going to uart_tx (based on priority)
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-26 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-08-06 (rev2)
--
-- INPUTS					DATA		FROM MODULE
-- i_fsm_tx_status_byte		8 bits 		<- analyzer_fsm
-- i_fsm_tx_valid			1 bit		<- analyzer_fsm
-- i_send_tx_byte			8 bits		<- send_engine
-- i_send_tx_valid			1 bit		<- send_engine
-- i_send_active			1 bit		<- send_engine
-- i_uart_tx_ready			1 bit		<- uart_tx
--
-- OUTPUTS					DATA		TO MODULE
-- o_fsm_tx_ready			1 bit		-> analyzer_fsm
-- o_send_tx_ready			1 bit		-> send_engine
-- o_mux_tx_byte			8 bits		-> uart_tx
-- o_mux_tx_valid			1 bit		-> uart_tx
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- r_ : register 			(internal signal; current; 		for sequential process)
-- n_ : next <register> 	(internal signal; next state; 	for combinational process)
-- v_ : variable

-- ITERATIVE PROCESS NOTES:
-- update VHDL entities in OneNote once module is locked
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tx_mux is
	generic (
		DATA_LENGTH : integer := 8
	);
	port (
		-- Analyzer_fsm related signals
		i_fsm_tx_status_byte	: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_fsm_tx_valid			: in  std_logic;
		o_fsm_tx_ready			: out std_logic;	-- i_uart_tx_ready relayed via tx_mux, from uart_tx
		
		-- Send_engine related signals
		i_send_tx_byte			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_send_tx_valid			: in  std_logic;
		i_send_active			: out std_logic;
		o_send_tx_ready			: out std_logic;	-- i_uart_tx_ready relayed via tx_mux, from uart_tx
		
		-- tx_mux <--> uart_tx signals
		i_uart_tx_ready			: in  std_logic;
		o_mux_tx_byte			: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_mux_tx_valid			: out std_logic
	);
end entity tx_mux;

architecture RTL of tx_mux is		
begin

	mux_proc : process(all) is
	begin
		-- Defaults
		o_mux_tx_byte   <= (others => '0');
        o_mux_tx_valid  <= '0';

        o_fsm_tx_ready  <= '0';
        o_send_tx_ready <= '0';

        if i_send_active = '1' then
            -- send_engine exclusively owns UART during READ transfer
			-- i_send_active is high as long as send_engine is not in states IDLE or DONE.
			-- (i_send_tx_valid is low during WAIT_RAM stage and would allow FSM bytes to be inserted between payload bytes. not desirable)
            o_mux_tx_byte   <= i_send_tx_byte;
            o_mux_tx_valid  <= i_send_tx_valid;
            o_send_tx_ready <= i_uart_tx_ready;

        else
            -- FSM may transmit status responses outside READ transfers.
            o_mux_tx_byte   <= i_fsm_tx_status_byte;
            o_mux_tx_valid  <= i_fsm_tx_valid;
            o_fsm_tx_ready  <= i_uart_tx_ready;
        end if;
	end process mux_proc;
	
end architecture RTL;
