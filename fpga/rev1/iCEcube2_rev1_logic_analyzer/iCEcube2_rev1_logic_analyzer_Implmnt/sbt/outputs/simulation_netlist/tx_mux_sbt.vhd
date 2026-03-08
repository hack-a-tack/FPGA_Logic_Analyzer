-- ******************************************************************************

-- iCEcube Netlister

-- Version:            2020.12.27943

-- Build Date:         Dec  9 2020 18:18:06

-- File Generated:     Mar 7 2026 11:38:59

-- Purpose:            Post-Route Verilog/VHDL netlist for timing simulation

-- Copyright (C) 2006-2010 by Lattice Semiconductor Corp. All rights reserved.

-- ******************************************************************************

-- VHDL file for cell "tx_mux" view "INTERFACE"

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library ice;
use ice.vcomponent_vital.all;

-- Entity of tx_mux
entity tx_mux is
port (
    i_fsm_tx_status_byte : in std_logic_vector(7 downto 0);
    i_send_tx_byte : in std_logic_vector(7 downto 0);
    o_mux_tx_byte : out std_logic_vector(7 downto 0);
    o_mux_tx_start_pulse : out std_logic;
    i_clk : in std_logic;
    i_send_tx_start_pulse : in std_logic;
    i_rst : in std_logic;
    i_fsm_tx_start_pulse : in std_logic);
end tx_mux;

-- Architecture of tx_mux
-- View name is \INTERFACE\
architecture \INTERFACE\ of tx_mux is

