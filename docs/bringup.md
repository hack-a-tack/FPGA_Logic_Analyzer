#Quick facts (fill in)
Board: FPGA Logic Analyzer Rev1
Date:
Location:
FPGA: iCE40UP5K SG48
Clock: SB_HFOSC (48 MHz nominal)
UART: 921600 8N1
Sample rate: 24 MHz (samp_tick every 2 clk cycles)
Depth: 4096 samples (4096 bytes)
Host tool: host/la_host.py
Protocol:
CAPTURE 0xA0
READ 0xA1
OK 0x55, DONE 0x77, HEADER 0x99, ERROR 0xEE, watchdog trigger 0xDD

#Tools required
Bench PSU (or USB power source)
DMM
(Optional) current-limited bench supply
Logic probe / scope (optional but helpful)
USB cable for UART bridge
VCOM driver (for CP2102N) installed
PulseView program installed
Jumper wires / resistors for LA input forcing
Signal source for toggling test (function generator / dev board GPIO / cheap oscillator)

#Phase 0 — Safety + visual inspection (no power)
 Inspect board under magnification: bridges, tombstones, rotated ICs
 Confirm polarities: diodes, LDOs, electrolytics
 Check USB connector + ESD parts orientation
 Check FPGA QFN joints (corners, obvious shorts)
 Verify no stray solder balls around fine-pitch parts
Notes:

##Resistance checks (power off)
 Measure resistance 3V3 → GND (record): ______ Ω
 Measure resistance 1V2 → GND (record): ______ Ω
 Measure resistance VBUS(5V) → GND (record): ______ Ω
If any rail is “near short” (< ~10Ω), stop and inspect.
Notes:

#Phase 1 — Power bring-up (no data cables)

Preferred: bench supply current-limited into 5V input (or USB with current monitor).

 Set current limit (start low, e.g. 100–200 mA)
 Apply power
 Record initial current: ______ mA

##Rail verification
 VBUS / 5V present: ______ V
 3V3 rail: ______ V (target ~3.3V)
 1V2 rail: ______ V (target ~1.2V)
 Any rail oscillation/heating? (touch test carefully) Y/N
Notes:

Pass criteria: rails within ~±5%, no abnormal heating, current reasonable.

#Phase 2 — USB-UART enumeration (PC-side)
 Virtual COM port device driver (for CP2102N) installed?
 Plug into PC
 Device appears in Device Manager → Ports (COM & LPT)
 COM port: ______
 Run: python host/la_host.py --list-ports and confirm it lists the adapter
Notes:

#Phase 3 — Protocol smoke test (no signal source yet)

Goal: prove the FPGA is alive, UART RX/TX works, command parsing works.

Self-test (preferred)
 Run: python host/la_host.py --port COM__ self-test
 Pass criteria: script prints PASS and shows HEADER + 4096 bytes
 If fail: note the step it failed at (CAPTURE/OK, CAPTURE/DONE, READ/HEADER, READ/DATA length)

##A) CAPTURE → OK + DONE
 Run:
python host/la_host.py --port COM__ capture
 Expected: receives 0x55 then 0x77
 Observed: ________________________
If fail:
No response → check reset polarity, clocking, UART TX pin mapping, bridge wiring
Garbled → baud mismatch/clock issue
Notes:

##B) READ after CAPTURE → HEADER + data
 Run:
python host/la_host.py --port COM__ read --csv output/read.csv
 Expected: 0x99 + 4096 bytes
 Observed length: ______ bytes
 If ERROR 0xEE: likely capture not completed / state issue
Notes:

##C) Capture+Read one shot
 Run:
python host/la_host.py --port COM__ capture-read --csv output/run1.csv --vcd output/run1.vcd
 Expected: success, CSV+VCD created
Notes:

#Phase 4 — Known static input tests (sanity patterns)

Goal: verify LA channel wiring and bit ordering.

Test setup
Decide mapping: LA0 = LSB … LA7 = MSB
Confirm ground reference to DUT signals.
##A) All-low
 Tie LA0–LA7 to GND (direct or via resistors)
 Run capture-read
 Expect bytes ≈ 0x00 (mostly/all)
 Observed first bytes (hex): ______________________
Notes:
##B) All-high
 Tie LA0–LA7 to 3V3 (direct or via resistors)
 Run capture-read
 Expect bytes ≈ 0xFF
 Observed first bytes (hex): ______________________
Notes:
##C) Single-bit high (bit order check)
 LA0 high, others low → expect 0x01
 LA7 high, others low → expect 0x80
 Record observed: LA0 test: ____ LA7 test: ____
Notes:

#Phase 5 — Dynamic input test (edge timing sanity)

Goal: verify transitions are captured and sample rate looks plausible.

##A) One channel toggling (square wave)
 Feed LA0 with known square wave (e.g. 100 kHz–1 MHz), others static
 Run capture-read + VCD
 Open VCD in viewer (PulseView/GTKWave)
 Confirm toggles and approximate frequency
Notes:
##B) Two-channel test (phase/relationship)
 Feed LA0/LA1 from two GPIOs with known pattern (e.g. Gray code or simple counter)
 Capture and verify pattern visually
Notes:

#Phase 6 — Error handling checks (optional)
 Send READ without capture → expect 0xEE
 Send unknown opcode → expect 0xEE
 Bad stop-bit frame (if you have a way) → no command accepted
Notes:

#Results summary
Power rails: PASS/FAIL
UART enumerates: PASS/FAIL
CAPTURE OK/DONE: PASS/FAIL
READ HEADER+4096: PASS/FAIL
Static patterns: PASS/FAIL
Dynamic waveform: PASS/FAIL

#If something fails — quickest fault tree
Rails wrong / high current → power section / shorts
No COM port → USB-UART bridge / cable / driver
COM ok, no responses → reset/clocking/FPGA not configured
Responses garbled → baud mismatch / clock wrong / wrong pins
Header ok but wrong data → LA pin mapping / bit order / input floating
Intermittent weirdness → grounding, floating inputs, clock tolerance, timing closure, noise