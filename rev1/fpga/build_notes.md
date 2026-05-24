# Rev1 FPGA Build Notes

## Toolchain
- Lattice iCEcube2 version: release 2020.12.27943
- Device family: iCE40UP
- Device: 5K
- Package: SG48
- Part: ICE40UP5K-SG48I
- Project top module: top.vhd

## Source files
RTL files included:
- clocking.vhd
- uart_rx.vhd
- cmd_parser.vhd
- capture_engine.vhd
- trace_buffer.vhd
- send_engine.vhd
- analyzer_fsm.vhd
- tx_mux.vhd
- uart_tx.vhd
- top.vhd

Constraint files:
- top.pcf
- top.sdc

## Build flow
1. Open iCEcube2 project.
2. Confirm all RTL files are included.
3. Confirm PCF and SDC files are included.
4. Run synthesis, placement, routing, and bitmap generation.
5. Use generated `top_bitmap.bin` for SPI flash programming.

## Notes / gotchas
- Internal SB_HFOSC used as 48 MHz system clock.
- Sampling tick derived internally.
- SDC clock constraint applied to HFOSC output.
- Lattice primitive simulation not covered by ModelSim testbenches. SB_HFOSC.vhd used for simulating primitive.
