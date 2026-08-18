-- ******************************************************************************

-- iCEcube Netlister

-- Version:            2020.12.27943

-- Build Date:         Dec  9 2020 18:18:06

-- File Generated:     Aug 18 2026 06:55:32

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
    i_resp_pl_byte : in std_logic_vector(7 downto 0);
    i_send_pl_byte : in std_logic_vector(7 downto 0);
    o_pl_byte : out std_logic_vector(7 downto 0);
    o_send_pl_ready : out std_logic;
    i_grant_sel : in std_logic;
    i_send_pl_valid : in std_logic;
    i_resp_pl_valid : in std_logic;
    o_pl_valid : out std_logic;
    o_resp_pl_ready : out std_logic;
    i_pl_ready : in std_logic);
end tx_mux;

-- Architecture of tx_mux
-- View name is \INTERFACE\
architecture \INTERFACE\ of tx_mux is

signal \N__1192\ : std_logic;
signal \N__1191\ : std_logic;
signal \N__1190\ : std_logic;
signal \N__1183\ : std_logic;
signal \N__1182\ : std_logic;
signal \N__1181\ : std_logic;
signal \N__1174\ : std_logic;
signal \N__1173\ : std_logic;
signal \N__1172\ : std_logic;
signal \N__1165\ : std_logic;
signal \N__1164\ : std_logic;
signal \N__1163\ : std_logic;
signal \N__1156\ : std_logic;
signal \N__1155\ : std_logic;
signal \N__1154\ : std_logic;
signal \N__1147\ : std_logic;
signal \N__1146\ : std_logic;
signal \N__1145\ : std_logic;
signal \N__1138\ : std_logic;
signal \N__1137\ : std_logic;
signal \N__1136\ : std_logic;
signal \N__1129\ : std_logic;
signal \N__1128\ : std_logic;
signal \N__1127\ : std_logic;
signal \N__1120\ : std_logic;
signal \N__1119\ : std_logic;
signal \N__1118\ : std_logic;
signal \N__1111\ : std_logic;
signal \N__1110\ : std_logic;
signal \N__1109\ : std_logic;
signal \N__1102\ : std_logic;
signal \N__1101\ : std_logic;
signal \N__1100\ : std_logic;
signal \N__1093\ : std_logic;
signal \N__1092\ : std_logic;
signal \N__1091\ : std_logic;
signal \N__1084\ : std_logic;
signal \N__1083\ : std_logic;
signal \N__1082\ : std_logic;
signal \N__1075\ : std_logic;
signal \N__1074\ : std_logic;
signal \N__1073\ : std_logic;
signal \N__1066\ : std_logic;
signal \N__1065\ : std_logic;
signal \N__1064\ : std_logic;
signal \N__1057\ : std_logic;
signal \N__1056\ : std_logic;
signal \N__1055\ : std_logic;
signal \N__1048\ : std_logic;
signal \N__1047\ : std_logic;
signal \N__1046\ : std_logic;
signal \N__1039\ : std_logic;
signal \N__1038\ : std_logic;
signal \N__1037\ : std_logic;
signal \N__1030\ : std_logic;
signal \N__1029\ : std_logic;
signal \N__1028\ : std_logic;
signal \N__1021\ : std_logic;
signal \N__1020\ : std_logic;
signal \N__1019\ : std_logic;
signal \N__1012\ : std_logic;
signal \N__1011\ : std_logic;
signal \N__1010\ : std_logic;
signal \N__1003\ : std_logic;
signal \N__1002\ : std_logic;
signal \N__1001\ : std_logic;
signal \N__994\ : std_logic;
signal \N__993\ : std_logic;
signal \N__992\ : std_logic;
signal \N__985\ : std_logic;
signal \N__984\ : std_logic;
signal \N__983\ : std_logic;
signal \N__976\ : std_logic;
signal \N__975\ : std_logic;
signal \N__974\ : std_logic;
signal \N__967\ : std_logic;
signal \N__966\ : std_logic;
signal \N__965\ : std_logic;
signal \N__958\ : std_logic;
signal \N__957\ : std_logic;
signal \N__956\ : std_logic;
signal \N__949\ : std_logic;
signal \N__948\ : std_logic;
signal \N__947\ : std_logic;
signal \N__940\ : std_logic;
signal \N__939\ : std_logic;
signal \N__938\ : std_logic;
signal \N__931\ : std_logic;
signal \N__930\ : std_logic;
signal \N__929\ : std_logic;
signal \N__922\ : std_logic;
signal \N__921\ : std_logic;
signal \N__920\ : std_logic;
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
signal \N__788\ : std_logic;
signal \N__783\ : std_logic;
signal \N__780\ : std_logic;
signal \N__779\ : std_logic;
signal \N__778\ : std_logic;
signal \N__777\ : std_logic;
signal \N__776\ : std_logic;
signal \N__775\ : std_logic;
signal \N__762\ : std_logic;
signal \N__759\ : std_logic;
signal \N__758\ : std_logic;
signal \N__757\ : std_logic;
signal \N__754\ : std_logic;
signal \N__749\ : std_logic;
signal \N__748\ : std_logic;
signal \N__747\ : std_logic;
signal \N__746\ : std_logic;
signal \N__743\ : std_logic;
signal \N__740\ : std_logic;
signal \N__733\ : std_logic;
signal \N__730\ : std_logic;
signal \N__725\ : std_logic;
signal \N__722\ : std_logic;
signal \N__719\ : std_logic;
signal \N__716\ : std_logic;
signal \N__713\ : std_logic;
signal \N__708\ : std_logic;
signal \N__705\ : std_logic;
signal \N__702\ : std_logic;
signal \N__699\ : std_logic;
signal \N__696\ : std_logic;
signal \N__693\ : std_logic;
signal \N__690\ : std_logic;
signal \N__687\ : std_logic;
signal \N__684\ : std_logic;
signal \N__681\ : std_logic;
signal \N__678\ : std_logic;
signal \N__675\ : std_logic;
signal \N__672\ : std_logic;
signal \N__669\ : std_logic;
signal \N__666\ : std_logic;
signal \N__663\ : std_logic;
signal \N__660\ : std_logic;
signal \N__657\ : std_logic;
signal \N__654\ : std_logic;
signal \N__651\ : std_logic;
signal \N__648\ : std_logic;
signal \N__645\ : std_logic;
signal \N__642\ : std_logic;
signal \N__639\ : std_logic;
signal \N__636\ : std_logic;
signal \N__633\ : std_logic;
signal \N__630\ : std_logic;
signal \N__627\ : std_logic;
signal \N__624\ : std_logic;
signal \N__621\ : std_logic;
signal \N__618\ : std_logic;
signal \N__615\ : std_logic;
signal \N__612\ : std_logic;
signal \N__609\ : std_logic;
signal \N__606\ : std_logic;
signal \N__603\ : std_logic;
signal \N__600\ : std_logic;
signal \N__597\ : std_logic;
signal \N__594\ : std_logic;
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
signal \N__507\ : std_logic;
signal \N__504\ : std_logic;
signal \N__501\ : std_logic;
signal \VCCG0\ : std_logic;
signal \GNDG0\ : std_logic;
signal i_send_pl_byte_c_6 : std_logic;
signal i_resp_pl_byte_c_6 : std_logic;
signal o_pl_byte_c_6 : std_logic;
signal i_send_pl_byte_c_7 : std_logic;
signal i_resp_pl_byte_c_7 : std_logic;
signal o_pl_byte_c_7 : std_logic;
signal i_resp_pl_valid_c : std_logic;
signal i_send_pl_valid_c : std_logic;
signal o_pl_valid_c : std_logic;
signal i_resp_pl_byte_c_0 : std_logic;
signal i_send_pl_byte_c_0 : std_logic;
signal o_pl_byte_c_0 : std_logic;
signal i_send_pl_byte_c_5 : std_logic;
signal i_resp_pl_byte_c_5 : std_logic;
signal o_pl_byte_c_5 : std_logic;
signal i_send_pl_byte_c_1 : std_logic;
signal i_resp_pl_byte_c_1 : std_logic;
signal o_pl_byte_c_1 : std_logic;
signal i_send_pl_byte_c_2 : std_logic;
signal i_resp_pl_byte_c_2 : std_logic;
signal o_pl_byte_c_2 : std_logic;
signal i_send_pl_byte_c_3 : std_logic;
signal i_resp_pl_byte_c_3 : std_logic;
signal o_pl_byte_c_3 : std_logic;
signal i_resp_pl_byte_c_4 : std_logic;
signal i_send_pl_byte_c_4 : std_logic;
signal o_pl_byte_c_4 : std_logic;
signal o_resp_pl_ready_c : std_logic;
signal i_pl_ready_c : std_logic;
signal i_grant_sel_c : std_logic;
signal o_send_pl_ready_c : std_logic;
signal \_gnd_net_\ : std_logic;

