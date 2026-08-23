create_clock -period 18.94 -name {clk52} -waveform [list 0.00 9.47] [get_pins E1.HF_OSC/CLKHF]
set_false_path -from [get_ports [list i_LA0 i_LA1 i_LA2 i_LA3 i_LA4 i_LA5 i_LA6 i_LA7 i_LA8 i_LA9 i_LA10 i_LA11 i_LA12 i_LA13 i_LA14 i_LA15]]
set_false_path -from [get_ports i_UART_RX]
set_false_path -from [get_ports i_FTDI_CTS_N]
