-- ========================================
-- MODULE: uart_pkg.vhd
-- FUNCTION: shared UART baud-timing lookup used by uart_tx and uart_rx
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-08-12 (YYYY-MM-DD)
--
-- INPUTS					DATA		FROM MODULE
-- N/A (package, no ports)
--
-- OUTPUTS					DATA		TO MODULE
-- N/A (package, no ports)
--
-- NOTES
-- f_clks_per_bit(baud_sel) returns the number of 48 MHz clock cycles per UART bit period for a given i_baud_sel code:
-- "00" -> 52  (921,600 nominal, actual 923,077, +0.16% error) -- legacy/compatibility rate, only one with divider error
-- "01" -> 12  (4,000,000 baud, exact)
-- "10" ->  8  (6,000,000 baud, exact)
-- others -> 52  (safe fallback to the compatibility rate)
-- Both new rates divide 48 MHz exactly. Only the legacy rate carries divider error, same as before this change.
--
-- PREFIXES
-- f_ : function
--
-- ITERATIVE PROCESS NOTES:
-- crc16_next is currently duplicated in frame_tx.vhd and rx_frame_parser.vhd. Both copies should be lifted into this package in a later pass.
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package uart_pkg is

  function f_clks_per_bit(baud_sel : std_logic_vector(1 downto 0)) return positive;

end package uart_pkg;

package body uart_pkg is

  function f_clks_per_bit(baud_sel : std_logic_vector(1 downto 0)) return positive is
  begin
	case baud_sel is
      when "00"   => return 52; -- 921,600 nominal, actual 923,077, +0.16%
      when "01"   => return 12; -- 4 Mbaud, exact
      when "10"   => return 8; -- 6 Mbaud, exact
      when others => return 52; -- safe fallback to the compatibility rate
    end case;
  end function f_clks_per_bit;

end package body uart_pkg;
