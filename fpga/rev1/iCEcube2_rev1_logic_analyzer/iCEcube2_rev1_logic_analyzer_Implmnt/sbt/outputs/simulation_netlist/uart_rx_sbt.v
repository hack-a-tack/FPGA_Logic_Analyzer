// ******************************************************************************

// iCEcube Netlister

// Version:            2020.12.27943

// Build Date:         Dec  9 2020 18:18:12

// File Generated:     Mar 11 2026 06:07:31

// Purpose:            Post-Route Verilog/VHDL netlist for timing simulation

// Copyright (C) 2006-2010 by Lattice Semiconductor Corp. All rights reserved.

// ******************************************************************************

// Verilog file for cell "uart_rx" view "INTERFACE"

module uart_rx (
    o_rx_byte,
    i_clk,
    o_rx_valid_pulse,
    i_rst,
    i_UART_RX,
    o_UART_RX_LED);

    output [7:0] o_rx_byte;
    input i_clk;
    output o_rx_valid_pulse;
    input i_rst;
    input i_UART_RX;
    output o_UART_RX_LED;

    wire N__4494;
    wire N__4493;
    wire N__4492;
    wire N__4483;
    wire N__4482;
    wire N__4481;
    wire N__4474;
    wire N__4473;
    wire N__4472;
    wire N__4465;
    wire N__4464;
    wire N__4463;
    wire N__4456;
    wire N__4455;
    wire N__4454;
    wire N__4447;
    wire N__4446;
    wire N__4445;
    wire N__4438;
    wire N__4437;
    wire N__4436;
    wire N__4429;
    wire N__4428;
    wire N__4427;
    wire N__4420;
    wire N__4419;
    wire N__4418;
    wire N__4411;
    wire N__4410;
    wire N__4409;
    wire N__4402;
    wire N__4401;
    wire N__4400;
    wire N__4393;
    wire N__4392;
    wire N__4391;
    wire N__4384;
    wire N__4383;
    wire N__4382;
    wire N__4365;
    wire N__4362;
    wire N__4359;
    wire N__4358;
    wire N__4355;
    wire N__4352;
    wire N__4349;
    wire N__4344;
    wire N__4341;
    wire N__4340;
    wire N__4337;
    wire N__4334;
    wire N__4329;
    wire N__4326;
    wire N__4325;
    wire N__4322;
    wire N__4319;
    wire N__4314;
    wire N__4311;
    wire N__4308;
    wire N__4307;
    wire N__4304;
    wire N__4301;
    wire N__4296;
    wire N__4295;
    wire N__4294;
    wire N__4293;
    wire N__4292;
    wire N__4291;
    wire N__4290;
    wire N__4289;
    wire N__4288;
    wire N__4287;
    wire N__4286;
    wire N__4285;
    wire N__4284;
    wire N__4283;
    wire N__4282;
    wire N__4281;
    wire N__4248;
    wire N__4245;
    wire N__4242;
    wire N__4241;
    wire N__4240;
    wire N__4239;
    wire N__4230;
    wire N__4227;
    wire N__4224;
    wire N__4223;
    wire N__4220;
    wire N__4217;
    wire N__4212;
    wire N__4211;
    wire N__4208;
    wire N__4205;
    wire N__4200;
    wire N__4199;
    wire N__4196;
    wire N__4193;
    wire N__4190;
    wire N__4185;
    wire N__4184;
    wire N__4181;
    wire N__4178;
    wire N__4173;
    wire N__4170;
    wire N__4167;
    wire N__4164;
    wire N__4163;
    wire N__4160;
    wire N__4157;
    wire N__4152;
    wire N__4149;
    wire N__4148;
    wire N__4145;
    wire N__4142;
    wire N__4137;
    wire N__4134;
    wire N__4133;
    wire N__4130;
    wire N__4127;
    wire N__4122;
    wire N__4119;
    wire N__4118;
    wire N__4115;
    wire N__4112;
    wire N__4107;
    wire N__4104;
    wire N__4103;
    wire N__4100;
    wire N__4097;
    wire N__4092;
    wire N__4089;
    wire N__4088;
    wire N__4085;
    wire N__4082;
    wire N__4079;
    wire N__4074;
    wire N__4071;
    wire N__4068;
    wire N__4065;
    wire N__4064;
    wire N__4061;
    wire N__4058;
    wire N__4053;
    wire N__4050;
    wire N__4049;
    wire N__4046;
    wire N__4043;
    wire N__4038;
    wire N__4035;
    wire N__4034;
    wire N__4031;
    wire N__4028;
    wire N__4023;
    wire N__4020;
    wire N__4019;
    wire N__4016;
    wire N__4013;
    wire N__4008;
    wire N__4005;
    wire N__4004;
    wire N__4001;
    wire N__3998;
    wire N__3995;
    wire N__3990;
    wire N__3987;
    wire N__3986;
    wire N__3983;
    wire N__3980;
    wire N__3975;
    wire N__3972;
    wire N__3971;
    wire N__3968;
    wire N__3965;
    wire N__3960;
    wire N__3957;
    wire N__3956;
    wire N__3953;
    wire N__3950;
    wire N__3945;
    wire N__3942;
    wire N__3941;
    wire N__3938;
    wire N__3935;
    wire N__3932;
    wire N__3927;
    wire N__3924;
    wire N__3923;
    wire N__3922;
    wire N__3919;
    wire N__3916;
    wire N__3915;
    wire N__3914;
    wire N__3913;
    wire N__3912;
    wire N__3911;
    wire N__3908;
    wire N__3901;
    wire N__3892;
    wire N__3887;
    wire N__3884;
    wire N__3883;
    wire N__3882;
    wire N__3879;
    wire N__3876;
    wire N__3873;
    wire N__3870;
    wire N__3861;
    wire N__3858;
    wire N__3857;
    wire N__3856;
    wire N__3855;
    wire N__3854;
    wire N__3853;
    wire N__3852;
    wire N__3851;
    wire N__3846;
    wire N__3841;
    wire N__3832;
    wire N__3825;
    wire N__3824;
    wire N__3823;
    wire N__3820;
    wire N__3817;
    wire N__3814;
    wire N__3807;
    wire N__3804;
    wire N__3803;
    wire N__3800;
    wire N__3797;
    wire N__3792;
    wire N__3789;
    wire N__3788;
    wire N__3785;
    wire N__3782;
    wire N__3777;
    wire N__3774;
    wire N__3773;
    wire N__3770;
    wire N__3767;
    wire N__3762;
    wire N__3759;
    wire N__3758;
    wire N__3755;
    wire N__3752;
    wire N__3749;
    wire N__3744;
    wire N__3741;
    wire N__3740;
    wire N__3737;
    wire N__3734;
    wire N__3729;
    wire N__3726;
    wire N__3725;
    wire N__3722;
    wire N__3719;
    wire N__3716;
    wire N__3711;
    wire N__3708;
    wire N__3705;
    wire N__3702;
    wire N__3699;
    wire N__3696;
    wire N__3693;
    wire N__3690;
    wire N__3687;
    wire N__3686;
    wire N__3683;
    wire N__3680;
    wire N__3679;
    wire N__3678;
    wire N__3677;
    wire N__3676;
    wire N__3675;
    wire N__3674;
    wire N__3673;
    wire N__3668;
    wire N__3665;
    wire N__3662;
    wire N__3655;
    wire N__3650;
    wire N__3645;
    wire N__3636;
    wire N__3635;
    wire N__3634;
    wire N__3631;
    wire N__3630;
    wire N__3627;
    wire N__3626;
    wire N__3625;
    wire N__3622;
    wire N__3619;
    wire N__3616;
    wire N__3615;
    wire N__3614;
    wire N__3613;
    wire N__3612;
    wire N__3611;
    wire N__3610;
    wire N__3603;
    wire N__3600;
    wire N__3597;
    wire N__3594;
    wire N__3591;
    wire N__3580;
    wire N__3567;
    wire N__3566;
    wire N__3563;
    wire N__3560;
    wire N__3557;
    wire N__3554;
    wire N__3551;
    wire N__3548;
    wire N__3543;
    wire N__3542;
    wire N__3539;
    wire N__3536;
    wire N__3535;
    wire N__3534;
    wire N__3533;
    wire N__3532;
    wire N__3529;
    wire N__3526;
    wire N__3523;
    wire N__3518;
    wire N__3515;
    wire N__3514;
    wire N__3513;
    wire N__3510;
    wire N__3505;
    wire N__3504;
    wire N__3503;
    wire N__3500;
    wire N__3497;
    wire N__3494;
    wire N__3491;
    wire N__3486;
    wire N__3483;
    wire N__3480;
    wire N__3477;
    wire N__3474;
    wire N__3471;
    wire N__3468;
    wire N__3461;
    wire N__3458;
    wire N__3453;
    wire N__3450;
    wire N__3447;
    wire N__3438;
    wire N__3437;
    wire N__3434;
    wire N__3433;
    wire N__3432;
    wire N__3429;
    wire N__3428;
    wire N__3427;
    wire N__3426;
    wire N__3423;
    wire N__3420;
    wire N__3417;
    wire N__3414;
    wire N__3413;
    wire N__3412;
    wire N__3411;
    wire N__3410;
    wire N__3407;
    wire N__3402;
    wire N__3397;
    wire N__3392;
    wire N__3389;
    wire N__3382;
    wire N__3369;
    wire N__3366;
    wire N__3365;
    wire N__3362;
    wire N__3359;
    wire N__3356;
    wire N__3351;
    wire N__3348;
    wire N__3345;
    wire N__3342;
    wire N__3341;
    wire N__3338;
    wire N__3335;
    wire N__3332;
    wire N__3327;
    wire N__3324;
    wire N__3321;
    wire N__3320;
    wire N__3319;
    wire N__3318;
    wire N__3317;
    wire N__3316;
    wire N__3315;
    wire N__3314;
    wire N__3305;
    wire N__3296;
    wire N__3295;
    wire N__3292;
    wire N__3289;
    wire N__3288;
    wire N__3285;
    wire N__3282;
    wire N__3279;
    wire N__3276;
    wire N__3273;
    wire N__3264;
    wire N__3261;
    wire N__3258;
    wire N__3255;
    wire N__3252;
    wire N__3249;
    wire N__3246;
    wire N__3243;
    wire N__3240;
    wire N__3237;
    wire N__3234;
    wire N__3231;
    wire N__3228;
    wire N__3225;
    wire N__3222;
    wire N__3219;
    wire N__3216;
    wire N__3213;
    wire N__3210;
    wire N__3207;
    wire N__3204;
    wire N__3201;
    wire N__3198;
    wire N__3195;
    wire N__3192;
    wire N__3189;
    wire N__3186;
    wire N__3185;
    wire N__3182;
    wire N__3179;
    wire N__3176;
    wire N__3171;
    wire N__3170;
    wire N__3167;
    wire N__3164;
    wire N__3163;
    wire N__3162;
    wire N__3157;
    wire N__3154;
    wire N__3153;
    wire N__3152;
    wire N__3151;
    wire N__3150;
    wire N__3149;
    wire N__3148;
    wire N__3145;
    wire N__3144;
    wire N__3141;
    wire N__3138;
    wire N__3137;
    wire N__3130;
    wire N__3121;
    wire N__3118;
    wire N__3113;
    wire N__3110;
    wire N__3099;
    wire N__3096;
    wire N__3093;
    wire N__3092;
    wire N__3091;
    wire N__3090;
    wire N__3089;
    wire N__3088;
    wire N__3087;
    wire N__3086;
    wire N__3083;
    wire N__3068;
    wire N__3063;
    wire N__3060;
    wire N__3057;
    wire N__3054;
    wire N__3053;
    wire N__3050;
    wire N__3047;
    wire N__3044;
    wire N__3041;
    wire N__3036;
    wire N__3033;
    wire N__3030;
    wire N__3027;
    wire N__3024;
    wire N__3021;
    wire N__3018;
    wire N__3017;
    wire N__3014;
    wire N__3011;
    wire N__3008;
    wire N__3005;
    wire N__3000;
    wire N__2999;
    wire N__2996;
    wire N__2993;
    wire N__2990;
    wire N__2987;
    wire N__2982;
    wire N__2981;
    wire N__2978;
    wire N__2975;
    wire N__2972;
    wire N__2969;
    wire N__2964;
    wire N__2961;
    wire N__2960;
    wire N__2957;
    wire N__2954;
    wire N__2951;
    wire N__2948;
    wire N__2943;
    wire N__2940;
    wire N__2939;
    wire N__2936;
    wire N__2933;
    wire N__2930;
    wire N__2927;
    wire N__2922;
    wire N__2919;
    wire N__2918;
    wire N__2915;
    wire N__2912;
    wire N__2909;
    wire N__2906;
    wire N__2901;
    wire N__2898;
    wire N__2895;
    wire N__2894;
    wire N__2891;
    wire N__2888;
    wire N__2885;
    wire N__2882;
    wire N__2877;
    wire N__2874;
    wire N__2871;
    wire N__2868;
    wire N__2865;
    wire N__2862;
    wire N__2861;
    wire N__2858;
    wire N__2855;
    wire N__2852;
    wire N__2849;
    wire N__2844;
    wire N__2841;
    wire N__2838;
    wire N__2835;
    wire N__2832;
    wire N__2829;
    wire N__2828;
    wire N__2825;
    wire N__2822;
    wire N__2819;
    wire N__2816;
    wire N__2811;
    wire N__2808;
    wire N__2805;
    wire N__2802;
    wire N__2799;
    wire N__2796;
    wire N__2793;
    wire N__2790;
    wire N__2787;
    wire N__2784;
    wire N__2781;
    wire N__2778;
    wire N__2775;
    wire N__2772;
    wire N__2769;
    wire N__2768;
    wire N__2765;
    wire N__2762;
    wire N__2759;
    wire N__2756;
    wire N__2751;
    wire N__2748;
    wire N__2745;
    wire N__2742;
    wire N__2739;
    wire N__2736;
    wire N__2733;
    wire N__2732;
    wire N__2729;
    wire N__2726;
    wire N__2723;
    wire N__2720;
    wire N__2715;
    wire N__2712;
    wire N__2709;
    wire N__2706;
    wire N__2703;
    wire N__2702;
    wire N__2699;
    wire N__2696;
    wire N__2691;
    wire N__2688;
    wire N__2685;
    wire N__2682;
    wire N__2679;
    wire N__2678;
    wire N__2675;
    wire N__2672;
    wire N__2669;
    wire N__2666;
    wire N__2661;
    wire N__2658;
    wire N__2655;
    wire N__2652;
    wire N__2649;
    wire N__2646;
    wire N__2645;
    wire N__2642;
    wire N__2639;
    wire N__2636;
    wire N__2633;
    wire N__2628;
    wire N__2625;
    wire N__2622;
    wire N__2619;
    wire N__2618;
    wire N__2615;
    wire N__2612;
    wire N__2609;
    wire N__2606;
    wire N__2601;
    wire N__2600;
    wire N__2597;
    wire N__2596;
    wire N__2593;
    wire N__2590;
    wire N__2587;
    wire N__2580;
    wire N__2579;
    wire N__2576;
    wire N__2575;
    wire N__2572;
    wire N__2569;
    wire N__2566;
    wire N__2559;
    wire N__2558;
    wire N__2557;
    wire N__2554;
    wire N__2551;
    wire N__2548;
    wire N__2541;
    wire N__2540;
    wire N__2537;
    wire N__2534;
    wire N__2529;
    wire N__2528;
    wire N__2525;
    wire N__2522;
    wire N__2517;
    wire N__2516;
    wire N__2513;
    wire N__2510;
    wire N__2507;
    wire N__2502;
    wire N__2501;
    wire N__2498;
    wire N__2495;
    wire N__2490;
    wire N__2489;
    wire N__2486;
    wire N__2485;
    wire N__2482;
    wire N__2477;
    wire N__2472;
    wire N__2471;
    wire N__2470;
    wire N__2467;
    wire N__2462;
    wire N__2457;
    wire N__2456;
    wire N__2455;
    wire N__2452;
    wire N__2449;
    wire N__2444;
    wire N__2439;
    wire N__2438;
    wire N__2437;
    wire N__2434;
    wire N__2429;
    wire N__2424;
    wire N__2423;
    wire N__2420;
    wire N__2417;
    wire N__2412;
    wire N__2411;
    wire N__2408;
    wire N__2405;
    wire N__2400;
    wire N__2399;
    wire N__2396;
    wire N__2393;
    wire N__2390;
    wire N__2385;
    wire N__2384;
    wire N__2381;
    wire N__2378;
    wire N__2373;
    wire N__2372;
    wire N__2369;
    wire N__2366;
    wire N__2361;
    wire N__2360;
    wire N__2357;
    wire N__2354;
    wire N__2349;
    wire N__2348;
    wire N__2345;
    wire N__2342;
    wire N__2339;
    wire N__2334;
    wire N__2333;
    wire N__2330;
    wire N__2327;
    wire N__2322;
    wire N__2321;
    wire N__2318;
    wire N__2315;
    wire N__2310;
    wire N__2309;
    wire N__2306;
    wire N__2303;
    wire N__2298;
    wire N__2297;
    wire N__2294;
    wire N__2291;
    wire N__2288;
    wire N__2283;
    wire N__2282;
    wire N__2279;
    wire N__2276;
    wire N__2271;
    wire N__2268;
    wire N__2265;
    wire N__2262;
    wire N__2259;
    wire N__2256;
    wire N__2253;
    wire N__2250;
    wire N__2247;
    wire N__2244;
    wire N__2241;
    wire N__2238;
    wire N__2235;
    wire N__2234;
    wire N__2233;
    wire N__2232;
    wire N__2231;
    wire N__2220;
    wire N__2217;
    wire N__2214;
    wire N__2213;
    wire N__2210;
    wire N__2207;
    wire N__2202;
    wire N__2201;
    wire N__2198;
    wire N__2195;
    wire N__2190;
    wire N__2189;
    wire N__2186;
    wire N__2183;
    wire N__2180;
    wire N__2175;
    wire N__2174;
    wire N__2171;
    wire N__2168;
    wire N__2163;
    wire N__2162;
    wire N__2159;
    wire N__2156;
    wire N__2153;
    wire N__2148;
    wire N__2145;
    wire N__2144;
    wire N__2143;
    wire N__2140;
    wire N__2137;
    wire N__2134;
    wire N__2131;
    wire N__2124;
    wire N__2123;
    wire N__2120;
    wire N__2117;
    wire N__2112;
    wire N__2111;
    wire N__2108;
    wire N__2105;
    wire N__2100;
    wire N__2099;
    wire N__2096;
    wire N__2093;
    wire N__2090;
    wire N__2085;
    wire N__2084;
    wire N__2081;
    wire N__2078;
    wire N__2073;
    wire N__2070;
    wire N__2067;
    wire N__2064;
    wire N__2061;
    wire N__2058;
    wire N__2055;
    wire N__2052;
    wire N__2049;
    wire N__2046;
    wire N__2043;
    wire N__2040;
    wire N__2037;
    wire N__2034;
    wire N__2031;
    wire N__2028;
    wire N__2025;
    wire N__2022;
    wire N__2019;
    wire N__2016;
    wire N__2013;
    wire N__2010;
    wire N__2007;
    wire N__2004;
    wire N__2001;
    wire N__1998;
    wire N__1995;
    wire N__1992;
    wire N__1989;
    wire N__1986;
    wire N__1983;
    wire VCCG0;
    wire GNDG0;
    wire bfn_7_9_0_;
    wire un1_r_clk_counter_1_cry_0;
    wire un1_r_clk_counter_1_cry_1;
    wire un1_r_clk_counter_1_cry_2;
    wire un1_r_clk_counter_1_cry_3;
    wire un1_r_clk_counter_1_cry_4;
    wire un1_r_clk_counter_1_cry_5;
    wire un1_r_clk_counter_1_cry_6;
    wire un1_r_clk_counter_1_cry_7;
    wire bfn_7_10_0_;
    wire un1_r_clk_counter_1_cry_8;
    wire un1_r_clk_counter_1_cry_9;
    wire un1_r_clk_counter_1_cry_10;
    wire un1_r_clk_counter_1_cry_11;
    wire un1_r_clk_counter_1_cry_12;
    wire un1_r_clk_counter_1_cry_13;
    wire un1_r_clk_counter_1_cry_14;
    wire un1_r_clk_counter_1_cry_15;
    wire bfn_7_11_0_;
    wire un1_r_clk_counter_1_cry_16;
    wire un1_r_clk_counter_1_cry_17;
    wire un1_r_clk_counter_1_cry_18;
    wire un1_r_clk_counter_1_cry_19;
    wire un1_r_clk_counter_1_cry_20;
    wire un1_r_clk_counter_1_cry_21;
    wire un1_r_clk_counter_1_cry_22;
    wire un1_r_clk_counter_1_cry_23;
    wire bfn_7_12_0_;
    wire un1_r_clk_counter_1_cry_24;
    wire un1_r_clk_counter_1_cry_25;
    wire un1_r_clk_counter_1_cry_26;
    wire un1_r_clk_counter_1_cry_27;
    wire un1_r_clk_counter_1_cry_28;
    wire un1_r_clk_counter_1_cry_29;
    wire un1_r_clk_counter_1_cry_30;
    wire i_UART_RX_c;
    wire r_clk_counter_RNO_0Z0Z_4;
    wire r_clk_counter_RNO_0Z0Z_5;
    wire r_clk_counter_RNO_0Z0Z_2;
    wire N_144_g;
    wire r_clk_counterZ0Z_11;
    wire r_clk_counterZ0Z_10;
    wire r_clk_counterZ0Z_9;
    wire r_clk_counterZ0Z_8;
    wire N_2_i;
    wire r_clk_counterZ0Z_3;
    wire r_clk_counterZ0Z_18;
    wire r_clk_counterZ0Z_19;
    wire r_clk_counterZ0Z_17;
    wire r_clk_counterZ0Z_16;
    wire r_clk_counterZ0Z_2;
    wire r_clk_counterZ0Z_6;
    wire r_clk_counterZ0Z_7;
    wire r_clk_counterZ0Z_12;
    wire r_clk_counterZ0Z_15;
    wire r_clk_counterZ0Z_13;
    wire r_clk_counterZ0Z_14;
    wire r_clk_counterZ0Z_1;
    wire r_clk_counterZ0Z_0;
    wire r_clk_counterZ0Z_4;
    wire r_clk_counterZ0Z_5;
    wire r_clk_counterZ0Z_29;
    wire r_clk_counterZ0Z_28;
    wire r_clk_counterZ0Z_31;
    wire r_clk_counterZ0Z_30;
    wire r_clk_counterZ0Z_26;
    wire r_clk_counterZ0Z_24;
    wire r_clk_counterZ0Z_27;
    wire r_clk_counterZ0Z_25;
    wire r_clk_counterZ0Z_23;
    wire r_clk_counterZ0Z_20;
    wire r_clk_counterZ0Z_22;
    wire r_clk_counterZ0Z_21;
    wire o_rx_valid_pulse_c;
    wire N_61;
    wire o_rx_byte_c_5;
    wire N_59;
    wire o_rx_byte_c_7;
    wire o_rx_byte_c_0;
    wire N_63;
    wire o_rx_byte_c_3;
    wire N_62;
    wire o_rx_byte_c_4;
    wire o_rx_byte_c_1;
    wire o_rx_byte_c_2;
    wire r_rx_syncZ0Z_1;
    wire o_UART_RX_LED_c;
    wire fsm_proc_un10_r_clk_counter_0_and;
    wire bfn_9_9_0_;
    wire fsm_proc_un10_r_clk_counter_1_and;
    wire fsm_proc_un10_r_clk_counter_0;
    wire fsm_proc_un10_r_clk_counter_1;
    wire fsm_proc_un10_r_clk_counter_2;
    wire fsm_proc_un10_r_clk_counter_3;
    wire fsm_proc_un10_r_clk_counter_4;
    wire fsm_proc_un10_r_clk_counter_5;
    wire fsm_proc_un10_r_clk_counter_6;
    wire fsm_proc_un10_r_clk_counter;
    wire bfn_9_10_0_;
    wire fsm_proc_un10_r_clk_counter_THRU_CO_cascade_;
    wire N_17_0;
    wire N_18_0_cascade_;
    wire N_21_cascade_;
    wire fsm_proc_un6_r_clk_counter_0_and;
    wire bfn_9_11_0_;
    wire fsm_proc_un6_r_clk_counter_1_and;
    wire fsm_proc_un6_r_clk_counter_0;
    wire fsm_proc_un6_r_clk_counter_2_and;
    wire fsm_proc_un6_r_clk_counter_1;
    wire fsm_proc_un6_r_clk_counter_3_and;
    wire fsm_proc_un6_r_clk_counter_2;
    wire fsm_proc_un6_r_clk_counter_4_and;
    wire fsm_proc_un6_r_clk_counter_3;
    wire fsm_proc_un6_r_clk_counter_5_and;
    wire fsm_proc_un6_r_clk_counter_4;
    wire fsm_proc_un6_r_clk_counter_6_and;
    wire fsm_proc_un6_r_clk_counter_5;
    wire fsm_proc_un6_r_clk_counter_7_and;
    wire fsm_proc_un6_r_clk_counter_6;
    wire fsm_proc_un6_r_clk_counter;
    wire bfn_9_12_0_;
    wire fsm_proc_un6_r_clk_counter_THRU_CO_cascade_;
    wire r_rx_bytece_0_2;
    wire r_rx_bytece_0_1;
    wire r_rx_bytece_0_0;
    wire fsm_proc_un6_r_clk_counter_THRU_CO;
    wire r_rx_syncZ0Z_2;
    wire N_60;
    wire n_rx_byte_0_sqmuxa;
    wire o_rx_byte_c_6;
    wire fsm_proc_un22_r_clk_counter_0_and;
    wire bfn_11_12_0_;
    wire fsm_proc_un22_r_clk_counter_1_and;
    wire fsm_proc_un22_r_clk_counter_0;
    wire fsm_proc_un22_r_clk_counter_2_and;
    wire fsm_proc_un22_r_clk_counter_1;
    wire fsm_proc_un22_r_clk_counter_3_and;
    wire fsm_proc_un22_r_clk_counter_2;
    wire fsm_proc_un22_r_clk_counter_4_and;
    wire fsm_proc_un22_r_clk_counter_3;
    wire fsm_proc_un22_r_clk_counter_5_and;
    wire fsm_proc_un22_r_clk_counter_4;
    wire fsm_proc_un22_r_clk_counter_5;
    wire fsm_proc_un22_r_clk_counter_6;
    wire fsm_proc_un22_r_clk_counter;
    wire bfn_11_13_0_;
    wire fsm_proc_un22_r_clk_counter_7_and;
    wire fsm_proc_un10_r_clk_counter_THRU_CO;
    wire r_stateZ0Z_1;
    wire fsm_proc_un22_r_clk_counter_THRU_CO;
    wire i_rst_c;
    wire r_stateZ0Z_0;
    wire N_27_cascade_;
    wire N_23;
    wire r_state_RNI6KS51Z0Z_0;
    wire n_state_2_sqmuxa;
    wire r_bit_counterZ0Z_0;
    wire bfn_12_9_0_;
    wire r_bit_counterZ0Z_1;
    wire un1_r_bit_counter_1_cry_0;
    wire r_bit_counterZ0Z_2;
    wire un1_r_bit_counter_1_cry_1;
    wire r_bit_counterZ0Z_3;
    wire un1_r_bit_counter_1_cry_2;
    wire r_bit_counterZ0Z_4;
    wire un1_r_bit_counter_1_cry_3;
    wire r_bit_counterZ0Z_5;
    wire un1_r_bit_counter_1_cry_4;
    wire r_bit_counterZ0Z_6;
    wire un1_r_bit_counter_1_cry_5;
    wire r_bit_counterZ0Z_7;
    wire un1_r_bit_counter_1_cry_6;
    wire un1_r_bit_counter_1_cry_7;
    wire r_bit_counterZ0Z_8;
    wire bfn_12_10_0_;
    wire r_bit_counterZ0Z_9;
    wire un1_r_bit_counter_1_cry_8;
    wire r_bit_counterZ0Z_10;
    wire un1_r_bit_counter_1_cry_9;
    wire r_bit_counterZ0Z_11;
    wire un1_r_bit_counter_1_cry_10;
    wire r_bit_counterZ0Z_12;
    wire un1_r_bit_counter_1_cry_11;
    wire r_bit_counterZ0Z_13;
    wire un1_r_bit_counter_1_cry_12;
    wire r_bit_counterZ0Z_14;
    wire un1_r_bit_counter_1_cry_13;
    wire r_bit_counterZ0Z_15;
    wire un1_r_bit_counter_1_cry_14;
    wire un1_r_bit_counter_1_cry_15;
    wire r_bit_counterZ0Z_16;
    wire bfn_12_11_0_;
    wire r_bit_counterZ0Z_17;
    wire un1_r_bit_counter_1_cry_16;
    wire r_bit_counterZ0Z_18;
    wire un1_r_bit_counter_1_cry_17;
    wire r_bit_counterZ0Z_19;
    wire un1_r_bit_counter_1_cry_18;
    wire r_bit_counterZ0Z_20;
    wire un1_r_bit_counter_1_cry_19;
    wire r_bit_counterZ0Z_21;
    wire un1_r_bit_counter_1_cry_20;
    wire r_bit_counterZ0Z_22;
    wire un1_r_bit_counter_1_cry_21;
    wire r_bit_counterZ0Z_23;
    wire un1_r_bit_counter_1_cry_22;
    wire un1_r_bit_counter_1_cry_23;
    wire bfn_12_12_0_;
    wire un1_r_bit_counter_1_cry_24;
    wire un1_r_bit_counter_1_cry_25;
    wire un1_r_bit_counter_1_cry_26;
    wire r_bit_counterZ0Z_28;
    wire un1_r_bit_counter_1_cry_27;
    wire r_bit_counterZ0Z_29;
    wire un1_r_bit_counter_1_cry_28;
    wire r_bit_counterZ0Z_30;
    wire un1_r_bit_counter_1_cry_29;
    wire un1_r_bit_counter_1_cry_30;
    wire r_bit_counterZ0Z_31;
    wire i_clk_c_g;
    wire N_209_g;
    wire r_bit_counterZ0Z_26;
    wire r_bit_counterZ0Z_25;
    wire r_bit_counterZ0Z_24;
    wire r_bit_counterZ0Z_27;
    wire fsm_proc_un22_r_clk_counter_6_and;
    wire _gnd_net_;

    PRE_IO_GBUF i_clk_ibuf_gb_io_preiogbuf (
            .PADSIGNALTOGLOBALBUFFER(N__4492),
            .GLOBALBUFFEROUTPUT(i_clk_c_g));
    IO_PAD i_clk_ibuf_gb_io_iopad (
            .OE(N__4494),
            .DIN(N__4493),
            .DOUT(N__4492),
            .PACKAGEPIN(i_clk));
    defparam i_clk_ibuf_gb_io_preio.NEG_TRIGGER=1'b0;
    defparam i_clk_ibuf_gb_io_preio.PIN_TYPE=6'b000001;
    PRE_IO i_clk_ibuf_gb_io_preio (
            .PADOEN(N__4494),
            .PADOUT(N__4493),
            .PADIN(N__4492),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_byte_obuf_7_iopad (
            .OE(N__4483),
            .DIN(N__4482),
            .DOUT(N__4481),
            .PACKAGEPIN(o_rx_byte[7]));
    defparam o_rx_byte_obuf_7_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_byte_obuf_7_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_byte_obuf_7_preio (
            .PADOEN(N__4483),
            .PADOUT(N__4482),
            .PADIN(N__4481),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2742),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_byte_obuf_0_iopad (
            .OE(N__4474),
            .DIN(N__4473),
            .DOUT(N__4472),
            .PACKAGEPIN(o_rx_byte[0]));
    defparam o_rx_byte_obuf_0_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_byte_obuf_0_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_byte_obuf_0_preio (
            .PADOEN(N__4474),
            .PADOUT(N__4473),
            .PADIN(N__4472),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2715),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_rst_ibuf_iopad (
            .OE(N__4465),
            .DIN(N__4464),
            .DOUT(N__4463),
            .PACKAGEPIN(i_rst));
    defparam i_rst_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_rst_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_rst_ibuf_preio (
            .PADOEN(N__4465),
            .PADOUT(N__4464),
            .PADIN(N__4463),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_rst_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_byte_obuf_5_iopad (
            .OE(N__4456),
            .DIN(N__4455),
            .DOUT(N__4454),
            .PACKAGEPIN(o_rx_byte[5]));
    defparam o_rx_byte_obuf_5_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_byte_obuf_5_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_byte_obuf_5_preio (
            .PADOEN(N__4456),
            .PADOUT(N__4455),
            .PADIN(N__4454),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2772),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_byte_obuf_6_iopad (
            .OE(N__4447),
            .DIN(N__4446),
            .DOUT(N__4445),
            .PACKAGEPIN(o_rx_byte[6]));
    defparam o_rx_byte_obuf_6_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_byte_obuf_6_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_byte_obuf_6_preio (
            .PADOEN(N__4447),
            .PADOUT(N__4446),
            .PADIN(N__4445),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__3063),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_valid_pulse_obuf_iopad (
            .OE(N__4438),
            .DIN(N__4437),
            .DOUT(N__4436),
            .PACKAGEPIN(o_rx_valid_pulse));
    defparam o_rx_valid_pulse_obuf_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_valid_pulse_obuf_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_valid_pulse_obuf_preio (
            .PADOEN(N__4438),
            .PADOUT(N__4437),
            .PADIN(N__4436),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2793),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_byte_obuf_3_iopad (
            .OE(N__4429),
            .DIN(N__4428),
            .DOUT(N__4427),
            .PACKAGEPIN(o_rx_byte[3]));
    defparam o_rx_byte_obuf_3_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_byte_obuf_3_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_byte_obuf_3_preio (
            .PADOEN(N__4429),
            .PADOUT(N__4428),
            .PADIN(N__4427),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2685),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_byte_obuf_4_iopad (
            .OE(N__4420),
            .DIN(N__4419),
            .DOUT(N__4418),
            .PACKAGEPIN(o_rx_byte[4]));
    defparam o_rx_byte_obuf_4_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_byte_obuf_4_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_byte_obuf_4_preio (
            .PADOEN(N__4420),
            .PADOUT(N__4419),
            .PADIN(N__4418),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2655),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD i_UART_RX_ibuf_iopad (
            .OE(N__4411),
            .DIN(N__4410),
            .DOUT(N__4409),
            .PACKAGEPIN(i_UART_RX));
    defparam i_UART_RX_ibuf_preio.NEG_TRIGGER=1'b0;
    defparam i_UART_RX_ibuf_preio.PIN_TYPE=6'b000001;
    PRE_IO i_UART_RX_ibuf_preio (
            .PADOEN(N__4411),
            .PADOUT(N__4410),
            .PADIN(N__4409),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(i_UART_RX_c),
            .DOUT0(),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_byte_obuf_1_iopad (
            .OE(N__4402),
            .DIN(N__4401),
            .DOUT(N__4400),
            .PACKAGEPIN(o_rx_byte[1]));
    defparam o_rx_byte_obuf_1_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_byte_obuf_1_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_byte_obuf_1_preio (
            .PADOEN(N__4402),
            .PADOUT(N__4401),
            .PADIN(N__4400),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2628),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_UART_RX_LED_obuf_iopad (
            .OE(N__4393),
            .DIN(N__4392),
            .DOUT(N__4391),
            .PACKAGEPIN(o_UART_RX_LED));
    defparam o_UART_RX_LED_obuf_preio.NEG_TRIGGER=1'b0;
    defparam o_UART_RX_LED_obuf_preio.PIN_TYPE=6'b011001;
    PRE_IO o_UART_RX_LED_obuf_preio (
            .PADOEN(N__4393),
            .PADOUT(N__4392),
            .PADIN(N__4391),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2838),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    IO_PAD o_rx_byte_obuf_2_iopad (
            .OE(N__4384),
            .DIN(N__4383),
            .DOUT(N__4382),
            .PACKAGEPIN(o_rx_byte[2]));
    defparam o_rx_byte_obuf_2_preio.NEG_TRIGGER=1'b0;
    defparam o_rx_byte_obuf_2_preio.PIN_TYPE=6'b011001;
    PRE_IO o_rx_byte_obuf_2_preio (
            .PADOEN(N__4384),
            .PADOUT(N__4383),
            .PADIN(N__4382),
            .CLOCKENABLE(),
            .DOUT1(),
            .OUTPUTENABLE(),
            .DIN0(),
            .DOUT0(N__2871),
            .INPUTCLK(),
            .LATCHINPUTVALUE(),
            .DIN1(),
            .OUTPUTCLK());
    InMux I__969 (
            .O(N__4365),
            .I(un1_r_bit_counter_1_cry_25));
    InMux I__968 (
            .O(N__4362),
            .I(un1_r_bit_counter_1_cry_26));
    CascadeMux I__967 (
            .O(N__4359),
            .I(N__4355));
    InMux I__966 (
            .O(N__4358),
            .I(N__4352));
    InMux I__965 (
            .O(N__4355),
            .I(N__4349));
    LocalMux I__964 (
            .O(N__4352),
            .I(r_bit_counterZ0Z_28));
    LocalMux I__963 (
            .O(N__4349),
            .I(r_bit_counterZ0Z_28));
    InMux I__962 (
            .O(N__4344),
            .I(un1_r_bit_counter_1_cry_27));
    InMux I__961 (
            .O(N__4341),
            .I(N__4337));
    InMux I__960 (
            .O(N__4340),
            .I(N__4334));
    LocalMux I__959 (
            .O(N__4337),
            .I(r_bit_counterZ0Z_29));
    LocalMux I__958 (
            .O(N__4334),
            .I(r_bit_counterZ0Z_29));
    InMux I__957 (
            .O(N__4329),
            .I(un1_r_bit_counter_1_cry_28));
    InMux I__956 (
            .O(N__4326),
            .I(N__4322));
    InMux I__955 (
            .O(N__4325),
            .I(N__4319));
    LocalMux I__954 (
            .O(N__4322),
            .I(r_bit_counterZ0Z_30));
    LocalMux I__953 (
            .O(N__4319),
            .I(r_bit_counterZ0Z_30));
    InMux I__952 (
            .O(N__4314),
            .I(un1_r_bit_counter_1_cry_29));
    InMux I__951 (
            .O(N__4311),
            .I(un1_r_bit_counter_1_cry_30));
    InMux I__950 (
            .O(N__4308),
            .I(N__4304));
    InMux I__949 (
            .O(N__4307),
            .I(N__4301));
    LocalMux I__948 (
            .O(N__4304),
            .I(r_bit_counterZ0Z_31));
    LocalMux I__947 (
            .O(N__4301),
            .I(r_bit_counterZ0Z_31));
    ClkMux I__946 (
            .O(N__4296),
            .I(N__4248));
    ClkMux I__945 (
            .O(N__4295),
            .I(N__4248));
    ClkMux I__944 (
            .O(N__4294),
            .I(N__4248));
    ClkMux I__943 (
            .O(N__4293),
            .I(N__4248));
    ClkMux I__942 (
            .O(N__4292),
            .I(N__4248));
    ClkMux I__941 (
            .O(N__4291),
            .I(N__4248));
    ClkMux I__940 (
            .O(N__4290),
            .I(N__4248));
    ClkMux I__939 (
            .O(N__4289),
            .I(N__4248));
    ClkMux I__938 (
            .O(N__4288),
            .I(N__4248));
    ClkMux I__937 (
            .O(N__4287),
            .I(N__4248));
    ClkMux I__936 (
            .O(N__4286),
            .I(N__4248));
    ClkMux I__935 (
            .O(N__4285),
            .I(N__4248));
    ClkMux I__934 (
            .O(N__4284),
            .I(N__4248));
    ClkMux I__933 (
            .O(N__4283),
            .I(N__4248));
    ClkMux I__932 (
            .O(N__4282),
            .I(N__4248));
    ClkMux I__931 (
            .O(N__4281),
            .I(N__4248));
    GlobalMux I__930 (
            .O(N__4248),
            .I(N__4245));
    gio2CtrlBuf I__929 (
            .O(N__4245),
            .I(i_clk_c_g));
    SRMux I__928 (
            .O(N__4242),
            .I(N__4230));
    SRMux I__927 (
            .O(N__4241),
            .I(N__4230));
    SRMux I__926 (
            .O(N__4240),
            .I(N__4230));
    SRMux I__925 (
            .O(N__4239),
            .I(N__4230));
    GlobalMux I__924 (
            .O(N__4230),
            .I(N__4227));
    gio2CtrlBuf I__923 (
            .O(N__4227),
            .I(N_209_g));
    InMux I__922 (
            .O(N__4224),
            .I(N__4220));
    InMux I__921 (
            .O(N__4223),
            .I(N__4217));
    LocalMux I__920 (
            .O(N__4220),
            .I(r_bit_counterZ0Z_26));
    LocalMux I__919 (
            .O(N__4217),
            .I(r_bit_counterZ0Z_26));
    InMux I__918 (
            .O(N__4212),
            .I(N__4208));
    InMux I__917 (
            .O(N__4211),
            .I(N__4205));
    LocalMux I__916 (
            .O(N__4208),
            .I(r_bit_counterZ0Z_25));
    LocalMux I__915 (
            .O(N__4205),
            .I(r_bit_counterZ0Z_25));
    CascadeMux I__914 (
            .O(N__4200),
            .I(N__4196));
    InMux I__913 (
            .O(N__4199),
            .I(N__4193));
    InMux I__912 (
            .O(N__4196),
            .I(N__4190));
    LocalMux I__911 (
            .O(N__4193),
            .I(r_bit_counterZ0Z_24));
    LocalMux I__910 (
            .O(N__4190),
            .I(r_bit_counterZ0Z_24));
    InMux I__909 (
            .O(N__4185),
            .I(N__4181));
    InMux I__908 (
            .O(N__4184),
            .I(N__4178));
    LocalMux I__907 (
            .O(N__4181),
            .I(r_bit_counterZ0Z_27));
    LocalMux I__906 (
            .O(N__4178),
            .I(r_bit_counterZ0Z_27));
    CascadeMux I__905 (
            .O(N__4173),
            .I(N__4170));
    InMux I__904 (
            .O(N__4170),
            .I(N__4167));
    LocalMux I__903 (
            .O(N__4167),
            .I(fsm_proc_un22_r_clk_counter_6_and));
    InMux I__902 (
            .O(N__4164),
            .I(N__4160));
    InMux I__901 (
            .O(N__4163),
            .I(N__4157));
    LocalMux I__900 (
            .O(N__4160),
            .I(r_bit_counterZ0Z_18));
    LocalMux I__899 (
            .O(N__4157),
            .I(r_bit_counterZ0Z_18));
    InMux I__898 (
            .O(N__4152),
            .I(un1_r_bit_counter_1_cry_17));
    InMux I__897 (
            .O(N__4149),
            .I(N__4145));
    InMux I__896 (
            .O(N__4148),
            .I(N__4142));
    LocalMux I__895 (
            .O(N__4145),
            .I(r_bit_counterZ0Z_19));
    LocalMux I__894 (
            .O(N__4142),
            .I(r_bit_counterZ0Z_19));
    InMux I__893 (
            .O(N__4137),
            .I(un1_r_bit_counter_1_cry_18));
    InMux I__892 (
            .O(N__4134),
            .I(N__4130));
    InMux I__891 (
            .O(N__4133),
            .I(N__4127));
    LocalMux I__890 (
            .O(N__4130),
            .I(r_bit_counterZ0Z_20));
    LocalMux I__889 (
            .O(N__4127),
            .I(r_bit_counterZ0Z_20));
    InMux I__888 (
            .O(N__4122),
            .I(un1_r_bit_counter_1_cry_19));
    InMux I__887 (
            .O(N__4119),
            .I(N__4115));
    InMux I__886 (
            .O(N__4118),
            .I(N__4112));
    LocalMux I__885 (
            .O(N__4115),
            .I(r_bit_counterZ0Z_21));
    LocalMux I__884 (
            .O(N__4112),
            .I(r_bit_counterZ0Z_21));
    InMux I__883 (
            .O(N__4107),
            .I(un1_r_bit_counter_1_cry_20));
    InMux I__882 (
            .O(N__4104),
            .I(N__4100));
    InMux I__881 (
            .O(N__4103),
            .I(N__4097));
    LocalMux I__880 (
            .O(N__4100),
            .I(r_bit_counterZ0Z_22));
    LocalMux I__879 (
            .O(N__4097),
            .I(r_bit_counterZ0Z_22));
    InMux I__878 (
            .O(N__4092),
            .I(un1_r_bit_counter_1_cry_21));
    CascadeMux I__877 (
            .O(N__4089),
            .I(N__4085));
    InMux I__876 (
            .O(N__4088),
            .I(N__4082));
    InMux I__875 (
            .O(N__4085),
            .I(N__4079));
    LocalMux I__874 (
            .O(N__4082),
            .I(r_bit_counterZ0Z_23));
    LocalMux I__873 (
            .O(N__4079),
            .I(r_bit_counterZ0Z_23));
    InMux I__872 (
            .O(N__4074),
            .I(un1_r_bit_counter_1_cry_22));
    InMux I__871 (
            .O(N__4071),
            .I(bfn_12_12_0_));
    InMux I__870 (
            .O(N__4068),
            .I(un1_r_bit_counter_1_cry_24));
    InMux I__869 (
            .O(N__4065),
            .I(N__4061));
    InMux I__868 (
            .O(N__4064),
            .I(N__4058));
    LocalMux I__867 (
            .O(N__4061),
            .I(r_bit_counterZ0Z_9));
    LocalMux I__866 (
            .O(N__4058),
            .I(r_bit_counterZ0Z_9));
    InMux I__865 (
            .O(N__4053),
            .I(un1_r_bit_counter_1_cry_8));
    InMux I__864 (
            .O(N__4050),
            .I(N__4046));
    InMux I__863 (
            .O(N__4049),
            .I(N__4043));
    LocalMux I__862 (
            .O(N__4046),
            .I(r_bit_counterZ0Z_10));
    LocalMux I__861 (
            .O(N__4043),
            .I(r_bit_counterZ0Z_10));
    InMux I__860 (
            .O(N__4038),
            .I(un1_r_bit_counter_1_cry_9));
    InMux I__859 (
            .O(N__4035),
            .I(N__4031));
    InMux I__858 (
            .O(N__4034),
            .I(N__4028));
    LocalMux I__857 (
            .O(N__4031),
            .I(r_bit_counterZ0Z_11));
    LocalMux I__856 (
            .O(N__4028),
            .I(r_bit_counterZ0Z_11));
    InMux I__855 (
            .O(N__4023),
            .I(un1_r_bit_counter_1_cry_10));
    InMux I__854 (
            .O(N__4020),
            .I(N__4016));
    InMux I__853 (
            .O(N__4019),
            .I(N__4013));
    LocalMux I__852 (
            .O(N__4016),
            .I(r_bit_counterZ0Z_12));
    LocalMux I__851 (
            .O(N__4013),
            .I(r_bit_counterZ0Z_12));
    InMux I__850 (
            .O(N__4008),
            .I(un1_r_bit_counter_1_cry_11));
    CascadeMux I__849 (
            .O(N__4005),
            .I(N__4001));
    InMux I__848 (
            .O(N__4004),
            .I(N__3998));
    InMux I__847 (
            .O(N__4001),
            .I(N__3995));
    LocalMux I__846 (
            .O(N__3998),
            .I(r_bit_counterZ0Z_13));
    LocalMux I__845 (
            .O(N__3995),
            .I(r_bit_counterZ0Z_13));
    InMux I__844 (
            .O(N__3990),
            .I(un1_r_bit_counter_1_cry_12));
    InMux I__843 (
            .O(N__3987),
            .I(N__3983));
    InMux I__842 (
            .O(N__3986),
            .I(N__3980));
    LocalMux I__841 (
            .O(N__3983),
            .I(r_bit_counterZ0Z_14));
    LocalMux I__840 (
            .O(N__3980),
            .I(r_bit_counterZ0Z_14));
    InMux I__839 (
            .O(N__3975),
            .I(un1_r_bit_counter_1_cry_13));
    InMux I__838 (
            .O(N__3972),
            .I(N__3968));
    InMux I__837 (
            .O(N__3971),
            .I(N__3965));
    LocalMux I__836 (
            .O(N__3968),
            .I(r_bit_counterZ0Z_15));
    LocalMux I__835 (
            .O(N__3965),
            .I(r_bit_counterZ0Z_15));
    InMux I__834 (
            .O(N__3960),
            .I(un1_r_bit_counter_1_cry_14));
    InMux I__833 (
            .O(N__3957),
            .I(N__3953));
    InMux I__832 (
            .O(N__3956),
            .I(N__3950));
    LocalMux I__831 (
            .O(N__3953),
            .I(r_bit_counterZ0Z_16));
    LocalMux I__830 (
            .O(N__3950),
            .I(r_bit_counterZ0Z_16));
    InMux I__829 (
            .O(N__3945),
            .I(bfn_12_11_0_));
    CascadeMux I__828 (
            .O(N__3942),
            .I(N__3938));
    InMux I__827 (
            .O(N__3941),
            .I(N__3935));
    InMux I__826 (
            .O(N__3938),
            .I(N__3932));
    LocalMux I__825 (
            .O(N__3935),
            .I(r_bit_counterZ0Z_17));
    LocalMux I__824 (
            .O(N__3932),
            .I(r_bit_counterZ0Z_17));
    InMux I__823 (
            .O(N__3927),
            .I(un1_r_bit_counter_1_cry_16));
    CascadeMux I__822 (
            .O(N__3924),
            .I(N__3919));
    CascadeMux I__821 (
            .O(N__3923),
            .I(N__3916));
    InMux I__820 (
            .O(N__3922),
            .I(N__3908));
    InMux I__819 (
            .O(N__3919),
            .I(N__3901));
    InMux I__818 (
            .O(N__3916),
            .I(N__3901));
    InMux I__817 (
            .O(N__3915),
            .I(N__3901));
    InMux I__816 (
            .O(N__3914),
            .I(N__3892));
    InMux I__815 (
            .O(N__3913),
            .I(N__3892));
    InMux I__814 (
            .O(N__3912),
            .I(N__3892));
    InMux I__813 (
            .O(N__3911),
            .I(N__3892));
    LocalMux I__812 (
            .O(N__3908),
            .I(N__3887));
    LocalMux I__811 (
            .O(N__3901),
            .I(N__3887));
    LocalMux I__810 (
            .O(N__3892),
            .I(N__3884));
    Span4Mux_h I__809 (
            .O(N__3887),
            .I(N__3879));
    Span4Mux_v I__808 (
            .O(N__3884),
            .I(N__3876));
    InMux I__807 (
            .O(N__3883),
            .I(N__3873));
    InMux I__806 (
            .O(N__3882),
            .I(N__3870));
    Odrv4 I__805 (
            .O(N__3879),
            .I(r_bit_counterZ0Z_1));
    Odrv4 I__804 (
            .O(N__3876),
            .I(r_bit_counterZ0Z_1));
    LocalMux I__803 (
            .O(N__3873),
            .I(r_bit_counterZ0Z_1));
    LocalMux I__802 (
            .O(N__3870),
            .I(r_bit_counterZ0Z_1));
    InMux I__801 (
            .O(N__3861),
            .I(un1_r_bit_counter_1_cry_0));
    InMux I__800 (
            .O(N__3858),
            .I(N__3846));
    InMux I__799 (
            .O(N__3857),
            .I(N__3846));
    InMux I__798 (
            .O(N__3856),
            .I(N__3841));
    InMux I__797 (
            .O(N__3855),
            .I(N__3841));
    InMux I__796 (
            .O(N__3854),
            .I(N__3832));
    InMux I__795 (
            .O(N__3853),
            .I(N__3832));
    InMux I__794 (
            .O(N__3852),
            .I(N__3832));
    InMux I__793 (
            .O(N__3851),
            .I(N__3832));
    LocalMux I__792 (
            .O(N__3846),
            .I(N__3825));
    LocalMux I__791 (
            .O(N__3841),
            .I(N__3825));
    LocalMux I__790 (
            .O(N__3832),
            .I(N__3825));
    Span4Mux_v I__789 (
            .O(N__3825),
            .I(N__3820));
    InMux I__788 (
            .O(N__3824),
            .I(N__3817));
    InMux I__787 (
            .O(N__3823),
            .I(N__3814));
    Odrv4 I__786 (
            .O(N__3820),
            .I(r_bit_counterZ0Z_2));
    LocalMux I__785 (
            .O(N__3817),
            .I(r_bit_counterZ0Z_2));
    LocalMux I__784 (
            .O(N__3814),
            .I(r_bit_counterZ0Z_2));
    InMux I__783 (
            .O(N__3807),
            .I(un1_r_bit_counter_1_cry_1));
    InMux I__782 (
            .O(N__3804),
            .I(N__3800));
    InMux I__781 (
            .O(N__3803),
            .I(N__3797));
    LocalMux I__780 (
            .O(N__3800),
            .I(r_bit_counterZ0Z_3));
    LocalMux I__779 (
            .O(N__3797),
            .I(r_bit_counterZ0Z_3));
    InMux I__778 (
            .O(N__3792),
            .I(un1_r_bit_counter_1_cry_2));
    InMux I__777 (
            .O(N__3789),
            .I(N__3785));
    InMux I__776 (
            .O(N__3788),
            .I(N__3782));
    LocalMux I__775 (
            .O(N__3785),
            .I(r_bit_counterZ0Z_4));
    LocalMux I__774 (
            .O(N__3782),
            .I(r_bit_counterZ0Z_4));
    InMux I__773 (
            .O(N__3777),
            .I(un1_r_bit_counter_1_cry_3));
    InMux I__772 (
            .O(N__3774),
            .I(N__3770));
    InMux I__771 (
            .O(N__3773),
            .I(N__3767));
    LocalMux I__770 (
            .O(N__3770),
            .I(r_bit_counterZ0Z_5));
    LocalMux I__769 (
            .O(N__3767),
            .I(r_bit_counterZ0Z_5));
    InMux I__768 (
            .O(N__3762),
            .I(un1_r_bit_counter_1_cry_4));
    CascadeMux I__767 (
            .O(N__3759),
            .I(N__3755));
    InMux I__766 (
            .O(N__3758),
            .I(N__3752));
    InMux I__765 (
            .O(N__3755),
            .I(N__3749));
    LocalMux I__764 (
            .O(N__3752),
            .I(r_bit_counterZ0Z_6));
    LocalMux I__763 (
            .O(N__3749),
            .I(r_bit_counterZ0Z_6));
    InMux I__762 (
            .O(N__3744),
            .I(un1_r_bit_counter_1_cry_5));
    InMux I__761 (
            .O(N__3741),
            .I(N__3737));
    InMux I__760 (
            .O(N__3740),
            .I(N__3734));
    LocalMux I__759 (
            .O(N__3737),
            .I(r_bit_counterZ0Z_7));
    LocalMux I__758 (
            .O(N__3734),
            .I(r_bit_counterZ0Z_7));
    InMux I__757 (
            .O(N__3729),
            .I(un1_r_bit_counter_1_cry_6));
    CascadeMux I__756 (
            .O(N__3726),
            .I(N__3722));
    InMux I__755 (
            .O(N__3725),
            .I(N__3719));
    InMux I__754 (
            .O(N__3722),
            .I(N__3716));
    LocalMux I__753 (
            .O(N__3719),
            .I(r_bit_counterZ0Z_8));
    LocalMux I__752 (
            .O(N__3716),
            .I(r_bit_counterZ0Z_8));
    InMux I__751 (
            .O(N__3711),
            .I(bfn_12_10_0_));
    CascadeMux I__750 (
            .O(N__3708),
            .I(N__3705));
    InMux I__749 (
            .O(N__3705),
            .I(N__3702));
    LocalMux I__748 (
            .O(N__3702),
            .I(fsm_proc_un22_r_clk_counter_5_and));
    InMux I__747 (
            .O(N__3699),
            .I(bfn_11_13_0_));
    CascadeMux I__746 (
            .O(N__3696),
            .I(N__3693));
    InMux I__745 (
            .O(N__3693),
            .I(N__3690));
    LocalMux I__744 (
            .O(N__3690),
            .I(fsm_proc_un22_r_clk_counter_7_and));
    InMux I__743 (
            .O(N__3687),
            .I(N__3683));
    InMux I__742 (
            .O(N__3686),
            .I(N__3680));
    LocalMux I__741 (
            .O(N__3683),
            .I(N__3668));
    LocalMux I__740 (
            .O(N__3680),
            .I(N__3668));
    InMux I__739 (
            .O(N__3679),
            .I(N__3665));
    InMux I__738 (
            .O(N__3678),
            .I(N__3662));
    InMux I__737 (
            .O(N__3677),
            .I(N__3655));
    InMux I__736 (
            .O(N__3676),
            .I(N__3655));
    InMux I__735 (
            .O(N__3675),
            .I(N__3655));
    InMux I__734 (
            .O(N__3674),
            .I(N__3650));
    InMux I__733 (
            .O(N__3673),
            .I(N__3650));
    Span4Mux_s3_h I__732 (
            .O(N__3668),
            .I(N__3645));
    LocalMux I__731 (
            .O(N__3665),
            .I(N__3645));
    LocalMux I__730 (
            .O(N__3662),
            .I(fsm_proc_un10_r_clk_counter_THRU_CO));
    LocalMux I__729 (
            .O(N__3655),
            .I(fsm_proc_un10_r_clk_counter_THRU_CO));
    LocalMux I__728 (
            .O(N__3650),
            .I(fsm_proc_un10_r_clk_counter_THRU_CO));
    Odrv4 I__727 (
            .O(N__3645),
            .I(fsm_proc_un10_r_clk_counter_THRU_CO));
    InMux I__726 (
            .O(N__3636),
            .I(N__3631));
    CascadeMux I__725 (
            .O(N__3635),
            .I(N__3627));
    InMux I__724 (
            .O(N__3634),
            .I(N__3622));
    LocalMux I__723 (
            .O(N__3631),
            .I(N__3619));
    InMux I__722 (
            .O(N__3630),
            .I(N__3616));
    InMux I__721 (
            .O(N__3627),
            .I(N__3603));
    InMux I__720 (
            .O(N__3626),
            .I(N__3603));
    InMux I__719 (
            .O(N__3625),
            .I(N__3603));
    LocalMux I__718 (
            .O(N__3622),
            .I(N__3600));
    Span4Mux_s2_h I__717 (
            .O(N__3619),
            .I(N__3597));
    LocalMux I__716 (
            .O(N__3616),
            .I(N__3594));
    InMux I__715 (
            .O(N__3615),
            .I(N__3591));
    InMux I__714 (
            .O(N__3614),
            .I(N__3580));
    InMux I__713 (
            .O(N__3613),
            .I(N__3580));
    InMux I__712 (
            .O(N__3612),
            .I(N__3580));
    InMux I__711 (
            .O(N__3611),
            .I(N__3580));
    InMux I__710 (
            .O(N__3610),
            .I(N__3580));
    LocalMux I__709 (
            .O(N__3603),
            .I(r_stateZ0Z_1));
    Odrv12 I__708 (
            .O(N__3600),
            .I(r_stateZ0Z_1));
    Odrv4 I__707 (
            .O(N__3597),
            .I(r_stateZ0Z_1));
    Odrv4 I__706 (
            .O(N__3594),
            .I(r_stateZ0Z_1));
    LocalMux I__705 (
            .O(N__3591),
            .I(r_stateZ0Z_1));
    LocalMux I__704 (
            .O(N__3580),
            .I(r_stateZ0Z_1));
    InMux I__703 (
            .O(N__3567),
            .I(N__3563));
    InMux I__702 (
            .O(N__3566),
            .I(N__3560));
    LocalMux I__701 (
            .O(N__3563),
            .I(N__3557));
    LocalMux I__700 (
            .O(N__3560),
            .I(N__3554));
    Span4Mux_h I__699 (
            .O(N__3557),
            .I(N__3551));
    Span4Mux_v I__698 (
            .O(N__3554),
            .I(N__3548));
    Odrv4 I__697 (
            .O(N__3551),
            .I(fsm_proc_un22_r_clk_counter_THRU_CO));
    Odrv4 I__696 (
            .O(N__3548),
            .I(fsm_proc_un22_r_clk_counter_THRU_CO));
    IoInMux I__695 (
            .O(N__3543),
            .I(N__3539));
    InMux I__694 (
            .O(N__3542),
            .I(N__3536));
    LocalMux I__693 (
            .O(N__3539),
            .I(N__3529));
    LocalMux I__692 (
            .O(N__3536),
            .I(N__3526));
    SRMux I__691 (
            .O(N__3535),
            .I(N__3523));
    InMux I__690 (
            .O(N__3534),
            .I(N__3518));
    InMux I__689 (
            .O(N__3533),
            .I(N__3518));
    CascadeMux I__688 (
            .O(N__3532),
            .I(N__3515));
    Span4Mux_s3_h I__687 (
            .O(N__3529),
            .I(N__3510));
    Span4Mux_s0_h I__686 (
            .O(N__3526),
            .I(N__3505));
    LocalMux I__685 (
            .O(N__3523),
            .I(N__3505));
    LocalMux I__684 (
            .O(N__3518),
            .I(N__3500));
    InMux I__683 (
            .O(N__3515),
            .I(N__3497));
    SRMux I__682 (
            .O(N__3514),
            .I(N__3494));
    SRMux I__681 (
            .O(N__3513),
            .I(N__3491));
    Span4Mux_h I__680 (
            .O(N__3510),
            .I(N__3486));
    Span4Mux_h I__679 (
            .O(N__3505),
            .I(N__3486));
    SRMux I__678 (
            .O(N__3504),
            .I(N__3483));
    SRMux I__677 (
            .O(N__3503),
            .I(N__3480));
    Span4Mux_v I__676 (
            .O(N__3500),
            .I(N__3477));
    LocalMux I__675 (
            .O(N__3497),
            .I(N__3474));
    LocalMux I__674 (
            .O(N__3494),
            .I(N__3471));
    LocalMux I__673 (
            .O(N__3491),
            .I(N__3468));
    Span4Mux_v I__672 (
            .O(N__3486),
            .I(N__3461));
    LocalMux I__671 (
            .O(N__3483),
            .I(N__3461));
    LocalMux I__670 (
            .O(N__3480),
            .I(N__3461));
    IoSpan4Mux I__669 (
            .O(N__3477),
            .I(N__3458));
    Span4Mux_v I__668 (
            .O(N__3474),
            .I(N__3453));
    Span4Mux_h I__667 (
            .O(N__3471),
            .I(N__3453));
    Span4Mux_v I__666 (
            .O(N__3468),
            .I(N__3450));
    Span4Mux_v I__665 (
            .O(N__3461),
            .I(N__3447));
    Odrv4 I__664 (
            .O(N__3458),
            .I(i_rst_c));
    Odrv4 I__663 (
            .O(N__3453),
            .I(i_rst_c));
    Odrv4 I__662 (
            .O(N__3450),
            .I(i_rst_c));
    Odrv4 I__661 (
            .O(N__3447),
            .I(i_rst_c));
    InMux I__660 (
            .O(N__3438),
            .I(N__3434));
    InMux I__659 (
            .O(N__3437),
            .I(N__3429));
    LocalMux I__658 (
            .O(N__3434),
            .I(N__3423));
    InMux I__657 (
            .O(N__3433),
            .I(N__3420));
    InMux I__656 (
            .O(N__3432),
            .I(N__3417));
    LocalMux I__655 (
            .O(N__3429),
            .I(N__3414));
    InMux I__654 (
            .O(N__3428),
            .I(N__3407));
    InMux I__653 (
            .O(N__3427),
            .I(N__3402));
    InMux I__652 (
            .O(N__3426),
            .I(N__3402));
    Span4Mux_h I__651 (
            .O(N__3423),
            .I(N__3397));
    LocalMux I__650 (
            .O(N__3420),
            .I(N__3397));
    LocalMux I__649 (
            .O(N__3417),
            .I(N__3392));
    Span4Mux_s2_h I__648 (
            .O(N__3414),
            .I(N__3392));
    InMux I__647 (
            .O(N__3413),
            .I(N__3389));
    InMux I__646 (
            .O(N__3412),
            .I(N__3382));
    InMux I__645 (
            .O(N__3411),
            .I(N__3382));
    InMux I__644 (
            .O(N__3410),
            .I(N__3382));
    LocalMux I__643 (
            .O(N__3407),
            .I(r_stateZ0Z_0));
    LocalMux I__642 (
            .O(N__3402),
            .I(r_stateZ0Z_0));
    Odrv4 I__641 (
            .O(N__3397),
            .I(r_stateZ0Z_0));
    Odrv4 I__640 (
            .O(N__3392),
            .I(r_stateZ0Z_0));
    LocalMux I__639 (
            .O(N__3389),
            .I(r_stateZ0Z_0));
    LocalMux I__638 (
            .O(N__3382),
            .I(r_stateZ0Z_0));
    CascadeMux I__637 (
            .O(N__3369),
            .I(N_27_cascade_));
    InMux I__636 (
            .O(N__3366),
            .I(N__3362));
    InMux I__635 (
            .O(N__3365),
            .I(N__3359));
    LocalMux I__634 (
            .O(N__3362),
            .I(N__3356));
    LocalMux I__633 (
            .O(N__3359),
            .I(N__3351));
    Span4Mux_s3_h I__632 (
            .O(N__3356),
            .I(N__3351));
    Odrv4 I__631 (
            .O(N__3351),
            .I(N_23));
    IoInMux I__630 (
            .O(N__3348),
            .I(N__3345));
    LocalMux I__629 (
            .O(N__3345),
            .I(r_state_RNI6KS51Z0Z_0));
    CascadeMux I__628 (
            .O(N__3342),
            .I(N__3338));
    InMux I__627 (
            .O(N__3341),
            .I(N__3335));
    InMux I__626 (
            .O(N__3338),
            .I(N__3332));
    LocalMux I__625 (
            .O(N__3335),
            .I(N__3327));
    LocalMux I__624 (
            .O(N__3332),
            .I(N__3327));
    Span4Mux_v I__623 (
            .O(N__3327),
            .I(N__3324));
    Odrv4 I__622 (
            .O(N__3324),
            .I(n_state_2_sqmuxa));
    InMux I__621 (
            .O(N__3321),
            .I(N__3305));
    InMux I__620 (
            .O(N__3320),
            .I(N__3305));
    InMux I__619 (
            .O(N__3319),
            .I(N__3305));
    InMux I__618 (
            .O(N__3318),
            .I(N__3305));
    InMux I__617 (
            .O(N__3317),
            .I(N__3296));
    InMux I__616 (
            .O(N__3316),
            .I(N__3296));
    InMux I__615 (
            .O(N__3315),
            .I(N__3296));
    InMux I__614 (
            .O(N__3314),
            .I(N__3296));
    LocalMux I__613 (
            .O(N__3305),
            .I(N__3292));
    LocalMux I__612 (
            .O(N__3296),
            .I(N__3289));
    CascadeMux I__611 (
            .O(N__3295),
            .I(N__3285));
    Span4Mux_v I__610 (
            .O(N__3292),
            .I(N__3282));
    Span4Mux_h I__609 (
            .O(N__3289),
            .I(N__3279));
    InMux I__608 (
            .O(N__3288),
            .I(N__3276));
    InMux I__607 (
            .O(N__3285),
            .I(N__3273));
    Odrv4 I__606 (
            .O(N__3282),
            .I(r_bit_counterZ0Z_0));
    Odrv4 I__605 (
            .O(N__3279),
            .I(r_bit_counterZ0Z_0));
    LocalMux I__604 (
            .O(N__3276),
            .I(r_bit_counterZ0Z_0));
    LocalMux I__603 (
            .O(N__3273),
            .I(r_bit_counterZ0Z_0));
    CascadeMux I__602 (
            .O(N__3264),
            .I(N__3261));
    InMux I__601 (
            .O(N__3261),
            .I(N__3258));
    LocalMux I__600 (
            .O(N__3258),
            .I(N__3255));
    Odrv4 I__599 (
            .O(N__3255),
            .I(fsm_proc_un22_r_clk_counter_0_and));
    CascadeMux I__598 (
            .O(N__3252),
            .I(N__3249));
    InMux I__597 (
            .O(N__3249),
            .I(N__3246));
    LocalMux I__596 (
            .O(N__3246),
            .I(N__3243));
    Odrv4 I__595 (
            .O(N__3243),
            .I(fsm_proc_un22_r_clk_counter_1_and));
    CascadeMux I__594 (
            .O(N__3240),
            .I(N__3237));
    InMux I__593 (
            .O(N__3237),
            .I(N__3234));
    LocalMux I__592 (
            .O(N__3234),
            .I(fsm_proc_un22_r_clk_counter_2_and));
    CascadeMux I__591 (
            .O(N__3231),
            .I(N__3228));
    InMux I__590 (
            .O(N__3228),
            .I(N__3225));
    LocalMux I__589 (
            .O(N__3225),
            .I(fsm_proc_un22_r_clk_counter_3_and));
    CascadeMux I__588 (
            .O(N__3222),
            .I(N__3219));
    InMux I__587 (
            .O(N__3219),
            .I(N__3216));
    LocalMux I__586 (
            .O(N__3216),
            .I(fsm_proc_un22_r_clk_counter_4_and));
    InMux I__585 (
            .O(N__3213),
            .I(bfn_9_12_0_));
    CascadeMux I__584 (
            .O(N__3210),
            .I(fsm_proc_un6_r_clk_counter_THRU_CO_cascade_));
    InMux I__583 (
            .O(N__3207),
            .I(N__3204));
    LocalMux I__582 (
            .O(N__3204),
            .I(N__3201));
    Odrv4 I__581 (
            .O(N__3201),
            .I(r_rx_bytece_0_2));
    InMux I__580 (
            .O(N__3198),
            .I(N__3195));
    LocalMux I__579 (
            .O(N__3195),
            .I(r_rx_bytece_0_1));
    InMux I__578 (
            .O(N__3192),
            .I(N__3189));
    LocalMux I__577 (
            .O(N__3189),
            .I(r_rx_bytece_0_0));
    InMux I__576 (
            .O(N__3186),
            .I(N__3182));
    InMux I__575 (
            .O(N__3185),
            .I(N__3179));
    LocalMux I__574 (
            .O(N__3182),
            .I(N__3176));
    LocalMux I__573 (
            .O(N__3179),
            .I(fsm_proc_un6_r_clk_counter_THRU_CO));
    Odrv4 I__572 (
            .O(N__3176),
            .I(fsm_proc_un6_r_clk_counter_THRU_CO));
    CascadeMux I__571 (
            .O(N__3171),
            .I(N__3167));
    CascadeMux I__570 (
            .O(N__3170),
            .I(N__3164));
    InMux I__569 (
            .O(N__3167),
            .I(N__3157));
    InMux I__568 (
            .O(N__3164),
            .I(N__3157));
    InMux I__567 (
            .O(N__3163),
            .I(N__3154));
    CascadeMux I__566 (
            .O(N__3162),
            .I(N__3145));
    LocalMux I__565 (
            .O(N__3157),
            .I(N__3141));
    LocalMux I__564 (
            .O(N__3154),
            .I(N__3138));
    InMux I__563 (
            .O(N__3153),
            .I(N__3130));
    InMux I__562 (
            .O(N__3152),
            .I(N__3130));
    InMux I__561 (
            .O(N__3151),
            .I(N__3130));
    InMux I__560 (
            .O(N__3150),
            .I(N__3121));
    InMux I__559 (
            .O(N__3149),
            .I(N__3121));
    InMux I__558 (
            .O(N__3148),
            .I(N__3121));
    InMux I__557 (
            .O(N__3145),
            .I(N__3121));
    InMux I__556 (
            .O(N__3144),
            .I(N__3118));
    Span4Mux_s3_h I__555 (
            .O(N__3141),
            .I(N__3113));
    Span4Mux_s3_h I__554 (
            .O(N__3138),
            .I(N__3113));
    InMux I__553 (
            .O(N__3137),
            .I(N__3110));
    LocalMux I__552 (
            .O(N__3130),
            .I(r_rx_syncZ0Z_2));
    LocalMux I__551 (
            .O(N__3121),
            .I(r_rx_syncZ0Z_2));
    LocalMux I__550 (
            .O(N__3118),
            .I(r_rx_syncZ0Z_2));
    Odrv4 I__549 (
            .O(N__3113),
            .I(r_rx_syncZ0Z_2));
    LocalMux I__548 (
            .O(N__3110),
            .I(r_rx_syncZ0Z_2));
    InMux I__547 (
            .O(N__3099),
            .I(N__3096));
    LocalMux I__546 (
            .O(N__3096),
            .I(N_60));
    InMux I__545 (
            .O(N__3093),
            .I(N__3083));
    InMux I__544 (
            .O(N__3092),
            .I(N__3068));
    InMux I__543 (
            .O(N__3091),
            .I(N__3068));
    InMux I__542 (
            .O(N__3090),
            .I(N__3068));
    InMux I__541 (
            .O(N__3089),
            .I(N__3068));
    InMux I__540 (
            .O(N__3088),
            .I(N__3068));
    InMux I__539 (
            .O(N__3087),
            .I(N__3068));
    InMux I__538 (
            .O(N__3086),
            .I(N__3068));
    LocalMux I__537 (
            .O(N__3083),
            .I(n_rx_byte_0_sqmuxa));
    LocalMux I__536 (
            .O(N__3068),
            .I(n_rx_byte_0_sqmuxa));
    IoInMux I__535 (
            .O(N__3063),
            .I(N__3060));
    LocalMux I__534 (
            .O(N__3060),
            .I(N__3057));
    IoSpan4Mux I__533 (
            .O(N__3057),
            .I(N__3054));
    Span4Mux_s3_h I__532 (
            .O(N__3054),
            .I(N__3050));
    CascadeMux I__531 (
            .O(N__3053),
            .I(N__3047));
    Span4Mux_h I__530 (
            .O(N__3050),
            .I(N__3044));
    InMux I__529 (
            .O(N__3047),
            .I(N__3041));
    Odrv4 I__528 (
            .O(N__3044),
            .I(o_rx_byte_c_6));
    LocalMux I__527 (
            .O(N__3041),
            .I(o_rx_byte_c_6));
    CascadeMux I__526 (
            .O(N__3036),
            .I(N__3033));
    InMux I__525 (
            .O(N__3033),
            .I(N__3030));
    LocalMux I__524 (
            .O(N__3030),
            .I(fsm_proc_un6_r_clk_counter_0_and));
    CascadeMux I__523 (
            .O(N__3027),
            .I(N__3024));
    InMux I__522 (
            .O(N__3024),
            .I(N__3021));
    LocalMux I__521 (
            .O(N__3021),
            .I(fsm_proc_un6_r_clk_counter_1_and));
    CascadeMux I__520 (
            .O(N__3018),
            .I(N__3014));
    CascadeMux I__519 (
            .O(N__3017),
            .I(N__3011));
    InMux I__518 (
            .O(N__3014),
            .I(N__3008));
    InMux I__517 (
            .O(N__3011),
            .I(N__3005));
    LocalMux I__516 (
            .O(N__3008),
            .I(fsm_proc_un6_r_clk_counter_2_and));
    LocalMux I__515 (
            .O(N__3005),
            .I(fsm_proc_un6_r_clk_counter_2_and));
    CascadeMux I__514 (
            .O(N__3000),
            .I(N__2996));
    CascadeMux I__513 (
            .O(N__2999),
            .I(N__2993));
    InMux I__512 (
            .O(N__2996),
            .I(N__2990));
    InMux I__511 (
            .O(N__2993),
            .I(N__2987));
    LocalMux I__510 (
            .O(N__2990),
            .I(fsm_proc_un6_r_clk_counter_3_and));
    LocalMux I__509 (
            .O(N__2987),
            .I(fsm_proc_un6_r_clk_counter_3_and));
    CascadeMux I__508 (
            .O(N__2982),
            .I(N__2978));
    CascadeMux I__507 (
            .O(N__2981),
            .I(N__2975));
    InMux I__506 (
            .O(N__2978),
            .I(N__2972));
    InMux I__505 (
            .O(N__2975),
            .I(N__2969));
    LocalMux I__504 (
            .O(N__2972),
            .I(fsm_proc_un6_r_clk_counter_4_and));
    LocalMux I__503 (
            .O(N__2969),
            .I(fsm_proc_un6_r_clk_counter_4_and));
    CascadeMux I__502 (
            .O(N__2964),
            .I(N__2961));
    InMux I__501 (
            .O(N__2961),
            .I(N__2957));
    CascadeMux I__500 (
            .O(N__2960),
            .I(N__2954));
    LocalMux I__499 (
            .O(N__2957),
            .I(N__2951));
    InMux I__498 (
            .O(N__2954),
            .I(N__2948));
    Odrv4 I__497 (
            .O(N__2951),
            .I(fsm_proc_un6_r_clk_counter_5_and));
    LocalMux I__496 (
            .O(N__2948),
            .I(fsm_proc_un6_r_clk_counter_5_and));
    CascadeMux I__495 (
            .O(N__2943),
            .I(N__2940));
    InMux I__494 (
            .O(N__2940),
            .I(N__2936));
    CascadeMux I__493 (
            .O(N__2939),
            .I(N__2933));
    LocalMux I__492 (
            .O(N__2936),
            .I(N__2930));
    InMux I__491 (
            .O(N__2933),
            .I(N__2927));
    Odrv4 I__490 (
            .O(N__2930),
            .I(fsm_proc_un6_r_clk_counter_6_and));
    LocalMux I__489 (
            .O(N__2927),
            .I(fsm_proc_un6_r_clk_counter_6_and));
    CascadeMux I__488 (
            .O(N__2922),
            .I(N__2919));
    InMux I__487 (
            .O(N__2919),
            .I(N__2915));
    CascadeMux I__486 (
            .O(N__2918),
            .I(N__2912));
    LocalMux I__485 (
            .O(N__2915),
            .I(N__2909));
    InMux I__484 (
            .O(N__2912),
            .I(N__2906));
    Odrv4 I__483 (
            .O(N__2909),
            .I(fsm_proc_un6_r_clk_counter_7_and));
    LocalMux I__482 (
            .O(N__2906),
            .I(fsm_proc_un6_r_clk_counter_7_and));
    InMux I__481 (
            .O(N__2901),
            .I(bfn_9_10_0_));
    CascadeMux I__480 (
            .O(N__2898),
            .I(fsm_proc_un10_r_clk_counter_THRU_CO_cascade_));
    InMux I__479 (
            .O(N__2895),
            .I(N__2891));
    InMux I__478 (
            .O(N__2894),
            .I(N__2888));
    LocalMux I__477 (
            .O(N__2891),
            .I(N__2885));
    LocalMux I__476 (
            .O(N__2888),
            .I(N__2882));
    Odrv4 I__475 (
            .O(N__2885),
            .I(N_17_0));
    Odrv4 I__474 (
            .O(N__2882),
            .I(N_17_0));
    CascadeMux I__473 (
            .O(N__2877),
            .I(N_18_0_cascade_));
    CascadeMux I__472 (
            .O(N__2874),
            .I(N_21_cascade_));
    IoInMux I__471 (
            .O(N__2871),
            .I(N__2868));
    LocalMux I__470 (
            .O(N__2868),
            .I(N__2865));
    Span4Mux_s3_h I__469 (
            .O(N__2865),
            .I(N__2862));
    Span4Mux_v I__468 (
            .O(N__2862),
            .I(N__2858));
    CascadeMux I__467 (
            .O(N__2861),
            .I(N__2855));
    Span4Mux_h I__466 (
            .O(N__2858),
            .I(N__2852));
    InMux I__465 (
            .O(N__2855),
            .I(N__2849));
    Odrv4 I__464 (
            .O(N__2852),
            .I(o_rx_byte_c_2));
    LocalMux I__463 (
            .O(N__2849),
            .I(o_rx_byte_c_2));
    InMux I__462 (
            .O(N__2844),
            .I(N__2841));
    LocalMux I__461 (
            .O(N__2841),
            .I(r_rx_syncZ0Z_1));
    IoInMux I__460 (
            .O(N__2838),
            .I(N__2835));
    LocalMux I__459 (
            .O(N__2835),
            .I(N__2832));
    Span4Mux_s3_h I__458 (
            .O(N__2832),
            .I(N__2829));
    Span4Mux_h I__457 (
            .O(N__2829),
            .I(N__2825));
    CascadeMux I__456 (
            .O(N__2828),
            .I(N__2822));
    Span4Mux_v I__455 (
            .O(N__2825),
            .I(N__2819));
    InMux I__454 (
            .O(N__2822),
            .I(N__2816));
    Odrv4 I__453 (
            .O(N__2819),
            .I(o_UART_RX_LED_c));
    LocalMux I__452 (
            .O(N__2816),
            .I(o_UART_RX_LED_c));
    CascadeMux I__451 (
            .O(N__2811),
            .I(N__2808));
    InMux I__450 (
            .O(N__2808),
            .I(N__2805));
    LocalMux I__449 (
            .O(N__2805),
            .I(fsm_proc_un10_r_clk_counter_0_and));
    CascadeMux I__448 (
            .O(N__2802),
            .I(N__2799));
    InMux I__447 (
            .O(N__2799),
            .I(N__2796));
    LocalMux I__446 (
            .O(N__2796),
            .I(fsm_proc_un10_r_clk_counter_1_and));
    IoInMux I__445 (
            .O(N__2793),
            .I(N__2790));
    LocalMux I__444 (
            .O(N__2790),
            .I(N__2787));
    Span4Mux_s2_v I__443 (
            .O(N__2787),
            .I(N__2784));
    Span4Mux_h I__442 (
            .O(N__2784),
            .I(N__2781));
    Odrv4 I__441 (
            .O(N__2781),
            .I(o_rx_valid_pulse_c));
    InMux I__440 (
            .O(N__2778),
            .I(N__2775));
    LocalMux I__439 (
            .O(N__2775),
            .I(N_61));
    IoInMux I__438 (
            .O(N__2772),
            .I(N__2769));
    LocalMux I__437 (
            .O(N__2769),
            .I(N__2765));
    CascadeMux I__436 (
            .O(N__2768),
            .I(N__2762));
    Span12Mux_s7_h I__435 (
            .O(N__2765),
            .I(N__2759));
    InMux I__434 (
            .O(N__2762),
            .I(N__2756));
    Odrv12 I__433 (
            .O(N__2759),
            .I(o_rx_byte_c_5));
    LocalMux I__432 (
            .O(N__2756),
            .I(o_rx_byte_c_5));
    InMux I__431 (
            .O(N__2751),
            .I(N__2748));
    LocalMux I__430 (
            .O(N__2748),
            .I(N__2745));
    Odrv4 I__429 (
            .O(N__2745),
            .I(N_59));
    IoInMux I__428 (
            .O(N__2742),
            .I(N__2739));
    LocalMux I__427 (
            .O(N__2739),
            .I(N__2736));
    IoSpan4Mux I__426 (
            .O(N__2736),
            .I(N__2733));
    IoSpan4Mux I__425 (
            .O(N__2733),
            .I(N__2729));
    CascadeMux I__424 (
            .O(N__2732),
            .I(N__2726));
    Span4Mux_s1_v I__423 (
            .O(N__2729),
            .I(N__2723));
    InMux I__422 (
            .O(N__2726),
            .I(N__2720));
    Odrv4 I__421 (
            .O(N__2723),
            .I(o_rx_byte_c_7));
    LocalMux I__420 (
            .O(N__2720),
            .I(o_rx_byte_c_7));
    IoInMux I__419 (
            .O(N__2715),
            .I(N__2712));
    LocalMux I__418 (
            .O(N__2712),
            .I(N__2709));
    Span4Mux_s3_h I__417 (
            .O(N__2709),
            .I(N__2706));
    Span4Mux_h I__416 (
            .O(N__2706),
            .I(N__2703));
    Sp12to4 I__415 (
            .O(N__2703),
            .I(N__2699));
    InMux I__414 (
            .O(N__2702),
            .I(N__2696));
    Odrv12 I__413 (
            .O(N__2699),
            .I(o_rx_byte_c_0));
    LocalMux I__412 (
            .O(N__2696),
            .I(o_rx_byte_c_0));
    InMux I__411 (
            .O(N__2691),
            .I(N__2688));
    LocalMux I__410 (
            .O(N__2688),
            .I(N_63));
    IoInMux I__409 (
            .O(N__2685),
            .I(N__2682));
    LocalMux I__408 (
            .O(N__2682),
            .I(N__2679));
    Span4Mux_s3_h I__407 (
            .O(N__2679),
            .I(N__2675));
    CascadeMux I__406 (
            .O(N__2678),
            .I(N__2672));
    Span4Mux_h I__405 (
            .O(N__2675),
            .I(N__2669));
    InMux I__404 (
            .O(N__2672),
            .I(N__2666));
    Odrv4 I__403 (
            .O(N__2669),
            .I(o_rx_byte_c_3));
    LocalMux I__402 (
            .O(N__2666),
            .I(o_rx_byte_c_3));
    InMux I__401 (
            .O(N__2661),
            .I(N__2658));
    LocalMux I__400 (
            .O(N__2658),
            .I(N_62));
    IoInMux I__399 (
            .O(N__2655),
            .I(N__2652));
    LocalMux I__398 (
            .O(N__2652),
            .I(N__2649));
    IoSpan4Mux I__397 (
            .O(N__2649),
            .I(N__2646));
    Span4Mux_s3_h I__396 (
            .O(N__2646),
            .I(N__2642));
    CascadeMux I__395 (
            .O(N__2645),
            .I(N__2639));
    Span4Mux_h I__394 (
            .O(N__2642),
            .I(N__2636));
    InMux I__393 (
            .O(N__2639),
            .I(N__2633));
    Odrv4 I__392 (
            .O(N__2636),
            .I(o_rx_byte_c_4));
    LocalMux I__391 (
            .O(N__2633),
            .I(o_rx_byte_c_4));
    IoInMux I__390 (
            .O(N__2628),
            .I(N__2625));
    LocalMux I__389 (
            .O(N__2625),
            .I(N__2622));
    Span4Mux_s3_h I__388 (
            .O(N__2622),
            .I(N__2619));
    Span4Mux_h I__387 (
            .O(N__2619),
            .I(N__2615));
    CascadeMux I__386 (
            .O(N__2618),
            .I(N__2612));
    Sp12to4 I__385 (
            .O(N__2615),
            .I(N__2609));
    InMux I__384 (
            .O(N__2612),
            .I(N__2606));
    Odrv12 I__383 (
            .O(N__2609),
            .I(o_rx_byte_c_1));
    LocalMux I__382 (
            .O(N__2606),
            .I(o_rx_byte_c_1));
    InMux I__381 (
            .O(N__2601),
            .I(N__2597));
    InMux I__380 (
            .O(N__2600),
            .I(N__2593));
    LocalMux I__379 (
            .O(N__2597),
            .I(N__2590));
    InMux I__378 (
            .O(N__2596),
            .I(N__2587));
    LocalMux I__377 (
            .O(N__2593),
            .I(r_clk_counterZ0Z_2));
    Odrv4 I__376 (
            .O(N__2590),
            .I(r_clk_counterZ0Z_2));
    LocalMux I__375 (
            .O(N__2587),
            .I(r_clk_counterZ0Z_2));
    CascadeMux I__374 (
            .O(N__2580),
            .I(N__2576));
    InMux I__373 (
            .O(N__2579),
            .I(N__2572));
    InMux I__372 (
            .O(N__2576),
            .I(N__2569));
    InMux I__371 (
            .O(N__2575),
            .I(N__2566));
    LocalMux I__370 (
            .O(N__2572),
            .I(r_clk_counterZ0Z_6));
    LocalMux I__369 (
            .O(N__2569),
            .I(r_clk_counterZ0Z_6));
    LocalMux I__368 (
            .O(N__2566),
            .I(r_clk_counterZ0Z_6));
    InMux I__367 (
            .O(N__2559),
            .I(N__2554));
    InMux I__366 (
            .O(N__2558),
            .I(N__2551));
    InMux I__365 (
            .O(N__2557),
            .I(N__2548));
    LocalMux I__364 (
            .O(N__2554),
            .I(r_clk_counterZ0Z_7));
    LocalMux I__363 (
            .O(N__2551),
            .I(r_clk_counterZ0Z_7));
    LocalMux I__362 (
            .O(N__2548),
            .I(r_clk_counterZ0Z_7));
    InMux I__361 (
            .O(N__2541),
            .I(N__2537));
    InMux I__360 (
            .O(N__2540),
            .I(N__2534));
    LocalMux I__359 (
            .O(N__2537),
            .I(r_clk_counterZ0Z_12));
    LocalMux I__358 (
            .O(N__2534),
            .I(r_clk_counterZ0Z_12));
    InMux I__357 (
            .O(N__2529),
            .I(N__2525));
    InMux I__356 (
            .O(N__2528),
            .I(N__2522));
    LocalMux I__355 (
            .O(N__2525),
            .I(r_clk_counterZ0Z_15));
    LocalMux I__354 (
            .O(N__2522),
            .I(r_clk_counterZ0Z_15));
    CascadeMux I__353 (
            .O(N__2517),
            .I(N__2513));
    InMux I__352 (
            .O(N__2516),
            .I(N__2510));
    InMux I__351 (
            .O(N__2513),
            .I(N__2507));
    LocalMux I__350 (
            .O(N__2510),
            .I(r_clk_counterZ0Z_13));
    LocalMux I__349 (
            .O(N__2507),
            .I(r_clk_counterZ0Z_13));
    InMux I__348 (
            .O(N__2502),
            .I(N__2498));
    InMux I__347 (
            .O(N__2501),
            .I(N__2495));
    LocalMux I__346 (
            .O(N__2498),
            .I(r_clk_counterZ0Z_14));
    LocalMux I__345 (
            .O(N__2495),
            .I(r_clk_counterZ0Z_14));
    CascadeMux I__344 (
            .O(N__2490),
            .I(N__2486));
    InMux I__343 (
            .O(N__2489),
            .I(N__2482));
    InMux I__342 (
            .O(N__2486),
            .I(N__2477));
    InMux I__341 (
            .O(N__2485),
            .I(N__2477));
    LocalMux I__340 (
            .O(N__2482),
            .I(r_clk_counterZ0Z_1));
    LocalMux I__339 (
            .O(N__2477),
            .I(r_clk_counterZ0Z_1));
    InMux I__338 (
            .O(N__2472),
            .I(N__2467));
    InMux I__337 (
            .O(N__2471),
            .I(N__2462));
    InMux I__336 (
            .O(N__2470),
            .I(N__2462));
    LocalMux I__335 (
            .O(N__2467),
            .I(r_clk_counterZ0Z_0));
    LocalMux I__334 (
            .O(N__2462),
            .I(r_clk_counterZ0Z_0));
    CascadeMux I__333 (
            .O(N__2457),
            .I(N__2452));
    InMux I__332 (
            .O(N__2456),
            .I(N__2449));
    InMux I__331 (
            .O(N__2455),
            .I(N__2444));
    InMux I__330 (
            .O(N__2452),
            .I(N__2444));
    LocalMux I__329 (
            .O(N__2449),
            .I(r_clk_counterZ0Z_4));
    LocalMux I__328 (
            .O(N__2444),
            .I(r_clk_counterZ0Z_4));
    InMux I__327 (
            .O(N__2439),
            .I(N__2434));
    InMux I__326 (
            .O(N__2438),
            .I(N__2429));
    InMux I__325 (
            .O(N__2437),
            .I(N__2429));
    LocalMux I__324 (
            .O(N__2434),
            .I(r_clk_counterZ0Z_5));
    LocalMux I__323 (
            .O(N__2429),
            .I(r_clk_counterZ0Z_5));
    InMux I__322 (
            .O(N__2424),
            .I(N__2420));
    InMux I__321 (
            .O(N__2423),
            .I(N__2417));
    LocalMux I__320 (
            .O(N__2420),
            .I(r_clk_counterZ0Z_29));
    LocalMux I__319 (
            .O(N__2417),
            .I(r_clk_counterZ0Z_29));
    InMux I__318 (
            .O(N__2412),
            .I(N__2408));
    InMux I__317 (
            .O(N__2411),
            .I(N__2405));
    LocalMux I__316 (
            .O(N__2408),
            .I(r_clk_counterZ0Z_28));
    LocalMux I__315 (
            .O(N__2405),
            .I(r_clk_counterZ0Z_28));
    CascadeMux I__314 (
            .O(N__2400),
            .I(N__2396));
    InMux I__313 (
            .O(N__2399),
            .I(N__2393));
    InMux I__312 (
            .O(N__2396),
            .I(N__2390));
    LocalMux I__311 (
            .O(N__2393),
            .I(r_clk_counterZ0Z_31));
    LocalMux I__310 (
            .O(N__2390),
            .I(r_clk_counterZ0Z_31));
    InMux I__309 (
            .O(N__2385),
            .I(N__2381));
    InMux I__308 (
            .O(N__2384),
            .I(N__2378));
    LocalMux I__307 (
            .O(N__2381),
            .I(r_clk_counterZ0Z_30));
    LocalMux I__306 (
            .O(N__2378),
            .I(r_clk_counterZ0Z_30));
    InMux I__305 (
            .O(N__2373),
            .I(N__2369));
    InMux I__304 (
            .O(N__2372),
            .I(N__2366));
    LocalMux I__303 (
            .O(N__2369),
            .I(r_clk_counterZ0Z_26));
    LocalMux I__302 (
            .O(N__2366),
            .I(r_clk_counterZ0Z_26));
    InMux I__301 (
            .O(N__2361),
            .I(N__2357));
    InMux I__300 (
            .O(N__2360),
            .I(N__2354));
    LocalMux I__299 (
            .O(N__2357),
            .I(r_clk_counterZ0Z_24));
    LocalMux I__298 (
            .O(N__2354),
            .I(r_clk_counterZ0Z_24));
    CascadeMux I__297 (
            .O(N__2349),
            .I(N__2345));
    InMux I__296 (
            .O(N__2348),
            .I(N__2342));
    InMux I__295 (
            .O(N__2345),
            .I(N__2339));
    LocalMux I__294 (
            .O(N__2342),
            .I(r_clk_counterZ0Z_27));
    LocalMux I__293 (
            .O(N__2339),
            .I(r_clk_counterZ0Z_27));
    InMux I__292 (
            .O(N__2334),
            .I(N__2330));
    InMux I__291 (
            .O(N__2333),
            .I(N__2327));
    LocalMux I__290 (
            .O(N__2330),
            .I(r_clk_counterZ0Z_25));
    LocalMux I__289 (
            .O(N__2327),
            .I(r_clk_counterZ0Z_25));
    InMux I__288 (
            .O(N__2322),
            .I(N__2318));
    InMux I__287 (
            .O(N__2321),
            .I(N__2315));
    LocalMux I__286 (
            .O(N__2318),
            .I(r_clk_counterZ0Z_23));
    LocalMux I__285 (
            .O(N__2315),
            .I(r_clk_counterZ0Z_23));
    InMux I__284 (
            .O(N__2310),
            .I(N__2306));
    InMux I__283 (
            .O(N__2309),
            .I(N__2303));
    LocalMux I__282 (
            .O(N__2306),
            .I(r_clk_counterZ0Z_20));
    LocalMux I__281 (
            .O(N__2303),
            .I(r_clk_counterZ0Z_20));
    CascadeMux I__280 (
            .O(N__2298),
            .I(N__2294));
    InMux I__279 (
            .O(N__2297),
            .I(N__2291));
    InMux I__278 (
            .O(N__2294),
            .I(N__2288));
    LocalMux I__277 (
            .O(N__2291),
            .I(r_clk_counterZ0Z_22));
    LocalMux I__276 (
            .O(N__2288),
            .I(r_clk_counterZ0Z_22));
    InMux I__275 (
            .O(N__2283),
            .I(N__2279));
    InMux I__274 (
            .O(N__2282),
            .I(N__2276));
    LocalMux I__273 (
            .O(N__2279),
            .I(r_clk_counterZ0Z_21));
    LocalMux I__272 (
            .O(N__2276),
            .I(r_clk_counterZ0Z_21));
    InMux I__271 (
            .O(N__2271),
            .I(N__2268));
    LocalMux I__270 (
            .O(N__2268),
            .I(N__2265));
    Span4Mux_h I__269 (
            .O(N__2265),
            .I(N__2262));
    Odrv4 I__268 (
            .O(N__2262),
            .I(i_UART_RX_c));
    CascadeMux I__267 (
            .O(N__2259),
            .I(N__2256));
    InMux I__266 (
            .O(N__2256),
            .I(N__2253));
    LocalMux I__265 (
            .O(N__2253),
            .I(r_clk_counter_RNO_0Z0Z_4));
    InMux I__264 (
            .O(N__2250),
            .I(N__2247));
    LocalMux I__263 (
            .O(N__2247),
            .I(r_clk_counter_RNO_0Z0Z_5));
    CascadeMux I__262 (
            .O(N__2244),
            .I(N__2241));
    InMux I__261 (
            .O(N__2241),
            .I(N__2238));
    LocalMux I__260 (
            .O(N__2238),
            .I(r_clk_counter_RNO_0Z0Z_2));
    SRMux I__259 (
            .O(N__2235),
            .I(N__2220));
    SRMux I__258 (
            .O(N__2234),
            .I(N__2220));
    SRMux I__257 (
            .O(N__2233),
            .I(N__2220));
    SRMux I__256 (
            .O(N__2232),
            .I(N__2220));
    SRMux I__255 (
            .O(N__2231),
            .I(N__2220));
    GlobalMux I__254 (
            .O(N__2220),
            .I(N__2217));
    gio2CtrlBuf I__253 (
            .O(N__2217),
            .I(N_144_g));
    InMux I__252 (
            .O(N__2214),
            .I(N__2210));
    InMux I__251 (
            .O(N__2213),
            .I(N__2207));
    LocalMux I__250 (
            .O(N__2210),
            .I(r_clk_counterZ0Z_11));
    LocalMux I__249 (
            .O(N__2207),
            .I(r_clk_counterZ0Z_11));
    InMux I__248 (
            .O(N__2202),
            .I(N__2198));
    InMux I__247 (
            .O(N__2201),
            .I(N__2195));
    LocalMux I__246 (
            .O(N__2198),
            .I(r_clk_counterZ0Z_10));
    LocalMux I__245 (
            .O(N__2195),
            .I(r_clk_counterZ0Z_10));
    CascadeMux I__244 (
            .O(N__2190),
            .I(N__2186));
    InMux I__243 (
            .O(N__2189),
            .I(N__2183));
    InMux I__242 (
            .O(N__2186),
            .I(N__2180));
    LocalMux I__241 (
            .O(N__2183),
            .I(r_clk_counterZ0Z_9));
    LocalMux I__240 (
            .O(N__2180),
            .I(r_clk_counterZ0Z_9));
    InMux I__239 (
            .O(N__2175),
            .I(N__2171));
    InMux I__238 (
            .O(N__2174),
            .I(N__2168));
    LocalMux I__237 (
            .O(N__2171),
            .I(r_clk_counterZ0Z_8));
    LocalMux I__236 (
            .O(N__2168),
            .I(r_clk_counterZ0Z_8));
    CascadeMux I__235 (
            .O(N__2163),
            .I(N__2159));
    InMux I__234 (
            .O(N__2162),
            .I(N__2156));
    InMux I__233 (
            .O(N__2159),
            .I(N__2153));
    LocalMux I__232 (
            .O(N__2156),
            .I(N__2148));
    LocalMux I__231 (
            .O(N__2153),
            .I(N__2148));
    Odrv4 I__230 (
            .O(N__2148),
            .I(N_2_i));
    CascadeMux I__229 (
            .O(N__2145),
            .I(N__2140));
    InMux I__228 (
            .O(N__2144),
            .I(N__2137));
    InMux I__227 (
            .O(N__2143),
            .I(N__2134));
    InMux I__226 (
            .O(N__2140),
            .I(N__2131));
    LocalMux I__225 (
            .O(N__2137),
            .I(r_clk_counterZ0Z_3));
    LocalMux I__224 (
            .O(N__2134),
            .I(r_clk_counterZ0Z_3));
    LocalMux I__223 (
            .O(N__2131),
            .I(r_clk_counterZ0Z_3));
    InMux I__222 (
            .O(N__2124),
            .I(N__2120));
    InMux I__221 (
            .O(N__2123),
            .I(N__2117));
    LocalMux I__220 (
            .O(N__2120),
            .I(r_clk_counterZ0Z_18));
    LocalMux I__219 (
            .O(N__2117),
            .I(r_clk_counterZ0Z_18));
    InMux I__218 (
            .O(N__2112),
            .I(N__2108));
    InMux I__217 (
            .O(N__2111),
            .I(N__2105));
    LocalMux I__216 (
            .O(N__2108),
            .I(r_clk_counterZ0Z_19));
    LocalMux I__215 (
            .O(N__2105),
            .I(r_clk_counterZ0Z_19));
    CascadeMux I__214 (
            .O(N__2100),
            .I(N__2096));
    InMux I__213 (
            .O(N__2099),
            .I(N__2093));
    InMux I__212 (
            .O(N__2096),
            .I(N__2090));
    LocalMux I__211 (
            .O(N__2093),
            .I(r_clk_counterZ0Z_17));
    LocalMux I__210 (
            .O(N__2090),
            .I(r_clk_counterZ0Z_17));
    InMux I__209 (
            .O(N__2085),
            .I(N__2081));
    InMux I__208 (
            .O(N__2084),
            .I(N__2078));
    LocalMux I__207 (
            .O(N__2081),
            .I(r_clk_counterZ0Z_16));
    LocalMux I__206 (
            .O(N__2078),
            .I(r_clk_counterZ0Z_16));
    InMux I__205 (
            .O(N__2073),
            .I(un1_r_clk_counter_1_cry_22));
    InMux I__204 (
            .O(N__2070),
            .I(bfn_7_12_0_));
    InMux I__203 (
            .O(N__2067),
            .I(un1_r_clk_counter_1_cry_24));
    InMux I__202 (
            .O(N__2064),
            .I(un1_r_clk_counter_1_cry_25));
    InMux I__201 (
            .O(N__2061),
            .I(un1_r_clk_counter_1_cry_26));
    InMux I__200 (
            .O(N__2058),
            .I(un1_r_clk_counter_1_cry_27));
    InMux I__199 (
            .O(N__2055),
            .I(un1_r_clk_counter_1_cry_28));
    InMux I__198 (
            .O(N__2052),
            .I(un1_r_clk_counter_1_cry_29));
    InMux I__197 (
            .O(N__2049),
            .I(un1_r_clk_counter_1_cry_30));
    InMux I__196 (
            .O(N__2046),
            .I(un1_r_clk_counter_1_cry_13));
    InMux I__195 (
            .O(N__2043),
            .I(un1_r_clk_counter_1_cry_14));
    InMux I__194 (
            .O(N__2040),
            .I(bfn_7_11_0_));
    InMux I__193 (
            .O(N__2037),
            .I(un1_r_clk_counter_1_cry_16));
    InMux I__192 (
            .O(N__2034),
            .I(un1_r_clk_counter_1_cry_17));
    InMux I__191 (
            .O(N__2031),
            .I(un1_r_clk_counter_1_cry_18));
    InMux I__190 (
            .O(N__2028),
            .I(un1_r_clk_counter_1_cry_19));
    InMux I__189 (
            .O(N__2025),
            .I(un1_r_clk_counter_1_cry_20));
    InMux I__188 (
            .O(N__2022),
            .I(un1_r_clk_counter_1_cry_21));
    InMux I__187 (
            .O(N__2019),
            .I(un1_r_clk_counter_1_cry_4));
    InMux I__186 (
            .O(N__2016),
            .I(un1_r_clk_counter_1_cry_5));
    InMux I__185 (
            .O(N__2013),
            .I(un1_r_clk_counter_1_cry_6));
    InMux I__184 (
            .O(N__2010),
            .I(bfn_7_10_0_));
    InMux I__183 (
            .O(N__2007),
            .I(un1_r_clk_counter_1_cry_8));
    InMux I__182 (
            .O(N__2004),
            .I(un1_r_clk_counter_1_cry_9));
    InMux I__181 (
            .O(N__2001),
            .I(un1_r_clk_counter_1_cry_10));
    InMux I__180 (
            .O(N__1998),
            .I(un1_r_clk_counter_1_cry_11));
    InMux I__179 (
            .O(N__1995),
            .I(un1_r_clk_counter_1_cry_12));
    InMux I__178 (
            .O(N__1992),
            .I(un1_r_clk_counter_1_cry_0));
    InMux I__177 (
            .O(N__1989),
            .I(un1_r_clk_counter_1_cry_1));
    InMux I__176 (
            .O(N__1986),
            .I(un1_r_clk_counter_1_cry_2));
    InMux I__175 (
            .O(N__1983),
            .I(un1_r_clk_counter_1_cry_3));
    defparam IN_MUX_bfv_9_11_0_.C_INIT=2'b01;
    ICE_CARRY_IN_MUX IN_MUX_bfv_9_11_0_ (
            .carryinitin(),
            .carryinitout(bfn_9_11_0_));
    defparam IN_MUX_bfv_9_12_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_9_12_0_ (
            .carryinitin(fsm_proc_un6_r_clk_counter),
            .carryinitout(bfn_9_12_0_));
    defparam IN_MUX_bfv_11_12_0_.C_INIT=2'b01;
    ICE_CARRY_IN_MUX IN_MUX_bfv_11_12_0_ (
            .carryinitin(),
            .carryinitout(bfn_11_12_0_));
    defparam IN_MUX_bfv_11_13_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_11_13_0_ (
            .carryinitin(fsm_proc_un22_r_clk_counter),
            .carryinitout(bfn_11_13_0_));
    defparam IN_MUX_bfv_9_9_0_.C_INIT=2'b01;
    ICE_CARRY_IN_MUX IN_MUX_bfv_9_9_0_ (
            .carryinitin(),
            .carryinitout(bfn_9_9_0_));
    defparam IN_MUX_bfv_9_10_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_9_10_0_ (
            .carryinitin(fsm_proc_un10_r_clk_counter),
            .carryinitout(bfn_9_10_0_));
    defparam IN_MUX_bfv_7_9_0_.C_INIT=2'b00;
    ICE_CARRY_IN_MUX IN_MUX_bfv_7_9_0_ (
            .carryinitin(),
            .carryinitout(bfn_7_9_0_));
    defparam IN_MUX_bfv_7_10_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_7_10_0_ (
            .carryinitin(un1_r_clk_counter_1_cry_7),
            .carryinitout(bfn_7_10_0_));
    defparam IN_MUX_bfv_7_11_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_7_11_0_ (
            .carryinitin(un1_r_clk_counter_1_cry_15),
            .carryinitout(bfn_7_11_0_));
    defparam IN_MUX_bfv_7_12_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_7_12_0_ (
            .carryinitin(un1_r_clk_counter_1_cry_23),
            .carryinitout(bfn_7_12_0_));
    defparam IN_MUX_bfv_12_9_0_.C_INIT=2'b00;
    ICE_CARRY_IN_MUX IN_MUX_bfv_12_9_0_ (
            .carryinitin(),
            .carryinitout(bfn_12_9_0_));
    defparam IN_MUX_bfv_12_10_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_12_10_0_ (
            .carryinitin(un1_r_bit_counter_1_cry_7),
            .carryinitout(bfn_12_10_0_));
    defparam IN_MUX_bfv_12_11_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_12_11_0_ (
            .carryinitin(un1_r_bit_counter_1_cry_15),
            .carryinitout(bfn_12_11_0_));
    defparam IN_MUX_bfv_12_12_0_.C_INIT=2'b10;
    ICE_CARRY_IN_MUX IN_MUX_bfv_12_12_0_ (
            .carryinitin(un1_r_bit_counter_1_cry_23),
            .carryinitout(bfn_12_12_0_));
    ICE_GB r_state_RNI6KS51_0_0 (
            .USERSIGNALTOGLOBALBUFFER(N__3348),
            .GLOBALBUFFEROUTPUT(N_209_g));
    VCC VCC (
            .Y(VCCG0));
    GND GND (
            .Y(GNDG0));
    ICE_GB i_rst_ibuf_RNI6EKC (
            .USERSIGNALTOGLOBALBUFFER(N__3543),
            .GLOBALBUFFEROUTPUT(N_144_g));
    GND GND_Inst (
            .Y(_gnd_net_));
    defparam r_clk_counter_0_LC_7_9_0.C_ON=1'b1;
    defparam r_clk_counter_0_LC_7_9_0.SEQ_MODE=4'b1000;
    defparam r_clk_counter_0_LC_7_9_0.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_0_LC_7_9_0 (
            .in0(_gnd_net_),
            .in1(N__2472),
            .in2(N__2163),
            .in3(N__2162),
            .lcout(r_clk_counterZ0Z_0),
            .ltout(),
            .carryin(bfn_7_9_0_),
            .carryout(un1_r_clk_counter_1_cry_0),
            .clk(N__4281),
            .ce(),
            .sr(N__2231));
    defparam r_clk_counter_1_LC_7_9_1.C_ON=1'b1;
    defparam r_clk_counter_1_LC_7_9_1.SEQ_MODE=4'b1000;
    defparam r_clk_counter_1_LC_7_9_1.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_1_LC_7_9_1 (
            .in0(_gnd_net_),
            .in1(N__2489),
            .in2(_gnd_net_),
            .in3(N__1992),
            .lcout(r_clk_counterZ0Z_1),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_0),
            .carryout(un1_r_clk_counter_1_cry_1),
            .clk(N__4281),
            .ce(),
            .sr(N__2231));
    defparam r_clk_counter_RNO_0_2_LC_7_9_2.C_ON=1'b1;
    defparam r_clk_counter_RNO_0_2_LC_7_9_2.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNO_0_2_LC_7_9_2.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_RNO_0_2_LC_7_9_2 (
            .in0(_gnd_net_),
            .in1(N__2600),
            .in2(_gnd_net_),
            .in3(N__1989),
            .lcout(r_clk_counter_RNO_0Z0Z_2),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_1),
            .carryout(un1_r_clk_counter_1_cry_2),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_3_LC_7_9_3.C_ON=1'b1;
    defparam r_clk_counter_3_LC_7_9_3.SEQ_MODE=4'b1000;
    defparam r_clk_counter_3_LC_7_9_3.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_3_LC_7_9_3 (
            .in0(_gnd_net_),
            .in1(N__2144),
            .in2(_gnd_net_),
            .in3(N__1986),
            .lcout(r_clk_counterZ0Z_3),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_2),
            .carryout(un1_r_clk_counter_1_cry_3),
            .clk(N__4281),
            .ce(),
            .sr(N__2231));
    defparam r_clk_counter_RNO_0_4_LC_7_9_4.C_ON=1'b1;
    defparam r_clk_counter_RNO_0_4_LC_7_9_4.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNO_0_4_LC_7_9_4.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_RNO_0_4_LC_7_9_4 (
            .in0(_gnd_net_),
            .in1(N__2456),
            .in2(_gnd_net_),
            .in3(N__1983),
            .lcout(r_clk_counter_RNO_0Z0Z_4),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_3),
            .carryout(un1_r_clk_counter_1_cry_4),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_RNO_0_5_LC_7_9_5.C_ON=1'b1;
    defparam r_clk_counter_RNO_0_5_LC_7_9_5.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNO_0_5_LC_7_9_5.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_RNO_0_5_LC_7_9_5 (
            .in0(_gnd_net_),
            .in1(N__2439),
            .in2(_gnd_net_),
            .in3(N__2019),
            .lcout(r_clk_counter_RNO_0Z0Z_5),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_4),
            .carryout(un1_r_clk_counter_1_cry_5),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_6_LC_7_9_6.C_ON=1'b1;
    defparam r_clk_counter_6_LC_7_9_6.SEQ_MODE=4'b1000;
    defparam r_clk_counter_6_LC_7_9_6.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_6_LC_7_9_6 (
            .in0(_gnd_net_),
            .in1(N__2579),
            .in2(_gnd_net_),
            .in3(N__2016),
            .lcout(r_clk_counterZ0Z_6),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_5),
            .carryout(un1_r_clk_counter_1_cry_6),
            .clk(N__4281),
            .ce(),
            .sr(N__2231));
    defparam r_clk_counter_7_LC_7_9_7.C_ON=1'b1;
    defparam r_clk_counter_7_LC_7_9_7.SEQ_MODE=4'b1000;
    defparam r_clk_counter_7_LC_7_9_7.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_7_LC_7_9_7 (
            .in0(_gnd_net_),
            .in1(N__2559),
            .in2(_gnd_net_),
            .in3(N__2013),
            .lcout(r_clk_counterZ0Z_7),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_6),
            .carryout(un1_r_clk_counter_1_cry_7),
            .clk(N__4281),
            .ce(),
            .sr(N__2231));
    defparam r_clk_counter_8_LC_7_10_0.C_ON=1'b1;
    defparam r_clk_counter_8_LC_7_10_0.SEQ_MODE=4'b1000;
    defparam r_clk_counter_8_LC_7_10_0.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_8_LC_7_10_0 (
            .in0(_gnd_net_),
            .in1(N__2175),
            .in2(_gnd_net_),
            .in3(N__2010),
            .lcout(r_clk_counterZ0Z_8),
            .ltout(),
            .carryin(bfn_7_10_0_),
            .carryout(un1_r_clk_counter_1_cry_8),
            .clk(N__4283),
            .ce(),
            .sr(N__2232));
    defparam r_clk_counter_9_LC_7_10_1.C_ON=1'b1;
    defparam r_clk_counter_9_LC_7_10_1.SEQ_MODE=4'b1000;
    defparam r_clk_counter_9_LC_7_10_1.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_9_LC_7_10_1 (
            .in0(_gnd_net_),
            .in1(N__2189),
            .in2(_gnd_net_),
            .in3(N__2007),
            .lcout(r_clk_counterZ0Z_9),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_8),
            .carryout(un1_r_clk_counter_1_cry_9),
            .clk(N__4283),
            .ce(),
            .sr(N__2232));
    defparam r_clk_counter_10_LC_7_10_2.C_ON=1'b1;
    defparam r_clk_counter_10_LC_7_10_2.SEQ_MODE=4'b1000;
    defparam r_clk_counter_10_LC_7_10_2.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_10_LC_7_10_2 (
            .in0(_gnd_net_),
            .in1(N__2202),
            .in2(_gnd_net_),
            .in3(N__2004),
            .lcout(r_clk_counterZ0Z_10),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_9),
            .carryout(un1_r_clk_counter_1_cry_10),
            .clk(N__4283),
            .ce(),
            .sr(N__2232));
    defparam r_clk_counter_11_LC_7_10_3.C_ON=1'b1;
    defparam r_clk_counter_11_LC_7_10_3.SEQ_MODE=4'b1000;
    defparam r_clk_counter_11_LC_7_10_3.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_11_LC_7_10_3 (
            .in0(_gnd_net_),
            .in1(N__2214),
            .in2(_gnd_net_),
            .in3(N__2001),
            .lcout(r_clk_counterZ0Z_11),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_10),
            .carryout(un1_r_clk_counter_1_cry_11),
            .clk(N__4283),
            .ce(),
            .sr(N__2232));
    defparam r_clk_counter_12_LC_7_10_4.C_ON=1'b1;
    defparam r_clk_counter_12_LC_7_10_4.SEQ_MODE=4'b1000;
    defparam r_clk_counter_12_LC_7_10_4.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_12_LC_7_10_4 (
            .in0(_gnd_net_),
            .in1(N__2541),
            .in2(_gnd_net_),
            .in3(N__1998),
            .lcout(r_clk_counterZ0Z_12),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_11),
            .carryout(un1_r_clk_counter_1_cry_12),
            .clk(N__4283),
            .ce(),
            .sr(N__2232));
    defparam r_clk_counter_13_LC_7_10_5.C_ON=1'b1;
    defparam r_clk_counter_13_LC_7_10_5.SEQ_MODE=4'b1000;
    defparam r_clk_counter_13_LC_7_10_5.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_13_LC_7_10_5 (
            .in0(_gnd_net_),
            .in1(N__2516),
            .in2(_gnd_net_),
            .in3(N__1995),
            .lcout(r_clk_counterZ0Z_13),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_12),
            .carryout(un1_r_clk_counter_1_cry_13),
            .clk(N__4283),
            .ce(),
            .sr(N__2232));
    defparam r_clk_counter_14_LC_7_10_6.C_ON=1'b1;
    defparam r_clk_counter_14_LC_7_10_6.SEQ_MODE=4'b1000;
    defparam r_clk_counter_14_LC_7_10_6.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_14_LC_7_10_6 (
            .in0(_gnd_net_),
            .in1(N__2502),
            .in2(_gnd_net_),
            .in3(N__2046),
            .lcout(r_clk_counterZ0Z_14),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_13),
            .carryout(un1_r_clk_counter_1_cry_14),
            .clk(N__4283),
            .ce(),
            .sr(N__2232));
    defparam r_clk_counter_15_LC_7_10_7.C_ON=1'b1;
    defparam r_clk_counter_15_LC_7_10_7.SEQ_MODE=4'b1000;
    defparam r_clk_counter_15_LC_7_10_7.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_15_LC_7_10_7 (
            .in0(_gnd_net_),
            .in1(N__2529),
            .in2(_gnd_net_),
            .in3(N__2043),
            .lcout(r_clk_counterZ0Z_15),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_14),
            .carryout(un1_r_clk_counter_1_cry_15),
            .clk(N__4283),
            .ce(),
            .sr(N__2232));
    defparam r_clk_counter_16_LC_7_11_0.C_ON=1'b1;
    defparam r_clk_counter_16_LC_7_11_0.SEQ_MODE=4'b1000;
    defparam r_clk_counter_16_LC_7_11_0.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_16_LC_7_11_0 (
            .in0(_gnd_net_),
            .in1(N__2085),
            .in2(_gnd_net_),
            .in3(N__2040),
            .lcout(r_clk_counterZ0Z_16),
            .ltout(),
            .carryin(bfn_7_11_0_),
            .carryout(un1_r_clk_counter_1_cry_16),
            .clk(N__4284),
            .ce(),
            .sr(N__2234));
    defparam r_clk_counter_17_LC_7_11_1.C_ON=1'b1;
    defparam r_clk_counter_17_LC_7_11_1.SEQ_MODE=4'b1000;
    defparam r_clk_counter_17_LC_7_11_1.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_17_LC_7_11_1 (
            .in0(_gnd_net_),
            .in1(N__2099),
            .in2(_gnd_net_),
            .in3(N__2037),
            .lcout(r_clk_counterZ0Z_17),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_16),
            .carryout(un1_r_clk_counter_1_cry_17),
            .clk(N__4284),
            .ce(),
            .sr(N__2234));
    defparam r_clk_counter_18_LC_7_11_2.C_ON=1'b1;
    defparam r_clk_counter_18_LC_7_11_2.SEQ_MODE=4'b1000;
    defparam r_clk_counter_18_LC_7_11_2.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_18_LC_7_11_2 (
            .in0(_gnd_net_),
            .in1(N__2124),
            .in2(_gnd_net_),
            .in3(N__2034),
            .lcout(r_clk_counterZ0Z_18),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_17),
            .carryout(un1_r_clk_counter_1_cry_18),
            .clk(N__4284),
            .ce(),
            .sr(N__2234));
    defparam r_clk_counter_19_LC_7_11_3.C_ON=1'b1;
    defparam r_clk_counter_19_LC_7_11_3.SEQ_MODE=4'b1000;
    defparam r_clk_counter_19_LC_7_11_3.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_19_LC_7_11_3 (
            .in0(_gnd_net_),
            .in1(N__2112),
            .in2(_gnd_net_),
            .in3(N__2031),
            .lcout(r_clk_counterZ0Z_19),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_18),
            .carryout(un1_r_clk_counter_1_cry_19),
            .clk(N__4284),
            .ce(),
            .sr(N__2234));
    defparam r_clk_counter_20_LC_7_11_4.C_ON=1'b1;
    defparam r_clk_counter_20_LC_7_11_4.SEQ_MODE=4'b1000;
    defparam r_clk_counter_20_LC_7_11_4.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_20_LC_7_11_4 (
            .in0(_gnd_net_),
            .in1(N__2310),
            .in2(_gnd_net_),
            .in3(N__2028),
            .lcout(r_clk_counterZ0Z_20),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_19),
            .carryout(un1_r_clk_counter_1_cry_20),
            .clk(N__4284),
            .ce(),
            .sr(N__2234));
    defparam r_clk_counter_21_LC_7_11_5.C_ON=1'b1;
    defparam r_clk_counter_21_LC_7_11_5.SEQ_MODE=4'b1000;
    defparam r_clk_counter_21_LC_7_11_5.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_21_LC_7_11_5 (
            .in0(_gnd_net_),
            .in1(N__2283),
            .in2(_gnd_net_),
            .in3(N__2025),
            .lcout(r_clk_counterZ0Z_21),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_20),
            .carryout(un1_r_clk_counter_1_cry_21),
            .clk(N__4284),
            .ce(),
            .sr(N__2234));
    defparam r_clk_counter_22_LC_7_11_6.C_ON=1'b1;
    defparam r_clk_counter_22_LC_7_11_6.SEQ_MODE=4'b1000;
    defparam r_clk_counter_22_LC_7_11_6.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_22_LC_7_11_6 (
            .in0(_gnd_net_),
            .in1(N__2297),
            .in2(_gnd_net_),
            .in3(N__2022),
            .lcout(r_clk_counterZ0Z_22),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_21),
            .carryout(un1_r_clk_counter_1_cry_22),
            .clk(N__4284),
            .ce(),
            .sr(N__2234));
    defparam r_clk_counter_23_LC_7_11_7.C_ON=1'b1;
    defparam r_clk_counter_23_LC_7_11_7.SEQ_MODE=4'b1000;
    defparam r_clk_counter_23_LC_7_11_7.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_23_LC_7_11_7 (
            .in0(_gnd_net_),
            .in1(N__2322),
            .in2(_gnd_net_),
            .in3(N__2073),
            .lcout(r_clk_counterZ0Z_23),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_22),
            .carryout(un1_r_clk_counter_1_cry_23),
            .clk(N__4284),
            .ce(),
            .sr(N__2234));
    defparam r_clk_counter_24_LC_7_12_0.C_ON=1'b1;
    defparam r_clk_counter_24_LC_7_12_0.SEQ_MODE=4'b1000;
    defparam r_clk_counter_24_LC_7_12_0.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_24_LC_7_12_0 (
            .in0(_gnd_net_),
            .in1(N__2361),
            .in2(_gnd_net_),
            .in3(N__2070),
            .lcout(r_clk_counterZ0Z_24),
            .ltout(),
            .carryin(bfn_7_12_0_),
            .carryout(un1_r_clk_counter_1_cry_24),
            .clk(N__4285),
            .ce(),
            .sr(N__2235));
    defparam r_clk_counter_25_LC_7_12_1.C_ON=1'b1;
    defparam r_clk_counter_25_LC_7_12_1.SEQ_MODE=4'b1000;
    defparam r_clk_counter_25_LC_7_12_1.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_25_LC_7_12_1 (
            .in0(_gnd_net_),
            .in1(N__2334),
            .in2(_gnd_net_),
            .in3(N__2067),
            .lcout(r_clk_counterZ0Z_25),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_24),
            .carryout(un1_r_clk_counter_1_cry_25),
            .clk(N__4285),
            .ce(),
            .sr(N__2235));
    defparam r_clk_counter_26_LC_7_12_2.C_ON=1'b1;
    defparam r_clk_counter_26_LC_7_12_2.SEQ_MODE=4'b1000;
    defparam r_clk_counter_26_LC_7_12_2.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_26_LC_7_12_2 (
            .in0(_gnd_net_),
            .in1(N__2373),
            .in2(_gnd_net_),
            .in3(N__2064),
            .lcout(r_clk_counterZ0Z_26),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_25),
            .carryout(un1_r_clk_counter_1_cry_26),
            .clk(N__4285),
            .ce(),
            .sr(N__2235));
    defparam r_clk_counter_27_LC_7_12_3.C_ON=1'b1;
    defparam r_clk_counter_27_LC_7_12_3.SEQ_MODE=4'b1000;
    defparam r_clk_counter_27_LC_7_12_3.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_27_LC_7_12_3 (
            .in0(_gnd_net_),
            .in1(N__2348),
            .in2(_gnd_net_),
            .in3(N__2061),
            .lcout(r_clk_counterZ0Z_27),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_26),
            .carryout(un1_r_clk_counter_1_cry_27),
            .clk(N__4285),
            .ce(),
            .sr(N__2235));
    defparam r_clk_counter_28_LC_7_12_4.C_ON=1'b1;
    defparam r_clk_counter_28_LC_7_12_4.SEQ_MODE=4'b1000;
    defparam r_clk_counter_28_LC_7_12_4.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_28_LC_7_12_4 (
            .in0(_gnd_net_),
            .in1(N__2412),
            .in2(_gnd_net_),
            .in3(N__2058),
            .lcout(r_clk_counterZ0Z_28),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_27),
            .carryout(un1_r_clk_counter_1_cry_28),
            .clk(N__4285),
            .ce(),
            .sr(N__2235));
    defparam r_clk_counter_29_LC_7_12_5.C_ON=1'b1;
    defparam r_clk_counter_29_LC_7_12_5.SEQ_MODE=4'b1000;
    defparam r_clk_counter_29_LC_7_12_5.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_29_LC_7_12_5 (
            .in0(_gnd_net_),
            .in1(N__2424),
            .in2(_gnd_net_),
            .in3(N__2055),
            .lcout(r_clk_counterZ0Z_29),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_28),
            .carryout(un1_r_clk_counter_1_cry_29),
            .clk(N__4285),
            .ce(),
            .sr(N__2235));
    defparam r_clk_counter_30_LC_7_12_6.C_ON=1'b1;
    defparam r_clk_counter_30_LC_7_12_6.SEQ_MODE=4'b1000;
    defparam r_clk_counter_30_LC_7_12_6.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_clk_counter_30_LC_7_12_6 (
            .in0(_gnd_net_),
            .in1(N__2385),
            .in2(_gnd_net_),
            .in3(N__2052),
            .lcout(r_clk_counterZ0Z_30),
            .ltout(),
            .carryin(un1_r_clk_counter_1_cry_29),
            .carryout(un1_r_clk_counter_1_cry_30),
            .clk(N__4285),
            .ce(),
            .sr(N__2235));
    defparam r_clk_counter_31_LC_7_12_7.C_ON=1'b0;
    defparam r_clk_counter_31_LC_7_12_7.SEQ_MODE=4'b1000;
    defparam r_clk_counter_31_LC_7_12_7.LUT_INIT=16'b0011001111001100;
    LogicCell40 r_clk_counter_31_LC_7_12_7 (
            .in0(_gnd_net_),
            .in1(N__2399),
            .in2(_gnd_net_),
            .in3(N__2049),
            .lcout(r_clk_counterZ0Z_31),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4285),
            .ce(),
            .sr(N__2235));
    defparam r_rx_sync_1_LC_7_13_2.C_ON=1'b0;
    defparam r_rx_sync_1_LC_7_13_2.SEQ_MODE=4'b1001;
    defparam r_rx_sync_1_LC_7_13_2.LUT_INIT=16'b1111111100000000;
    LogicCell40 r_rx_sync_1_LC_7_13_2 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__2271),
            .lcout(r_rx_syncZ0Z_1),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4289),
            .ce(),
            .sr(N__3504));
    defparam r_clk_counter_4_LC_8_9_1.C_ON=1'b0;
    defparam r_clk_counter_4_LC_8_9_1.SEQ_MODE=4'b1000;
    defparam r_clk_counter_4_LC_8_9_1.LUT_INIT=16'b0101000001110000;
    LogicCell40 r_clk_counter_4_LC_8_9_1 (
            .in0(N__3675),
            .in1(N__3626),
            .in2(N__2259),
            .in3(N__3427),
            .lcout(r_clk_counterZ0Z_4),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4282),
            .ce(),
            .sr(N__2233));
    defparam r_clk_counter_5_LC_8_9_2.C_ON=1'b0;
    defparam r_clk_counter_5_LC_8_9_2.SEQ_MODE=4'b1000;
    defparam r_clk_counter_5_LC_8_9_2.LUT_INIT=16'b0000010011001100;
    LogicCell40 r_clk_counter_5_LC_8_9_2 (
            .in0(N__3426),
            .in1(N__2250),
            .in2(N__3635),
            .in3(N__3677),
            .lcout(r_clk_counterZ0Z_5),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4282),
            .ce(),
            .sr(N__2233));
    defparam r_clk_counter_2_LC_8_9_4.C_ON=1'b0;
    defparam r_clk_counter_2_LC_8_9_4.SEQ_MODE=4'b1000;
    defparam r_clk_counter_2_LC_8_9_4.LUT_INIT=16'b0001000011110000;
    LogicCell40 r_clk_counter_2_LC_8_9_4 (
            .in0(N__3625),
            .in1(N__3428),
            .in2(N__2244),
            .in3(N__3676),
            .lcout(r_clk_counterZ0Z_2),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4282),
            .ce(),
            .sr(N__2233));
    defparam fsm_proc_un10_r_clk_counter_1_c_RNO_LC_8_9_5.C_ON=1'b0;
    defparam fsm_proc_un10_r_clk_counter_1_c_RNO_LC_8_9_5.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_1_c_RNO_LC_8_9_5.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un10_r_clk_counter_1_c_RNO_LC_8_9_5 (
            .in0(N__2575),
            .in1(N__2596),
            .in2(N__2145),
            .in3(N__2558),
            .lcout(fsm_proc_un10_r_clk_counter_1_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_RNIST191_8_LC_8_10_0.C_ON=1'b0;
    defparam r_clk_counter_RNIST191_8_LC_8_10_0.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNIST191_8_LC_8_10_0.LUT_INIT=16'b0000000000000001;
    LogicCell40 r_clk_counter_RNIST191_8_LC_8_10_0 (
            .in0(N__2213),
            .in1(N__2201),
            .in2(N__2190),
            .in3(N__2174),
            .lcout(fsm_proc_un6_r_clk_counter_2_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_state_RNIL0I4_0_LC_8_10_1.C_ON=1'b0;
    defparam r_state_RNIL0I4_0_LC_8_10_1.SEQ_MODE=4'b0000;
    defparam r_state_RNIL0I4_0_LC_8_10_1.LUT_INIT=16'b1111111110101010;
    LogicCell40 r_state_RNIL0I4_0_LC_8_10_1 (
            .in0(N__3413),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__3615),
            .lcout(N_2_i),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_0_c_RNO_LC_8_10_3.C_ON=1'b0;
    defparam fsm_proc_un6_r_clk_counter_0_c_RNO_LC_8_10_3.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_0_c_RNO_LC_8_10_3.LUT_INIT=16'b0010000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_0_c_RNO_LC_8_10_3 (
            .in0(N__2455),
            .in1(N__2471),
            .in2(N__2490),
            .in3(N__2143),
            .lcout(fsm_proc_un6_r_clk_counter_0_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_RNIAREJ1_16_LC_8_10_4.C_ON=1'b0;
    defparam r_clk_counter_RNIAREJ1_16_LC_8_10_4.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNIAREJ1_16_LC_8_10_4.LUT_INIT=16'b0000000000000001;
    LogicCell40 r_clk_counter_RNIAREJ1_16_LC_8_10_4 (
            .in0(N__2123),
            .in1(N__2111),
            .in2(N__2100),
            .in3(N__2084),
            .lcout(fsm_proc_un6_r_clk_counter_4_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_1_c_RNO_LC_8_10_5.C_ON=1'b0;
    defparam fsm_proc_un6_r_clk_counter_1_c_RNO_LC_8_10_5.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_1_c_RNO_LC_8_10_5.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un6_r_clk_counter_1_c_RNO_LC_8_10_5 (
            .in0(N__2601),
            .in1(N__2438),
            .in2(N__2580),
            .in3(N__2557),
            .lcout(fsm_proc_un6_r_clk_counter_1_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_RNIQAEJ1_12_LC_8_10_6.C_ON=1'b0;
    defparam r_clk_counter_RNIQAEJ1_12_LC_8_10_6.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNIQAEJ1_12_LC_8_10_6.LUT_INIT=16'b0000000000000001;
    LogicCell40 r_clk_counter_RNIQAEJ1_12_LC_8_10_6 (
            .in0(N__2540),
            .in1(N__2528),
            .in2(N__2517),
            .in3(N__2501),
            .lcout(fsm_proc_un6_r_clk_counter_3_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_0_c_RNO_LC_8_10_7.C_ON=1'b0;
    defparam fsm_proc_un10_r_clk_counter_0_c_RNO_LC_8_10_7.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_0_c_RNO_LC_8_10_7.LUT_INIT=16'b1000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_0_c_RNO_LC_8_10_7 (
            .in0(N__2485),
            .in1(N__2470),
            .in2(N__2457),
            .in3(N__2437),
            .lcout(fsm_proc_un10_r_clk_counter_0_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_RNI4RKJ1_31_LC_8_11_0.C_ON=1'b0;
    defparam r_clk_counter_RNI4RKJ1_31_LC_8_11_0.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNI4RKJ1_31_LC_8_11_0.LUT_INIT=16'b0000000000000001;
    LogicCell40 r_clk_counter_RNI4RKJ1_31_LC_8_11_0 (
            .in0(N__2423),
            .in1(N__2411),
            .in2(N__2400),
            .in3(N__2384),
            .lcout(fsm_proc_un6_r_clk_counter_7_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_RNI6RIJ1_24_LC_8_11_1.C_ON=1'b0;
    defparam r_clk_counter_RNI6RIJ1_24_LC_8_11_1.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNI6RIJ1_24_LC_8_11_1.LUT_INIT=16'b0000000000000001;
    LogicCell40 r_clk_counter_RNI6RIJ1_24_LC_8_11_1 (
            .in0(N__2372),
            .in1(N__2360),
            .in2(N__2349),
            .in3(N__2333),
            .lcout(fsm_proc_un6_r_clk_counter_6_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_RNO_0_3_LC_8_11_2.C_ON=1'b0;
    defparam r_rx_byte_RNO_0_3_LC_8_11_2.SEQ_MODE=4'b0000;
    defparam r_rx_byte_RNO_0_3_LC_8_11_2.LUT_INIT=16'b0100010000000000;
    LogicCell40 r_rx_byte_RNO_0_3_LC_8_11_2 (
            .in0(N__3851),
            .in1(N__3922),
            .in2(_gnd_net_),
            .in3(N__3314),
            .lcout(N_63),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_clk_counter_RNIMAIJ1_20_LC_8_11_3.C_ON=1'b0;
    defparam r_clk_counter_RNIMAIJ1_20_LC_8_11_3.SEQ_MODE=4'b0000;
    defparam r_clk_counter_RNIMAIJ1_20_LC_8_11_3.LUT_INIT=16'b0000000000000001;
    LogicCell40 r_clk_counter_RNIMAIJ1_20_LC_8_11_3 (
            .in0(N__2321),
            .in1(N__2309),
            .in2(N__2298),
            .in3(N__2282),
            .lcout(fsm_proc_un6_r_clk_counter_5_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_RNO_0_4_LC_8_11_4.C_ON=1'b0;
    defparam r_rx_byte_RNO_0_4_LC_8_11_4.SEQ_MODE=4'b0000;
    defparam r_rx_byte_RNO_0_4_LC_8_11_4.LUT_INIT=16'b0000000000001010;
    LogicCell40 r_rx_byte_RNO_0_4_LC_8_11_4 (
            .in0(N__3852),
            .in1(_gnd_net_),
            .in2(N__3923),
            .in3(N__3315),
            .lcout(N_62),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_valid_pulse_LC_8_11_5.C_ON=1'b0;
    defparam r_rx_valid_pulse_LC_8_11_5.SEQ_MODE=4'b1000;
    defparam r_rx_valid_pulse_LC_8_11_5.LUT_INIT=16'b0000100000000000;
    LogicCell40 r_rx_valid_pulse_LC_8_11_5 (
            .in0(N__3438),
            .in1(N__3678),
            .in2(N__3532),
            .in3(N__2895),
            .lcout(o_rx_valid_pulse_c),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4286),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_RNO_0_5_LC_8_11_6.C_ON=1'b0;
    defparam r_rx_byte_RNO_0_5_LC_8_11_6.SEQ_MODE=4'b0000;
    defparam r_rx_byte_RNO_0_5_LC_8_11_6.LUT_INIT=16'b0000101000000000;
    LogicCell40 r_rx_byte_RNO_0_5_LC_8_11_6 (
            .in0(N__3853),
            .in1(_gnd_net_),
            .in2(N__3924),
            .in3(N__3316),
            .lcout(N_61),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_RNO_0_7_LC_8_11_7.C_ON=1'b0;
    defparam r_rx_byte_RNO_0_7_LC_8_11_7.SEQ_MODE=4'b0000;
    defparam r_rx_byte_RNO_0_7_LC_8_11_7.LUT_INIT=16'b1000100000000000;
    LogicCell40 r_rx_byte_RNO_0_7_LC_8_11_7 (
            .in0(N__3317),
            .in1(N__3854),
            .in2(_gnd_net_),
            .in3(N__3915),
            .lcout(N_59),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_5_LC_8_12_1.C_ON=1'b0;
    defparam r_rx_byte_5_LC_8_12_1.SEQ_MODE=4'b1000;
    defparam r_rx_byte_5_LC_8_12_1.LUT_INIT=16'b1101100011110000;
    LogicCell40 r_rx_byte_5_LC_8_12_1 (
            .in0(N__2778),
            .in1(N__3153),
            .in2(N__2768),
            .in3(N__3091),
            .lcout(o_rx_byte_c_5),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4290),
            .ce(),
            .sr(N__3513));
    defparam r_rx_byte_7_LC_8_12_2.C_ON=1'b0;
    defparam r_rx_byte_7_LC_8_12_2.SEQ_MODE=4'b1000;
    defparam r_rx_byte_7_LC_8_12_2.LUT_INIT=16'b1111100001110000;
    LogicCell40 r_rx_byte_7_LC_8_12_2 (
            .in0(N__3092),
            .in1(N__2751),
            .in2(N__2732),
            .in3(N__3150),
            .lcout(o_rx_byte_c_7),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4290),
            .ce(),
            .sr(N__3513));
    defparam r_rx_byte_0_LC_8_12_3.C_ON=1'b0;
    defparam r_rx_byte_0_LC_8_12_3.SEQ_MODE=4'b1000;
    defparam r_rx_byte_0_LC_8_12_3.LUT_INIT=16'b1110010011001100;
    LogicCell40 r_rx_byte_0_LC_8_12_3 (
            .in0(N__3192),
            .in1(N__2702),
            .in2(N__3162),
            .in3(N__3086),
            .lcout(o_rx_byte_c_0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4290),
            .ce(),
            .sr(N__3513));
    defparam r_rx_byte_3_LC_8_12_4.C_ON=1'b0;
    defparam r_rx_byte_3_LC_8_12_4.SEQ_MODE=4'b1000;
    defparam r_rx_byte_3_LC_8_12_4.LUT_INIT=16'b1111100001110000;
    LogicCell40 r_rx_byte_3_LC_8_12_4 (
            .in0(N__3089),
            .in1(N__2691),
            .in2(N__2678),
            .in3(N__3149),
            .lcout(o_rx_byte_c_3),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4290),
            .ce(),
            .sr(N__3513));
    defparam r_rx_byte_4_LC_8_12_5.C_ON=1'b0;
    defparam r_rx_byte_4_LC_8_12_5.SEQ_MODE=4'b1000;
    defparam r_rx_byte_4_LC_8_12_5.LUT_INIT=16'b1101100011110000;
    LogicCell40 r_rx_byte_4_LC_8_12_5 (
            .in0(N__2661),
            .in1(N__3152),
            .in2(N__2645),
            .in3(N__3090),
            .lcout(o_rx_byte_c_4),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4290),
            .ce(),
            .sr(N__3513));
    defparam r_rx_byte_1_LC_8_12_6.C_ON=1'b0;
    defparam r_rx_byte_1_LC_8_12_6.SEQ_MODE=4'b1000;
    defparam r_rx_byte_1_LC_8_12_6.LUT_INIT=16'b1111100001110000;
    LogicCell40 r_rx_byte_1_LC_8_12_6 (
            .in0(N__3087),
            .in1(N__3198),
            .in2(N__2618),
            .in3(N__3148),
            .lcout(o_rx_byte_c_1),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4290),
            .ce(),
            .sr(N__3513));
    defparam r_rx_byte_2_LC_8_12_7.C_ON=1'b0;
    defparam r_rx_byte_2_LC_8_12_7.SEQ_MODE=4'b1000;
    defparam r_rx_byte_2_LC_8_12_7.LUT_INIT=16'b1101100011110000;
    LogicCell40 r_rx_byte_2_LC_8_12_7 (
            .in0(N__3207),
            .in1(N__3151),
            .in2(N__2861),
            .in3(N__3088),
            .lcout(o_rx_byte_c_2),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4290),
            .ce(),
            .sr(N__3513));
    defparam r_rx_sync_2_LC_8_13_7.C_ON=1'b0;
    defparam r_rx_sync_2_LC_8_13_7.SEQ_MODE=4'b1001;
    defparam r_rx_sync_2_LC_8_13_7.LUT_INIT=16'b1111111100000000;
    LogicCell40 r_rx_sync_2_LC_8_13_7 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__2844),
            .lcout(r_rx_syncZ0Z_2),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4292),
            .ce(),
            .sr(N__3503));
    defparam r_UART_RX_LED_LC_9_8_7.C_ON=1'b0;
    defparam r_UART_RX_LED_LC_9_8_7.SEQ_MODE=4'b1000;
    defparam r_UART_RX_LED_LC_9_8_7.LUT_INIT=16'b0111100011110000;
    LogicCell40 r_UART_RX_LED_LC_9_8_7 (
            .in0(N__2894),
            .in1(N__3433),
            .in2(N__2828),
            .in3(N__3687),
            .lcout(o_UART_RX_LED_c),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4288),
            .ce(),
            .sr(N__3535));
    defparam fsm_proc_un10_r_clk_counter_0_c_LC_9_9_0.C_ON=1'b1;
    defparam fsm_proc_un10_r_clk_counter_0_c_LC_9_9_0.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_0_c_LC_9_9_0.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_0_c_LC_9_9_0 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2811),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(bfn_9_9_0_),
            .carryout(fsm_proc_un10_r_clk_counter_0),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_1_c_LC_9_9_1.C_ON=1'b1;
    defparam fsm_proc_un10_r_clk_counter_1_c_LC_9_9_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_1_c_LC_9_9_1.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_1_c_LC_9_9_1 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2802),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un10_r_clk_counter_0),
            .carryout(fsm_proc_un10_r_clk_counter_1),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_2_c_LC_9_9_2.C_ON=1'b1;
    defparam fsm_proc_un10_r_clk_counter_2_c_LC_9_9_2.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_2_c_LC_9_9_2.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_2_c_LC_9_9_2 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3018),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un10_r_clk_counter_1),
            .carryout(fsm_proc_un10_r_clk_counter_2),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_3_c_LC_9_9_3.C_ON=1'b1;
    defparam fsm_proc_un10_r_clk_counter_3_c_LC_9_9_3.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_3_c_LC_9_9_3.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_3_c_LC_9_9_3 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3000),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un10_r_clk_counter_2),
            .carryout(fsm_proc_un10_r_clk_counter_3),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_4_c_LC_9_9_4.C_ON=1'b1;
    defparam fsm_proc_un10_r_clk_counter_4_c_LC_9_9_4.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_4_c_LC_9_9_4.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_4_c_LC_9_9_4 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2982),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un10_r_clk_counter_3),
            .carryout(fsm_proc_un10_r_clk_counter_4),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_5_c_LC_9_9_5.C_ON=1'b1;
    defparam fsm_proc_un10_r_clk_counter_5_c_LC_9_9_5.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_5_c_LC_9_9_5.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_5_c_LC_9_9_5 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2964),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un10_r_clk_counter_4),
            .carryout(fsm_proc_un10_r_clk_counter_5),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_6_c_LC_9_9_6.C_ON=1'b1;
    defparam fsm_proc_un10_r_clk_counter_6_c_LC_9_9_6.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_6_c_LC_9_9_6.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_6_c_LC_9_9_6 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2943),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un10_r_clk_counter_5),
            .carryout(fsm_proc_un10_r_clk_counter_6),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_7_c_LC_9_9_7.C_ON=1'b1;
    defparam fsm_proc_un10_r_clk_counter_7_c_LC_9_9_7.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_7_c_LC_9_9_7.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_7_c_LC_9_9_7 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2922),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un10_r_clk_counter_6),
            .carryout(fsm_proc_un10_r_clk_counter),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_THRU_LUT4_0_LC_9_10_0.C_ON=1'b0;
    defparam fsm_proc_un10_r_clk_counter_THRU_LUT4_0_LC_9_10_0.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_THRU_LUT4_0_LC_9_10_0.LUT_INIT=16'b1111111100000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_THRU_LUT4_0_LC_9_10_0 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__2901),
            .lcout(fsm_proc_un10_r_clk_counter_THRU_CO),
            .ltout(fsm_proc_un10_r_clk_counter_THRU_CO_cascade_),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un10_r_clk_counter_7_c_RNI1G15_LC_9_10_1.C_ON=1'b0;
    defparam fsm_proc_un10_r_clk_counter_7_c_RNI1G15_LC_9_10_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un10_r_clk_counter_7_c_RNI1G15_LC_9_10_1.LUT_INIT=16'b0000000011000000;
    LogicCell40 fsm_proc_un10_r_clk_counter_7_c_RNI1G15_LC_9_10_1 (
            .in0(_gnd_net_),
            .in1(N__3610),
            .in2(N__2898),
            .in3(N__3410),
            .lcout(n_state_2_sqmuxa),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_state_RNI3JDA_1_LC_9_10_2.C_ON=1'b0;
    defparam r_state_RNI3JDA_1_LC_9_10_2.SEQ_MODE=4'b0000;
    defparam r_state_RNI3JDA_1_LC_9_10_2.LUT_INIT=16'b1010101000000000;
    LogicCell40 r_state_RNI3JDA_1_LC_9_10_2 (
            .in0(N__3611),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__3163),
            .lcout(N_17_0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_state_RNO_0_1_LC_9_10_4.C_ON=1'b0;
    defparam r_state_RNO_0_1_LC_9_10_4.SEQ_MODE=4'b0000;
    defparam r_state_RNO_0_1_LC_9_10_4.LUT_INIT=16'b0111111001011101;
    LogicCell40 r_state_RNO_0_1_LC_9_10_4 (
            .in0(N__3613),
            .in1(N__3186),
            .in2(N__3171),
            .in3(N__3674),
            .lcout(),
            .ltout(N_18_0_cascade_),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_state_1_LC_9_10_5.C_ON=1'b0;
    defparam r_state_1_LC_9_10_5.SEQ_MODE=4'b1000;
    defparam r_state_1_LC_9_10_5.LUT_INIT=16'b0000010101000100;
    LogicCell40 r_state_1_LC_9_10_5 (
            .in0(N__3534),
            .in1(N__3614),
            .in2(N__2877),
            .in3(N__3412),
            .lcout(r_stateZ0Z_1),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4287),
            .ce(),
            .sr(_gnd_net_));
    defparam r_state_RNO_0_0_LC_9_10_6.C_ON=1'b0;
    defparam r_state_RNO_0_0_LC_9_10_6.SEQ_MODE=4'b0000;
    defparam r_state_RNO_0_0_LC_9_10_6.LUT_INIT=16'b0111001011111010;
    LogicCell40 r_state_RNO_0_0_LC_9_10_6 (
            .in0(N__3612),
            .in1(N__3567),
            .in2(N__3170),
            .in3(N__3673),
            .lcout(),
            .ltout(N_21_cascade_),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_state_0_LC_9_10_7.C_ON=1'b0;
    defparam r_state_0_LC_9_10_7.SEQ_MODE=4'b1000;
    defparam r_state_0_LC_9_10_7.LUT_INIT=16'b0000000101000101;
    LogicCell40 r_state_0_LC_9_10_7 (
            .in0(N__3533),
            .in1(N__3411),
            .in2(N__2874),
            .in3(N__3365),
            .lcout(r_stateZ0Z_0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4287),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_0_c_LC_9_11_0.C_ON=1'b1;
    defparam fsm_proc_un6_r_clk_counter_0_c_LC_9_11_0.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_0_c_LC_9_11_0.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_0_c_LC_9_11_0 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3036),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(bfn_9_11_0_),
            .carryout(fsm_proc_un6_r_clk_counter_0),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_1_c_LC_9_11_1.C_ON=1'b1;
    defparam fsm_proc_un6_r_clk_counter_1_c_LC_9_11_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_1_c_LC_9_11_1.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_1_c_LC_9_11_1 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3027),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un6_r_clk_counter_0),
            .carryout(fsm_proc_un6_r_clk_counter_1),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_2_c_LC_9_11_2.C_ON=1'b1;
    defparam fsm_proc_un6_r_clk_counter_2_c_LC_9_11_2.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_2_c_LC_9_11_2.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_2_c_LC_9_11_2 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3017),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un6_r_clk_counter_1),
            .carryout(fsm_proc_un6_r_clk_counter_2),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_3_c_LC_9_11_3.C_ON=1'b1;
    defparam fsm_proc_un6_r_clk_counter_3_c_LC_9_11_3.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_3_c_LC_9_11_3.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_3_c_LC_9_11_3 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2999),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un6_r_clk_counter_2),
            .carryout(fsm_proc_un6_r_clk_counter_3),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_4_c_LC_9_11_4.C_ON=1'b1;
    defparam fsm_proc_un6_r_clk_counter_4_c_LC_9_11_4.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_4_c_LC_9_11_4.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_4_c_LC_9_11_4 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2981),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un6_r_clk_counter_3),
            .carryout(fsm_proc_un6_r_clk_counter_4),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_5_c_LC_9_11_5.C_ON=1'b1;
    defparam fsm_proc_un6_r_clk_counter_5_c_LC_9_11_5.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_5_c_LC_9_11_5.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_5_c_LC_9_11_5 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2960),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un6_r_clk_counter_4),
            .carryout(fsm_proc_un6_r_clk_counter_5),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_6_c_LC_9_11_6.C_ON=1'b1;
    defparam fsm_proc_un6_r_clk_counter_6_c_LC_9_11_6.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_6_c_LC_9_11_6.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_6_c_LC_9_11_6 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2939),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un6_r_clk_counter_5),
            .carryout(fsm_proc_un6_r_clk_counter_6),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_7_c_LC_9_11_7.C_ON=1'b1;
    defparam fsm_proc_un6_r_clk_counter_7_c_LC_9_11_7.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_7_c_LC_9_11_7.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_7_c_LC_9_11_7 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__2918),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un6_r_clk_counter_6),
            .carryout(fsm_proc_un6_r_clk_counter),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_THRU_LUT4_0_LC_9_12_0.C_ON=1'b0;
    defparam fsm_proc_un6_r_clk_counter_THRU_LUT4_0_LC_9_12_0.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_THRU_LUT4_0_LC_9_12_0.LUT_INIT=16'b1111111100000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_THRU_LUT4_0_LC_9_12_0 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__3213),
            .lcout(fsm_proc_un6_r_clk_counter_THRU_CO),
            .ltout(fsm_proc_un6_r_clk_counter_THRU_CO_cascade_),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_7_c_RNIGFOB_LC_9_12_1.C_ON=1'b0;
    defparam fsm_proc_un6_r_clk_counter_7_c_RNIGFOB_LC_9_12_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_7_c_RNIGFOB_LC_9_12_1.LUT_INIT=16'b0011101011001010;
    LogicCell40 fsm_proc_un6_r_clk_counter_7_c_RNIGFOB_LC_9_12_1 (
            .in0(N__3679),
            .in1(N__3137),
            .in2(N__3210),
            .in3(N__3630),
            .lcout(N_23),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_RNO_0_6_LC_9_12_2.C_ON=1'b0;
    defparam r_rx_byte_RNO_0_6_LC_9_12_2.SEQ_MODE=4'b0000;
    defparam r_rx_byte_RNO_0_6_LC_9_12_2.LUT_INIT=16'b0000000010001000;
    LogicCell40 r_rx_byte_RNO_0_6_LC_9_12_2 (
            .in0(N__3913),
            .in1(N__3855),
            .in2(_gnd_net_),
            .in3(N__3318),
            .lcout(N_60),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_RNO_0_2_LC_9_12_3.C_ON=1'b0;
    defparam r_rx_byte_RNO_0_2_LC_9_12_3.SEQ_MODE=4'b0000;
    defparam r_rx_byte_RNO_0_2_LC_9_12_3.LUT_INIT=16'b0001000100000000;
    LogicCell40 r_rx_byte_RNO_0_2_LC_9_12_3 (
            .in0(N__3321),
            .in1(N__3858),
            .in2(_gnd_net_),
            .in3(N__3911),
            .lcout(r_rx_bytece_0_2),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_RNO_0_1_LC_9_12_5.C_ON=1'b0;
    defparam r_rx_byte_RNO_0_1_LC_9_12_5.SEQ_MODE=4'b0000;
    defparam r_rx_byte_RNO_0_1_LC_9_12_5.LUT_INIT=16'b0000000000100010;
    LogicCell40 r_rx_byte_RNO_0_1_LC_9_12_5 (
            .in0(N__3320),
            .in1(N__3857),
            .in2(_gnd_net_),
            .in3(N__3914),
            .lcout(r_rx_bytece_0_1),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_RNO_0_0_LC_9_12_6.C_ON=1'b0;
    defparam r_rx_byte_RNO_0_0_LC_9_12_6.SEQ_MODE=4'b0000;
    defparam r_rx_byte_RNO_0_0_LC_9_12_6.LUT_INIT=16'b0000000000010001;
    LogicCell40 r_rx_byte_RNO_0_0_LC_9_12_6 (
            .in0(N__3912),
            .in1(N__3856),
            .in2(_gnd_net_),
            .in3(N__3319),
            .lcout(r_rx_bytece_0_0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un6_r_clk_counter_7_c_RNIMDD5_LC_9_12_7.C_ON=1'b0;
    defparam fsm_proc_un6_r_clk_counter_7_c_RNIMDD5_LC_9_12_7.SEQ_MODE=4'b0000;
    defparam fsm_proc_un6_r_clk_counter_7_c_RNIMDD5_LC_9_12_7.LUT_INIT=16'b0010001000000000;
    LogicCell40 fsm_proc_un6_r_clk_counter_7_c_RNIMDD5_LC_9_12_7 (
            .in0(N__3634),
            .in1(N__3432),
            .in2(_gnd_net_),
            .in3(N__3185),
            .lcout(n_rx_byte_0_sqmuxa),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_rx_byte_6_LC_9_13_3.C_ON=1'b0;
    defparam r_rx_byte_6_LC_9_13_3.SEQ_MODE=4'b1000;
    defparam r_rx_byte_6_LC_9_13_3.LUT_INIT=16'b1011100011110000;
    LogicCell40 r_rx_byte_6_LC_9_13_3 (
            .in0(N__3144),
            .in1(N__3099),
            .in2(N__3053),
            .in3(N__3093),
            .lcout(o_rx_byte_c_6),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4294),
            .ce(),
            .sr(N__3514));
    defparam fsm_proc_un22_r_clk_counter_1_c_RNO_LC_11_10_0.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_1_c_RNO_LC_11_10_0.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_1_c_RNO_LC_11_10_0.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un22_r_clk_counter_1_c_RNO_LC_11_10_0 (
            .in0(N__3788),
            .in1(N__3740),
            .in2(N__3759),
            .in3(N__3773),
            .lcout(fsm_proc_un22_r_clk_counter_1_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_0_c_RNO_LC_11_10_1.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_0_c_RNO_LC_11_10_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_0_c_RNO_LC_11_10_1.LUT_INIT=16'b0100000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_0_c_RNO_LC_11_10_1 (
            .in0(N__3803),
            .in1(N__3882),
            .in2(N__3295),
            .in3(N__3823),
            .lcout(fsm_proc_un22_r_clk_counter_0_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_2_c_RNO_LC_11_11_1.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_2_c_RNO_LC_11_11_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_2_c_RNO_LC_11_11_1.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un22_r_clk_counter_2_c_RNO_LC_11_11_1 (
            .in0(N__4049),
            .in1(N__4034),
            .in2(N__3726),
            .in3(N__4064),
            .lcout(fsm_proc_un22_r_clk_counter_2_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_3_c_RNO_LC_11_11_2.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_3_c_RNO_LC_11_11_2.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_3_c_RNO_LC_11_11_2.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un22_r_clk_counter_3_c_RNO_LC_11_11_2 (
            .in0(N__3986),
            .in1(N__3971),
            .in2(N__4005),
            .in3(N__4019),
            .lcout(fsm_proc_un22_r_clk_counter_3_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_5_c_RNO_LC_11_11_4.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_5_c_RNO_LC_11_11_4.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_5_c_RNO_LC_11_11_4.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un22_r_clk_counter_5_c_RNO_LC_11_11_4 (
            .in0(N__4103),
            .in1(N__4118),
            .in2(N__4089),
            .in3(N__4133),
            .lcout(fsm_proc_un22_r_clk_counter_5_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_4_c_RNO_LC_11_11_6.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_4_c_RNO_LC_11_11_6.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_4_c_RNO_LC_11_11_6.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un22_r_clk_counter_4_c_RNO_LC_11_11_6 (
            .in0(N__4163),
            .in1(N__4148),
            .in2(N__3942),
            .in3(N__3956),
            .lcout(fsm_proc_un22_r_clk_counter_4_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_0_c_LC_11_12_0.C_ON=1'b1;
    defparam fsm_proc_un22_r_clk_counter_0_c_LC_11_12_0.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_0_c_LC_11_12_0.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_0_c_LC_11_12_0 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3264),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(bfn_11_12_0_),
            .carryout(fsm_proc_un22_r_clk_counter_0),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_1_c_LC_11_12_1.C_ON=1'b1;
    defparam fsm_proc_un22_r_clk_counter_1_c_LC_11_12_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_1_c_LC_11_12_1.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_1_c_LC_11_12_1 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3252),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un22_r_clk_counter_0),
            .carryout(fsm_proc_un22_r_clk_counter_1),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_2_c_LC_11_12_2.C_ON=1'b1;
    defparam fsm_proc_un22_r_clk_counter_2_c_LC_11_12_2.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_2_c_LC_11_12_2.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_2_c_LC_11_12_2 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3240),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un22_r_clk_counter_1),
            .carryout(fsm_proc_un22_r_clk_counter_2),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_3_c_LC_11_12_3.C_ON=1'b1;
    defparam fsm_proc_un22_r_clk_counter_3_c_LC_11_12_3.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_3_c_LC_11_12_3.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_3_c_LC_11_12_3 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3231),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un22_r_clk_counter_2),
            .carryout(fsm_proc_un22_r_clk_counter_3),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_4_c_LC_11_12_4.C_ON=1'b1;
    defparam fsm_proc_un22_r_clk_counter_4_c_LC_11_12_4.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_4_c_LC_11_12_4.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_4_c_LC_11_12_4 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3222),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un22_r_clk_counter_3),
            .carryout(fsm_proc_un22_r_clk_counter_4),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_5_c_LC_11_12_5.C_ON=1'b1;
    defparam fsm_proc_un22_r_clk_counter_5_c_LC_11_12_5.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_5_c_LC_11_12_5.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_5_c_LC_11_12_5 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3708),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un22_r_clk_counter_4),
            .carryout(fsm_proc_un22_r_clk_counter_5),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_6_c_LC_11_12_6.C_ON=1'b1;
    defparam fsm_proc_un22_r_clk_counter_6_c_LC_11_12_6.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_6_c_LC_11_12_6.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_6_c_LC_11_12_6 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__4173),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un22_r_clk_counter_5),
            .carryout(fsm_proc_un22_r_clk_counter_6),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_7_c_LC_11_12_7.C_ON=1'b1;
    defparam fsm_proc_un22_r_clk_counter_7_c_LC_11_12_7.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_7_c_LC_11_12_7.LUT_INIT=16'b0000000000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_7_c_LC_11_12_7 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(N__3696),
            .in3(_gnd_net_),
            .lcout(),
            .ltout(),
            .carryin(fsm_proc_un22_r_clk_counter_6),
            .carryout(fsm_proc_un22_r_clk_counter),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_THRU_LUT4_0_LC_11_13_0.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_THRU_LUT4_0_LC_11_13_0.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_THRU_LUT4_0_LC_11_13_0.LUT_INIT=16'b1111111100000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_THRU_LUT4_0_LC_11_13_0 (
            .in0(_gnd_net_),
            .in1(_gnd_net_),
            .in2(_gnd_net_),
            .in3(N__3699),
            .lcout(fsm_proc_un22_r_clk_counter_THRU_CO),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_7_c_RNO_LC_11_13_5.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_7_c_RNO_LC_11_13_5.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_7_c_RNO_LC_11_13_5.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un22_r_clk_counter_7_c_RNO_LC_11_13_5 (
            .in0(N__4340),
            .in1(N__4307),
            .in2(N__4359),
            .in3(N__4325),
            .lcout(fsm_proc_un22_r_clk_counter_7_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam fsm_proc_un22_r_clk_counter_7_c_RNIMM6B_LC_12_8_1.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_7_c_RNIMM6B_LC_12_8_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_7_c_RNIMM6B_LC_12_8_1.LUT_INIT=16'b1000100000000000;
    LogicCell40 fsm_proc_un22_r_clk_counter_7_c_RNIMM6B_LC_12_8_1 (
            .in0(N__3686),
            .in1(N__3636),
            .in2(_gnd_net_),
            .in3(N__3566),
            .lcout(),
            .ltout(N_27_cascade_),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_state_RNI6KS51_0_LC_12_8_2.C_ON=1'b0;
    defparam r_state_RNI6KS51_0_LC_12_8_2.SEQ_MODE=4'b0000;
    defparam r_state_RNI6KS51_0_LC_12_8_2.LUT_INIT=16'b1111111010111010;
    LogicCell40 r_state_RNI6KS51_0_LC_12_8_2 (
            .in0(N__3542),
            .in1(N__3437),
            .in2(N__3369),
            .in3(N__3366),
            .lcout(r_state_RNI6KS51Z0Z_0),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
    defparam r_bit_counter_0_LC_12_9_0.C_ON=1'b1;
    defparam r_bit_counter_0_LC_12_9_0.SEQ_MODE=4'b1000;
    defparam r_bit_counter_0_LC_12_9_0.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_0_LC_12_9_0 (
            .in0(_gnd_net_),
            .in1(N__3288),
            .in2(N__3342),
            .in3(N__3341),
            .lcout(r_bit_counterZ0Z_0),
            .ltout(),
            .carryin(bfn_12_9_0_),
            .carryout(un1_r_bit_counter_1_cry_0),
            .clk(N__4291),
            .ce(),
            .sr(N__4239));
    defparam r_bit_counter_1_LC_12_9_1.C_ON=1'b1;
    defparam r_bit_counter_1_LC_12_9_1.SEQ_MODE=4'b1000;
    defparam r_bit_counter_1_LC_12_9_1.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_1_LC_12_9_1 (
            .in0(_gnd_net_),
            .in1(N__3883),
            .in2(_gnd_net_),
            .in3(N__3861),
            .lcout(r_bit_counterZ0Z_1),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_0),
            .carryout(un1_r_bit_counter_1_cry_1),
            .clk(N__4291),
            .ce(),
            .sr(N__4239));
    defparam r_bit_counter_2_LC_12_9_2.C_ON=1'b1;
    defparam r_bit_counter_2_LC_12_9_2.SEQ_MODE=4'b1000;
    defparam r_bit_counter_2_LC_12_9_2.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_2_LC_12_9_2 (
            .in0(_gnd_net_),
            .in1(N__3824),
            .in2(_gnd_net_),
            .in3(N__3807),
            .lcout(r_bit_counterZ0Z_2),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_1),
            .carryout(un1_r_bit_counter_1_cry_2),
            .clk(N__4291),
            .ce(),
            .sr(N__4239));
    defparam r_bit_counter_3_LC_12_9_3.C_ON=1'b1;
    defparam r_bit_counter_3_LC_12_9_3.SEQ_MODE=4'b1000;
    defparam r_bit_counter_3_LC_12_9_3.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_3_LC_12_9_3 (
            .in0(_gnd_net_),
            .in1(N__3804),
            .in2(_gnd_net_),
            .in3(N__3792),
            .lcout(r_bit_counterZ0Z_3),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_2),
            .carryout(un1_r_bit_counter_1_cry_3),
            .clk(N__4291),
            .ce(),
            .sr(N__4239));
    defparam r_bit_counter_4_LC_12_9_4.C_ON=1'b1;
    defparam r_bit_counter_4_LC_12_9_4.SEQ_MODE=4'b1000;
    defparam r_bit_counter_4_LC_12_9_4.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_4_LC_12_9_4 (
            .in0(_gnd_net_),
            .in1(N__3789),
            .in2(_gnd_net_),
            .in3(N__3777),
            .lcout(r_bit_counterZ0Z_4),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_3),
            .carryout(un1_r_bit_counter_1_cry_4),
            .clk(N__4291),
            .ce(),
            .sr(N__4239));
    defparam r_bit_counter_5_LC_12_9_5.C_ON=1'b1;
    defparam r_bit_counter_5_LC_12_9_5.SEQ_MODE=4'b1000;
    defparam r_bit_counter_5_LC_12_9_5.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_5_LC_12_9_5 (
            .in0(_gnd_net_),
            .in1(N__3774),
            .in2(_gnd_net_),
            .in3(N__3762),
            .lcout(r_bit_counterZ0Z_5),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_4),
            .carryout(un1_r_bit_counter_1_cry_5),
            .clk(N__4291),
            .ce(),
            .sr(N__4239));
    defparam r_bit_counter_6_LC_12_9_6.C_ON=1'b1;
    defparam r_bit_counter_6_LC_12_9_6.SEQ_MODE=4'b1000;
    defparam r_bit_counter_6_LC_12_9_6.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_6_LC_12_9_6 (
            .in0(_gnd_net_),
            .in1(N__3758),
            .in2(_gnd_net_),
            .in3(N__3744),
            .lcout(r_bit_counterZ0Z_6),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_5),
            .carryout(un1_r_bit_counter_1_cry_6),
            .clk(N__4291),
            .ce(),
            .sr(N__4239));
    defparam r_bit_counter_7_LC_12_9_7.C_ON=1'b1;
    defparam r_bit_counter_7_LC_12_9_7.SEQ_MODE=4'b1000;
    defparam r_bit_counter_7_LC_12_9_7.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_7_LC_12_9_7 (
            .in0(_gnd_net_),
            .in1(N__3741),
            .in2(_gnd_net_),
            .in3(N__3729),
            .lcout(r_bit_counterZ0Z_7),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_6),
            .carryout(un1_r_bit_counter_1_cry_7),
            .clk(N__4291),
            .ce(),
            .sr(N__4239));
    defparam r_bit_counter_8_LC_12_10_0.C_ON=1'b1;
    defparam r_bit_counter_8_LC_12_10_0.SEQ_MODE=4'b1000;
    defparam r_bit_counter_8_LC_12_10_0.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_8_LC_12_10_0 (
            .in0(_gnd_net_),
            .in1(N__3725),
            .in2(_gnd_net_),
            .in3(N__3711),
            .lcout(r_bit_counterZ0Z_8),
            .ltout(),
            .carryin(bfn_12_10_0_),
            .carryout(un1_r_bit_counter_1_cry_8),
            .clk(N__4293),
            .ce(),
            .sr(N__4240));
    defparam r_bit_counter_9_LC_12_10_1.C_ON=1'b1;
    defparam r_bit_counter_9_LC_12_10_1.SEQ_MODE=4'b1000;
    defparam r_bit_counter_9_LC_12_10_1.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_9_LC_12_10_1 (
            .in0(_gnd_net_),
            .in1(N__4065),
            .in2(_gnd_net_),
            .in3(N__4053),
            .lcout(r_bit_counterZ0Z_9),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_8),
            .carryout(un1_r_bit_counter_1_cry_9),
            .clk(N__4293),
            .ce(),
            .sr(N__4240));
    defparam r_bit_counter_10_LC_12_10_2.C_ON=1'b1;
    defparam r_bit_counter_10_LC_12_10_2.SEQ_MODE=4'b1000;
    defparam r_bit_counter_10_LC_12_10_2.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_10_LC_12_10_2 (
            .in0(_gnd_net_),
            .in1(N__4050),
            .in2(_gnd_net_),
            .in3(N__4038),
            .lcout(r_bit_counterZ0Z_10),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_9),
            .carryout(un1_r_bit_counter_1_cry_10),
            .clk(N__4293),
            .ce(),
            .sr(N__4240));
    defparam r_bit_counter_11_LC_12_10_3.C_ON=1'b1;
    defparam r_bit_counter_11_LC_12_10_3.SEQ_MODE=4'b1000;
    defparam r_bit_counter_11_LC_12_10_3.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_11_LC_12_10_3 (
            .in0(_gnd_net_),
            .in1(N__4035),
            .in2(_gnd_net_),
            .in3(N__4023),
            .lcout(r_bit_counterZ0Z_11),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_10),
            .carryout(un1_r_bit_counter_1_cry_11),
            .clk(N__4293),
            .ce(),
            .sr(N__4240));
    defparam r_bit_counter_12_LC_12_10_4.C_ON=1'b1;
    defparam r_bit_counter_12_LC_12_10_4.SEQ_MODE=4'b1000;
    defparam r_bit_counter_12_LC_12_10_4.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_12_LC_12_10_4 (
            .in0(_gnd_net_),
            .in1(N__4020),
            .in2(_gnd_net_),
            .in3(N__4008),
            .lcout(r_bit_counterZ0Z_12),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_11),
            .carryout(un1_r_bit_counter_1_cry_12),
            .clk(N__4293),
            .ce(),
            .sr(N__4240));
    defparam r_bit_counter_13_LC_12_10_5.C_ON=1'b1;
    defparam r_bit_counter_13_LC_12_10_5.SEQ_MODE=4'b1000;
    defparam r_bit_counter_13_LC_12_10_5.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_13_LC_12_10_5 (
            .in0(_gnd_net_),
            .in1(N__4004),
            .in2(_gnd_net_),
            .in3(N__3990),
            .lcout(r_bit_counterZ0Z_13),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_12),
            .carryout(un1_r_bit_counter_1_cry_13),
            .clk(N__4293),
            .ce(),
            .sr(N__4240));
    defparam r_bit_counter_14_LC_12_10_6.C_ON=1'b1;
    defparam r_bit_counter_14_LC_12_10_6.SEQ_MODE=4'b1000;
    defparam r_bit_counter_14_LC_12_10_6.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_14_LC_12_10_6 (
            .in0(_gnd_net_),
            .in1(N__3987),
            .in2(_gnd_net_),
            .in3(N__3975),
            .lcout(r_bit_counterZ0Z_14),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_13),
            .carryout(un1_r_bit_counter_1_cry_14),
            .clk(N__4293),
            .ce(),
            .sr(N__4240));
    defparam r_bit_counter_15_LC_12_10_7.C_ON=1'b1;
    defparam r_bit_counter_15_LC_12_10_7.SEQ_MODE=4'b1000;
    defparam r_bit_counter_15_LC_12_10_7.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_15_LC_12_10_7 (
            .in0(_gnd_net_),
            .in1(N__3972),
            .in2(_gnd_net_),
            .in3(N__3960),
            .lcout(r_bit_counterZ0Z_15),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_14),
            .carryout(un1_r_bit_counter_1_cry_15),
            .clk(N__4293),
            .ce(),
            .sr(N__4240));
    defparam r_bit_counter_16_LC_12_11_0.C_ON=1'b1;
    defparam r_bit_counter_16_LC_12_11_0.SEQ_MODE=4'b1000;
    defparam r_bit_counter_16_LC_12_11_0.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_16_LC_12_11_0 (
            .in0(_gnd_net_),
            .in1(N__3957),
            .in2(_gnd_net_),
            .in3(N__3945),
            .lcout(r_bit_counterZ0Z_16),
            .ltout(),
            .carryin(bfn_12_11_0_),
            .carryout(un1_r_bit_counter_1_cry_16),
            .clk(N__4295),
            .ce(),
            .sr(N__4241));
    defparam r_bit_counter_17_LC_12_11_1.C_ON=1'b1;
    defparam r_bit_counter_17_LC_12_11_1.SEQ_MODE=4'b1000;
    defparam r_bit_counter_17_LC_12_11_1.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_17_LC_12_11_1 (
            .in0(_gnd_net_),
            .in1(N__3941),
            .in2(_gnd_net_),
            .in3(N__3927),
            .lcout(r_bit_counterZ0Z_17),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_16),
            .carryout(un1_r_bit_counter_1_cry_17),
            .clk(N__4295),
            .ce(),
            .sr(N__4241));
    defparam r_bit_counter_18_LC_12_11_2.C_ON=1'b1;
    defparam r_bit_counter_18_LC_12_11_2.SEQ_MODE=4'b1000;
    defparam r_bit_counter_18_LC_12_11_2.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_18_LC_12_11_2 (
            .in0(_gnd_net_),
            .in1(N__4164),
            .in2(_gnd_net_),
            .in3(N__4152),
            .lcout(r_bit_counterZ0Z_18),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_17),
            .carryout(un1_r_bit_counter_1_cry_18),
            .clk(N__4295),
            .ce(),
            .sr(N__4241));
    defparam r_bit_counter_19_LC_12_11_3.C_ON=1'b1;
    defparam r_bit_counter_19_LC_12_11_3.SEQ_MODE=4'b1000;
    defparam r_bit_counter_19_LC_12_11_3.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_19_LC_12_11_3 (
            .in0(_gnd_net_),
            .in1(N__4149),
            .in2(_gnd_net_),
            .in3(N__4137),
            .lcout(r_bit_counterZ0Z_19),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_18),
            .carryout(un1_r_bit_counter_1_cry_19),
            .clk(N__4295),
            .ce(),
            .sr(N__4241));
    defparam r_bit_counter_20_LC_12_11_4.C_ON=1'b1;
    defparam r_bit_counter_20_LC_12_11_4.SEQ_MODE=4'b1000;
    defparam r_bit_counter_20_LC_12_11_4.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_20_LC_12_11_4 (
            .in0(_gnd_net_),
            .in1(N__4134),
            .in2(_gnd_net_),
            .in3(N__4122),
            .lcout(r_bit_counterZ0Z_20),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_19),
            .carryout(un1_r_bit_counter_1_cry_20),
            .clk(N__4295),
            .ce(),
            .sr(N__4241));
    defparam r_bit_counter_21_LC_12_11_5.C_ON=1'b1;
    defparam r_bit_counter_21_LC_12_11_5.SEQ_MODE=4'b1000;
    defparam r_bit_counter_21_LC_12_11_5.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_21_LC_12_11_5 (
            .in0(_gnd_net_),
            .in1(N__4119),
            .in2(_gnd_net_),
            .in3(N__4107),
            .lcout(r_bit_counterZ0Z_21),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_20),
            .carryout(un1_r_bit_counter_1_cry_21),
            .clk(N__4295),
            .ce(),
            .sr(N__4241));
    defparam r_bit_counter_22_LC_12_11_6.C_ON=1'b1;
    defparam r_bit_counter_22_LC_12_11_6.SEQ_MODE=4'b1000;
    defparam r_bit_counter_22_LC_12_11_6.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_22_LC_12_11_6 (
            .in0(_gnd_net_),
            .in1(N__4104),
            .in2(_gnd_net_),
            .in3(N__4092),
            .lcout(r_bit_counterZ0Z_22),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_21),
            .carryout(un1_r_bit_counter_1_cry_22),
            .clk(N__4295),
            .ce(),
            .sr(N__4241));
    defparam r_bit_counter_23_LC_12_11_7.C_ON=1'b1;
    defparam r_bit_counter_23_LC_12_11_7.SEQ_MODE=4'b1000;
    defparam r_bit_counter_23_LC_12_11_7.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_23_LC_12_11_7 (
            .in0(_gnd_net_),
            .in1(N__4088),
            .in2(_gnd_net_),
            .in3(N__4074),
            .lcout(r_bit_counterZ0Z_23),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_22),
            .carryout(un1_r_bit_counter_1_cry_23),
            .clk(N__4295),
            .ce(),
            .sr(N__4241));
    defparam r_bit_counter_24_LC_12_12_0.C_ON=1'b1;
    defparam r_bit_counter_24_LC_12_12_0.SEQ_MODE=4'b1000;
    defparam r_bit_counter_24_LC_12_12_0.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_24_LC_12_12_0 (
            .in0(_gnd_net_),
            .in1(N__4199),
            .in2(_gnd_net_),
            .in3(N__4071),
            .lcout(r_bit_counterZ0Z_24),
            .ltout(),
            .carryin(bfn_12_12_0_),
            .carryout(un1_r_bit_counter_1_cry_24),
            .clk(N__4296),
            .ce(),
            .sr(N__4242));
    defparam r_bit_counter_25_LC_12_12_1.C_ON=1'b1;
    defparam r_bit_counter_25_LC_12_12_1.SEQ_MODE=4'b1000;
    defparam r_bit_counter_25_LC_12_12_1.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_25_LC_12_12_1 (
            .in0(_gnd_net_),
            .in1(N__4212),
            .in2(_gnd_net_),
            .in3(N__4068),
            .lcout(r_bit_counterZ0Z_25),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_24),
            .carryout(un1_r_bit_counter_1_cry_25),
            .clk(N__4296),
            .ce(),
            .sr(N__4242));
    defparam r_bit_counter_26_LC_12_12_2.C_ON=1'b1;
    defparam r_bit_counter_26_LC_12_12_2.SEQ_MODE=4'b1000;
    defparam r_bit_counter_26_LC_12_12_2.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_26_LC_12_12_2 (
            .in0(_gnd_net_),
            .in1(N__4224),
            .in2(_gnd_net_),
            .in3(N__4365),
            .lcout(r_bit_counterZ0Z_26),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_25),
            .carryout(un1_r_bit_counter_1_cry_26),
            .clk(N__4296),
            .ce(),
            .sr(N__4242));
    defparam r_bit_counter_27_LC_12_12_3.C_ON=1'b1;
    defparam r_bit_counter_27_LC_12_12_3.SEQ_MODE=4'b1000;
    defparam r_bit_counter_27_LC_12_12_3.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_27_LC_12_12_3 (
            .in0(_gnd_net_),
            .in1(N__4185),
            .in2(_gnd_net_),
            .in3(N__4362),
            .lcout(r_bit_counterZ0Z_27),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_26),
            .carryout(un1_r_bit_counter_1_cry_27),
            .clk(N__4296),
            .ce(),
            .sr(N__4242));
    defparam r_bit_counter_28_LC_12_12_4.C_ON=1'b1;
    defparam r_bit_counter_28_LC_12_12_4.SEQ_MODE=4'b1000;
    defparam r_bit_counter_28_LC_12_12_4.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_28_LC_12_12_4 (
            .in0(_gnd_net_),
            .in1(N__4358),
            .in2(_gnd_net_),
            .in3(N__4344),
            .lcout(r_bit_counterZ0Z_28),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_27),
            .carryout(un1_r_bit_counter_1_cry_28),
            .clk(N__4296),
            .ce(),
            .sr(N__4242));
    defparam r_bit_counter_29_LC_12_12_5.C_ON=1'b1;
    defparam r_bit_counter_29_LC_12_12_5.SEQ_MODE=4'b1000;
    defparam r_bit_counter_29_LC_12_12_5.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_29_LC_12_12_5 (
            .in0(_gnd_net_),
            .in1(N__4341),
            .in2(_gnd_net_),
            .in3(N__4329),
            .lcout(r_bit_counterZ0Z_29),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_28),
            .carryout(un1_r_bit_counter_1_cry_29),
            .clk(N__4296),
            .ce(),
            .sr(N__4242));
    defparam r_bit_counter_30_LC_12_12_6.C_ON=1'b1;
    defparam r_bit_counter_30_LC_12_12_6.SEQ_MODE=4'b1000;
    defparam r_bit_counter_30_LC_12_12_6.LUT_INIT=16'b1001100101100110;
    LogicCell40 r_bit_counter_30_LC_12_12_6 (
            .in0(_gnd_net_),
            .in1(N__4326),
            .in2(_gnd_net_),
            .in3(N__4314),
            .lcout(r_bit_counterZ0Z_30),
            .ltout(),
            .carryin(un1_r_bit_counter_1_cry_29),
            .carryout(un1_r_bit_counter_1_cry_30),
            .clk(N__4296),
            .ce(),
            .sr(N__4242));
    defparam r_bit_counter_31_LC_12_12_7.C_ON=1'b0;
    defparam r_bit_counter_31_LC_12_12_7.SEQ_MODE=4'b1000;
    defparam r_bit_counter_31_LC_12_12_7.LUT_INIT=16'b0011001111001100;
    LogicCell40 r_bit_counter_31_LC_12_12_7 (
            .in0(_gnd_net_),
            .in1(N__4308),
            .in2(_gnd_net_),
            .in3(N__4311),
            .lcout(r_bit_counterZ0Z_31),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(N__4296),
            .ce(),
            .sr(N__4242));
    defparam fsm_proc_un22_r_clk_counter_6_c_RNO_LC_12_13_1.C_ON=1'b0;
    defparam fsm_proc_un22_r_clk_counter_6_c_RNO_LC_12_13_1.SEQ_MODE=4'b0000;
    defparam fsm_proc_un22_r_clk_counter_6_c_RNO_LC_12_13_1.LUT_INIT=16'b0000000000000001;
    LogicCell40 fsm_proc_un22_r_clk_counter_6_c_RNO_LC_12_13_1 (
            .in0(N__4223),
            .in1(N__4211),
            .in2(N__4200),
            .in3(N__4184),
            .lcout(fsm_proc_un22_r_clk_counter_6_and),
            .ltout(),
            .carryin(_gnd_net_),
            .carryout(),
            .clk(_gnd_net_),
            .ce(),
            .sr(_gnd_net_));
endmodule // uart_rx
