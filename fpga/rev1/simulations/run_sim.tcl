# quit previous sim
#quit -sim

#vlib work
#vmap work work

# simulate
vsim -gui work.tx_mux_tb
add wave sim:/tx_mux_tb/*
run -all