signal \N__1191\ : std_logic;
signal \N__1190\ : std_logic;
signal \N__1189\ : std_logic;
signal \N__1180\ : std_logic;
signal \N__1179\ : std_logic;
signal \N__1178\ : std_logic;
signal \N__1171\ : std_logic;
signal \N__1170\ : std_logic;
signal \N__1169\ : std_logic;
signal \N__1162\ : std_logic;
signal \N__1161\ : std_logic;
signal \N__1160\ : std_logic;
signal \N__1153\ : std_logic;
signal \N__1152\ : std_logic;
signal \N__1151\ : std_logic;
signal \N__1144\ : std_logic;
signal \N__1143\ : std_logic;
signal \N__1142\ : std_logic;
signal \N__1135\ : std_logic;
signal \N__1134\ : std_logic;
signal \N__1133\ : std_logic;
signal \N__1126\ : std_logic;
signal \N__1125\ : std_logic;
signal \N__1124\ : std_logic;
signal \N__1117\ : std_logic;
signal \N__1116\ : std_logic;
signal \N__1115\ : std_logic;
signal \N__1108\ : std_logic;
signal \N__1107\ : std_logic;
signal \N__1106\ : std_logic;
signal \N__1099\ : std_logic;
signal \N__1098\ : std_logic;
signal \N__1097\ : std_logic;
signal \N__1090\ : std_logic;
signal \N__1089\ : std_logic;
signal \N__1088\ : std_logic;
signal \N__1081\ : std_logic;
signal \N__1080\ : std_logic;
signal \N__1079\ : std_logic;
signal \N__1072\ : std_logic;
signal \N__1071\ : std_logic;
signal \N__1070\ : std_logic;
signal \N__1063\ : std_logic;
signal \N__1062\ : std_logic;
signal \N__1061\ : std_logic;
signal \N__1054\ : std_logic;
signal \N__1053\ : std_logic;
signal \N__1052\ : std_logic;
signal \N__1045\ : std_logic;
signal \N__1044\ : std_logic;
signal \N__1043\ : std_logic;
signal \N__1036\ : std_logic;
signal \N__1035\ : std_logic;
signal \N__1034\ : std_logic;
signal \N__1027\ : std_logic;
signal \N__1026\ : std_logic;
signal \N__1025\ : std_logic;
signal \N__1018\ : std_logic;
signal \N__1017\ : std_logic;
signal \N__1016\ : std_logic;
signal \N__1009\ : std_logic;
signal \N__1008\ : std_logic;
signal \N__1007\ : std_logic;
signal \N__1000\ : std_logic;
signal \N__999\ : std_logic;
signal \N__998\ : std_logic;
signal \N__991\ : std_logic;
signal \N__990\ : std_logic;
signal \N__989\ : std_logic;
signal \N__982\ : std_logic;
signal \N__981\ : std_logic;
signal \N__980\ : std_logic;
signal \N__973\ : std_logic;
signal \N__972\ : std_logic;
signal \N__971\ : std_logic;
signal \N__964\ : std_logic;
signal \N__963\ : std_logic;
signal \N__962\ : std_logic;
signal \N__955\ : std_logic;
signal \N__954\ : std_logic;
signal \N__953\ : std_logic;
signal \N__946\ : std_logic;
signal \N__945\ : std_logic;
signal \N__944\ : std_logic;
signal \N__937\ : std_logic;
signal \N__936\ : std_logic;
signal \N__935\ : std_logic;
signal \N__918\ : std_logic;
signal \N__915\ : std_logic;
signal \N__912\ : std_logic;
signal \N__909\ : std_logic;
signal \N__906\ : std_logic;
signal \N__903\ : std_logic;
signal \N__900\ : std_logic;
signal \N__897\ : std_logic;
signal \N__894\ : std_logic;
signal \N__891\ : std_logic;
signal \N__888\ : std_logic;
signal \N__885\ : std_logic;
signal \N__882\ : std_logic;
signal \N__879\ : std_logic;
signal \N__876\ : std_logic;
signal \N__873\ : std_logic;
signal \N__870\ : std_logic;
signal \N__867\ : std_logic;
signal \N__864\ : std_logic;
signal \N__861\ : std_logic;
signal \N__858\ : std_logic;
signal \N__855\ : std_logic;
signal \N__852\ : std_logic;
signal \N__849\ : std_logic;
signal \N__846\ : std_logic;
signal \N__843\ : std_logic;
signal \N__840\ : std_logic;
signal \N__837\ : std_logic;
signal \N__834\ : std_logic;
signal \N__831\ : std_logic;
signal \N__828\ : std_logic;
signal \N__825\ : std_logic;
signal \N__822\ : std_logic;
signal \N__819\ : std_logic;
signal \N__816\ : std_logic;
signal \N__813\ : std_logic;
signal \N__810\ : std_logic;
signal \N__807\ : std_logic;
signal \N__804\ : std_logic;
signal \N__801\ : std_logic;
signal \N__798\ : std_logic;
signal \N__795\ : std_logic;
signal \N__792\ : std_logic;
signal \N__789\ : std_logic;
signal \N__786\ : std_logic;
signal \N__783\ : std_logic;
signal \N__782\ : std_logic;
signal \N__781\ : std_logic;
signal \N__778\ : std_logic;
signal \N__775\ : std_logic;
signal \N__772\ : std_logic;
signal \N__771\ : std_logic;
signal \N__770\ : std_logic;
signal \N__769\ : std_logic;
signal \N__768\ : std_logic;
signal \N__767\ : std_logic;
signal \N__760\ : std_logic;
signal \N__759\ : std_logic;
signal \N__758\ : std_logic;
signal \N__747\ : std_logic;
signal \N__744\ : std_logic;
signal \N__739\ : std_logic;
signal \N__736\ : std_logic;
signal \N__733\ : std_logic;
signal \N__730\ : std_logic;
signal \N__727\ : std_logic;
signal \N__724\ : std_logic;
signal \N__721\ : std_logic;
signal \N__714\ : std_logic;
signal \N__711\ : std_logic;
signal \N__708\ : std_logic;
signal \N__705\ : std_logic;
signal \N__702\ : std_logic;
signal \N__699\ : std_logic;
signal \N__696\ : std_logic;
signal \N__693\ : std_logic;
signal \N__690\ : std_logic;
signal \N__687\ : std_logic;
signal \N__684\ : std_logic;
signal \N__683\ : std_logic;
signal \N__682\ : std_logic;
signal \N__681\ : std_logic;
signal \N__672\ : std_logic;
signal \N__669\ : std_logic;
signal \N__666\ : std_logic;
signal \N__665\ : std_logic;
signal \N__664\ : std_logic;
signal \N__661\ : std_logic;
signal \N__658\ : std_logic;
signal \N__655\ : std_logic;
signal \N__652\ : std_logic;
signal \N__647\ : std_logic;
signal \N__644\ : std_logic;
signal \N__641\ : std_logic;
signal \N__636\ : std_logic;
signal \N__633\ : std_logic;
signal \N__630\ : std_logic;
signal \N__629\ : std_logic;
signal \N__628\ : std_logic;
signal \N__627\ : std_logic;
signal \N__624\ : std_logic;
signal \N__621\ : std_logic;
signal \N__618\ : std_logic;
signal \N__615\ : std_logic;
signal \N__614\ : std_logic;
signal \N__611\ : std_logic;
signal \N__606\ : std_logic;
signal \N__603\ : std_logic;
signal \N__600\ : std_logic;
signal \N__591\ : std_logic;
signal \N__588\ : std_logic;
signal \N__585\ : std_logic;
signal \N__582\ : std_logic;
signal \N__579\ : std_logic;
signal \N__576\ : std_logic;
signal \N__573\ : std_logic;
signal \N__570\ : std_logic;
signal \N__567\ : std_logic;
signal \N__564\ : std_logic;
signal \N__561\ : std_logic;
signal \N__558\ : std_logic;
signal \N__555\ : std_logic;
signal \N__552\ : std_logic;
signal \N__549\ : std_logic;
signal \N__546\ : std_logic;
signal \N__543\ : std_logic;
signal \N__540\ : std_logic;
signal \N__537\ : std_logic;
signal \N__534\ : std_logic;
signal \N__531\ : std_logic;
signal \N__528\ : std_logic;
signal \N__525\ : std_logic;
signal \N__522\ : std_logic;
signal \N__519\ : std_logic;
signal \N__516\ : std_logic;
signal \N__513\ : std_logic;
signal \N__510\ : std_logic;
signal \N__509\ : std_logic;
signal \N__506\ : std_logic;
signal \N__503\ : std_logic;
signal \N__498\ : std_logic;
signal \N__495\ : std_logic;
signal \N__492\ : std_logic;
signal \N__489\ : std_logic;
signal \N__486\ : std_logic;
signal \N__483\ : std_logic;
signal \N__480\ : std_logic;
signal \N__477\ : std_logic;
signal \N__474\ : std_logic;
signal \N__471\ : std_logic;
signal \N__468\ : std_logic;
signal \VCCG0\ : std_logic;
signal \GNDG0\ : std_logic;
signal i_send_tx_byte_c_6 : std_logic;
signal i_fsm_tx_status_byte_c_6 : std_logic;
signal o_mux_tx_byte_c_6 : std_logic;
signal i_send_tx_byte_c_7 : std_logic;
signal i_fsm_tx_status_byte_c_7 : std_logic;
signal o_mux_tx_byte_c_7 : std_logic;
signal \r_mux_tx_start_pulseZ0\ : std_logic;
signal i_send_tx_start_pulse_c : std_logic;
signal i_send_tx_byte_c_0 : std_logic;
signal i_fsm_tx_status_byte_c_0 : std_logic;
signal o_mux_tx_byte_c_0 : std_logic;
signal i_send_tx_byte_c_1 : std_logic;
signal i_fsm_tx_status_byte_c_1 : std_logic;
signal o_mux_tx_byte_c_1 : std_logic;
signal i_send_tx_byte_c_2 : std_logic;
signal i_fsm_tx_status_byte_c_2 : std_logic;
signal o_mux_tx_byte_c_2 : std_logic;
signal i_send_tx_byte_c_3 : std_logic;
signal i_fsm_tx_status_byte_c_3 : std_logic;
signal o_mux_tx_byte_c_3 : std_logic;
signal i_send_tx_byte_c_4 : std_logic;
signal i_fsm_tx_status_byte_c_4 : std_logic;
signal o_mux_tx_byte_c_4 : std_logic;
signal i_fsm_tx_start_pulse_c : std_logic;
signal i_send_tx_byte_c_5 : std_logic;
signal i_fsm_tx_status_byte_c_5 : std_logic;
signal o_mux_tx_byte_c_5 : std_logic;
signal \_gnd_net_\ : std_logic;
signal i_clk_c_g : std_logic;
signal seq_proc_un1_i_send_tx_start_pulse_0_i_0 : std_logic;
signal i_rst_c : std_logic;

