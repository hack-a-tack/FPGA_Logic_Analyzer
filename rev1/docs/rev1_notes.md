#FPGA Logic Analyzer — CONTEXT KEY (Rev1 Notes)

##System Summary
Target FPGA: Lattice iCE40UP5K (SG48)
Clock: internal SB_HFOSC nominal 48 MHz
Sampling: 24 MHz effective via samp_tick enable (every 2 clk cycles)
Channels: 8 digital inputs (LA0..LA7)
Capture depth: 4096 samples (4096 bytes)
UART: 921600 baud, 8N1

##UART Protocol
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

##Module Architecture (RTL)
clocking.vhd: SB_HFOSC → clk_int (48 MHz), samp_tick enable at 24 MHz.
uart_rx.vhd: 2FF sync, mid-bit start check, LSB-first, stop-bit checked mid-bit; does not exit stop-bit early on error.
cmd_parser.vhd: decodes rx bytes into command pulses (CAPTURE/READ), errors on unknown.
capture_engine.vhd: writes first sample on capture_start_pulse at addr 0; then writes on each samp_tick; ignores start while busy; emits done pulse; resets addr to 0 on exit.
trace_buffer.vhd: synchronous read, separate rd/wr addrs; EBR inferred (4096x8 mapped to 8 RAM blocks in reports).
send_engine.vhd: sends HEADER then streams RAM data; handles sync RAM latency via state sequencing; no “first_sample” special-case.
analyzer_fsm.vhd: orchestrates capture/send and status bytes, includes watchdog; pending status byte handling when UART busy.
tx_mux.vhd: registered arbiter: FSM status has priority over send stream.
uart_tx.vhd: LSB-first, CLKS_PER_BIT = 52 (48 MHz / 921600), busy deassert cleaned up.

##Rev1 status

Rev1 is complete and hardware-validated.

Board bring-up passed through:

power rail validation
USB-UART enumeration
SPI flash programming
FPGA boot/configuration
UART command protocol smoke testing
static input validation
dynamic waveform validation
error-handling checks
repeated reliability/soak testing

The final board works reliably over USB-UART and captures 8-bit digital samples into FPGA BRAM, then transfers captured data to the host over UART.

##Major Rev1 hardware bring-up lessons

Rev1 exposed several practical PCB/hardware lessons:

Fine-pitch/QFN assembly is manageable with microscope inspection, conservative solder paste, flux, solder wick, and hot air rework.
DIP switches may not tolerate the chosen reflow profile; hand-solder or use more robust THT/mechanical parts in future revisions.
CDONE is open-drain and should not directly drive an LED to ground. Rev2 should use a correct pullup/indicator arrangement, likely with a transistor/MOSFET LED driver.
Resistance/continuity probing must only be done on unpowered circuits. Live resistance checks produce false readings.
In-circuit resistance readings can be misleading because parallel board paths affect the result.
Backpowering through programmer signal pins is real and should be avoided by clearer programming-header/power-domain handling.
Dedicated test pads, debug LEDs, and spare debug pins are extremely valuable and should be planned from the schematic stage.


##Programming/configuration lessons

Initial Diamond Programmer / FTDI-based SPI flash programming was unreliable or incompatible in this setup.

Final working programming method:

hold FPGA in reset using CRESET_B
power board normally
use Arduino as SPI flash programmer
send bitstream from Python script through Arduino
use voltage dividers on Arduino-driven SPI lines to keep signals at 3.3 V
program external SPI flash
release CRESET_B so FPGA boots from flash

SPI flash communication was verified using JEDEC ID readback: 0xEF 0x40 0x13.

Key lesson: for Rev2, keep the programming path simple and deliberate. Either preserve the proven Arduino/Python method with a cleaner header, or add a better-defined programming interface. Do not add complexity unless it directly improves bring-up reliability.

##Rev1 RTL / firmware lessons

Important RTL/debug lessons:

Reset polarity must be unambiguous across schematic, VHDL, testbenches, and physical DIP-switch behavior.
UART/protocol watchdogs must be kicked on meaningful progress, not only full transaction completion.
Long UART transfers require progress-aware timeout logic.
send_engine needed correct busy/handshake handling to avoid READ-path issues.
Simulation is useful, but hardware timing/debug pins are needed to validate real behavior.
Exposing internal FPGA signals on reusable pins after configuration is very valuable for measuring latency and debugging.

