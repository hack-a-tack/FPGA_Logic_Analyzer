#FPGA Logic Analyzer — CONTEXT KEY (Rev1)
Status (as of 2026-04-12)
Rev1 FPGA RTL implemented, compiles, synthesizes, bitstream generated.
All modules have individual testbenches; all pass simulation (ModelSim).
Top-level integration TB created; verifies reset/idle, capture, read, back-to-back commands, and bad UART frame resilience; passes.
All module TBs pass + top-level TB passes:
reset/idle, capture, read (partial), back-to-back command response logic, bad UART stop-bit resilience
note: back-to-back READ during CAPTURE returns ERROR by design; READ must be resent after DONE.
PC host tool (host/la_host.py) implemented: capture/read + CSV output, optional VCD export; --list-ports added; awaiting hardware for validation.
Hardware assembly pending (tools/instruments not yet arrived).

#System Summary
Target FPGA: Lattice iCE40UP5K (SG48)
Clock: internal SB_HFOSC nominal 48 MHz
Sampling: 24 MHz effective via samp_tick enable (every 2 clk cycles)
Channels: 8 digital inputs (LA0..LA7)
Capture depth: 4096 samples (4096 bytes)
UART: 921600 baud, 8N1

#UART Protocol
Commands PC→FPGA (1 byte):

CAPTURE = 0xA0
READ = 0xA1

FPGA responses:

OK = 0x55
DONE = 0x77
HEADER = 0x99
ERROR = 0xEE
WATCHDOG TRIGGER = 0xDD

READ stream format:

0x99 header
4096 data bytes (each byte = LA[7:0] sampled)

Behavior notes:

READ while capture not complete returns ERROR (0xEE).
Back-to-back commands are handled; invalid/unknown opcodes return ERROR.

#Module Architecture (RTL)
clocking.vhd: SB_HFOSC → clk_int (48 MHz), samp_tick enable at 24 MHz.
uart_rx.vhd: 2FF sync, mid-bit start check, LSB-first, stop-bit checked mid-bit; does not exit stop-bit early on error.
cmd_parser.vhd: decodes rx bytes into command pulses (CAPTURE/READ), errors on unknown.
capture_engine.vhd: writes first sample on capture_start_pulse at addr 0; then writes on each samp_tick; ignores start while busy; emits done pulse; resets addr to 0 on exit.
trace_buffer.vhd: synchronous read, separate rd/wr addrs; EBR inferred (4096x8 mapped to 8 RAM blocks in reports).
send_engine.vhd: sends HEADER then streams RAM data; handles sync RAM latency via state sequencing; no “first_sample” special-case.
analyzer_fsm.vhd: orchestrates capture/send and status bytes, includes watchdog; pending status byte handling when UART busy.
tx_mux.vhd: registered arbiter: FSM status has priority over send stream.
uart_tx.vhd: LSB-first, CLKS_PER_BIT = 52 (48 MHz / 921600), busy deassert cleaned up.

#Timing / STA Metrics (Rev1)
After watchdog counter width reduction to 22 bits and watchdog timeout was made registered:
WNS = +2.997 ns
Fmax ≈ 55.72 MHz
Previously failing path was watchdog compare logic; reduced counter width fixed closure for 48 MHz target.

#Resource Usage (Rev1)
LUTs: 250
DFFs: 142
BRAM/RAM blocks: 8
DSPs: 0
IOs used: 14
HFOSC: 1

#Host Tool (Python)

Location: host/la_host.py

Uses pyserial.
Modes: capture / read / capture-read / self-test.
flags: --list-ports, --vcd, --samplerate, --out, --samples
Outputs:
CSV: columns index,value (0..4095, 0..255)
Optional VCD: LA0..LA7 signals, timestamps based on --samplerate (default 24e6)
--list-ports lists available serial ports with descriptions.
Default port placeholder: COM3 (update once hardware enumerates).

#Bring-up
docs/bringup.md created.
Includes:
Hardware assembly + power rail validation (5V, 3.3V, 1.2V).
Confirm COM port enumerates; run host tool:
CAPTURE → expect 0x55 then 0x77
READ → expect 0x99 + 4096 bytes
Simple input tests:
all low → expect 0x00
all high → expect 0xFF
single toggling input → corresponding bit toggles
Import VCD into PulseView/GTKWave for waveform inspection.

#Next Steps (Bring-up)
(1) waiting for PCBA tools, (2) first bring-up steps (Phase 0→3), (3) first known-input tests (all-low/all-high/single-bit).