signal i_resp_pl_byte_wire : std_logic_vector(7 downto 0);
signal o_send_pl_ready_wire : std_logic;
signal i_send_pl_valid_wire : std_logic;
signal o_pl_byte_wire : std_logic_vector(7 downto 0);
signal i_send_pl_byte_wire : std_logic_vector(7 downto 0);
signal o_resp_pl_ready_wire : std_logic;
signal o_pl_valid_wire : std_logic;
signal i_grant_sel_wire : std_logic;
signal i_resp_pl_valid_wire : std_logic;
signal i_pl_ready_wire : std_logic;

begin
    i_resp_pl_byte_wire <= i_resp_pl_byte;
    o_send_pl_ready <= o_send_pl_ready_wire;
    i_send_pl_valid_wire <= i_send_pl_valid;
    o_pl_byte <= o_pl_byte_wire;
    i_send_pl_byte_wire <= i_send_pl_byte;
    o_resp_pl_ready <= o_resp_pl_ready_wire;
    o_pl_valid <= o_pl_valid_wire;
    i_grant_sel_wire <= i_grant_sel;
    i_resp_pl_valid_wire <= i_resp_pl_valid;
    i_pl_ready_wire <= i_pl_ready;

    \i_resp_pl_byte_ibuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1192\,
            DIN => \N__1191\,
            DOUT => \N__1190\,
            PACKAGEPIN => i_resp_pl_byte_wire(5)
        );

    \i_resp_pl_byte_ibuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1192\,
            PADOUT => \N__1191\,
            PADIN => \N__1190\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_byte_c_5,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_send_pl_ready_obuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1183\,
            DIN => \N__1182\,
            DOUT => \N__1181\,
            PACKAGEPIN => o_send_pl_ready_wire
        );

    \o_send_pl_ready_obuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1183\,
            PADOUT => \N__1182\,
            PADIN => \N__1181\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__708\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_valid_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1174\,
            DIN => \N__1173\,
            DOUT => \N__1172\,
            PACKAGEPIN => i_send_pl_valid_wire
        );

    \i_send_pl_valid_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1174\,
            PADOUT => \N__1173\,
            PADIN => \N__1172\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_valid_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_byte_obuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1165\,
            DIN => \N__1164\,
            DOUT => \N__1163\,
            PACKAGEPIN => o_pl_byte_wire(1)
        );

    \o_pl_byte_obuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1165\,
            PADOUT => \N__1164\,
            PADIN => \N__1163\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__510\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_resp_pl_byte_ibuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1156\,
            DIN => \N__1155\,
            DOUT => \N__1154\,
            PACKAGEPIN => i_resp_pl_byte_wire(7)
        );

    \i_resp_pl_byte_ibuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1156\,
            PADOUT => \N__1155\,
            PADIN => \N__1154\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_byte_c_7,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_byte_ibuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1147\,
            DIN => \N__1146\,
            DOUT => \N__1145\,
            PACKAGEPIN => i_send_pl_byte_wire(5)
        );

    \i_send_pl_byte_ibuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1147\,
            PADOUT => \N__1146\,
            PADIN => \N__1145\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_byte_c_5,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_resp_pl_ready_obuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1138\,
            DIN => \N__1137\,
            DOUT => \N__1136\,
            PACKAGEPIN => o_resp_pl_ready_wire
        );

    \o_resp_pl_ready_obuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1138\,
            PADOUT => \N__1137\,
            PADIN => \N__1136\,
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

    \i_resp_pl_byte_ibuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1129\,
            DIN => \N__1128\,
            DOUT => \N__1127\,
            PACKAGEPIN => i_resp_pl_byte_wire(0)
        );

    \i_resp_pl_byte_ibuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1129\,
            PADOUT => \N__1128\,
            PADIN => \N__1127\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_byte_c_0,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_byte_ibuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1120\,
            DIN => \N__1119\,
            DOUT => \N__1118\,
            PACKAGEPIN => i_send_pl_byte_wire(6)
        );

    \i_send_pl_byte_ibuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1120\,
            PADOUT => \N__1119\,
            PADIN => \N__1118\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_byte_c_6,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_byte_obuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1111\,
            DIN => \N__1110\,
            DOUT => \N__1109\,
            PACKAGEPIN => o_pl_byte_wire(7)
        );

    \o_pl_byte_obuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1111\,
            PADOUT => \N__1110\,
            PADIN => \N__1109\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__654\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_resp_pl_byte_ibuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1102\,
            DIN => \N__1101\,
            DOUT => \N__1100\,
            PACKAGEPIN => i_resp_pl_byte_wire(1)
        );

    \i_resp_pl_byte_ibuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1102\,
            PADOUT => \N__1101\,
            PADIN => \N__1100\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_byte_c_1,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_byte_ibuf_7_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1093\,
            DIN => \N__1092\,
            DOUT => \N__1091\,
            PACKAGEPIN => i_send_pl_byte_wire(7)
        );

    \i_send_pl_byte_ibuf_7_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1093\,
            PADOUT => \N__1092\,
            PADIN => \N__1091\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_byte_c_7,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_byte_obuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1084\,
            DIN => \N__1083\,
            DOUT => \N__1082\,
            PACKAGEPIN => o_pl_byte_wire(6)
        );

    \o_pl_byte_obuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1084\,
            PADOUT => \N__1083\,
            PADIN => \N__1082\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__684\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_resp_pl_byte_ibuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1075\,
            DIN => \N__1074\,
            DOUT => \N__1073\,
            PACKAGEPIN => i_resp_pl_byte_wire(2)
        );

    \i_resp_pl_byte_ibuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1075\,
            PADOUT => \N__1074\,
            PADIN => \N__1073\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_byte_c_2,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_byte_ibuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1066\,
            DIN => \N__1065\,
            DOUT => \N__1064\,
            PACKAGEPIN => i_send_pl_byte_wire(0)
        );

    \i_send_pl_byte_ibuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1066\,
            PADOUT => \N__1065\,
            PADIN => \N__1064\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_byte_c_0,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_byte_obuf_5_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1057\,
            DIN => \N__1056\,
            DOUT => \N__1055\,
            PACKAGEPIN => o_pl_byte_wire(5)
        );

    \o_pl_byte_obuf_5_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1057\,
            PADOUT => \N__1056\,
            PADIN => \N__1055\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__552\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_valid_obuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1048\,
            DIN => \N__1047\,
            DOUT => \N__1046\,
            PACKAGEPIN => o_pl_valid_wire
        );

    \o_pl_valid_obuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1048\,
            PADOUT => \N__1047\,
            PADIN => \N__1046\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__624\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_grant_sel_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1039\,
            DIN => \N__1038\,
            DOUT => \N__1037\,
            PACKAGEPIN => i_grant_sel_wire
        );

    \i_grant_sel_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1039\,
            PADOUT => \N__1038\,
            PADIN => \N__1037\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_grant_sel_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_resp_pl_byte_ibuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1030\,
            DIN => \N__1029\,
            DOUT => \N__1028\,
            PACKAGEPIN => i_resp_pl_byte_wire(3)
        );

    \i_resp_pl_byte_ibuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1030\,
            PADOUT => \N__1029\,
            PADIN => \N__1028\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_byte_c_3,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_resp_pl_valid_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1021\,
            DIN => \N__1020\,
            DOUT => \N__1019\,
            PACKAGEPIN => i_resp_pl_valid_wire
        );

    \i_resp_pl_valid_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1021\,
            PADOUT => \N__1020\,
            PADIN => \N__1019\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_valid_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_byte_ibuf_1_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1012\,
            DIN => \N__1011\,
            DOUT => \N__1010\,
            PACKAGEPIN => i_send_pl_byte_wire(1)
        );

    \i_send_pl_byte_ibuf_1_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__1012\,
            PADOUT => \N__1011\,
            PADIN => \N__1010\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_byte_c_1,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_byte_obuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__1003\,
            DIN => \N__1002\,
            DOUT => \N__1001\,
            PACKAGEPIN => o_pl_byte_wire(4)
        );

    \o_pl_byte_obuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__1003\,
            PADOUT => \N__1002\,
            PADIN => \N__1001\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__810\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_resp_pl_byte_ibuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__994\,
            DIN => \N__993\,
            DOUT => \N__992\,
            PACKAGEPIN => i_resp_pl_byte_wire(4)
        );

    \i_resp_pl_byte_ibuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__994\,
            PADOUT => \N__993\,
            PADIN => \N__992\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_byte_c_4,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_byte_ibuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__985\,
            DIN => \N__984\,
            DOUT => \N__983\,
            PACKAGEPIN => i_send_pl_byte_wire(2)
        );

    \i_send_pl_byte_ibuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__985\,
            PADOUT => \N__984\,
            PADIN => \N__983\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_byte_c_2,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_byte_obuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__976\,
            DIN => \N__975\,
            DOUT => \N__974\,
            PACKAGEPIN => o_pl_byte_wire(3)
        );

    \o_pl_byte_obuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__976\,
            PADOUT => \N__975\,
            PADIN => \N__974\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__843\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_pl_ready_ibuf_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__967\,
            DIN => \N__966\,
            DOUT => \N__965\,
            PACKAGEPIN => i_pl_ready_wire
        );

    \i_pl_ready_ibuf_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__967\,
            PADOUT => \N__966\,
            PADIN => \N__965\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_pl_ready_c,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_byte_ibuf_3_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__958\,
            DIN => \N__957\,
            DOUT => \N__956\,
            PACKAGEPIN => i_send_pl_byte_wire(3)
        );

    \i_send_pl_byte_ibuf_3_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__958\,
            PADOUT => \N__957\,
            PADIN => \N__956\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_byte_c_3,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_byte_obuf_2_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__949\,
            DIN => \N__948\,
            DOUT => \N__947\,
            PACKAGEPIN => o_pl_byte_wire(2)
        );

    \o_pl_byte_obuf_2_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__949\,
            PADOUT => \N__948\,
            PADIN => \N__947\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__879\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_resp_pl_byte_ibuf_6_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__940\,
            DIN => \N__939\,
            DOUT => \N__938\,
            PACKAGEPIN => i_resp_pl_byte_wire(6)
        );

    \i_resp_pl_byte_ibuf_6_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__940\,
            PADOUT => \N__939\,
            PADIN => \N__938\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_resp_pl_byte_c_6,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \i_send_pl_byte_ibuf_4_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__931\,
            DIN => \N__930\,
            DOUT => \N__929\,
            PACKAGEPIN => i_send_pl_byte_wire(4)
        );

    \i_send_pl_byte_ibuf_4_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "000001"
        )
    port map (
            PADOEN => \N__931\,
            PADOUT => \N__930\,
            PADIN => \N__929\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => i_send_pl_byte_c_4,
            DOUT0 => '0',
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \o_pl_byte_obuf_0_iopad\ : IO_PAD
    generic map (
            IO_STANDARD => "SB_LVCMOS",
            PULLUP => '0'
        )
    port map (
            OE => \N__922\,
            DIN => \N__921\,
            DOUT => \N__920\,
            PACKAGEPIN => o_pl_byte_wire(0)
        );

    \o_pl_byte_obuf_0_preio\ : PRE_IO
    generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE => "011001"
        )
    port map (
            PADOEN => \N__922\,
            PADOUT => \N__921\,
            PADIN => \N__920\,
            CLOCKENABLE => 'H',
            DOUT1 => '0',
            OUTPUTENABLE => '0',
            DIN0 => OPEN,
            DOUT0 => \N__588\,
            INPUTCLK => '0',
            LATCHINPUTVALUE => '0',
            DIN1 => OPEN,
            OUTPUTCLK => '0'
        );

    \I__179\ : InMux
    port map (
            O => \N__903\,
            I => \N__900\
        );

    \I__178\ : LocalMux
    port map (
            O => \N__900\,
            I => i_send_pl_byte_c_2
        );

    \I__177\ : InMux
    port map (
            O => \N__897\,
            I => \N__894\
        );

    \I__176\ : LocalMux
    port map (
            O => \N__894\,
            I => \N__891\
        );

    \I__175\ : Span4Mux_s2_v
    port map (
            O => \N__891\,
            I => \N__888\
        );

    \I__174\ : Sp12to4
    port map (
            O => \N__888\,
            I => \N__885\
        );

    \I__173\ : Span12Mux_h
    port map (
            O => \N__885\,
            I => \N__882\
        );

    \I__172\ : Odrv12
    port map (
            O => \N__882\,
            I => i_resp_pl_byte_c_2
        );

    \I__171\ : IoInMux
    port map (
            O => \N__879\,
            I => \N__876\
        );

    \I__170\ : LocalMux
    port map (
            O => \N__876\,
            I => \N__873\
        );

    \I__169\ : Span4Mux_s0_v
    port map (
            O => \N__873\,
            I => \N__870\
        );

    \I__168\ : Sp12to4
    port map (
            O => \N__870\,
            I => \N__867\
        );

    \I__167\ : Odrv12
    port map (
            O => \N__867\,
            I => o_pl_byte_c_2
        );

    \I__166\ : InMux
    port map (
            O => \N__864\,
            I => \N__861\
        );

    \I__165\ : LocalMux
    port map (
            O => \N__861\,
            I => i_send_pl_byte_c_3
        );

    \I__164\ : InMux
    port map (
            O => \N__858\,
            I => \N__855\
        );

    \I__163\ : LocalMux
    port map (
            O => \N__855\,
            I => \N__852\
        );

    \I__162\ : Span4Mux_h
    port map (
            O => \N__852\,
            I => \N__849\
        );

    \I__161\ : Span4Mux_h
    port map (
            O => \N__849\,
            I => \N__846\
        );

    \I__160\ : Odrv4
    port map (
            O => \N__846\,
            I => i_resp_pl_byte_c_3
        );

    \I__159\ : IoInMux
    port map (
            O => \N__843\,
            I => \N__840\
        );

    \I__158\ : LocalMux
    port map (
            O => \N__840\,
            I => \N__837\
        );

    \I__157\ : Span4Mux_s0_v
    port map (
            O => \N__837\,
            I => \N__834\
        );

    \I__156\ : Span4Mux_h
    port map (
            O => \N__834\,
            I => \N__831\
        );

    \I__155\ : Odrv4
    port map (
            O => \N__831\,
            I => o_pl_byte_c_3
        );

    \I__154\ : InMux
    port map (
            O => \N__828\,
            I => \N__825\
        );

    \I__153\ : LocalMux
    port map (
            O => \N__825\,
            I => \N__822\
        );

    \I__152\ : Span4Mux_h
    port map (
            O => \N__822\,
            I => \N__819\
        );

    \I__151\ : Odrv4
    port map (
            O => \N__819\,
            I => i_resp_pl_byte_c_4
        );

    \I__150\ : InMux
    port map (
            O => \N__816\,
            I => \N__813\
        );

    \I__149\ : LocalMux
    port map (
            O => \N__813\,
            I => i_send_pl_byte_c_4
        );

    \I__148\ : IoInMux
    port map (
            O => \N__810\,
            I => \N__807\
        );

    \I__147\ : LocalMux
    port map (
            O => \N__807\,
            I => \N__804\
        );

    \I__146\ : IoSpan4Mux
    port map (
            O => \N__804\,
            I => \N__801\
        );

    \I__145\ : Span4Mux_s0_v
    port map (
            O => \N__801\,
            I => \N__798\
        );

    \I__144\ : Odrv4
    port map (
            O => \N__798\,
            I => o_pl_byte_c_4
        );

    \I__143\ : IoInMux
    port map (
            O => \N__795\,
            I => \N__792\
        );

    \I__142\ : LocalMux
    port map (
            O => \N__792\,
            I => o_resp_pl_ready_c
        );

    \I__141\ : InMux
    port map (
            O => \N__789\,
            I => \N__783\
        );

    \I__140\ : InMux
    port map (
            O => \N__788\,
            I => \N__783\
        );

    \I__139\ : LocalMux
    port map (
            O => \N__783\,
            I => i_pl_ready_c
        );

    \I__138\ : InMux
    port map (
            O => \N__780\,
            I => \N__762\
        );

    \I__137\ : InMux
    port map (
            O => \N__779\,
            I => \N__762\
        );

    \I__136\ : InMux
    port map (
            O => \N__778\,
            I => \N__762\
        );

    \I__135\ : InMux
    port map (
            O => \N__777\,
            I => \N__762\
        );

    \I__134\ : InMux
    port map (
            O => \N__776\,
            I => \N__762\
        );

    \I__133\ : InMux
    port map (
            O => \N__775\,
            I => \N__762\
        );

    \I__132\ : LocalMux
    port map (
            O => \N__762\,
            I => \N__759\
        );

    \I__131\ : Span4Mux_h
    port map (
            O => \N__759\,
            I => \N__754\
        );

    \I__130\ : InMux
    port map (
            O => \N__758\,
            I => \N__749\
        );

    \I__129\ : InMux
    port map (
            O => \N__757\,
            I => \N__749\
        );

    \I__128\ : Sp12to4
    port map (
            O => \N__754\,
            I => \N__743\
        );

    \I__127\ : LocalMux
    port map (
            O => \N__749\,
            I => \N__740\
        );

    \I__126\ : InMux
    port map (
            O => \N__748\,
            I => \N__733\
        );

    \I__125\ : InMux
    port map (
            O => \N__747\,
            I => \N__733\
        );

    \I__124\ : InMux
    port map (
            O => \N__746\,
            I => \N__733\
        );

    \I__123\ : Span12Mux_s8_v
    port map (
            O => \N__743\,
            I => \N__730\
        );

    \I__122\ : Span4Mux_h
    port map (
            O => \N__740\,
            I => \N__725\
        );

    \I__121\ : LocalMux
    port map (
            O => \N__733\,
            I => \N__725\
        );

    \I__120\ : Span12Mux_h
    port map (
            O => \N__730\,
            I => \N__722\
        );

    \I__119\ : Span4Mux_h
    port map (
            O => \N__725\,
            I => \N__719\
        );

    \I__118\ : Span12Mux_v
    port map (
            O => \N__722\,
            I => \N__716\
        );

    \I__117\ : IoSpan4Mux
    port map (
            O => \N__719\,
            I => \N__713\
        );

    \I__116\ : Odrv12
    port map (
            O => \N__716\,
            I => i_grant_sel_c
        );

    \I__115\ : Odrv4
    port map (
            O => \N__713\,
            I => i_grant_sel_c
        );

    \I__114\ : IoInMux
    port map (
            O => \N__708\,
            I => \N__705\
        );

    \I__113\ : LocalMux
    port map (
            O => \N__705\,
            I => o_send_pl_ready_c
        );

    \I__112\ : InMux
    port map (
            O => \N__702\,
            I => \N__699\
        );

    \I__111\ : LocalMux
    port map (
            O => \N__699\,
            I => i_send_pl_byte_c_6
        );

    \I__110\ : InMux
    port map (
            O => \N__696\,
            I => \N__693\
        );

    \I__109\ : LocalMux
    port map (
            O => \N__693\,
            I => \N__690\
        );

    \I__108\ : Span4Mux_h
    port map (
            O => \N__690\,
            I => \N__687\
        );

    \I__107\ : Odrv4
    port map (
            O => \N__687\,
            I => i_resp_pl_byte_c_6
        );

    \I__106\ : IoInMux
    port map (
            O => \N__684\,
            I => \N__681\
        );

    \I__105\ : LocalMux
    port map (
            O => \N__681\,
            I => \N__678\
        );

    \I__104\ : Span12Mux_s0_v
    port map (
            O => \N__678\,
            I => \N__675\
        );

    \I__103\ : Odrv12
    port map (
            O => \N__675\,
            I => o_pl_byte_c_6
        );

    \I__102\ : InMux
    port map (
            O => \N__672\,
            I => \N__669\
        );

    \I__101\ : LocalMux
    port map (
            O => \N__669\,
            I => i_send_pl_byte_c_7
        );

    \I__100\ : InMux
    port map (
            O => \N__666\,
            I => \N__663\
        );

    \I__99\ : LocalMux
    port map (
            O => \N__663\,
            I => \N__660\
        );

    \I__98\ : Span4Mux_h
    port map (
            O => \N__660\,
            I => \N__657\
        );

    \I__97\ : Odrv4
    port map (
            O => \N__657\,
            I => i_resp_pl_byte_c_7
        );

    \I__96\ : IoInMux
    port map (
            O => \N__654\,
            I => \N__651\
        );

    \I__95\ : LocalMux
    port map (
            O => \N__651\,
            I => \N__648\
        );

    \I__94\ : IoSpan4Mux
    port map (
            O => \N__648\,
            I => \N__645\
        );

    \I__93\ : Odrv4
    port map (
            O => \N__645\,
            I => o_pl_byte_c_7
        );

    \I__92\ : InMux
    port map (
            O => \N__642\,
            I => \N__639\
        );

    \I__91\ : LocalMux
    port map (
            O => \N__639\,
            I => \N__636\
        );

    \I__90\ : Span4Mux_h
    port map (
            O => \N__636\,
            I => \N__633\
        );

    \I__89\ : Odrv4
    port map (
            O => \N__633\,
            I => i_resp_pl_valid_c
        );

    \I__88\ : InMux
    port map (
            O => \N__630\,
            I => \N__627\
        );

    \I__87\ : LocalMux
    port map (
            O => \N__627\,
            I => i_send_pl_valid_c
        );

    \I__86\ : IoInMux
    port map (
            O => \N__624\,
            I => \N__621\
        );

    \I__85\ : LocalMux
    port map (
            O => \N__621\,
            I => \N__618\
        );

    \I__84\ : IoSpan4Mux
    port map (
            O => \N__618\,
            I => \N__615\
        );

    \I__83\ : IoSpan4Mux
    port map (
            O => \N__615\,
            I => \N__612\
        );

    \I__82\ : Odrv4
    port map (
            O => \N__612\,
            I => o_pl_valid_c
        );

    \I__81\ : InMux
    port map (
            O => \N__609\,
            I => \N__606\
        );

    \I__80\ : LocalMux
    port map (
            O => \N__606\,
            I => \N__603\
        );

    \I__79\ : Sp12to4
    port map (
            O => \N__603\,
            I => \N__600\
        );

    \I__78\ : Span12Mux_h
    port map (
            O => \N__600\,
            I => \N__597\
        );

    \I__77\ : Odrv12
    port map (
            O => \N__597\,
            I => i_resp_pl_byte_c_0
        );

    \I__76\ : InMux
    port map (
            O => \N__594\,
            I => \N__591\
        );

    \I__75\ : LocalMux
    port map (
            O => \N__591\,
            I => i_send_pl_byte_c_0
        );

    \I__74\ : IoInMux
    port map (
            O => \N__588\,
            I => \N__585\
        );

    \I__73\ : LocalMux
    port map (
            O => \N__585\,
            I => \N__582\
        );

    \I__72\ : Span4Mux_s0_v
    port map (
            O => \N__582\,
            I => \N__579\
        );

    \I__71\ : Odrv4
    port map (
            O => \N__579\,
            I => o_pl_byte_c_0
        );

    \I__70\ : InMux
    port map (
            O => \N__576\,
            I => \N__573\
        );

    \I__69\ : LocalMux
    port map (
            O => \N__573\,
            I => \N__570\
        );

    \I__68\ : Span4Mux_h
    port map (
            O => \N__570\,
            I => \N__567\
        );

    \I__67\ : Odrv4
    port map (
            O => \N__567\,
            I => i_send_pl_byte_c_5
        );

    \I__66\ : InMux
    port map (
            O => \N__564\,
            I => \N__561\
        );

    \I__65\ : LocalMux
    port map (
            O => \N__561\,
            I => \N__558\
        );

    \I__64\ : Span4Mux_h
    port map (
            O => \N__558\,
            I => \N__555\
        );

    \I__63\ : Odrv4
    port map (
            O => \N__555\,
            I => i_resp_pl_byte_c_5
        );

    \I__62\ : IoInMux
    port map (
            O => \N__552\,
            I => \N__549\
        );

    \I__61\ : LocalMux
    port map (
            O => \N__549\,
            I => \N__546\
        );

    \I__60\ : IoSpan4Mux
    port map (
            O => \N__546\,
            I => \N__543\
        );

    \I__59\ : Span4Mux_s3_v
    port map (
            O => \N__543\,
            I => \N__540\
        );

    \I__58\ : Span4Mux_v
    port map (
            O => \N__540\,
            I => \N__537\
        );

    \I__57\ : Sp12to4
    port map (
            O => \N__537\,
            I => \N__534\
        );

    \I__56\ : Span12Mux_v
    port map (
            O => \N__534\,
            I => \N__531\
        );

    \I__55\ : Odrv12
    port map (
            O => \N__531\,
            I => o_pl_byte_c_5
        );

    \I__54\ : InMux
    port map (
            O => \N__528\,
            I => \N__525\
        );

    \I__53\ : LocalMux
    port map (
            O => \N__525\,
            I => i_send_pl_byte_c_1
        );

    \I__52\ : InMux
    port map (
            O => \N__522\,
            I => \N__519\
        );

    \I__51\ : LocalMux
    port map (
            O => \N__519\,
            I => \N__516\
        );

    \I__50\ : Span12Mux_h
    port map (
            O => \N__516\,
            I => \N__513\
        );

    \I__49\ : Odrv12
    port map (
            O => \N__513\,
            I => i_resp_pl_byte_c_1
        );

    \I__48\ : IoInMux
    port map (
            O => \N__510\,
            I => \N__507\
        );

    \I__47\ : LocalMux
    port map (
            O => \N__507\,
            I => \N__504\
        );

    \I__46\ : Span12Mux_s0_v
    port map (
            O => \N__504\,
            I => \N__501\
        );

    \I__45\ : Odrv12
    port map (
            O => \N__501\,
            I => o_pl_byte_c_1
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

    \o_pl_byte_obuf_RNO_6_LC_13_30_0\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1010101011001100"
        )
    port map (
            in0 => \N__702\,
            in1 => \N__696\,
            in2 => \_gnd_net_\,
            in3 => \N__746\,
            lcout => o_pl_byte_c_6,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_pl_byte_obuf_RNO_7_LC_13_30_1\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1101110110001000"
        )
    port map (
            in0 => \N__747\,
            in1 => \N__672\,
            in2 => \_gnd_net_\,
            in3 => \N__666\,
            lcout => o_pl_byte_c_7,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_pl_valid_obuf_RNO_LC_13_30_2\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1100110010101010"
        )
    port map (
            in0 => \N__642\,
            in1 => \N__630\,
            in2 => \_gnd_net_\,
            in3 => \N__748\,
            lcout => o_pl_valid_c,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_pl_byte_obuf_RNO_0_LC_18_1_0\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1100110010101010"
        )
    port map (
            in0 => \N__609\,
            in1 => \N__594\,
            in2 => \_gnd_net_\,
            in3 => \N__775\,
            lcout => o_pl_byte_c_0,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_pl_byte_obuf_RNO_5_LC_18_1_1\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1101110110001000"
        )
    port map (
            in0 => \N__780\,
            in1 => \N__576\,
            in2 => \_gnd_net_\,
            in3 => \N__564\,
            lcout => o_pl_byte_c_5,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_pl_byte_obuf_RNO_1_LC_18_1_3\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1101110110001000"
        )
    port map (
            in0 => \N__776\,
            in1 => \N__528\,
            in2 => \_gnd_net_\,
            in3 => \N__522\,
            lcout => o_pl_byte_c_1,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_pl_byte_obuf_RNO_2_LC_18_1_4\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1010101011001100"
        )
    port map (
            in0 => \N__903\,
            in1 => \N__897\,
            in2 => \_gnd_net_\,
            in3 => \N__777\,
            lcout => o_pl_byte_c_2,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_pl_byte_obuf_RNO_3_LC_18_1_5\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1101110110001000"
        )
    port map (
            in0 => \N__778\,
            in1 => \N__864\,
            in2 => \_gnd_net_\,
            in3 => \N__858\,
            lcout => o_pl_byte_c_3,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_pl_byte_obuf_RNO_4_LC_18_1_6\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1100110010101010"
        )
    port map (
            in0 => \N__828\,
            in1 => \N__816\,
            in2 => \_gnd_net_\,
            in3 => \N__779\,
            lcout => o_pl_byte_c_4,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_resp_pl_ready_obuf_RNO_LC_18_30_1\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "0000000010101010"
        )
    port map (
            in0 => \N__788\,
            in1 => \_gnd_net_\,
            in2 => \_gnd_net_\,
            in3 => \N__757\,
            lcout => o_resp_pl_ready_c,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );

    \o_send_pl_ready_obuf_RNO_LC_18_30_5\ : LogicCell40
    generic map (
            C_ON => '0',
            SEQ_MODE => "0000",
            LUT_INIT => "1010101000000000"
        )
    port map (
            in0 => \N__789\,
            in1 => \_gnd_net_\,
            in2 => \_gnd_net_\,
            in3 => \N__758\,
            lcout => o_send_pl_ready_c,
            ltout => OPEN,
            carryin => \_gnd_net_\,
            carryout => OPEN,
            clk => \_gnd_net_\,
            ce => 'H',
            sr => \_gnd_net_\
        );
end \INTERFACE\;