signal i_clk_wire : std_logic;
signal i_fsm_tx_status_byte_wire : std_logic_vector(7 downto 0);
signal i_send_tx_byte_wire : std_logic_vector(7 downto 0);
signal o_mux_tx_byte_wire : std_logic_vector(7 downto 0);
signal i_fsm_tx_start_pulse_wire : std_logic;
signal i_send_tx_start_pulse_wire : std_logic;
signal o_mux_tx_start_pulse_wire : std_logic;
signal i_rst_wire : std_logic;

begin
    i_clk_wire <= i_clk;
    i_fsm_tx_status_byte_wire <= i_fsm_tx_status_byte;
    i_send_tx_byte_wire <= i_send_tx_byte;
    o_mux_tx_byte <= o_mux_tx_byte_wire;
    i_fsm_tx_start_pulse_wire <= i_fsm_tx_start_pulse;
    i_send_tx_start_pulse_wire <= i_send_tx_start_pulse;
    o_mux_tx_start_pulse <= o_mux_tx_start_pulse_wire;
    i_rst_wire <= i_rst;

    \i_clk_ibuf_gb_io_preiogbuf\ : PRE_IO_GBUF
    port map (
            PADSIGNALTOGLOBALBUFFER => \N__1189\,
            GLOBALBUFFEROUTPUT => i_clk_c_g
        );

    \i_clk_ibuf_gb_io_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1191\,
            DIN => \N__1190\,
            DOUT => \N__1189\,
            PACKAGEPIN => i_clk_wire
        );

    \i_clk_ibuf_gb_io_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1191\,
            PADOUT => \N__1190\,
            PADIN => \N__1189\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_status_byte_ibuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1180\,
            DIN => \N__1179\,
            DOUT => \N__1178\,
            PACKAGEPIN => i_fsm_tx_status_byte_wire(5)
        );

    \i_fsm_tx_status_byte_ibuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1180\,
            PADOUT => \N__1179\,
            PADIN => \N__1178\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_status_byte_c_5,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_tx_byte_ibuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1171\,
            DIN => \N__1170\,
            DOUT => \N__1169\,
            PACKAGEPIN => i_send_tx_byte_wire(2)
        );

    \i_send_tx_byte_ibuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1171\,
            PADOUT => \N__1170\,
            PADIN => \N__1169\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_byte_c_2,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_byte_obuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1162\,
            DIN => \N__1161\,
            DOUT => \N__1160\,
            PACKAGEPIN => o_mux_tx_byte_wire(5)
        );

    \o_mux_tx_byte_obuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1162\,
            PADOUT => \N__1161\,
            PADIN => \N__1160\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__696\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_status_byte_ibuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1153\,
            DIN => \N__1152\,
            DOUT => \N__1151\,
            PACKAGEPIN => i_fsm_tx_status_byte_wire(3)
        );

    \i_fsm_tx_status_byte_ibuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1153\,
            PADOUT => \N__1152\,
            PADIN => \N__1151\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_status_byte_c_3,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_tx_byte_ibuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1144\,
            DIN => \N__1143\,
            DOUT => \N__1142\,
            PACKAGEPIN => i_send_tx_byte_wire(5)
        );

    \i_send_tx_byte_ibuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1144\,
            PADOUT => \N__1143\,
            PADIN => \N__1142\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_byte_c_5,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_byte_obuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1135\,
            DIN => \N__1134\,
            DOUT => \N__1133\,
            PACKAGEPIN => o_mux_tx_byte_wire(3)
        );

    \o_mux_tx_byte_obuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1135\,
            PADOUT => \N__1134\,
            PADIN => \N__1133\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__825\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_start_pulse_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1126\,
            DIN => \N__1125\,
            DOUT => \N__1124\,
            PACKAGEPIN => i_fsm_tx_start_pulse_wire
        );

    \i_fsm_tx_start_pulse_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1126\,
            PADOUT => \N__1125\,
            PADIN => \N__1124\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_start_pulse_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_status_byte_ibuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1117\,
            DIN => \N__1116\,
            DOUT => \N__1115\,
            PACKAGEPIN => i_fsm_tx_status_byte_wire(1)
        );

    \i_fsm_tx_status_byte_ibuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1117\,
            PADOUT => \N__1116\,
            PADIN => \N__1115\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_status_byte_c_1,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_status_byte_ibuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1108\,
            DIN => \N__1107\,
            DOUT => \N__1106\,
            PACKAGEPIN => i_fsm_tx_status_byte_wire(0)
        );

    \i_fsm_tx_status_byte_ibuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1108\,
            PADOUT => \N__1107\,
            PADIN => \N__1106\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_status_byte_c_0,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_tx_byte_ibuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1099\,
            DIN => \N__1098\,
            DOUT => \N__1097\,
            PACKAGEPIN => i_send_tx_byte_wire(7)
        );

    \i_send_tx_byte_ibuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1099\,
            PADOUT => \N__1098\,
            PADIN => \N__1097\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_byte_c_7,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_tx_start_pulse_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1090\,
            DIN => \N__1089\,
            DOUT => \N__1088\,
            PACKAGEPIN => i_send_tx_start_pulse_wire
        );

    \i_send_tx_start_pulse_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1090\,
            PADOUT => \N__1089\,
            PADIN => \N__1088\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_start_pulse_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_byte_obuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1081\,
            DIN => \N__1080\,
            DOUT => \N__1079\,
            PACKAGEPIN => o_mux_tx_byte_wire(1)
        );

    \o_mux_tx_byte_obuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1081\,
            PADOUT => \N__1080\,
            PADIN => \N__1079\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__891\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_status_byte_ibuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1072\,
            DIN => \N__1071\,
            DOUT => \N__1070\,
            PACKAGEPIN => i_fsm_tx_status_byte_wire(7)
        );

    \i_fsm_tx_status_byte_ibuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1072\,
            PADOUT => \N__1071\,
            PADIN => \N__1070\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_status_byte_c_7,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_tx_byte_ibuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1063\,
            DIN => \N__1062\,
            DOUT => \N__1061\,
            PACKAGEPIN => i_send_tx_byte_wire(0)
        );

    \i_send_tx_byte_ibuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1063\,
            PADOUT => \N__1062\,
            PADIN => \N__1061\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_byte_c_0,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_byte_obuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1054\,
            DIN => \N__1053\,
            DOUT => \N__1052\,
            PACKAGEPIN => o_mux_tx_byte_wire(6)
        );

    \o_mux_tx_byte_obuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1054\,
            PADOUT => \N__1053\,
            PADIN => \N__1052\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__570\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_status_byte_ibuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1045\,
            DIN => \N__1044\,
            DOUT => \N__1043\,
            PACKAGEPIN => i_fsm_tx_status_byte_wire(6)
        );

    \i_fsm_tx_status_byte_ibuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1045\,
            PADOUT => \N__1044\,
            PADIN => \N__1043\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_status_byte_c_6,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_tx_byte_ibuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1036\,
            DIN => \N__1035\,
            DOUT => \N__1034\,
            PACKAGEPIN => i_send_tx_byte_wire(1)
        );

    \i_send_tx_byte_ibuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1036\,
            PADOUT => \N__1035\,
            PADIN => \N__1034\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_byte_c_1,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_byte_obuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1027\,
            DIN => \N__1026\,
            DOUT => \N__1025\,
            PACKAGEPIN => o_mux_tx_byte_wire(7)
        );

    \o_mux_tx_byte_obuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1027\,
            PADOUT => \N__1026\,
            PADIN => \N__1025\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__540\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_byte_obuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1018\,
            DIN => \N__1017\,
            DOUT => \N__1016\,
            PACKAGEPIN => o_mux_tx_byte_wire(4)
        );

    \o_mux_tx_byte_obuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1018\,
            PADOUT => \N__1017\,
            PADIN => \N__1016\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__795\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_status_byte_ibuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1009\,
            DIN => \N__1008\,
            DOUT => \N__1007\,
            PACKAGEPIN => i_fsm_tx_status_byte_wire(4)
        );

    \i_fsm_tx_status_byte_ibuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1009\,
            PADOUT => \N__1008\,
            PADIN => \N__1007\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_status_byte_c_4,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_tx_byte_ibuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1000\,
            DIN => \N__999\,
            DOUT => \N__998\,
            PACKAGEPIN => i_send_tx_byte_wire(3)
        );

    \i_send_tx_byte_ibuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1000\,
            PADOUT => \N__999\,
            PADIN => \N__998\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_byte_c_3,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_start_pulse_obuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__991\,
            DIN => \N__990\,
            DOUT => \N__989\,
            PACKAGEPIN => o_mux_tx_start_pulse_wire
        );

    \o_mux_tx_start_pulse_obuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "010101"
        )
    port map (
            PADOEN => \N__991\,
            PADOUT => \N__990\,
            PADIN => \N__989\,
            CLOCKENABLE => \VCCG0\,
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__525\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => \N__682\
        );

    \i_send_tx_byte_ibuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__982\,
            DIN => \N__981\,
            DOUT => \N__980\,
            PACKAGEPIN => i_send_tx_byte_wire(4)
        );

    \i_send_tx_byte_ibuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__982\,
            PADOUT => \N__981\,
            PADIN => \N__980\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_byte_c_4,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_byte_obuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__973\,
            DIN => \N__972\,
            DOUT => \N__971\,
            PACKAGEPIN => o_mux_tx_byte_wire(2)
        );

    \o_mux_tx_byte_obuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__973\,
            PADOUT => \N__972\,
            PADIN => \N__971\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__858\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_fsm_tx_status_byte_ibuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__964\,
            DIN => \N__963\,
            DOUT => \N__962\,
            PACKAGEPIN => i_fsm_tx_status_byte_wire(2)
        );

    \i_fsm_tx_status_byte_ibuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__964\,
            PADOUT => \N__963\,
            PADIN => \N__962\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_fsm_tx_status_byte_c_2,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_rst_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__955\,
            DIN => \N__954\,
            DOUT => \N__953\,
            PACKAGEPIN => i_rst_wire
        );

    \i_rst_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__955\,
            PADOUT => \N__954\,
            PADIN => \N__953\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_rst_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_tx_byte_ibuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__946\,
            DIN => \N__945\,
            DOUT => \N__944\,
            PACKAGEPIN => i_send_tx_byte_wire(6)
        );

    \i_send_tx_byte_ibuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__946\,
            PADOUT => \N__945\,
            PADIN => \N__944\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_tx_byte_c_6,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_mux_tx_byte_obuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__937\,
            DIN => \N__936\,
            DOUT => \N__935\,
            PACKAGEPIN => o_mux_tx_byte_wire(0)
        );

    \o_mux_tx_byte_obuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__937\,
            PADOUT => \N__936\,
            PADIN => \N__935\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__471\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \I__192\ : InMux
    port map (
            O => \N__918\,
            I => \N__915\
        );

    \I__191\ : LocalMux
    port map (
            O => \N__915\,
            I => \N__912\
        );

    \I__190\ : Span4Mux_h
    port map (
            O => \N__912\,
            I => \N__909\
        );

    \I__189\ : Odrv4
    port map (
            O => \N__909\,
            I => i_send_tx_byte_c_1
        );

    \I__188\ : InMux
    port map (
            O => \N__906\,
            I => \N__903\
        );

    \I__187\ : LocalMux
    port map (
            O => \N__903\,
            I => \N__900\
        );

    \I__186\ : IoSpan4Mux
    port map (
            O => \N__900\,
            I => \N__897\
        );

    \I__185\ : IoSpan4Mux
    port map (
            O => \N__897\,
            I => \N__894\
        );

    \I__184\ : Odrv4
    port map (
            O => \N__894\,
            I => i_fsm_tx_status_byte_c_1
        );

    \I__183\ : IoInMux
    port map (
            O => \N__891\,
            I => \N__888\
        );

    \I__182\ : LocalMux
    port map (
            O => \N__888\,
            I => \N__885\
        );

    \I__181\ : Span4Mux_s0_v
    port map (
            O => \N__885\,
            I => \N__882\
        );

    \I__180\ : Odrv4
    port map (
            O => \N__882\,
            I => o_mux_tx_byte_c_1
        );

    \I__179\ : InMux
    port map (
            O => \N__879\,
            I => \N__876\
        );

    \I__178\ : LocalMux
    port map (
            O => \N__876\,
            I => i_send_tx_byte_c_2
        );

    \I__177\ : InMux
    port map (
            O => \N__873\,
            I => \N__870\
        );

    \I__176\ : LocalMux
    port map (
            O => \N__870\,
            I => \N__867\
        );

    \I__175\ : IoSpan4Mux
    port map (
            O => \N__867\,
            I => \N__864\
        );

    \I__174\ : IoSpan4Mux
    port map (
            O => \N__864\,
            I => \N__861\
        );

    \I__173\ : Odrv4
    port map (
            O => \N__861\,
            I => i_fsm_tx_status_byte_c_2
        );

    \I__172\ : IoInMux
    port map (
            O => \N__858\,
            I => \N__855\
        );

    \I__171\ : LocalMux
    port map (
            O => \N__855\,
            I => \N__852\
        );

    \I__170\ : Span4Mux_s3_h
    port map (
            O => \N__852\,
            I => \N__849\
        );

    \I__169\ : Odrv4
    port map (
            O => \N__849\,
            I => o_mux_tx_byte_c_2
        );

    \I__168\ : InMux
    port map (
            O => \N__846\,
            I => \N__843\
        );

    \I__167\ : LocalMux
    port map (
            O => \N__843\,
            I => i_send_tx_byte_c_3
        );

    \I__166\ : InMux
    port map (
            O => \N__840\,
            I => \N__837\
        );

    \I__165\ : LocalMux
    port map (
            O => \N__837\,
            I => \N__834\
        );

    \I__164\ : Span4Mux_h
    port map (
            O => \N__834\,
            I => \N__831\
        );

    \I__163\ : Span4Mux_h
    port map (
            O => \N__831\,
            I => \N__828\
        );

    \I__162\ : Odrv4
    port map (
            O => \N__828\,
            I => i_fsm_tx_status_byte_c_3
        );

    \I__161\ : IoInMux
    port map (
            O => \N__825\,
            I => \N__822\
        );

    \I__160\ : LocalMux
    port map (
            O => \N__822\,
            I => \N__819\
        );

    \I__159\ : IoSpan4Mux
    port map (
            O => \N__819\,
            I => \N__816\
        );

    \I__158\ : Odrv4
    port map (
            O => \N__816\,
            I => o_mux_tx_byte_c_3
        );

    \I__157\ : InMux
    port map (
            O => \N__813\,
            I => \N__810\
        );

    \I__156\ : LocalMux
    port map (
            O => \N__810\,
            I => i_send_tx_byte_c_4
        );

    \I__155\ : InMux
    port map (
            O => \N__807\,
            I => \N__804\
        );

    \I__154\ : LocalMux
    port map (
            O => \N__804\,
            I => \N__801\
        );

    \I__153\ : Span4Mux_h
    port map (
            O => \N__801\,
            I => \N__798\
        );

    \I__152\ : Odrv4
    port map (
            O => \N__798\,
            I => i_fsm_tx_status_byte_c_4
        );

    \I__151\ : IoInMux
    port map (
            O => \N__795\,
            I => \N__792\
        );

    \I__150\ : LocalMux
    port map (
            O => \N__792\,
            I => \N__789\
        );

    \I__149\ : Span4Mux_s3_h
    port map (
            O => \N__789\,
            I => \N__786\
        );

    \I__148\ : Odrv4
    port map (
            O => \N__786\,
            I => o_mux_tx_byte_c_4
        );

    \I__147\ : InMux
    port map (
            O => \N__783\,
            I => \N__778\
        );

    \I__146\ : InMux
    port map (
            O => \N__782\,
            I => \N__775\
        );

    \I__145\ : InMux
    port map (
            O => \N__781\,
            I => \N__772\
        );

    \I__144\ : LocalMux
    port map (
            O => \N__778\,
            I => \N__760\
        );

    \I__143\ : LocalMux
    port map (
            O => \N__775\,
            I => \N__760\
        );

    \I__142\ : LocalMux
    port map (
            O => \N__772\,
            I => \N__760\
        );

    \I__141\ : InMux
    port map (
            O => \N__771\,
            I => \N__747\
        );

    \I__140\ : InMux
    port map (
            O => \N__770\,
            I => \N__747\
        );

    \I__139\ : InMux
    port map (
            O => \N__769\,
            I => \N__747\
        );

    \I__138\ : InMux
    port map (
            O => \N__768\,
            I => \N__747\
        );

    \I__137\ : InMux
    port map (
            O => \N__767\,
            I => \N__747\
        );

    \I__136\ : Span4Mux_v
    port map (
            O => \N__760\,
            I => \N__744\
        );

    \I__135\ : InMux
    port map (
            O => \N__759\,
            I => \N__739\
        );

    \I__134\ : InMux
    port map (
            O => \N__758\,
            I => \N__739\
        );

    \I__133\ : LocalMux
    port map (
            O => \N__747\,
            I => \N__736\
        );

    \I__132\ : Span4Mux_v
    port map (
            O => \N__744\,
            I => \N__733\
        );

    \I__131\ : LocalMux
    port map (
            O => \N__739\,
            I => \N__730\
        );

    \I__130\ : Span12Mux_v
    port map (
            O => \N__736\,
            I => \N__727\
        );

    \I__129\ : Span4Mux_v
    port map (
            O => \N__733\,
            I => \N__724\
        );

    \I__128\ : Span4Mux_v
    port map (
            O => \N__730\,
            I => \N__721\
        );

    \I__127\ : Odrv12
    port map (
            O => \N__727\,
            I => i_fsm_tx_start_pulse_c
        );

    \I__126\ : Odrv4
    port map (
            O => \N__724\,
            I => i_fsm_tx_start_pulse_c
        );

    \I__125\ : Odrv4
    port map (
            O => \N__721\,
            I => i_fsm_tx_start_pulse_c
        );

    \I__124\ : InMux
    port map (
            O => \N__714\,
            I => \N__711\
        );

    \I__123\ : LocalMux
    port map (
            O => \N__711\,
            I => i_send_tx_byte_c_5
        );

    \I__122\ : InMux
    port map (
            O => \N__708\,
            I => \N__705\
        );

    \I__121\ : LocalMux
    port map (
            O => \N__705\,
            I => \N__702\
        );

    \I__120\ : Span4Mux_h
    port map (
            O => \N__702\,
            I => \N__699\
        );

    \I__119\ : Odrv4
    port map (
            O => \N__699\,
            I => i_fsm_tx_status_byte_c_5
        );

    \I__118\ : IoInMux
    port map (
            O => \N__696\,
            I => \N__693\
        );

    \I__117\ : LocalMux
    port map (
            O => \N__693\,
            I => \N__690\
        );

    \I__116\ : Span4Mux_s3_h
    port map (
            O => \N__690\,
            I => \N__687\
        );

    \I__115\ : Odrv4
    port map (
            O => \N__687\,
            I => o_mux_tx_byte_c_5
        );

    \I__114\ : ClkMux
    port map (
            O => \N__684\,
            I => \N__672\
        );

    \I__113\ : ClkMux
    port map (
            O => \N__683\,
            I => \N__672\
        );

    \I__112\ : ClkMux
    port map (
            O => \N__682\,
            I => \N__672\
        );

    \I__111\ : ClkMux
    port map (
            O => \N__681\,
            I => \N__672\
        );

    \I__110\ : GlobalMux
    port map (
            O => \N__672\,
            I => \N__669\
        );

    \I__109\ : gio2CtrlBuf
    port map (
            O => \N__669\,
            I => i_clk_c_g
        );

    \I__108\ : CEMux
    port map (
            O => \N__666\,
            I => \N__661\
        );

    \I__107\ : CEMux
    port map (
            O => \N__665\,
            I => \N__658\
        );

    \I__106\ : CEMux
    port map (
            O => \N__664\,
            I => \N__655\
        );

    \I__105\ : LocalMux
    port map (
            O => \N__661\,
            I => \N__652\
        );

    \I__104\ : LocalMux
    port map (
            O => \N__658\,
            I => \N__647\
        );

    \I__103\ : LocalMux
    port map (
            O => \N__655\,
            I => \N__647\
        );

    \I__102\ : Span4Mux_v
    port map (
            O => \N__652\,
            I => \N__644\
        );

    \I__101\ : Span4Mux_h
    port map (
            O => \N__647\,
            I => \N__641\
        );

    \I__100\ : Odrv4
    port map (
            O => \N__644\,
            I => seq_proc_un1_i_send_tx_start_pulse_0_i_0
        );

    \I__99\ : Odrv4
    port map (
            O => \N__641\,
            I => seq_proc_un1_i_send_tx_start_pulse_0_i_0
        );

    \I__98\ : SRMux
    port map (
            O => \N__636\,
            I => \N__633\
        );

    \I__97\ : LocalMux
    port map (
            O => \N__633\,
            I => \N__630\
        );

    \I__96\ : Span4Mux_s2_h
    port map (
            O => \N__630\,
            I => \N__624\
        );

    \I__95\ : InMux
    port map (
            O => \N__629\,
            I => \N__621\
        );

    \I__94\ : InMux
    port map (
            O => \N__628\,
            I => \N__618\
        );

    \I__93\ : SRMux
    port map (
            O => \N__627\,
            I => \N__615\
        );

    \I__92\ : Span4Mux_v
    port map (
            O => \N__624\,
            I => \N__611\
        );

    \I__91\ : LocalMux
    port map (
            O => \N__621\,
            I => \N__606\
        );

    \I__90\ : LocalMux
    port map (
            O => \N__618\,
            I => \N__606\
        );

    \I__89\ : LocalMux
    port map (
            O => \N__615\,
            I => \N__603\
        );

    \I__88\ : SRMux
    port map (
            O => \N__614\,
            I => \N__600\
        );

    \I__87\ : Span4Mux_v
    port map (
            O => \N__611\,
            I => \N__591\
        );

    \I__86\ : Span4Mux_v
    port map (
            O => \N__606\,
            I => \N__591\
        );

    \I__85\ : Span4Mux_s2_h
    port map (
            O => \N__603\,
            I => \N__591\
        );

    \I__84\ : LocalMux
    port map (
            O => \N__600\,
            I => \N__591\
        );

    \I__83\ : Span4Mux_h
    port map (
            O => \N__591\,
            I => \N__588\
        );

    \I__82\ : Span4Mux_h
    port map (
            O => \N__588\,
            I => \N__585\
        );

    \I__81\ : Odrv4
    port map (
            O => \N__585\,
            I => i_rst_c
        );

    \I__80\ : InMux
    port map (
            O => \N__582\,
            I => \N__579\
        );

    \I__79\ : LocalMux
    port map (
            O => \N__579\,
            I => i_send_tx_byte_c_6
        );

    \I__78\ : InMux
    port map (
            O => \N__576\,
            I => \N__573\
        );

    \I__77\ : LocalMux
    port map (
            O => \N__573\,
            I => i_fsm_tx_status_byte_c_6
        );

    \I__76\ : IoInMux
    port map (
            O => \N__570\,
            I => \N__567\
        );

    \I__75\ : LocalMux
    port map (
            O => \N__567\,
            I => \N__564\
        );

    \I__74\ : Span4Mux_s0_h
    port map (
            O => \N__564\,
            I => \N__561\
        );

    \I__73\ : Odrv4
    port map (
            O => \N__561\,
            I => o_mux_tx_byte_c_6
        );

    \I__72\ : InMux
    port map (
            O => \N__558\,
            I => \N__555\
        );

    \I__71\ : LocalMux
    port map (
            O => \N__555\,
            I => \N__552\
        );

    \I__70\ : Span4Mux_v
    port map (
            O => \N__552\,
            I => \N__549\
        );

    \I__69\ : Odrv4
    port map (
            O => \N__549\,
            I => i_send_tx_byte_c_7
        );

    \I__68\ : InMux
    port map (
            O => \N__546\,
            I => \N__543\
        );

    \I__67\ : LocalMux
    port map (
            O => \N__543\,
            I => i_fsm_tx_status_byte_c_7
        );

    \I__66\ : IoInMux
    port map (
            O => \N__540\,
            I => \N__537\
        );

    \I__65\ : LocalMux
    port map (
            O => \N__537\,
            I => \N__534\
        );

    \I__64\ : IoSpan4Mux
    port map (
            O => \N__534\,
            I => \N__531\
        );

    \I__63\ : IoSpan4Mux
    port map (
            O => \N__531\,
            I => \N__528\
        );

    \I__62\ : Odrv4
    port map (
            O => \N__528\,
            I => o_mux_tx_byte_c_7
        );

    \I__61\ : IoInMux
    port map (
            O => \N__525\,
            I => \N__522\
        );

    \I__60\ : LocalMux
    port map (
            O => \N__522\,
            I => \N__519\
        );

    \I__59\ : Span4Mux_s1_h
    port map (
            O => \N__519\,
            I => \N__516\
        );

    \I__58\ : Odrv4
    port map (
            O => \N__516\,
            I => \r_mux_tx_start_pulseZ0\
        );

    \I__57\ : InMux
    port map (
            O => \N__513\,
            I => \N__510\
        );

    \I__56\ : LocalMux
    port map (
            O => \N__510\,
            I => \N__506\
        );

    \I__55\ : InMux
    port map (
            O => \N__509\,
            I => \N__503\
        );

    \I__54\ : Span4Mux_s2_h
    port map (
            O => \N__506\,
            I => \N__498\
        );

    \I__53\ : LocalMux
    port map (
            O => \N__503\,
            I => \N__498\
        );

    \I__52\ : Odrv4
    port map (
            O => \N__498\,
            I => i_send_tx_start_pulse_c
        );

    \I__51\ : InMux
    port map (
            O => \N__495\,
            I => \N__492\
        );

    \I__50\ : LocalMux
    port map (
            O => \N__492\,
            I => \N__489\
        );

    \I__49\ : Span4Mux_h
    port map (
            O => \N__489\,
            I => \N__486\
        );

    \I__48\ : Odrv4
    port map (
            O => \N__486\,
            I => i_send_tx_byte_c_0
        );

    \I__47\ : InMux
    port map (
            O => \N__483\,
            I => \N__480\
        );

    \I__46\ : LocalMux
    port map (
            O => \N__480\,
            I => \N__477\
        );

    \I__45\ : Span4Mux_v
    port map (
            O => \N__477\,
            I => \N__474\
        );

    \I__44\ : Odrv4
    port map (
            O => \N__474\,
            I => i_fsm_tx_status_byte_c_0
        );

    \I__43\ : IoInMux
    port map (
            O => \N__471\,
            I => \N__468\
        );

    \I__42\ : LocalMux
    port map (
            O => \N__468\,
            I => o_mux_tx_byte_c_0
        );

    \VCC\ : VCC
    port map (
            Y => \VCCG0\
        );

    \GND\ : GND
    port map (
            Y => \GNDG0\
        );

    \GND_Inst\ : GND
    port map (
            Y => \_gnd_net_\
        );

    \r_mux_tx_byte_esr_6_LC_1_8_0\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1110111001000100"
        )
    port map (
            in0 => \N__758\,
            in1 => \N__582\,
            in2 => \_gnd_net_\,
            in3 => \N__576\,
            lcout => o_mux_tx_byte_c_6,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__681\,
            ce => \N__666\,
            sr => \N__636\
        );

    \r_mux_tx_byte_esr_7_LC_1_8_1\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1100110010101010"
        )
    port map (
            in0 => \N__558\,
            in1 => \N__546\,
            in2 => \_gnd_net_\,
            in3 => \N__759\,
            lcout => o_mux_tx_byte_c_7,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__681\,
            ce => \N__666\,
            sr => \N__636\
        );

    \r_mux_tx_start_pulse_RNO_LC_2_13_4\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "0101010101000100"
        )
    port map (
            in0 => \N__629\,
            in1 => \N__513\,
            in2 => \_gnd_net_\,
            in3 => \N__781\,
            lcout => \r_mux_tx_start_pulseZ0\,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \i_send_tx_start_pulse_ibuf_RNIGI041_LC_2_14_0\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1111111111101110"
        )
    port map (
            in0 => \N__509\,
            in1 => \N__628\,
            in2 => \_gnd_net_\,
            in3 => \N__782\,
            lcout => seq_proc_un1_i_send_tx_start_pulse_0_i_0,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \r_mux_tx_byte_esr_0_LC_2_16_2\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1100110010101010"
        )
    port map (
            in0 => \N__495\,
            in1 => \N__483\,
            in2 => \_gnd_net_\,
            in3 => \N__783\,
            lcout => o_mux_tx_byte_c_0,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__683\,
            ce => \N__664\,
            sr => \N__627\
        );

    \r_mux_tx_byte_esr_1_LC_4_16_3\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1110111001000100"
        )
    port map (
            in0 => \N__767\,
            in1 => \N__918\,
            in2 => \_gnd_net_\,
            in3 => \N__906\,
            lcout => o_mux_tx_byte_c_1,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__684\,
            ce => \N__665\,
            sr => \N__614\
        );

    \r_mux_tx_byte_esr_2_LC_4_16_4\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1100110010101010"
        )
    port map (
            in0 => \N__879\,
            in1 => \N__873\,
            in2 => \_gnd_net_\,
            in3 => \N__768\,
            lcout => o_mux_tx_byte_c_2,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__684\,
            ce => \N__665\,
            sr => \N__614\
        );

    \r_mux_tx_byte_esr_3_LC_4_16_5\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1110111001000100"
        )
    port map (
            in0 => \N__769\,
            in1 => \N__846\,
            in2 => \_gnd_net_\,
            in3 => \N__840\,
            lcout => o_mux_tx_byte_c_3,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__684\,
            ce => \N__665\,
            sr => \N__614\
        );

    \r_mux_tx_byte_esr_4_LC_4_16_6\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1100110010101010"
        )
    port map (
            in0 => \N__813\,
            in1 => \N__807\,
            in2 => \_gnd_net_\,
            in3 => \N__770\,
            lcout => o_mux_tx_byte_c_4,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__684\,
            ce => \N__665\,
            sr => \N__614\
        );

    \r_mux_tx_byte_esr_5_LC_4_16_7\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "1000",
            LUT_INIT => "1110111001000100"
        )
    port map (
            in0 => \N__771\,
            in1 => \N__714\,
            in2 => \_gnd_net_\,
            in3 => \N__708\,
            lcout => o_mux_tx_byte_c_5,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \N__684\,
            ce => \N__665\,
            sr => \N__614\
        );
end \INTERFACE\;
