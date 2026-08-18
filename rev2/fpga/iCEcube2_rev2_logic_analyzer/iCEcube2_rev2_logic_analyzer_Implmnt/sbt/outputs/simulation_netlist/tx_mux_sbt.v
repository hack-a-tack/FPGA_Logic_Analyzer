// ******************************************************************************

// iCEcube Netlister

// Version:            2020.12.27943

// Build Date:         Dec  9 2020 18:18:12

// File Generated:     Aug 18 2026 06:55:32

// Purpose:            Post-Route Verilog/VHDL netlist for timing simulation

// Copyright (C) 2006-2010 by Lattice Semiconductor Corp. All rights reserved.

// ******************************************************************************

// Verilog file for cell "tx_mux" view "INTERFACE"

module tx_mux (
    i_resp_pl_byte,
    i_send_pl_byte,
    o_pl_byte,
    o_send_pl_ready,
    i_grant_sel,
    i_send_pl_valid,
    i_resp_pl_valid,
    o_pl_valid,
    o_resp_pl_ready,
    i_pl_ready);

    input [7:0] i_resp_pl_byte;
    input [7:0] i_send_pl_byte;
    output [7:0] o_pl_byte;
    output o_send_pl_ready;
    input i_grant_sel;
    input i_send_pl_valid;
    input i_resp_pl_valid;
    output o_pl_valid;
    output o_resp_pl_ready;
    input i_pl_ready;

    wire N__1192;
    wire N__1191;
    wire N__1190;
    wire N__1183;
    wire N__1182;
    wire N__1181;
    wire N__1174;
    wire N__1173;
    wire N__1172;
    wire N__1165;
    wire N__1164;
    wire N__1163;
    wire N__1156;
    wire N__1155;
    wire N__1154;
    wire N__1147;
    wire N__1146;
    wire N__1145;
    wire N__1138;
    wire N__1137;
    wire N__1136;
    wire N__1129;
    wire N__1128;
    wire N__1127;
    wire N__1120;
    wire N__1119;
    wire N__1118;
    wire N__1111;
    wire N__1110;
    wire N__1109;
    wire N__1102;
    wire N__1101;
    wire N__1100;
    wire N__1093;
    wire N__1092;
    wire N__1091;
    wire N__1084;
    wire N__1083;
    wire N__1082;
    wire N__1075;
    wire N__1074;
    wire N__1073;
    wire N__1066;
    wire N__1065;
    wire N__1064;
    wire N__1057;
    wire N__1056;
    wire N__1055;
    wire N__1048;
    wire N__1047;
    wire N__1046;
    wire N__1039;
    wire N__1038;
    wire N__1037;
    wire N__1030;
    wire N__1029;
    wire N__1028;
    wire N__1021;
    wire N__1020;
    wire N__1019;
    wire N__1012;
    wire N__1011;
    wire N__1010;
    wire N__1003;
    wire N__1002;
    wire N__1001;
    wire N__994;
    wire N__993;
    wire N__992;
    wire N__985;
    wire N__984;
    wire N__983;
    wire N__976;
    wire N__975;
    wire N__974;
    wire N__967;
    wire N__966;
    wire N__965;
    wire N__958;
    wire N__957;
    wire N__956;
    wire N__949;
    wire N__948;
    wire N__947;
    wire N__940;
    wire N__939;
    wire N__938;
    wire N__931;
    wire N__930;
    wire N__929;
    wire N__922;
    wire N__921;
    wire N__920;
    wire N__903;
    wire N__900;
    wire N__897;
    wire N__894;
    wire N__891;
    wire N__888;
    wire N__885;
    wire N__882;
    wire N__879;
    wire N__876;
    wire N__873;
    wire N__870;
    wire N__867;
    wire N__864;
    wire N__861;
    wire N__858;
    wire N__855;
    wire N__852;
    wire N__849;
    wire N__846;
    wire N__843;
    wire N__840;
    wire N__837;
    wire N__834;
    wire N__831;
    wire N__828;
    wire N__825;
    wire N__822;
    wire N__819;
    wire N__816;
    wire N__813;
    wire N__810;
    wire N__807;
    wire N__804;
    wire N__801;
    wire N__798;
    wire N__795;
    wire N__792;
    wire N__789;
    wire N__788;
    wire N__783;
    wire N__780;
    wire N__779;
    wire N__778;
    wire N__777;
    wire N__776;
    wire N__775;
    wire N__762;
    wire N__759;
    wire N__758;
    wire N__757;
    wire N__754;
    wire N__749;
    wire N__748;
    wire N__747;
    wire N__746;
    wire N__743;
    wire N__740;
    wire N__733;
    wire N__730;
    wire N__725;
    wire N__722;
    wire N__719;
    wire N__716;
    wire N__713;
    wire N__708;
    wire N__705;
    wire N__702;
    wire N__699;
    wire N__696;
    wire N__693;
    wire N__690;
    wire N__687;
    wire N__684;
    wire N__681;
    wire N__678;
    wire N__675;
    wire N__672;
    wire N__669;
    wire N__666;
    wire N__663;
    wire N__660;
    wire N__657;
    wire N__654;
    wire N__651;
    wire N__648;
    wire N__645;
    wire N__642;
    wire N__639;
    wire N__636;
    wire N__633;
    wire N__630;
    wire N__627;
    wire N__624;
    wire N__621;
    wire N__618;
    wire N__615;
    wire N__612;
    wire N__609;
    wire N__606;
    wire N__603;
    wire N__600;
    wire N__597;
    wire N__594;
    wire N__591;
    wire N__588;
    wire N__585;
    wire N__582;
    wire N__579;
    wire N__576;
    wire N__573;
    wire N__570;
    wire N__567;
    wire N__564;
    wire N__561;
    wire N__558;
    wire N__555;
    wire N__552;
    wire N__549;
    wire N__546;
    wire N__543;
    wire N__540;
    wire N__537;
    wire N__534;
    wire N__531;
    wire N__528;
    wire N__525;
    wire N__522;
    wire N__519;
    wire N__516;
    wire N__513;
    wire N__510;
    wire N__507;
    wire N__504;
    wire N__501;
    wire VCCG0;
    wire GNDG0;
    wire i_send_pl_byte_c_6;
    wire i_resp_pl_byte_c_6;
    wire o_pl_byte_c_6;
    wire i_send_pl_byte_c_7;
    wire i_resp_pl_byte_c_7;
    wire o_pl_byte_c_7;
    wire i_resp_pl_valid_c;
    wire i_send_pl_valid_c;
    wire o_pl_valid_c;
    wire i_resp_pl_byte_c_0;
    wire i_send_pl_byte_c_0;
    wire o_pl_byte_c_0;
    wire i_send_pl_byte_c_5;
    wire i_resp_pl_byte_c_5;
    wire o_pl_byte_c_5;
    wire i_send_pl_byte_c_1;
    wire i_resp_pl_byte_c_1;
    wire o_pl_byte_c_1;
    wire i_send_pl_byte_c_2;
    wire i_resp_pl_byte_c_2;
    wire o_pl_byte_c_2;
    wire i_send_pl_byte_c_3;
    wire i_resp_pl_byte_c_3;
    wire o_pl_byte_c_3;
    wire i_resp_pl_byte_c_4;
    wire i_send_pl_byte_c_4;
    wire o_pl_byte_c_4;
    wire o_resp_pl_ready_c;
    wire i_pl_ready_c;
    wire i_grant_sel_c;
    wire o_send_pl_ready_c;
    wire _gnd_net_;

    IO_PAD i_resp_pl_byte_ibuf_5_iopad (
            .OE(N__1192),
            .DIN(N__1191),
            .DOUT(N__1190),
            .PACKAGEPIN(i_resp_pl_byte[5]));
    defparam i_resp_pl_byte_ibuf_5_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_byte_ibuf_5_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_byte_ibuf_5_preio (
            .PADOEN(N__1192),
            .PADOUT(N__1191),
            .PADIN(N__1190),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_byte_c_5),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_send_pl_ready_obuf_iopad (
            .OE(N__1183),
            .DIN(N__1182),
            .DOUT(N__1181),
            .PACKAGEPIN(o_send_pl_ready));
    defparam o_send_pl_ready_obuf_preio.NEG_TRIGGER=1'b0;
    defparam o_send_pl_ready_obuf_preio.PIN_TYPE=6'b011001;
    PRE_IO o_send_pl_ready_obuf_preio (
            .PADOEN(N__1183),
            .PADOUT(N__1182),
            .PADIN(N__1181),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__708),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_valid_ibuf_iopad (
            .OE(N__1174),
            .DIN(N__1173),
            .DOUT(N__1172),
            .PACKAGEPIN(i_send_pl_valid));
    defparam i_send_pl_valid_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_valid_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_valid_ibuf_preio (
            .PADOEN(N__1174),
            .PADOUT(N__1173),
            .PADIN(N__1172),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_valid_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_byte_obuf_1_iopad (
            .OE(N__1165),
            .DIN(N__1164),
            .DOUT(N__1163),
            .PACKAGEPIN(o_pl_byte[1]));
    defparam o_pl_byte_obuf_1_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_byte_obuf_1_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_byte_obuf_1_preio (
            .PADOEN(N__1165),
            .PADOUT(N__1164),
            .PADIN(N__1163),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__510),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_resp_pl_byte_ibuf_7_iopad (
            .OE(N__1156),
            .DIN(N__1155),
            .DOUT(N__1154),
            .PACKAGEPIN(i_resp_pl_byte[7]));
    defparam i_resp_pl_byte_ibuf_7_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_byte_ibuf_7_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_byte_ibuf_7_preio (
            .PADOEN(N__1156),
            .PADOUT(N__1155),
            .PADIN(N__1154),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_byte_c_7),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_byte_ibuf_5_iopad (
            .OE(N__1147),
            .DIN(N__1146),
            .DOUT(N__1145),
            .PACKAGEPIN(i_send_pl_byte[5]));
    defparam i_send_pl_byte_ibuf_5_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_byte_ibuf_5_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_byte_ibuf_5_preio (
            .PADOEN(N__1147),
            .PADOUT(N__1146),
            .PADIN(N__1145),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_byte_c_5),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_resp_pl_ready_obuf_iopad (
            .OE(N__1138),
            .DIN(N__1137),
            .DOUT(N__1136),
            .PACKAGEPIN(o_resp_pl_ready));
    defparam o_resp_pl_ready_obuf_preio.NEG_TRIGGER=1'b0;
    defparam o_resp_pl_ready_obuf_preio.PIN_TYPE=6'b011001;
    PRE_IO o_resp_pl_ready_obuf_preio (
            .PADOEN(N__1138),
            .PADOUT(N__1137),
            .PADIN(N__1136),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__795),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_resp_pl_byte_ibuf_0_iopad (
            .OE(N__1129),
            .DIN(N__1128),
            .DOUT(N__1127),
            .PACKAGEPIN(i_resp_pl_byte[0]));
    defparam i_resp_pl_byte_ibuf_0_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_byte_ibuf_0_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_byte_ibuf_0_preio (
            .PADOEN(N__1129),
            .PADOUT(N__1128),
            .PADIN(N__1127),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_byte_c_0),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_byte_ibuf_6_iopad (
            .OE(N__1120),
            .DIN(N__1119),
            .DOUT(N__1118),
            .PACKAGEPIN(i_send_pl_byte[6]));
    defparam i_send_pl_byte_ibuf_6_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_byte_ibuf_6_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_byte_ibuf_6_preio (
            .PADOEN(N__1120),
            .PADOUT(N__1119),
            .PADIN(N__1118),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_byte_c_6),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_byte_obuf_7_iopad (
            .OE(N__1111),
            .DIN(N__1110),
            .DOUT(N__1109),
            .PACKAGEPIN(o_pl_byte[7]));
    defparam o_pl_byte_obuf_7_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_byte_obuf_7_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_byte_obuf_7_preio (
            .PADOEN(N__1111),
            .PADOUT(N__1110),
            .PADIN(N__1109),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__654),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_resp_pl_byte_ibuf_1_iopad (
            .OE(N__1102),
            .DIN(N__1101),
            .DOUT(N__1100),
            .PACKAGEPIN(i_resp_pl_byte[1]));
    defparam i_resp_pl_byte_ibuf_1_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_byte_ibuf_1_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_byte_ibuf_1_preio (
            .PADOEN(N__1102),
            .PADOUT(N__1101),
            .PADIN(N__1100),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_byte_c_1),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_byte_ibuf_7_iopad (
            .OE(N__1093),
            .DIN(N__1092),
            .DOUT(N__1091),
            .PACKAGEPIN(i_send_pl_byte[7]));
    defparam i_send_pl_byte_ibuf_7_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_byte_ibuf_7_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_byte_ibuf_7_preio (
            .PADOEN(N__1093),
            .PADOUT(N__1092),
            .PADIN(N__1091),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_byte_c_7),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_byte_obuf_6_iopad (
            .OE(N__1084),
            .DIN(N__1083),
            .DOUT(N__1082),
            .PACKAGEPIN(o_pl_byte[6]));
    defparam o_pl_byte_obuf_6_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_byte_obuf_6_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_byte_obuf_6_preio (
            .PADOEN(N__1084),
            .PADOUT(N__1083),
            .PADIN(N__1082),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__684),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_resp_pl_byte_ibuf_2_iopad (
            .OE(N__1075),
            .DIN(N__1074),
            .DOUT(N__1073),
            .PACKAGEPIN(i_resp_pl_byte[2]));
    defparam i_resp_pl_byte_ibuf_2_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_byte_ibuf_2_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_byte_ibuf_2_preio (
            .PADOEN(N__1075),
            .PADOUT(N__1074),
            .PADIN(N__1073),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_byte_c_2),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_byte_ibuf_0_iopad (
            .OE(N__1066),
            .DIN(N__1065),
            .DOUT(N__1064),
            .PACKAGEPIN(i_send_pl_byte[0]));
    defparam i_send_pl_byte_ibuf_0_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_byte_ibuf_0_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_byte_ibuf_0_preio (
            .PADOEN(N__1066),
            .PADOUT(N__1065),
            .PADIN(N__1064),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_byte_c_0),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_byte_obuf_5_iopad (
            .OE(N__1057),
            .DIN(N__1056),
            .DOUT(N__1055),
            .PACKAGEPIN(o_pl_byte[5]));
    defparam o_pl_byte_obuf_5_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_byte_obuf_5_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_byte_obuf_5_preio (
            .PADOEN(N__1057),
            .PADOUT(N__1056),
            .PADIN(N__1055),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__552),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_valid_obuf_iopad (
            .OE(N__1048),
            .DIN(N__1047),
            .DOUT(N__1046),
            .PACKAGEPIN(o_pl_valid));
    defparam o_pl_valid_obuf_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_valid_obuf_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_valid_obuf_preio (
            .PADOEN(N__1048),
            .PADOUT(N__1047),
            .PADIN(N__1046),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__624),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_grant_sel_ibuf_iopad (
            .OE(N__1039),
            .DIN(N__1038),
            .DOUT(N__1037),
            .PACKAGEPIN(i_grant_sel));
    defparam i_grant_sel_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_grant_sel_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_grant_sel_ibuf_preio (
            .PADOEN(N__1039),
            .PADOUT(N__1038),
            .PADIN(N__1037),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_grant_sel_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_resp_pl_byte_ibuf_3_iopad (
            .OE(N__1030),
            .DIN(N__1029),
            .DOUT(N__1028),
            .PACKAGEPIN(i_resp_pl_byte[3]));
    defparam i_resp_pl_byte_ibuf_3_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_byte_ibuf_3_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_byte_ibuf_3_preio (
            .PADOEN(N__1030),
            .PADOUT(N__1029),
            .PADIN(N__1028),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_byte_c_3),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_resp_pl_valid_ibuf_iopad (
            .OE(N__1021),
            .DIN(N__1020),
            .DOUT(N__1019),
            .PACKAGEPIN(i_resp_pl_valid));
    defparam i_resp_pl_valid_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_valid_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_valid_ibuf_preio (
            .PADOEN(N__1021),
            .PADOUT(N__1020),
            .PADIN(N__1019),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_valid_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_byte_ibuf_1_iopad (
            .OE(N__1012),
            .DIN(N__1011),
            .DOUT(N__1010),
            .PACKAGEPIN(i_send_pl_byte[1]));
    defparam i_send_pl_byte_ibuf_1_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_byte_ibuf_1_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_byte_ibuf_1_preio (
            .PADOEN(N__1012),
            .PADOUT(N__1011),
            .PADIN(N__1010),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_byte_c_1),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_byte_obuf_4_iopad (
            .OE(N__1003),
            .DIN(N__1002),
            .DOUT(N__1001),
            .PACKAGEPIN(o_pl_byte[4]));
    defparam o_pl_byte_obuf_4_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_byte_obuf_4_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_byte_obuf_4_preio (
            .PADOEN(N__1003),
            .PADOUT(N__1002),
            .PADIN(N__1001),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__810),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_resp_pl_byte_ibuf_4_iopad (
            .OE(N__994),
            .DIN(N__993),
            .DOUT(N__992),
            .PACKAGEPIN(i_resp_pl_byte[4]));
    defparam i_resp_pl_byte_ibuf_4_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_byte_ibuf_4_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_byte_ibuf_4_preio (
            .PADOEN(N__994),
            .PADOUT(N__993),
            .PADIN(N__992),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_byte_c_4),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_byte_ibuf_2_iopad (
            .OE(N__985),
            .DIN(N__984),
            .DOUT(N__983),
            .PACKAGEPIN(i_send_pl_byte[2]));
    defparam i_send_pl_byte_ibuf_2_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_byte_ibuf_2_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_byte_ibuf_2_preio (
            .PADOEN(N__985),
            .PADOUT(N__984),
            .PADIN(N__983),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_byte_c_2),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_byte_obuf_3_iopad (
            .OE(N__976),
            .DIN(N__975),
            .DOUT(N__974),
            .PACKAGEPIN(o_pl_byte[3]));
    defparam o_pl_byte_obuf_3_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_byte_obuf_3_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_byte_obuf_3_preio (
            .PADOEN(N__976),
            .PADOUT(N__975),
            .PADIN(N__974),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__843),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_pl_ready_ibuf_iopad (
            .OE(N__967),
            .DIN(N__966),
            .DOUT(N__965),
            .PACKAGEPIN(i_pl_ready));
    defparam i_pl_ready_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_pl_ready_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_pl_ready_ibuf_preio (
            .PADOEN(N__967),
            .PADOUT(N__966),
            .PADIN(N__965),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_pl_ready_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_byte_ibuf_3_iopad (
            .OE(N__958),
            .DIN(N__957),
            .DOUT(N__956),
            .PACKAGEPIN(i_send_pl_byte[3]));
    defparam i_send_pl_byte_ibuf_3_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_byte_ibuf_3_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_byte_ibuf_3_preio (
            .PADOEN(N__958),
            .PADOUT(N__957),
            .PADIN(N__956),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_byte_c_3),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_byte_obuf_2_iopad (
            .OE(N__949),
            .DIN(N__948),
            .DOUT(N__947),
            .PACKAGEPIN(o_pl_byte[2]));
    defparam o_pl_byte_obuf_2_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_byte_obuf_2_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_byte_obuf_2_preio (
            .PADOEN(N__949),
            .PADOUT(N__948),
            .PADIN(N__947),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__879),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_resp_pl_byte_ibuf_6_iopad (
            .OE(N__940),
            .DIN(N__939),
            .DOUT(N__938),
            .PACKAGEPIN(i_resp_pl_byte[6]));
    defparam i_resp_pl_byte_ibuf_6_preio.NEG_TRIGGER=1'b0;
    defparam i_resp_pl_byte_ibuf_6_preio.PIN_TYPE=6'b000001;
    PRE_IO i_resp_pl_byte_ibuf_6_preio (
            .PADOEN(N__940),
            .PADOUT(N__939),
            .PADIN(N__938),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_resp_pl_byte_c_6),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_pl_byte_ibuf_4_iopad (
            .OE(N__931),
            .DIN(N__930),
            .DOUT(N__929),
            .PACKAGEPIN(i_send_pl_byte[4]));
    defparam i_send_pl_byte_ibuf_4_preio.NEG_TRIGGER=1'b0;
    defparam i_send_pl_byte_ibuf_4_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_pl_byte_ibuf_4_preio (
            .PADOEN(N__931),
            .PADOUT(N__930),
            .PADIN(N__929),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_pl_byte_c_4),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_pl_byte_obuf_0_iopad (
            .OE(N__922),
            .DIN(N__921),
            .DOUT(N__920),
            .PACKAGEPIN(o_pl_byte[0]));
    defparam o_pl_byte_obuf_0_preio.NEG_TRIGGER=1'b0;
    defparam o_pl_byte_obuf_0_preio.PIN_TYPE=6'b011001;
    PRE_IO o_pl_byte_obuf_0_preio (
            .PADOEN(N__922),
            .PADOUT(N__921),
            .PADIN(N__920),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__588),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    InMux I__179 (
            .O(N__903),
            .I(N__900));
    LocalMux I__178 (
            .O(N__900),
            .I(i_send_pl_byte_c_2));
    InMux I__177 (
            .O(N__897),
            .I(N__894));
    LocalMux I__176 (
            .O(N__894),
            .I(N__891));
    Span4Mux_s2_v I__175 (
            .O(N__891),
            .I(N__888));
    Sp12to4 I__174 (
            .O(N__888),
            .I(N__885));
    Span12Mux_h I__173 (
            .O(N__885),
            .I(N__882));
    Odrv12 I__172 (
            .O(N__882),
            .I(i_resp_pl_byte_c_2));
    IoInMux I__171 (
            .O(N__879),
            .I(N__876));
    LocalMux I__170 (
            .O(N__876),
            .I(N__873));
    Span4Mux_s0_v I__169 (
            .O(N__873),
            .I(N__870));
    Sp12to4 I__168 (
            .O(N__870),
            .I(N__867));
    Odrv12 I__167 (
            .O(N__867),
            .I(o_pl_byte_c_2));
    InMux I__166 (
            .O(N__864),
            .I(N__861));
    LocalMux I__165 (
            .O(N__861),
            .I(i_send_pl_byte_c_3));
    InMux I__164 (
            .O(N__858),
            .I(N__855));
    LocalMux I__163 (
            .O(N__855),
            .I(N__852));
    Span4Mux_h I__162 (
            .O(N__852),
            .I(N__849));
    Span4Mux_h I__161 (
            .O(N__849),
            .I(N__846));
    Odrv4 I__160 (
            .O(N__846),
            .I(i_resp_pl_byte_c_3));
    IoInMux I__159 (
            .O(N__843),
            .I(N__840));
    LocalMux I__158 (
            .O(N__840),
            .I(N__837));
    Span4Mux_s0_v I__157 (
            .O(N__837),
            .I(N__834));
    Span4Mux_h I__156 (
            .O(N__834),
            .I(N__831));
    Odrv4 I__155 (
            .O(N__831),
            .I(o_pl_byte_c_3));
    InMux I__154 (
            .O(N__828),
            .I(N__825));
    LocalMux I__153 (
            .O(N__825),
            .I(N__822));
    Span4Mux_h I__152 (
            .O(N__822),
            .I(N__819));
    Odrv4 I__151 (
            .O(N__819),
            .I(i_resp_pl_byte_c_4));
    InMux I__150 (
            .O(N__816),
            .I(N__813));
    LocalMux I__149 (
            .O(N__813),
            .I(i_send_pl_byte_c_4));
    IoInMux I__148 (
            .O(N__810),
            .I(N__807));
    LocalMux I__147 (
            .O(N__807),
            .I(N__804));
    IoSpan4Mux I__146 (
            .O(N__804),
            .I(N__801));
    Span4Mux_s0_v I__145 (
            .O(N__801),
            .I(N__798));
    Odrv4 I__144 (
            .O(N__798),
            .I(o_pl_byte_c_4));
    IoInMux I__143 (
            .O(N__795),
            .I(N__792));
    LocalMux I__142 (
            .O(N__792),
            .I(o_resp_pl_ready_c));
    InMux I__141 (
            .O(N__789),
            .I(N__783));
    InMux I__140 (
            .O(N__788),
            .I(N__783));
    LocalMux I__139 (
            .O(N__783),
            .I(i_pl_ready_c));
    InMux I__138 (
            .O(N__780),
            .I(N__762));
    InMux I__137 (
            .O(N__779),
            .I(N__762));
    InMux I__136 (
            .O(N__778),
            .I(N__762));
    InMux I__135 (
            .O(N__777),
            .I(N__762));
    InMux I__134 (
            .O(N__776),
            .I(N__762));
    InMux I__133 (
            .O(N__775),
            .I(N__762));
    LocalMux I__132 (
            .O(N__762),
            .I(N__759));
    Span4Mux_h I__131 (
            .O(N__759),
            .I(N__754));
    InMux I__130 (
            .O(N__758),
            .I(N__749));
    InMux I__129 (
            .O(N__757),
            .I(N__749));
    Sp12to4 I__128 (
            .O(N__754),
            .I(N__743));
    LocalMux I__127 (
            .O(N__749),
            .I(N__740));
    InMux I__126 (
            .O(N__748),
            .I(N__733));
    InMux I__125 (
            .O(N__747),
            .I(N__733));
    InMux I__124 (
            .O(N__746),
            .I(N__733));
    Span12Mux_s8_v I__123 (
            .O(N__743),
            .I(N__730));
    Span4Mux_h I__122 (
            .O(N__740),
            .I(N__725));
    LocalMux I__121 (
            .O(N__733),
            .I(N__725));
    Span12Mux_h I__120 (
            .O(N__730),
            .I(N__722));
    Span4Mux_h I__119 (
            .O(N__725),
            .I(N__719));
    Span12Mux_v I__118 (
            .O(N__722),
            .I(N__716));
    IoSpan4Mux I__117 (
            .O(N__719),
            .I(N__713));
    Odrv12 I__116 (
            .O(N__716),
            .I(i_grant_sel_c));
    Odrv4 I__115 (
            .O(N__713),
            .I(i_grant_sel_c));
    IoInMux I__114 (
            .O(N__708),
            .I(N__705));
    LocalMux I__113 (
            .O(N__705),
            .I(o_send_pl_ready_c));
    InMux I__112 (
            .O(N__702),
            .I(N__699));
    LocalMux I__111 (
            .O(N__699),
            .I(i_send_pl_byte_c_6));
    InMux I__110 (
            .O(N__696),
            .I(N__693));
    LocalMux I__109 (
            .O(N__693),
            .I(N__690));
    Span4Mux_h I__108 (
            .O(N__690),
            .I(N__687));
    Odrv4 I__107 (
            .O(N__687),
            .I(i_resp_pl_byte_c_6));
    IoInMux I__106 (
            .O(N__684),
            .I(N__681));
    LocalMux I__105 (
            .O(N__681),
            .I(N__678));
    Span12Mux_s0_v I__104 (
            .O(N__678),
            .I(N__675));
    Odrv12 I__103 (
            .O(N__675),
            .I(o_pl_byte_c_6));
    InMux I__102 (
            .O(N__672),
            .I(N__669));
    LocalMux I__101 (
            .O(N__669),
            .I(i_send_pl_byte_c_7));
    InMux I__100 (
            .O(N__666),
            .I(N__663));
    LocalMux I__99 (
            .O(N__663),
            .I(N__660));
    Span4Mux_h I__98 (
            .O(N__660),
            .I(N__657));
    Odrv4 I__97 (
            .O(N__657),
            .I(i_resp_pl_byte_c_7));
    IoInMux I__96 (
            .O(N__654),
            .I(N__651));
    LocalMux I__95 (
            .O(N__651),
            .I(N__648));
    IoSpan4Mux I__94 (
            .O(N__648),
            .I(N__645));
    Odrv4 I__93 (
            .O(N__645),
            .I(o_pl_byte_c_7));
    InMux I__92 (
            .O(N__642),
            .I(N__639));
    LocalMux I__91 (
            .O(N__639),
            .I(N__636));
    Span4Mux_h I__90 (
            .O(N__636),
            .I(N__633));
    Odrv4 I__89 (
            .O(N__633),
            .I(i_resp_pl_valid_c));
    InMux I__88 (
            .O(N__630),
            .I(N__627));
    LocalMux I__87 (
            .O(N__627),
            .I(i_send_pl_valid_c));
    IoInMux I__86 (
            .O(N__624),
            .I(N__621));
    LocalMux I__85 (
            .O(N__621),
            .I(N__618));
    IoSpan4Mux I__84 (
            .O(N__618),
            .I(N__615));
    IoSpan4Mux I__83 (
            .O(N__615),
            .I(N__612));
    Odrv4 I__82 (
            .O(N__612),
            .I(o_pl_valid_c));
    InMux I__81 (
            .O(N__609),
            .I(N__606));
    LocalMux I__80 (
            .O(N__606),
            .I(N__603));
    Sp12to4 I__79 (
            .O(N__603),
            .I(N__600));
    Span12Mux_h I__78 (
            .O(N__600),
            .I(N__597));
    Odrv12 I__77 (
            .O(N__597),
            .I(i_resp_pl_byte_c_0));
    InMux I__76 (
            .O(N__594),
            .I(N__591));
    LocalMux I__75 (
            .O(N__591),
            .I(i_send_pl_byte_c_0));
    IoInMux I__74 (
            .O(N__588),
            .I(N__585));
    LocalMux I__73 (
            .O(N__585),
            .I(N__582));
    Span4Mux_s0_v I__72 (
            .O(N__582),
            .I(N__579));
    Odrv4 I__71 (
            .O(N__579),
            .I(o_pl_byte_c_0));
    InMux I__70 (
            .O(N__576),
            .I(N__573));
    LocalMux I__69 (
            .O(N__573),
            .I(N__570));
    Span4Mux_h I__68 (
            .O(N__570),
            .I(N__567));
    Odrv4 I__67 (
            .O(N__567),
            .I(i_send_pl_byte_c_5));
    InMux I__66 (
            .O(N__564),
            .I(N__561));
    LocalMux I__65 (
            .O(N__561),
            .I(N__558));
    Span4Mux_h I__64 (
            .O(N__558),
            .I(N__555));
    Odrv4 I__63 (
            .O(N__555),
            .I(i_resp_pl_byte_c_5));
    IoInMux I__62 (
            .O(N__552),
            .I(N__549));
    LocalMux I__61 (
            .O(N__549),
            .I(N__546));
    IoSpan4Mux I__60 (
            .O(N__546),
            .I(N__543));
    Span4Mux_s3_v I__59 (
            .O(N__543),
            .I(N__540));
    Span4Mux_v I__58 (
            .O(N__540),
            .I(N__537));
    Sp12to4 I__57 (
            .O(N__537),
            .I(N__534));
    Span12Mux_v I__56 (
            .O(N__534),
            .I(N__531));
    Odrv12 I__55 (
            .O(N__531),
            .I(o_pl_byte_c_5));
    InMux I__54 (
            .O(N__528),
            .I(N__525));
    LocalMux I__53 (
            .O(N__525),
            .I(i_send_pl_byte_c_1));
    InMux I__52 (
            .O(N__522),
            .I(N__519));
    LocalMux I__51 (
            .O(N__519),
            .I(N__516));
    Span12Mux_h I__50 (
            .O(N__516),
            .I(N__513));
    Odrv12 I__49 (
            .O(N__513),
            .I(i_resp_pl_byte_c_1));
    IoInMux I__48 (
            .O(N__510),
            .I(N__507));
    LocalMux I__47 (
            .O(N__507),
            .I(N__504));
    Span12Mux_s0_v I__46 (
            .O(N__504),
            .I(N__501));
    Odrv12 I__45 (
            .O(N__501),
            .I(o_pl_byte_c_1));
    VCC VCC (
            .Y(VCCG0));
    GND GND (
            .Y(GNDG0));
    GND GND_Inst (
            .Y(_gnd_net_));
    defparam o_pl_byte_obuf_RNO_6_LC_13_30_0.C_ON=1'b0;
    defparam o_pl_byte_obuf_RNO_6_LC_13_30_0.SEQ_MODE=4'b0000;
    defparam o_pl_byte_obuf_RNO_6_LC_13_30_0.LUT_INIT=16'b1010101011001100;
    LogicCell40 o_pl_byte_obuf_RNO_6_LC_13_30_0 (
            .in0(N__702),
            .in1(N__696),
            .in2(_gnd_net_),
            .in3(N__746),
            .lcout(o_pl_byte_c_6),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_pl_byte_obuf_RNO_7_LC_13_30_1.C_ON=1'b0;
    defparam o_pl_byte_obuf_RNO_7_LC_13_30_1.SEQ_MODE=4'b0000;
    defparam o_pl_byte_obuf_RNO_7_LC_13_30_1.LUT_INIT=16'b1101110110001000;
    LogicCell40 o_pl_byte_obuf_RNO_7_LC_13_30_1 (
            .in0(N__747),
            .in1(N__672),
            .in2(_gnd_net_),
            .in3(N__666),
            .lcout(o_pl_byte_c_7),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_pl_valid_obuf_RNO_LC_13_30_2.C_ON=1'b0;
    defparam o_pl_valid_obuf_RNO_LC_13_30_2.SEQ_MODE=4'b0000;
    defparam o_pl_valid_obuf_RNO_LC_13_30_2.LUT_INIT=16'b1100110010101010;
    LogicCell40 o_pl_valid_obuf_RNO_LC_13_30_2 (
            .in0(N__642),
            .in1(N__630),
            .in2(_gnd_net_),
            .in3(N__748),
            .lcout(o_pl_valid_c),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_pl_byte_obuf_RNO_0_LC_18_1_0.C_ON=1'b0;
    defparam o_pl_byte_obuf_RNO_0_LC_18_1_0.SEQ_MODE=4'b0000;
    defparam o_pl_byte_obuf_RNO_0_LC_18_1_0.LUT_INIT=16'b1100110010101010;
    LogicCell40 o_pl_byte_obuf_RNO_0_LC_18_1_0 (
            .in0(N__609),
            .in1(N__594),
            .in2(_gnd_net_),
            .in3(N__775),
            .lcout(o_pl_byte_c_0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_pl_byte_obuf_RNO_5_LC_18_1_1.C_ON=1'b0;
    defparam o_pl_byte_obuf_RNO_5_LC_18_1_1.SEQ_MODE=4'b0000;
    defparam o_pl_byte_obuf_RNO_5_LC_18_1_1.LUT_INIT=16'b1101110110001000;
    LogicCell40 o_pl_byte_obuf_RNO_5_LC_18_1_1 (
            .in0(N__780),
            .in1(N__576),
            .in2(_gnd_net_),
            .in3(N__564),
            .lcout(o_pl_byte_c_5),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_pl_byte_obuf_RNO_1_LC_18_1_3.C_ON=1'b0;
    defparam o_pl_byte_obuf_RNO_1_LC_18_1_3.SEQ_MODE=4'b0000;
    defparam o_pl_byte_obuf_RNO_1_LC_18_1_3.LUT_INIT=16'b1101110110001000;
    LogicCell40 o_pl_byte_obuf_RNO_1_LC_18_1_3 (
            .in0(N__776),
            .in1(N__528),
            .in2(_gnd_net_),
            .in3(N__522),
            .lcout(o_pl_byte_c_1),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_pl_byte_obuf_RNO_2_LC_18_1_4.C_ON=1'b0;
    defparam o_pl_byte_obuf_RNO_2_LC_18_1_4.SEQ_MODE=4'b0000;
    defparam o_pl_byte_obuf_RNO_2_LC_18_1_4.LUT_INIT=16'b1010101011001100;
    LogicCell40 o_pl_byte_obuf_RNO_2_LC_18_1_4 (
            .in0(N__903),
            .in1(N__897),
            .in2(_gnd_net_),
            .in3(N__777),
            .lcout(o_pl_byte_c_2),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_pl_byte_obuf_RNO_3_LC_18_1_5.C_ON=1'b0;
    defparam o_pl_byte_obuf_RNO_3_LC_18_1_5.SEQ_MODE=4'b0000;
    defparam o_pl_byte_obuf_RNO_3_LC_18_1_5.LUT_INIT=16'b1101110110001000;
    LogicCell40 o_pl_byte_obuf_RNO_3_LC_18_1_5 (
            .in0(N__778),
            .in1(N__864),
            .in2(_gnd_net_),
            .in3(N__858),
            .lcout(o_pl_byte_c_3),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_pl_byte_obuf_RNO_4_LC_18_1_6.C_ON=1'b0;
    defparam o_pl_byte_obuf_RNO_4_LC_18_1_6.SEQ_MODE=4'b0000;
    defparam o_pl_byte_obuf_RNO_4_LC_18_1_6.LUT_INIT=16'b1100110010101010;
    LogicCell40 o_pl_byte_obuf_RNO_4_LC_18_1_6 (
            .in0(N__828),
            .in1(N__816),
            .in2(_gnd_net_),
            .in3(N__779),
            .lcout(o_pl_byte_c_4),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_resp_pl_ready_obuf_RNO_LC_18_30_1.C_ON=1'b0;
    defparam o_resp_pl_ready_obuf_RNO_LC_18_30_1.SEQ_MODE=4'b0000;
    defparam o_resp_pl_ready_obuf_RNO_LC_18_30_1.LUT_INIT=16'b0000000010101010;
    LogicCell40 o_resp_pl_ready_obuf_RNO_LC_18_30_1 (
            .in0(N__788),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__757),
            .lcout(o_resp_pl_ready_c),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam o_send_pl_ready_obuf_RNO_LC_18_30_5.C_ON=1'b0;
    defparam o_send_pl_ready_obuf_RNO_LC_18_30_5.SEQ_MODE=4'b0000;
    defparam o_send_pl_ready_obuf_RNO_LC_18_30_5.LUT_INIT=16'b1010101000000000;
    LogicCell40 o_send_pl_ready_obuf_RNO_LC_18_30_5 (
            .in0(N__789),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__758),
            .lcout(o_send_pl_ready_c),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
endmodule // tx_mux
