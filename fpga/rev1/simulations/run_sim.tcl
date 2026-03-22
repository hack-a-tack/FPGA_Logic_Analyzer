# quit previous sim
quit -sim

vlib work
vmap work work

vcom -2008 rtl/uart_tx.vhd
vcom -2008 rtl/uart_tx_tb.vhd

# simulate
vsim work.uart_tx_tb
#add wave sim:/uart_tx_tb/*
run -all