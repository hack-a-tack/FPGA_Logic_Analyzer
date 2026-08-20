# TOP_TODO.md

Running tally of everything `top.vhd` must do once the module-level work is finished.

**STATUS 2026-08-19: `top.vhd` has been rewritten against the current rev2 module
set (all 13 direct instantiations) and `rev2\fpga\check.bat` completes through it
cleanly — `ghdl -a` and a full `ghdl -e top` both pass with zero errors/warnings.
Everything in §1 and §3 below is now RESOLVED.** This file stays as the integration
record; new findings from that rewrite are appended in §8.

**Rule for all future work:** every prompt that changes a module port list, adds a
module, or defers something to top level MUST append a row to the relevant table
here in the same pass. A change that is not written down is a change that will be
missed at integration.

Last updated: 2026-08-19

---

## 1. Blocking defects in the current top.vhd — ALL RESOLVED 2026-08-19

These made the pre-rewrite file fail to elaborate. Kept for the record.

| # | Defect | Fix | Status |
|---|---|---|---|
| 1 | `DATA_LENGTH => 16` passed to `uart_rx` / `uart_tx` / `cmd_parser` | UART path is 8 bits | RESOLVED — top's `C_BYTE_WIDTH` generic (8) now feeds every `DATA_LENGTH` generic on the byte path |
| 2 | `ADDR_LENGTH => 12` | Now 14 bits (12288 logical samples) | RESOLVED — top's `C_ADDR_LENGTH` (14) feeds `capture_engine`/`send_engine`/`trace_buffer` |
| 3 | `i_rst` used; modules expect `i_rst_n` | Active-low throughout | RESOLVED — `s_rst_n` (see §3.1) routed to `i_rst_n` on all 11 modules that have one |
| 4 | No `config_regs` instance | Instantiate and route | RESOLVED — E5 |
| 5 | `clocking.i_cfg_sample_rate_sel` undriven | From `config_regs` | RESOLVED |
| 6 | `capture_engine` missing all `i_cfg_*` inputs | From `config_regs` | RESOLVED |
| 7 | `trace_buffer` missing `i_capture_width_sel` | From `config_regs` | RESOLVED, but **not from `config_regs`** — see §8.1, the source (both `capture_engine.vhd` and `trace_buffer.vhd`'s own header comments) disagrees with this row |
| 8 | `send_engine` wired with `i_tx_busy` / `o_send_tx_start_pulse` | Gone — now payload + frame req | RESOLVED — wired via `o_pl_byte/valid`, `i_pl_ready`, `o_send_frame_req/len`, `i_send_grant` |
| 9 | `tx_mux` wired with `i_clk` / `i_rst` / pulse-style ports | `tx_mux` is combinational, no clock | RESOLVED, but the real port list is bigger than this row implies — see §8.2 |
| 10 | No startup reset | See §3 | RESOLVED — see §3.1 |

---

## 2. New modules to instantiate — ALL RESOLVED 2026-08-19

| Module | Purpose | Notes | Status |
|---|---|---|---|
| `la_pkg` | Shared package | `use work.la_pkg.all;` in top | RESOLVED |
| `frame_tx` | TX framing: sync/ver/type/seq/len/CRC | Sits between `tx_mux` and `uart_tx` | RESOLVED — E12 |
| `resp_gen` | Status/error payload source + queue | `QUEUE_DEPTH = 4` | RESOLVED — E10 |
| `rx_frame_parser` | RX frame validation | Between `uart_rx` and `cmd_parser` | RESOLVED — E3, `G_BYPASS => true` for bring-up |

---

## 3. Logic that exists ONLY in top.vhd

### 3.1 Startup reset — RESOLVED 2026-08-19
Implemented exactly as specified: `r_rst_pipe` shifts `'1'` in on each `rising_edge(CLK)`,
`s_rst_n <= r_rst_pipe(3)`. Routed to `i_rst_n` on every module that has one (11 of 13
instances — `clocking` and `tx_mux` have no clock/reset port at all, see §8.3).

### 3.2 LVC14 input inversion normalisation — RESOLVED 2026-08-19 (was already correct)
The pre-rewrite top.vhd's `ANALYZER_INPUTS` assignment already did this correctly
(per-bit `not i_LAx`, all 16 channels) and was preserved verbatim in the rewrite,
unchanged.

### 3.3 FTDI flow-control de-inversion — RESOLVED 2026-08-19
`s_usb_can_accept_tx_byte <= not i_FTDI_CTS_N;`, routed to `uart_tx.i_usb_can_accept_tx_byte`.
`o_FTDI_RTS_N <= '0';` tied asserted, commented in top.vhd's NOTES.

### 3.4 `rx_frame_parser` G_BYPASS — RESOLVED 2026-08-19 (still bring-up-only)
`G_BYPASS => true` at E3, with a NOTES paragraph in top.vhd flagging in capitals that
this must become `false` before release. Still open as a release-readiness item, not
an integration item.

### 3.5 `i_cmd_opcode` tie-off — RESOLVED
`cmd_parser` now drives `o_cmd_opcode`. Wired to `analyzer_fsm.i_cmd_opcode` (as
`CMD_OPCODE`) in the rewrite; the `x"00"` tie-off never existed in the new file.

### 3.6 Debug header routing — RESOLVED 2026-08-19
`o_DBG0 <= SAMP_TICK`, `o_DBG1 <= FRAME_DONE_PULSE`, `o_DBG2 <= RESP_OVERFLOW`,
`o_DBG3 <= SEND_FRAME_REQ`.

### 3.7 Configuration / status indicators — confirmed, no RTL action needed
`CDONE` is PCB-level (2N7002), not RTL. `o_USER_LED <= analyzer_fsm.o_USER_LED` directly.

---

## 4. Signal-name changes to apply when rewiring — ALL APPLIED 2026-08-19

| Old (Rev1 / early Rev2) | New | Module |
|---|---|---|
| `o_send_active` | *(removed)* | `send_engine` |
| `o_send_tx_byte/valid`, `i_send_tx_ready` | `o_pl_byte/valid`, `i_pl_ready` | `send_engine` |
| `o_fsm_tx_status_byte`, `o_fsm_tx_valid`, `i_fsm_tx_ready` | `o_resp_req/type/code/detail` | `analyzer_fsm` |
| `i_uart_tx_ready`, `o_mux_tx_byte/valid` | `i_pl_ready`, `o_pl_byte/valid` | `tx_mux` — incomplete, see §8.2 for the actual full port list |
| `CLKS_PER_BIT` generic | `i_baud_sel` | `uart_tx`, `uart_rx` |

---

## 5. Generics to set at instantiation — APPLIED 2026-08-19

Top itself now has three generics instead of one overloaded `DATA_LENGTH`:
`C_BYTE_WIDTH => 8` (UART/protocol byte path), `C_CAPTURE_WIDTH => 16` (parallel
capture word width, not passed to any submodule generic — `capture_engine`,
`trace_buffer` and `send_engine`'s capture-word ports are a fixed 16 bits in their own
entities, not generic-controlled), `C_ADDR_LENGTH => 14`.

| Module | Generic | Value |
|---|---|---|
| `uart_rx`, `uart_tx`, `cmd_parser`, `analyzer_fsm`, `rx_frame_parser`, `frame_tx`, `resp_gen`, `tx_mux`, `send_engine` | `DATA_LENGTH` | `C_BYTE_WIDTH` (8) |
| `capture_engine`, `send_engine`, `trace_buffer` | `ADDR_LENGTH` | `C_ADDR_LENGTH` (14) |
| `cmd_parser` | `G_TIMEOUT_CYCLES` | 48_000 (1 ms @ 48 MHz) |
| `rx_frame_parser` | `G_TIMEOUT_CYCLES` | 48_000 |
| `rx_frame_parser` | `G_MAX_PAYLOAD` | 8 |
| `rx_frame_parser` | `G_BYPASS` | `true` for bring-up, `false` for release |
| `resp_gen` | `QUEUE_DEPTH` | 4 |
| `config_regs` | `G_BAUD_CONFIRM_CYCLES` | 24_000_000 (500 ms @ 48 MHz) |
| `trace_buffer` | `BANK_DEPTH` | left at its own default (6144) — see §8.4, not mentioned anywhere in this file before now |

`capture_engine` takes **only** `ADDR_LENGTH` — it has no `DATA_LENGTH` generic at all
(its capture-word ports are fixed 16-bit). `config_regs` takes **only**
`G_BAUD_CONFIRM_CYCLES` — no `DATA_LENGTH` either (its config ports are fixed
7/15-downto-0). `clocking` takes no generics.

---

## 6. Post-elaboration verification checklist

Run in this order. Each catches a class of defect the one before it cannot.

1. **Elaborates at all** — port names, widths, directions. DONE 2026-08-19: `ghdl -a`
   (via `check.bat`) and a full `ghdl -e top` both pass with zero errors/warnings.
2. **No undriven inputs, no multiply-driven signals** — check synthesis warnings, do
   not skip them. DONE 2026-08-19 for undriven/multiply-driven at the GHDL level (no
   port left unconnected, and a script pass over every port map + concurrent
   assignment in top.vhd found no internal signal driven from more than one source).
   Synplify's own synthesis warnings for this have NOT been checked — GHDL analysis
   does not run place-and-route or synthesis-level checks, so this item is only
   partially closed; re-run the Synplify build and read its warnings before trusting
   this fully.
3. **`s_rst_n` reaches every module** — grep the port maps. DONE 2026-08-19: 11 of 13
   instances (all except `clocking` and `tx_mux`, which have no reset port — see §8.3).
4. **LVC14 inversion present on all 16 channels** (§3.2). DONE 2026-08-19 — preserved
   verbatim from the pre-rewrite file, all 16 channels present.
5. **Ground-truth capture** — static `0x00`, `0xFF`, one-hot per channel; confirms
   channel mapping *and* inversion polarity together. NOT DONE — needs real hardware.
6. **`frame_tx` grant is registered**, not combinational — mid-frame preemption check.
   NOT DONE — needs simulation or hardware; `r_grant_sel`/`n_grant_sel` in
   `frame_tx.vhd` is a registered signal set only in the `IDLE` branch, which is
   consistent with "registered, not combinational," but this checklist item asks for
   an actual mid-frame preemption test, not just a read of the declaration.
7. **Payload length matches emitted bytes** — 8-bit/4096, 8-bit/12288, 16-bit/2048,
   16-bit/6144. Deep 8-bit and deep 16-bit both give payload 12295. NOT DONE — needs
   simulation or hardware.
8. **Post-route Fmax / WNS** — Rev1 baseline was ~60.26 MHz, WNS +4.238 ns. NOT DONE —
   needs a full Synplify + P&R run, which top.vhd not previously elaborating had been
   blocking; that blocker is now gone.

---

## 7. Deferred to Rev3

| Item | Reason |
|---|---|
| Runtime logic-reset button | PCB already ordered; not worth a respin |
| Route FT2232H 12 MHz osc to FPGA pin | Would allow `SB_PLL40_CORE` for crystal-accurate baud; currently not routed, so 6 Mbaud depends on `SB_HFOSC` tolerance. Check oscillator fan-out and PLL lock time |
| SPRAM for capture depth | 128 kB unused vs 12 kB in EBR; Rev2 stays on EBR |
| `0xA2` ABORT opcode | Escapes an armed trigger that never fires without `CRESET_B` |

---

## 8. Findings from the 2026-08-19 integration pass

This file was written before several modules reached their current form. Per
instruction, wiring followed the actual entity declarations in `rtl/` (all re-read
fresh for this pass) wherever they disagreed with what's written above. Each
disagreement is recorded here rather than silently overwriting the old rows.

### 8.1 `trace_buffer.i_capture_width_sel` source — corrects §1 row 7
§1 row 7 said "from `config_regs`." The source disagrees: `capture_engine.vhd`'s own
OUTPUTS table documents `o_capture_width_sel` as going to `-> send_engine,
trace_buffer`, and `trace_buffer.vhd`'s own INPUTS table documents
`i_capture_width_sel` as coming `<- capture_engine`. Wired accordingly:
`trace_buffer.i_capture_width_sel <= CAPTURE_WIDTH_SEL` (from
`capture_engine.o_capture_width_sel`), not from `config_regs.o_cfg_capture_width_sel`
directly.

This is not just a naming difference — it is a real correctness requirement.
`config_regs` accepts config writes again once a capture reaches `DATA_READY` (writes
are blocked only during `CAPTURE`/`SEND`). If `trace_buffer` read the live
`config_regs` value instead of the value `capture_engine` latched for the capture in
progress, a host that changes capture width between a `CAPTURE` and the `READ` that
retrieves it would desync `trace_buffer`'s bank decoding from how the data was
actually written, corrupting the readout. `capture_engine.o_capture_width_sel` exists
specifically to prevent this (it already serves the identical purpose for
`send_engine`).

### 8.2 `tx_mux`'s real port list — corrects §1 row 9 and §4
Neither predates the module's current two-payload-source design. The actual entity
(`tx_mux.vhd`) has no clock/reset (confirmed, matches the old §1 row 9), but instead
of a single `i_pl_ready`/`o_pl_byte/valid` triplet it has **two independent payload
sources**, each with its own byte/valid/ready:
`i_resp_pl_byte/valid` + `o_resp_pl_ready` (from `resp_gen`) and
`i_send_pl_byte/valid` + `o_send_pl_ready` (from `send_engine`), muxed by
`i_grant_sel` (driven by `frame_tx.o_grant_sel`) onto a single
`o_pl_byte/valid` + `i_pl_ready` triplet toward `frame_tx`. §4's row for `tx_mux` only
documented the frame_tx-facing rename, not this fan-in structure.

### 8.3 Modules with no clock/reset port
`clocking.vhd` and `tx_mux.vhd` have no `i_clk`/`i_rst_n` ports at all — `s_rst_n`
cannot and does not connect to either. `clocking` free-runs from `SB_HFOSC` and only
needs defined power-on values (its signal initialisers already provide them);
`tx_mux` is purely combinational. Neither is a defect; there is nothing in either
module for a reset to do. Documented explicitly in top.vhd's NOTES so this isn't
mistaken for an omission later.

### 8.4 `trace_buffer`'s `BANK_DEPTH` generic — not previously documented anywhere
`trace_buffer` takes `ADDR_LENGTH` (14, as expected) **and** `BANK_DEPTH` (default
6144), the latter never mentioned in this file. Left at its default in the
instantiation since nothing here specifies otherwise, and 6144 matches the module's
own addressing scheme (its NOTES: 16-channel mode uses one address per bank per
sample, max byte address 6143).

### 8.5 `capture_engine` has no `DATA_LENGTH` generic; `config_regs` has no `DATA_LENGTH` generic
Both take only their own specific generics (`ADDR_LENGTH` only for `capture_engine`;
`G_BAUD_CONFIRM_CYCLES` only for `config_regs`) — their data-width ports are fixed
widths in the entity declaration, not generic-controlled. Neither needed
`C_BYTE_WIDTH` wired to them.

### 8.6 Top's own generics restructured
Per instruction, `DATA_LENGTH`/`NUM_SAMPLES`/`BAUD_RATE`/`CLK_FREQ_HZ` are gone from
top's generic list, replaced with `C_BYTE_WIDTH` (8), `C_CAPTURE_WIDTH` (16, sizes
top-level signals only — no submodule has a matching generic to receive it), and
`C_ADDR_LENGTH` (14). `NUM_SAMPLES` is confirmed gone from `capture_engine`,
`send_engine` and `trace_buffer` — capture depth is fully runtime-selected via
`config_regs` now, matching the prompt's expectation.