##Rev1 final validated behavior

Basic command protocol works:

CAPTURE returns 0x55 OK, then 0x77 DONE
READ returns 0x99 HEADER, then 4096 payload bytes
capture-read creates valid CSV/VCD outputs
error handling works:
READ before capture returns 0xEE
unknown opcode returns 0xEE
invalid commands do not corrupt state
valid capture works after an error

##Static input validation

Static tests passed:

all inputs low → all samples 0x00
all inputs high → all samples 0xFF
one-hot inputs verified correct bit order:
LA0 → 0x01
LA1 → 0x02
LA2 → 0x04
LA3 → 0x08
LA4 → 0x10
LA5 → 0x20
LA6 → 0x40
LA7 → 0x80

Floating inputs are undefined and not meaningful for captures.

##Dynamic input validation

Dynamic LA0 square-wave tests:

100 kHz: clean, about 240 samples/period
1 MHz: clean, about 24 samples/period
5 MHz: frequency-deducible but visibly quantized
8–10 MHz: near-limit behavior with strong sample-grid effects

Practical Rev1 clean/frequency-deducible square-wave bandwidth: about 5 MHz.

Theoretical Nyquist limit at 24 MS/s: 12 MHz, but this is not a clean square-wave capture limit.

Two-channel LA0/LA1 test passed:

stable divide-by-2 relationship
channels captured in the same sample word
no observed sample-word/channel skew

##Rev1 measured metrics

Core design specs:

channels: 8 digital inputs
capture depth: 4096 samples
nominal sample rate: 24 MS/s
nominal sample period: 41.67 ns
nominal max capture window: 170.67 µs
UART baud: 921600 baud, 8N1

Measured sampling:

measured sample rate: 24.03 MS/s
measured sample period: 41.61 ns
deviation from nominal: +0.13%
measured max capture window: 170.44 µs

Measured transfer:

theoretical UART transfer time including 1-byte header: 44.46 ms
measured wire-level transfer time: 44.64 ms
measured payload throughput: 91.75 kB/s
measured effective line throughput: 917.7 kbit/s

Measured host-visible acquisition cycle:

mean end-to-end capture-read cycle: 49.47 ms
range: 49.05–50.01 ms
standard deviation: about 0.26 ms
method: Python host timing from before CAPTURE command write to final expected payload byte received

##Rev1 latency metrics

Measured/sim-aligned latency values:

capture acknowledge latency: about 60 ns
capture command to DONE response: about 170.24 µs
capture complete to DONE byte TX start: about 70 ns
READ accepted to HEADER TX start: about 110 ns
READ accepted to first payload byte TX start: about 11.04 µs
header start to first payload start: about 10.93 µs

These are Rev1 baseline values for comparison against later protocol/architecture revisions.

##Rev1 reliability results

Repeated acquisition testing passed:

24,000 total validated capture-read runs
24,000 / 24,000 successful acquisitions
0 protocol errors
0 timeouts / short reads
0 serial errors
0 payload mismatches

Static patterns tested:

0x00
0x01
0x80
0xFF

Long-run tests:

10,000 / 10,000 successful for 0x00
10,000 / 10,000 successful for 0xFF

Observed acquisition success rate: 100.000% over tested runs.

##Rev2 implications from Rev1

Rev2 targets should be based on Rev1 pain points, not random feature creep.

High-value Rev2 improvements:

proper trigger system: edge/pattern trigger
pre/post-trigger capture using circular buffer
stronger framed protocol with length, sequence, and checksum/CRC
cleaner programming/debug interface
better input front-end protection/conditioning
dedicated debug/test pins
improved CDONE/DONE LED circuit
optional variable sample rate and capture depth
better host tooling and output formats
clearer measurement hooks for timing and latency

##Rev1 big engineering lesson

Most hardware/debug problems became solvable once isolated with the right measurements.

The core lesson was not “everything magically works eventually,” but:

Break the system into rails, reset/configuration, communication, protocol, capture, transfer, and validation. Then instrument each boundary until the fault has nowhere left to hide.