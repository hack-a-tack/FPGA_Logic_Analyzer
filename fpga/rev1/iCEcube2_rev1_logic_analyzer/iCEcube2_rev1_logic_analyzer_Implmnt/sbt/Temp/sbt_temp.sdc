####---- CreateClock list ----1
create_clock  -period 1000.00 -waveform {0.00 500.00} -name {cmd_parser|i_clk} [get_ports {i_clk}] 

