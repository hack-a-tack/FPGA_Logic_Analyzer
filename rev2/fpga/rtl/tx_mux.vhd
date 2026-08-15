-- ========================================
-- MODULE: tx_mux.vhd
-- FUNCTION: multiplexes payload bytes from resp_gen/send_engine toward frame_tx, selected by frame_tx's grant
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-03-26 (YYYY-MM-DD)
-- MODIFIED: 2026-05-14 (reset active low)
-- MODIFIED: 2026-08-06 (rev2)
-- MODIFIED: 2026-08-15 (rev2) (packet framing: pure combinational 2:1 payload mux selected by frame_tx's grant; no longer connects to uart_tx directly)
--
-- INPUTS					DATA		FROM MODULE
-- i_resp_pl_byte			8 bits		<- resp_gen
-- i_resp_pl_valid			1 bit		<- resp_gen
-- i_send_pl_byte			8 bits		<- send_engine
-- i_send_pl_valid			1 bit		<- send_engine
-- i_grant_sel				1 bit		<- frame_tx
-- i_pl_ready				1 bit		<- frame_tx
--
-- OUTPUTS					DATA		TO MODULE
-- o_resp_pl_ready			1 bit		-> resp_gen
-- o_send_pl_ready			1 bit		-> send_engine
-- o_pl_byte				8 bits		-> frame_tx
-- o_pl_valid				1 bit		-> frame_tx
--
-- PREFIXES
-- i_ : input
-- o_ : output

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
		-- resp_gen payload source
		i_resp_pl_byte			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_resp_pl_valid			: in  std_logic;
		o_resp_pl_ready			: out std_logic;

		-- send_engine payload source
		i_send_pl_byte			: in  std_logic_vector(DATA_LENGTH-1 downto 0);
		i_send_pl_valid			: in  std_logic;
		o_send_pl_ready			: out std_logic;

		-- frame_tx
		i_grant_sel				: in  std_logic;	-- '0' = resp_gen, '1' = send_engine
		i_pl_ready				: in  std_logic;
		o_pl_byte				: out std_logic_vector(DATA_LENGTH-1 downto 0);
		o_pl_valid				: out std_logic
	);
end entity tx_mux;

architecture RTL of tx_mux is
begin

	mux_proc : process(all) is
	begin
		-- Defaults
		o_pl_byte       <= (others => '0');
		o_pl_valid      <= '0';

		o_resp_pl_ready <= '0';
		o_send_pl_ready <= '0';

		-- Selection comes from frame_tx's registered grant (i_grant_sel), which is held for a whole frame.
		-- tx_mux does not decide this itself. i_send_pl_valid legitimately drops during send_engine's WAIT_RAM
		-- cycles without releasing the grant; frame_tx just holds in that case.
		if i_grant_sel = '1' then
			o_pl_byte       <= i_send_pl_byte;
			o_pl_valid      <= i_send_pl_valid;
			o_send_pl_ready <= i_pl_ready;

		else
			o_pl_byte       <= i_resp_pl_byte;
			o_pl_valid      <= i_resp_pl_valid;
			o_resp_pl_ready <= i_pl_ready;
		end if;
	end process mux_proc;

end architecture RTL;
