# iCE40UP5K Logic Analyzer, Rev2
# Synopsys Design Constraints
# Using frequency 52.8MHz to acccount for internal oscillator (48MHz) with tolerance of +- 10%

create_clock -name clk52 -period 18.939 [get_nets {E1.o_clk}]

# The 16 capture inputs are asynchronous to clk52 (external logic analyzer pins, no relationship to the FPGA
# clock). 2-FF synchronised in capture_engine.vhd (sync_proc, r_inputs_sync_1/r_inputs_sync_2) before any use.
set_false_path -from [get_ports {i_LA0 i_LA1 i_LA2 i_LA3 i_LA4 i_LA5 i_LA6 i_LA7 \
                                  i_LA8 i_LA9 i_LA10 i_LA11 i_LA12 i_LA13 i_LA14 i_LA15}]

# i_UART_RX is asynchronous to clk52 (serial line from the FTDI bridge, no relationship to the FPGA clock).
# 2-FF synchronised in uart_rx.vhd (sync_proc, r_rx_sync_1/r_rx_sync_2).
set_false_path -from [get_ports {i_UART_RX}]

# i_FTDI_CTS_N is asynchronous to clk52 (FT2232H flow-control pin, no relationship to the FPGA clock).
# 2-FF synchronised in uart_tx.vhd (sync_proc, r_usb_can_accept_sync_1/s_usb_can_accept).
set_false_path -from [get_ports {i_FTDI_CTS_N}]
