// ******************************************************************************

// iCEcube Netlister

// Version:            2020.12.27943

// Build Date:         Dec  9 2020 18:18:12

// File Generated:     Mar 7 2026 11:38:59

// Purpose:            Post-Route Verilog/VHDL netlist for timing simulation

// Copyright (C) 2006-2010 by Lattice Semiconductor Corp. All rights reserved.

// ******************************************************************************

// Verilog file for cell "tx_mux" view "INTERFACE"

module tx_mux (
    i_fsm_tx_status_byte,
    i_send_tx_byte,
    o_mux_tx_byte,
    o_mux_tx_start_pulse,
    i_clk,
    i_send_tx_start_pulse,
    i_rst,
    i_fsm_tx_start_pulse);

    input [7:0] i_fsm_tx_status_byte;
    input [7:0] i_send_tx_byte;
    output [7:0] o_mux_tx_byte;
    output o_mux_tx_start_pulse;
    input i_clk;
    input i_send_tx_start_pulse;
    input i_rst;
    input i_fsm_tx_start_pulse;

    wire N__1191;
    wire N__1190;
    wire N__1189;
    wire N__1180;
    wire N__1179;
    wire N__1178;
    wire N__1171;
    wire N__1170;
    wire N__1169;
    wire N__1162;
    wire N__1161;
    wire N__1160;
    wire N__1153;
    wire N__1152;
    wire N__1151;
    wire N__1144;
    wire N__1143;
    wire N__1142;
    wire N__1135;
    wire N__1134;
    wire N__1133;
    wire N__1126;
    wire N__1125;
    wire N__1124;
    wire N__1117;
    wire N__1116;
    wire N__1115;
    wire N__1108;
    wire N__1107;
    wire N__1106;
    wire N__1099;
    wire N__1098;
    wire N__1097;
    wire N__1090;
    wire N__1089;
    wire N__1088;
    wire N__1081;
    wire N__1080;
    wire N__1079;
    wire N__1072;
    wire N__1071;
    wire N__1070;
    wire N__1063;
    wire N__1062;
    wire N__1061;
    wire N__1054;
    wire N__1053;
    wire N__1052;
    wire N__1045;
    wire N__1044;
    wire N__1043;
    wire N__1036;
    wire N__1035;
    wire N__1034;
    wire N__1027;
    wire N__1026;
    wire N__1025;
    wire N__1018;
    wire N__1017;
    wire N__1016;
    wire N__1009;
    wire N__1008;
    wire N__1007;
    wire N__1000;
    wire N__999;
    wire N__998;
    wire N__991;
    wire N__990;
    wire N__989;
    wire N__982;
    wire N__981;
    wire N__980;
    wire N__973;
    wire N__972;
    wire N__971;
    wire N__964;
    wire N__963;
    wire N__962;
    wire N__955;
    wire N__954;
    wire N__953;
    wire N__946;
    wire N__945;
    wire N__944;
    wire N__937;
    wire N__936;
    wire N__935;
    wire N__918;
    wire N__915;
    wire N__912;
    wire N__909;
    wire N__906;
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
    wire N__786;
    wire N__783;
    wire N__782;
    wire N__781;
    wire N__778;
    wire N__775;
    wire N__772;
    wire N__771;
    wire N__770;
    wire N__769;
    wire N__768;
    wire N__767;
    wire N__760;
    wire N__759;
    wire N__758;
    wire N__747;
    wire N__744;
    wire N__739;
    wire N__736;
    wire N__733;
    wire N__730;
    wire N__727;
    wire N__724;
    wire N__721;
    wire N__714;
    wire N__711;
    wire N__708;
    wire N__705;
    wire N__702;
    wire N__699;
    wire N__696;
    wire N__693;
    wire N__690;
    wire N__687;
    wire N__684;
    wire N__683;
    wire N__682;
    wire N__681;
    wire N__672;
    wire N__669;
    wire N__666;
    wire N__665;
    wire N__664;
    wire N__661;
    wire N__658;
    wire N__655;
    wire N__652;
    wire N__647;
    wire N__644;
    wire N__641;
    wire N__636;
    wire N__633;
    wire N__630;
    wire N__629;
    wire N__628;
    wire N__627;
    wire N__624;
    wire N__621;
    wire N__618;
    wire N__615;
    wire N__614;
    wire N__611;
    wire N__606;
    wire N__603;
    wire N__600;
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
    wire N__509;
    wire N__506;
    wire N__503;
    wire N__498;
    wire N__495;
    wire N__492;
    wire N__489;
    wire N__486;
    wire N__483;
    wire N__480;
    wire N__477;
    wire N__474;
    wire N__471;
    wire N__468;
    wire VCCG0;
    wire GNDG0;
    wire i_send_tx_byte_c_6;
    wire i_fsm_tx_status_byte_c_6;
    wire o_mux_tx_byte_c_6;
    wire i_send_tx_byte_c_7;
    wire i_fsm_tx_status_byte_c_7;
    wire o_mux_tx_byte_c_7;
    wire r_mux_tx_start_pulseZ0;
    wire i_send_tx_start_pulse_c;
    wire i_send_tx_byte_c_0;
    wire i_fsm_tx_status_byte_c_0;
    wire o_mux_tx_byte_c_0;
    wire i_send_tx_byte_c_1;
    wire i_fsm_tx_status_byte_c_1;
    wire o_mux_tx_byte_c_1;
    wire i_send_tx_byte_c_2;
    wire i_fsm_tx_status_byte_c_2;
    wire o_mux_tx_byte_c_2;
    wire i_send_tx_byte_c_3;
    wire i_fsm_tx_status_byte_c_3;
    wire o_mux_tx_byte_c_3;
    wire i_send_tx_byte_c_4;
    wire i_fsm_tx_status_byte_c_4;
    wire o_mux_tx_byte_c_4;
    wire i_fsm_tx_start_pulse_c;
    wire i_send_tx_byte_c_5;
    wire i_fsm_tx_status_byte_c_5;
    wire o_mux_tx_byte_c_5;
    wire _gnd_net_;
    wire i_clk_c_g;
    wire seq_proc_un1_i_send_tx_start_pulse_0_i_0;
    wire i_rst_c;

    PRE_IO_GBUF i_clk_ibuf_gb_io_preiogbuf (
            .PADSIGNALTOGLOBALBUFFER(N__1189),
            .GLOBALBUFFEROUTPUT(i_clk_c_g));
    IO_PAD i_clk_ibuf_gb_io_iopad (
            .OE(N__1191),
            .DIN(N__1190),
            .DOUT(N__1189),
            .PACKAGEPIN(i_clk));
    defparam i_clk_ibuf_gb_io_preio.NEG_TRIGGER=1'b0;
    defparam i_clk_ibuf_gb_io_preio.PIN_TYPE=6'b000001;
    PRE_IO i_clk_ibuf_gb_io_preio (
            .PADOEN(N__1191),
            .PADOUT(N__1190),
            .PADIN(N__1189),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_status_byte_ibuf_5_iopad (
            .OE(N__1180),
            .DIN(N__1179),
            .DOUT(N__1178),
            .PACKAGEPIN(i_fsm_tx_status_byte[5]));
    defparam i_fsm_tx_status_byte_ibuf_5_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_status_byte_ibuf_5_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_status_byte_ibuf_5_preio (
            .PADOEN(N__1180),
            .PADOUT(N__1179),
            .PADIN(N__1178),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_status_byte_c_5),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_tx_byte_ibuf_2_iopad (
            .OE(N__1171),
            .DIN(N__1170),
            .DOUT(N__1169),
            .PACKAGEPIN(i_send_tx_byte[2]));
    defparam i_send_tx_byte_ibuf_2_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_byte_ibuf_2_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_byte_ibuf_2_preio (
            .PADOEN(N__1171),
            .PADOUT(N__1170),
            .PADIN(N__1169),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_byte_c_2),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_byte_obuf_5_iopad (
            .OE(N__1162),
            .DIN(N__1161),
            .DOUT(N__1160),
            .PACKAGEPIN(o_mux_tx_byte[5]));
    defparam o_mux_tx_byte_obuf_5_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_byte_obuf_5_preio.PIN_TYPE=6'b011001;
    PRE_IO o_mux_tx_byte_obuf_5_preio (
            .PADOEN(N__1162),
            .PADOUT(N__1161),
            .PADIN(N__1160),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__696),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_status_byte_ibuf_3_iopad (
            .OE(N__1153),
            .DIN(N__1152),
            .DOUT(N__1151),
            .PACKAGEPIN(i_fsm_tx_status_byte[3]));
    defparam i_fsm_tx_status_byte_ibuf_3_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_status_byte_ibuf_3_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_status_byte_ibuf_3_preio (
            .PADOEN(N__1153),
            .PADOUT(N__1152),
            .PADIN(N__1151),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_status_byte_c_3),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_tx_byte_ibuf_5_iopad (
            .OE(N__1144),
            .DIN(N__1143),
            .DOUT(N__1142),
            .PACKAGEPIN(i_send_tx_byte[5]));
    defparam i_send_tx_byte_ibuf_5_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_byte_ibuf_5_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_byte_ibuf_5_preio (
            .PADOEN(N__1144),
            .PADOUT(N__1143),
            .PADIN(N__1142),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_byte_c_5),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_byte_obuf_3_iopad (
            .OE(N__1135),
            .DIN(N__1134),
            .DOUT(N__1133),
            .PACKAGEPIN(o_mux_tx_byte[3]));
    defparam o_mux_tx_byte_obuf_3_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_byte_obuf_3_preio.PIN_TYPE=6'b011001;
    PRE_IO o_mux_tx_byte_obuf_3_preio (
            .PADOEN(N__1135),
            .PADOUT(N__1134),
            .PADIN(N__1133),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__825),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_start_pulse_ibuf_iopad (
            .OE(N__1126),
            .DIN(N__1125),
            .DOUT(N__1124),
            .PACKAGEPIN(i_fsm_tx_start_pulse));
    defparam i_fsm_tx_start_pulse_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_start_pulse_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_start_pulse_ibuf_preio (
            .PADOEN(N__1126),
            .PADOUT(N__1125),
            .PADIN(N__1124),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_start_pulse_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_status_byte_ibuf_1_iopad (
            .OE(N__1117),
            .DIN(N__1116),
            .DOUT(N__1115),
            .PACKAGEPIN(i_fsm_tx_status_byte[1]));
    defparam i_fsm_tx_status_byte_ibuf_1_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_status_byte_ibuf_1_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_status_byte_ibuf_1_preio (
            .PADOEN(N__1117),
            .PADOUT(N__1116),
            .PADIN(N__1115),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_status_byte_c_1),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_status_byte_ibuf_0_iopad (
            .OE(N__1108),
            .DIN(N__1107),
            .DOUT(N__1106),
            .PACKAGEPIN(i_fsm_tx_status_byte[0]));
    defparam i_fsm_tx_status_byte_ibuf_0_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_status_byte_ibuf_0_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_status_byte_ibuf_0_preio (
            .PADOEN(N__1108),
            .PADOUT(N__1107),
            .PADIN(N__1106),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_status_byte_c_0),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_tx_byte_ibuf_7_iopad (
            .OE(N__1099),
            .DIN(N__1098),
            .DOUT(N__1097),
            .PACKAGEPIN(i_send_tx_byte[7]));
    defparam i_send_tx_byte_ibuf_7_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_byte_ibuf_7_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_byte_ibuf_7_preio (
            .PADOEN(N__1099),
            .PADOUT(N__1098),
            .PADIN(N__1097),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_byte_c_7),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_tx_start_pulse_ibuf_iopad (
            .OE(N__1090),
            .DIN(N__1089),
            .DOUT(N__1088),
            .PACKAGEPIN(i_send_tx_start_pulse));
    defparam i_send_tx_start_pulse_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_start_pulse_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_start_pulse_ibuf_preio (
            .PADOEN(N__1090),
            .PADOUT(N__1089),
            .PADIN(N__1088),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_start_pulse_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_byte_obuf_1_iopad (
            .OE(N__1081),
            .DIN(N__1080),
            .DOUT(N__1079),
            .PACKAGEPIN(o_mux_tx_byte[1]));
    defparam o_mux_tx_byte_obuf_1_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_byte_obuf_1_preio.PIN_TYPE=6'b011001;
    PRE_IO o_mux_tx_byte_obuf_1_preio (
            .PADOEN(N__1081),
            .PADOUT(N__1080),
            .PADIN(N__1079),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__891),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_status_byte_ibuf_7_iopad (
            .OE(N__1072),
            .DIN(N__1071),
            .DOUT(N__1070),
            .PACKAGEPIN(i_fsm_tx_status_byte[7]));
    defparam i_fsm_tx_status_byte_ibuf_7_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_status_byte_ibuf_7_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_status_byte_ibuf_7_preio (
            .PADOEN(N__1072),
            .PADOUT(N__1071),
            .PADIN(N__1070),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_status_byte_c_7),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_tx_byte_ibuf_0_iopad (
            .OE(N__1063),
            .DIN(N__1062),
            .DOUT(N__1061),
            .PACKAGEPIN(i_send_tx_byte[0]));
    defparam i_send_tx_byte_ibuf_0_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_byte_ibuf_0_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_byte_ibuf_0_preio (
            .PADOEN(N__1063),
            .PADOUT(N__1062),
            .PADIN(N__1061),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_byte_c_0),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_byte_obuf_6_iopad (
            .OE(N__1054),
            .DIN(N__1053),
            .DOUT(N__1052),
            .PACKAGEPIN(o_mux_tx_byte[6]));
    defparam o_mux_tx_byte_obuf_6_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_byte_obuf_6_preio.PIN_TYPE=6'b011001;
    PRE_IO o_mux_tx_byte_obuf_6_preio (
            .PADOEN(N__1054),
            .PADOUT(N__1053),
            .PADIN(N__1052),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__570),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_status_byte_ibuf_6_iopad (
            .OE(N__1045),
            .DIN(N__1044),
            .DOUT(N__1043),
            .PACKAGEPIN(i_fsm_tx_status_byte[6]));
    defparam i_fsm_tx_status_byte_ibuf_6_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_status_byte_ibuf_6_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_status_byte_ibuf_6_preio (
            .PADOEN(N__1045),
            .PADOUT(N__1044),
            .PADIN(N__1043),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_status_byte_c_6),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_tx_byte_ibuf_1_iopad (
            .OE(N__1036),
            .DIN(N__1035),
            .DOUT(N__1034),
            .PACKAGEPIN(i_send_tx_byte[1]));
    defparam i_send_tx_byte_ibuf_1_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_byte_ibuf_1_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_byte_ibuf_1_preio (
            .PADOEN(N__1036),
            .PADOUT(N__1035),
            .PADIN(N__1034),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_byte_c_1),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_byte_obuf_7_iopad (
            .OE(N__1027),
            .DIN(N__1026),
            .DOUT(N__1025),
            .PACKAGEPIN(o_mux_tx_byte[7]));
    defparam o_mux_tx_byte_obuf_7_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_byte_obuf_7_preio.PIN_TYPE=6'b011001;
    PRE_IO o_mux_tx_byte_obuf_7_preio (
            .PADOEN(N__1027),
            .PADOUT(N__1026),
            .PADIN(N__1025),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__540),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_byte_obuf_4_iopad (
            .OE(N__1018),
            .DIN(N__1017),
            .DOUT(N__1016),
            .PACKAGEPIN(o_mux_tx_byte[4]));
    defparam o_mux_tx_byte_obuf_4_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_byte_obuf_4_preio.PIN_TYPE=6'b011001;
    PRE_IO o_mux_tx_byte_obuf_4_preio (
            .PADOEN(N__1018),
            .PADOUT(N__1017),
            .PADIN(N__1016),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__795),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_status_byte_ibuf_4_iopad (
            .OE(N__1009),
            .DIN(N__1008),
            .DOUT(N__1007),
            .PACKAGEPIN(i_fsm_tx_status_byte[4]));
    defparam i_fsm_tx_status_byte_ibuf_4_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_status_byte_ibuf_4_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_status_byte_ibuf_4_preio (
            .PADOEN(N__1009),
            .PADOUT(N__1008),
            .PADIN(N__1007),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_status_byte_c_4),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_tx_byte_ibuf_3_iopad (
            .OE(N__1000),
            .DIN(N__999),
            .DOUT(N__998),
            .PACKAGEPIN(i_send_tx_byte[3]));
    defparam i_send_tx_byte_ibuf_3_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_byte_ibuf_3_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_byte_ibuf_3_preio (
            .PADOEN(N__1000),
            .PADOUT(N__999),
            .PADIN(N__998),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_byte_c_3),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_start_pulse_obuf_iopad (
            .OE(N__991),
            .DIN(N__990),
            .DOUT(N__989),
            .PACKAGEPIN(o_mux_tx_start_pulse));
    defparam o_mux_tx_start_pulse_obuf_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_start_pulse_obuf_preio.PIN_TYPE=6'b010101;
    PRE_IO o_mux_tx_start_pulse_obuf_preio (
            .PADOEN(N__991),
            .PADOUT(N__990),
            .PADIN(N__989),
            .CLOCKENABLE(VCCG0),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__525),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK(N__682));
    IO_PAD i_send_tx_byte_ibuf_4_iopad (
            .OE(N__982),
            .DIN(N__981),
            .DOUT(N__980),
            .PACKAGEPIN(i_send_tx_byte[4]));
    defparam i_send_tx_byte_ibuf_4_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_byte_ibuf_4_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_byte_ibuf_4_preio (
            .PADOEN(N__982),
            .PADOUT(N__981),
            .PADIN(N__980),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_byte_c_4),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_byte_obuf_2_iopad (
            .OE(N__973),
            .DIN(N__972),
            .DOUT(N__971),
            .PACKAGEPIN(o_mux_tx_byte[2]));
    defparam o_mux_tx_byte_obuf_2_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_byte_obuf_2_preio.PIN_TYPE=6'b011001;
    PRE_IO o_mux_tx_byte_obuf_2_preio (
            .PADOEN(N__973),
            .PADOUT(N__972),
            .PADIN(N__971),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__858),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_fsm_tx_status_byte_ibuf_2_iopad (
            .OE(N__964),
            .DIN(N__963),
            .DOUT(N__962),
            .PACKAGEPIN(i_fsm_tx_status_byte[2]));
    defparam i_fsm_tx_status_byte_ibuf_2_preio.NEG_TRIGGER=1'b0;
    defparam i_fsm_tx_status_byte_ibuf_2_preio.PIN_TYPE=6'b000001;
    PRE_IO i_fsm_tx_status_byte_ibuf_2_preio (
            .PADOEN(N__964),
            .PADOUT(N__963),
            .PADIN(N__962),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_fsm_tx_status_byte_c_2),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_rst_ibuf_iopad (
            .OE(N__955),
            .DIN(N__954),
            .DOUT(N__953),
            .PACKAGEPIN(i_rst));
    defparam i_rst_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_rst_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_rst_ibuf_preio (
            .PADOEN(N__955),
            .PADOUT(N__954),
            .PADIN(N__953),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_rst_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_send_tx_byte_ibuf_6_iopad (
            .OE(N__946),
            .DIN(N__945),
            .DOUT(N__944),
            .PACKAGEPIN(i_send_tx_byte[6]));
    defparam i_send_tx_byte_ibuf_6_preio.NEG_TRIGGER=1'b0;
    defparam i_send_tx_byte_ibuf_6_preio.PIN_TYPE=6'b000001;
    PRE_IO i_send_tx_byte_ibuf_6_preio (
            .PADOEN(N__946),
            .PADOUT(N__945),
            .PADIN(N__944),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_send_tx_byte_c_6),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_mux_tx_byte_obuf_0_iopad (
            .OE(N__937),
            .DIN(N__936),
            .DOUT(N__935),
            .PACKAGEPIN(o_mux_tx_byte[0]));
    defparam o_mux_tx_byte_obuf_0_preio.NEG_TRIGGER=1'b0;
    defparam o_mux_tx_byte_obuf_0_preio.PIN_TYPE=6'b011001;
    PRE_IO o_mux_tx_byte_obuf_0_preio (
            .PADOEN(N__937),
            .PADOUT(N__936),
            .PADIN(N__935),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__471),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    InMux I__192 (
            .O(N__918),
            .I(N__915));
    LocalMux I__191 (
            .O(N__915),
            .I(N__912));
    Span4Mux_h I__190 (
            .O(N__912),
            .I(N__909));
    Odrv4 I__189 (
            .O(N__909),
            .I(i_send_tx_byte_c_1));
    InMux I__188 (
            .O(N__906),
            .I(N__903));
    LocalMux I__187 (
            .O(N__903),
            .I(N__900));
    IoSpan4Mux I__186 (
            .O(N__900),
            .I(N__897));
    IoSpan4Mux I__185 (
            .O(N__897),
            .I(N__894));
    Odrv4 I__184 (
            .O(N__894),
            .I(i_fsm_tx_status_byte_c_1));
    IoInMux I__183 (
            .O(N__891),
            .I(N__888));
    LocalMux I__182 (
            .O(N__888),
            .I(N__885));
    Span4Mux_s0_v I__181 (
            .O(N__885),
            .I(N__882));
    Odrv4 I__180 (
            .O(N__882),
            .I(o_mux_tx_byte_c_1));
    InMux I__179 (
            .O(N__879),
            .I(N__876));
    LocalMux I__178 (
            .O(N__876),
            .I(i_send_tx_byte_c_2));
    InMux I__177 (
            .O(N__873),
            .I(N__870));
    LocalMux I__176 (
            .O(N__870),
            .I(N__867));
    IoSpan4Mux I__175 (
            .O(N__867),
            .I(N__864));
    IoSpan4Mux I__174 (
            .O(N__864),
            .I(N__861));
    Odrv4 I__173 (
            .O(N__861),
            .I(i_fsm_tx_status_byte_c_2));
    IoInMux I__172 (
            .O(N__858),
            .I(N__855));
    LocalMux I__171 (
            .O(N__855),
            .I(N__852));
    Span4Mux_s3_h I__170 (
            .O(N__852),
            .I(N__849));
    Odrv4 I__169 (
            .O(N__849),
            .I(o_mux_tx_byte_c_2));
    InMux I__168 (
            .O(N__846),
            .I(N__843));
    LocalMux I__167 (
            .O(N__843),
            .I(i_send_tx_byte_c_3));
    InMux I__166 (
            .O(N__840),
            .I(N__837));
    LocalMux I__165 (
            .O(N__837),
            .I(N__834));
    Span4Mux_h I__164 (
            .O(N__834),
            .I(N__831));
    Span4Mux_h I__163 (
            .O(N__831),
            .I(N__828));
    Odrv4 I__162 (
            .O(N__828),
            .I(i_fsm_tx_status_byte_c_3));
    IoInMux I__161 (
            .O(N__825),
            .I(N__822));
    LocalMux I__160 (
            .O(N__822),
            .I(N__819));
    IoSpan4Mux I__159 (
            .O(N__819),
            .I(N__816));
    Odrv4 I__158 (
            .O(N__816),
            .I(o_mux_tx_byte_c_3));
    InMux I__157 (
            .O(N__813),
            .I(N__810));
    LocalMux I__156 (
            .O(N__810),
            .I(i_send_tx_byte_c_4));
    InMux I__155 (
            .O(N__807),
            .I(N__804));
    LocalMux I__154 (
            .O(N__804),
            .I(N__801));
    Span4Mux_h I__153 (
            .O(N__801),
            .I(N__798));
    Odrv4 I__152 (
            .O(N__798),
            .I(i_fsm_tx_status_byte_c_4));
    IoInMux I__151 (
            .O(N__795),
            .I(N__792));
    LocalMux I__150 (
            .O(N__792),
            .I(N__789));
    Span4Mux_s3_h I__149 (
            .O(N__789),
            .I(N__786));
    Odrv4 I__148 (
            .O(N__786),
            .I(o_mux_tx_byte_c_4));
    InMux I__147 (
            .O(N__783),
            .I(N__778));
    InMux I__146 (
            .O(N__782),
            .I(N__775));
    InMux I__145 (
            .O(N__781),
            .I(N__772));
    LocalMux I__144 (
            .O(N__778),
            .I(N__760));
    LocalMux I__143 (
            .O(N__775),
            .I(N__760));
    LocalMux I__142 (
            .O(N__772),
            .I(N__760));
    InMux I__141 (
            .O(N__771),
            .I(N__747));
    InMux I__140 (
            .O(N__770),
            .I(N__747));
    InMux I__139 (
            .O(N__769),
            .I(N__747));
    InMux I__138 (
            .O(N__768),
            .I(N__747));
    InMux I__137 (
            .O(N__767),
            .I(N__747));
    Span4Mux_v I__136 (
            .O(N__760),
            .I(N__744));
    InMux I__135 (
            .O(N__759),
            .I(N__739));
    InMux I__134 (
            .O(N__758),
            .I(N__739));
    LocalMux I__133 (
            .O(N__747),
            .I(N__736));
    Span4Mux_v I__132 (
            .O(N__744),
            .I(N__733));
    LocalMux I__131 (
            .O(N__739),
            .I(N__730));
    Span12Mux_v I__130 (
            .O(N__736),
            .I(N__727));
    Span4Mux_v I__129 (
            .O(N__733),
            .I(N__724));
    Span4Mux_v I__128 (
            .O(N__730),
            .I(N__721));
    Odrv12 I__127 (
            .O(N__727),
            .I(i_fsm_tx_start_pulse_c));
    Odrv4 I__126 (
            .O(N__724),
            .I(i_fsm_tx_start_pulse_c));
    Odrv4 I__125 (
            .O(N__721),
            .I(i_fsm_tx_start_pulse_c));
    InMux I__124 (
            .O(N__714),
            .I(N__711));
    LocalMux I__123 (
            .O(N__711),
            .I(i_send_tx_byte_c_5));
    InMux I__122 (
            .O(N__708),
            .I(N__705));
    LocalMux I__121 (
            .O(N__705),
            .I(N__702));
    Span4Mux_h I__120 (
            .O(N__702),
            .I(N__699));
    Odrv4 I__119 (
            .O(N__699),
            .I(i_fsm_tx_status_byte_c_5));
    IoInMux I__118 (
            .O(N__696),
            .I(N__693));
    LocalMux I__117 (
            .O(N__693),
            .I(N__690));
    Span4Mux_s3_h I__116 (
            .O(N__690),
            .I(N__687));
    Odrv4 I__115 (
            .O(N__687),
            .I(o_mux_tx_byte_c_5));
    ClkMux I__114 (
            .O(N__684),
            .I(N__672));
    ClkMux I__113 (
            .O(N__683),
            .I(N__672));
    ClkMux I__112 (
            .O(N__682),
            .I(N__672));
    ClkMux I__111 (
            .O(N__681),
            .I(N__672));
    GlobalMux I__110 (
            .O(N__672),
            .I(N__669));
    gio2CtrlBuf I__109 (
            .O(N__669),
            .I(i_clk_c_g));
    CEMux I__108 (
            .O(N__666),
            .I(N__661));
    CEMux I__107 (
            .O(N__665),
            .I(N__658));
    CEMux I__106 (
            .O(N__664),
            .I(N__655));
    LocalMux I__105 (
            .O(N__661),
            .I(N__652));
    LocalMux I__104 (
            .O(N__658),
            .I(N__647));
    LocalMux I__103 (
            .O(N__655),
            .I(N__647));
    Span4Mux_v I__102 (
            .O(N__652),
            .I(N__644));
    Span4Mux_h I__101 (
            .O(N__647),
            .I(N__641));
    Odrv4 I__100 (
            .O(N__644),
            .I(seq_proc_un1_i_send_tx_start_pulse_0_i_0));
    Odrv4 I__99 (
            .O(N__641),
            .I(seq_proc_un1_i_send_tx_start_pulse_0_i_0));
    SRMux I__98 (
            .O(N__636),
            .I(N__633));
    LocalMux I__97 (
            .O(N__633),
            .I(N__630));
    Span4Mux_s2_h I__96 (
            .O(N__630),
            .I(N__624));
    InMux I__95 (
            .O(N__629),
            .I(N__621));
    InMux I__94 (
            .O(N__628),
            .I(N__618));
    SRMux I__93 (
            .O(N__627),
            .I(N__615));
    Span4Mux_v I__92 (
            .O(N__624),
            .I(N__611));
    LocalMux I__91 (
            .O(N__621),
            .I(N__606));
    LocalMux I__90 (
            .O(N__618),
            .I(N__606));
    LocalMux I__89 (
            .O(N__615),
            .I(N__603));
    SRMux I__88 (
            .O(N__614),
            .I(N__600));
    Span4Mux_v I__87 (
            .O(N__611),
            .I(N__591));
    Span4Mux_v I__86 (
            .O(N__606),
            .I(N__591));
    Span4Mux_s2_h I__85 (
            .O(N__603),
            .I(N__591));
    LocalMux I__84 (
            .O(N__600),
            .I(N__591));
    Span4Mux_h I__83 (
            .O(N__591),
            .I(N__588));
    Span4Mux_h I__82 (
            .O(N__588),
            .I(N__585));
    Odrv4 I__81 (
            .O(N__585),
            .I(i_rst_c));
    InMux I__80 (
            .O(N__582),
            .I(N__579));
    LocalMux I__79 (
            .O(N__579),
            .I(i_send_tx_byte_c_6));
    InMux I__78 (
            .O(N__576),
            .I(N__573));
    LocalMux I__77 (
            .O(N__573),
            .I(i_fsm_tx_status_byte_c_6));
    IoInMux I__76 (
            .O(N__570),
            .I(N__567));
    LocalMux I__75 (
            .O(N__567),
            .I(N__564));
    Span4Mux_s0_h I__74 (
            .O(N__564),
            .I(N__561));
    Odrv4 I__73 (
            .O(N__561),
            .I(o_mux_tx_byte_c_6));
    InMux I__72 (
            .O(N__558),
            .I(N__555));
    LocalMux I__71 (
            .O(N__555),
            .I(N__552));
    Span4Mux_v I__70 (
            .O(N__552),
            .I(N__549));
    Odrv4 I__69 (
            .O(N__549),
            .I(i_send_tx_byte_c_7));
    InMux I__68 (
            .O(N__546),
            .I(N__543));
    LocalMux I__67 (
            .O(N__543),
            .I(i_fsm_tx_status_byte_c_7));
    IoInMux I__66 (
            .O(N__540),
            .I(N__537));
    LocalMux I__65 (
            .O(N__537),
            .I(N__534));
    IoSpan4Mux I__64 (
            .O(N__534),
            .I(N__531));
    IoSpan4Mux I__63 (
            .O(N__531),
            .I(N__528));
    Odrv4 I__62 (
            .O(N__528),
            .I(o_mux_tx_byte_c_7));
    IoInMux I__61 (
            .O(N__525),
            .I(N__522));
    LocalMux I__60 (
            .O(N__522),
            .I(N__519));
    Span4Mux_s1_h I__59 (
            .O(N__519),
            .I(N__516));
    Odrv4 I__58 (
            .O(N__516),
            .I(r_mux_tx_start_pulseZ0));
    InMux I__57 (
            .O(N__513),
            .I(N__510));
    LocalMux I__56 (
            .O(N__510),
            .I(N__506));
    InMux I__55 (
            .O(N__509),
            .I(N__503));
    Span4Mux_s2_h I__54 (
            .O(N__506),
            .I(N__498));
    LocalMux I__53 (
            .O(N__503),
            .I(N__498));
    Odrv4 I__52 (
            .O(N__498),
            .I(i_send_tx_start_pulse_c));
    InMux I__51 (
            .O(N__495),
            .I(N__492));
    LocalMux I__50 (
            .O(N__492),
            .I(N__489));
    Span4Mux_h I__49 (
            .O(N__489),
            .I(N__486));
    Odrv4 I__48 (
            .O(N__486),
            .I(i_send_tx_byte_c_0));
    InMux I__47 (
            .O(N__483),
            .I(N__480));
    LocalMux I__46 (
            .O(N__480),
            .I(N__477));
    Span4Mux_v I__45 (
            .O(N__477),
            .I(N__474));
    Odrv4 I__44 (
            .O(N__474),
            .I(i_fsm_tx_status_byte_c_0));
    IoInMux I__43 (
            .O(N__471),
            .I(N__468));
    LocalMux I__42 (
            .O(N__468),
            .I(o_mux_tx_byte_c_0));
    VCC VCC (
            .Y(VCCG0));
    GND GND (
            .Y(GNDG0));
    GND GND_Inst (
            .Y(_gnd_net_));
    defparam r_mux_tx_byte_esr_6_LC_1_8_0.C_ON=1'b0;
    defparam r_mux_tx_byte_esr_6_LC_1_8_0.SEQ_MODE=4'b1000;
    defparam r_mux_tx_byte_esr_6_LC_1_8_0.LUT_INIT=16'b1110111001000100;
    LogicCell40 r_mux_tx_byte_esr_6_LC_1_8_0 (
            .in0(N__758),
            .in1(N__582),
            .in2(_gnd_net_),
            .in3(N__576),
            .lcout(o_mux_tx_byte_c_6),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__681),
            .ce(N__666),
            .sr(N__636));
    defparam r_mux_tx_byte_esr_7_LC_1_8_1.C_ON=1'b0;
    defparam r_mux_tx_byte_esr_7_LC_1_8_1.SEQ_MODE=4'b1000;
    defparam r_mux_tx_byte_esr_7_LC_1_8_1.LUT_INIT=16'b1100110010101010;
    LogicCell40 r_mux_tx_byte_esr_7_LC_1_8_1 (
            .in0(N__558),
            .in1(N__546),
            .in2(_gnd_net_),
            .in3(N__759),
            .lcout(o_mux_tx_byte_c_7),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__681),
            .ce(N__666),
            .sr(N__636));
    defparam r_mux_tx_start_pulse_RNO_LC_2_13_4.C_ON=1'b0;
    defparam r_mux_tx_start_pulse_RNO_LC_2_13_4.SEQ_MODE=4'b0000;
    defparam r_mux_tx_start_pulse_RNO_LC_2_13_4.LUT_INIT=16'b0101010101000100;
    LogicCell40 r_mux_tx_start_pulse_RNO_LC_2_13_4 (
            .in0(N__629),
            .in1(N__513),
            .in2(_gnd_net_),
            .in3(N__781),
            .lcout(r_mux_tx_start_pulseZ0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam i_send_tx_start_pulse_ibuf_RNIGI041_LC_2_14_0.C_ON=1'b0;
    defparam i_send_tx_start_pulse_ibuf_RNIGI041_LC_2_14_0.SEQ_MODE=4'b0000;
    defparam i_send_tx_start_pulse_ibuf_RNIGI041_LC_2_14_0.LUT_INIT=16'b1111111111101110;
    LogicCell40 i_send_tx_start_pulse_ibuf_RNIGI041_LC_2_14_0 (
            .in0(N__509),
            .in1(N__628),
            .in2(_gnd_net_),
            .in3(N__782),
            .lcout(seq_proc_un1_i_send_tx_start_pulse_0_i_0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_mux_tx_byte_esr_0_LC_2_16_2.C_ON=1'b0;
    defparam r_mux_tx_byte_esr_0_LC_2_16_2.SEQ_MODE=4'b1000;
    defparam r_mux_tx_byte_esr_0_LC_2_16_2.LUT_INIT=16'b1100110010101010;
    LogicCell40 r_mux_tx_byte_esr_0_LC_2_16_2 (
            .in0(N__495),
            .in1(N__483),
            .in2(_gnd_net_),
            .in3(N__783),
            .lcout(o_mux_tx_byte_c_0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__683),
            .ce(N__664),
            .sr(N__627));
    defparam r_mux_tx_byte_esr_1_LC_4_16_3.C_ON=1'b0;
    defparam r_mux_tx_byte_esr_1_LC_4_16_3.SEQ_MODE=4'b1000;
    defparam r_mux_tx_byte_esr_1_LC_4_16_3.LUT_INIT=16'b1110111001000100;
    LogicCell40 r_mux_tx_byte_esr_1_LC_4_16_3 (
            .in0(N__767),
            .in1(N__918),
            .in2(_gnd_net_),
            .in3(N__906),
            .lcout(o_mux_tx_byte_c_1),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__684),
            .ce(N__665),
            .sr(N__614));
    defparam r_mux_tx_byte_esr_2_LC_4_16_4.C_ON=1'b0;
    defparam r_mux_tx_byte_esr_2_LC_4_16_4.SEQ_MODE=4'b1000;
    defparam r_mux_tx_byte_esr_2_LC_4_16_4.LUT_INIT=16'b1100110010101010;
    LogicCell40 r_mux_tx_byte_esr_2_LC_4_16_4 (
            .in0(N__879),
            .in1(N__873),
            .in2(_gnd_net_),
            .in3(N__768),
            .lcout(o_mux_tx_byte_c_2),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__684),
            .ce(N__665),
            .sr(N__614));
    defparam r_mux_tx_byte_esr_3_LC_4_16_5.C_ON=1'b0;
    defparam r_mux_tx_byte_esr_3_LC_4_16_5.SEQ_MODE=4'b1000;
    defparam r_mux_tx_byte_esr_3_LC_4_16_5.LUT_INIT=16'b1110111001000100;
    LogicCell40 r_mux_tx_byte_esr_3_LC_4_16_5 (
            .in0(N__769),
            .in1(N__846),
            .in2(_gnd_net_),
            .in3(N__840),
            .lcout(o_mux_tx_byte_c_3),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__684),
            .ce(N__665),
            .sr(N__614));
    defparam r_mux_tx_byte_esr_4_LC_4_16_6.C_ON=1'b0;
    defparam r_mux_tx_byte_esr_4_LC_4_16_6.SEQ_MODE=4'b1000;
    defparam r_mux_tx_byte_esr_4_LC_4_16_6.LUT_INIT=16'b1100110010101010;
    LogicCell40 r_mux_tx_byte_esr_4_LC_4_16_6 (
            .in0(N__813),
            .in1(N__807),
            .in2(_gnd_net_),
            .in3(N__770),
            .lcout(o_mux_tx_byte_c_4),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__684),
            .ce(N__665),
            .sr(N__614));
    defparam r_mux_tx_byte_esr_5_LC_4_16_7.C_ON=1'b0;
    defparam r_mux_tx_byte_esr_5_LC_4_16_7.SEQ_MODE=4'b1000;
    defparam r_mux_tx_byte_esr_5_LC_4_16_7.LUT_INIT=16'b1110111001000100;
    LogicCell40 r_mux_tx_byte_esr_5_LC_4_16_7 (
            .in0(N__771),
            .in1(N__714),
            .in2(_gnd_net_),
            .in3(N__708),
            .lcout(o_mux_tx_byte_c_5),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__684),
            .ce(N__665),
            .sr(N__614));
endmodule // tx_mux
