-- ========================================
-- MODULE: clocking.vhd
-- FUNCTION: generates clock and sampling signal
-- AUTHOR: Jakob Kieszek Ottesen
-- DATE: 2026-04-05 (YYYY-MM-DD)
-- MODIFIED: 2026-08-09 (rev2)
--
-- INPUTS					DATA		FROM MODULE
-- i_cfg_sample_rate_sel	2 bits		<- config_regs
--
-- OUTPUTS					DATA		TO MODULE
-- o_clk					1 bit		-> uart_rx | cmd_parser | analyzer_fsm | capture_engine | send_engine | tx_mux | uart_tx
-- o_samp_tick				1 bit		-> capture_engine
--
-- NOTES
-- SB_HFOSC instantiation --> iCE40UP5K primitive
-- The main o_clk signal is 48MHz
-- The o_samp_tick signal is a one-clock-cycle enable pulse occurring at 24MHz/12MHz/6MHz
--
-- PREFIXES					
-- i_ : input
-- o_ : output
-- ========================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

entity clocking is
	port (
		i_cfg_sample_rate_sel	: in  std_logic_vector(1 downto 0);
		o_clk					: out std_logic;
		o_samp_tick				: out std_logic
	);
end entity clocking;
	
architecture RTL of clocking is
	-- Primitive instantiation: high frequency oscillator (SB_HFOSC)
	component SB_HFOSC is
		generic (
			CLKHF_DIV : string := "0b00";  -- 0b00=48MHz, 0b01=24MHz, 0b10=12MHz, 0b11=6MHz
			ROUTE_THROUGH_FABRIC : string := "0"
		);
		port (
			CLKHFEN : in  std_logic;
			CLKHFPU	: in  std_logic;
			CLKHF  	: out std_logic
		);
	end component SB_HFOSC;
	
	-- registered signal
	signal r_clk : std_logic;
	signal r_samp_tick : std_logic := '0';
	signal r_div_counter : unsigned(2 downto 0) := (others => '0');
	
begin
	-- Use primitive to generate 48MHz clk signal
	HF_OSC: SB_HFOSC
		generic map (
			CLKHF_DIV => "0b00",
			ROUTE_THROUGH_FABRIC => "0"
		)
		port map(
			CLKHFEN	=> '1',
			CLKHFPU => '1',
			CLKHF	=> r_clk
		);
		
	-- 48MHz r_clk (for simulation purposes only)
	--r_clk <= not r_clk after 10.416 ns;
	
	-- Process for generating pulse at 24MHz/12MHz/6MHz sampling rate
	samp_gen_proc: process(r_clk) is
	begin
		if rising_edge(r_clk) then
			-- Default: no sampling event at this clock cycle
			r_samp_tick <= '0';
			
			r_div_counter <= r_div_counter + 1;
		
			case i_cfg_sample_rate_sel is
				when "00" =>						-- 24MHz sample rate	
					if r_div_counter(0) = '0' then	-- 1/2 cases
						r_samp_tick <= '1';
					end if;
					
				when "01" =>						-- 12MHz sample rate
					if r_div_counter(1 downto 0) = "00" then	-- 1/4 cases
						r_samp_tick <= '1';
					end if;
				
				when "10" =>						-- 6MHz sample rate
					if r_div_counter = "000" then	-- 1/8 cases
						r_samp_tick <= '1';
					end if;
				
				when others =>
					r_samp_tick <= '0';
					
			end case;
		end if;
	end process samp_gen_proc;
	
	o_clk <= r_clk;
	o_samp_tick <= r_samp_tick;
	
end architecture RTL;
