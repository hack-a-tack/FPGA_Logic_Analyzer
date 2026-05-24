# quit previous sim
#quit -sim

#vlib work
#vmap work work

# simulate
vsim -gui work.top_tb
add wave sim:/top_tb/*


# Signals needed to gauge latencies
add wave sim:/top_tb/dut/E3/o_capture_cmd_pulse
add wave sim:/top_tb/dut/E3/o_read_cmd_pulse
add wave sim:/top_tb/dut/E3/o_cmd_error_pulse
add wave sim:/top_tb/dut/E4/o_fsm_tx_start_pulse
add wave sim:/top_tb/dut/E5/o_capture_done_pulse
add wave sim:/top_tb/dut/E6/o_send_tx_start_pulse
add wave sim:/top_tb/dut/E6/i_tx_busy
add wave sim:/top_tb/dut/E8/o_mux_tx_start_pulse
add wave sim:/top_tb/dut/E9/o_tx_busy

configure wave -timelineunits ns

run -all