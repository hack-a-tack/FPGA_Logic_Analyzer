# TOP_TODO.md

Running tally of everything `top.vhd` must do once the module-level work is finished.
`top.vhd` is still the Rev1 version and **does not elaborate** against the current
modules. Nothing below has been implemented or verified in integration.

**Rule for all future work:** every prompt that changes a module port list, adds a
module, or defers something to top level MUST append a row to the relevant table
here in the same pass. A change that is not written down is a change that will be
missed at integration.

Last updated: 2026-08-17

---

## 1. Blocking defects in the current top.vhd

These make the existing file fail to elaborate. All must be fixed in the rewrite.

| # | Defect | Fix |
|---|---|---|
| 1 | `DATA_LENGTH => 16` passed to `uart_rx` / `uart_tx` / `cmd_parser` | UART path is 8 bits |
| 2 | `ADDR_LENGTH => 12` | Now 14 bits (12288 logical samples) |
| 3 | `i_rst` used; modules expect `i_rst_n` | Active-low throughout |
| 4 | No `config_regs` instance | Instantiate and route |
| 5 | `clocking.i_cfg_sample_rate_sel` undriven | From `config_regs` |
| 6 | `capture_engine` missing all `i_cfg_*` inputs | From `config_regs` |
| 7 | `trace_buffer` missing `i_capture_width_sel` | From `config_regs` |
| 8 | `send_engine` wired with `i_tx_busy` / `o_send_tx_start_pulse` | Gone — now payload + frame req |
| 9 | `tx_mux` wired with `i_clk` / `i_rst` / pulse-style ports | `tx_mux` is combinational, no clock |
| 10 | No startup reset | See §3 |

---

## 2. New modules to instantiate

| Module | Purpose | Notes |
|---|---|---|
| `la_pkg` | Shared package | `use work.la_pkg.all;` in top |
| `frame_tx` | TX framing: sync/ver/type/seq/len/CRC | Sits between `tx_mux` and `uart_tx` |
| `resp_gen` | Status/error payload source + queue | `QUEUE_DEPTH = 4` |
| `rx_frame_parser` | RX frame validation | Between `uart_rx` and `cmd_parser` |

---

## 3. Logic that exists ONLY in top.vhd

Not written anywhere yet. Each is a real behavioural requirement, not wiring.

### 3.1 Startup reset  (design decision #8)
No runtime reset button on the Rev2 PCB; `CRESET_B` reconfigures the FPGA rather than
resetting user logic. Generate an internal startup reset:

```vhdl
signal r_rst_pipe : std_logic_vector(3 downto 0) := (others => '0');
signal s_rst_n    : std_logic;
-- shift '1' in on each rising edge; s_rst_n <= r_rst_pipe(3);
```

Route `s_rst_n` to every module. Pressing `CRESET_B` reloads the bitstream, which
restarts this sequence.

### 3.2 LVC14 input inversion normalisation  ← HIGHEST RISK ITEM
Three SN74LVC14A Schmitt-trigger buffers invert. Normalise **once** at the top-level
boundary so all downstream RTL reasons in terms of true external logic state:

```vhdl
s_capture_inputs <= not i_capture_pins;   -- all 16 channels
```

If this is missed, every capture returns inverted data and every pattern trigger
matches the complement of the requested pattern. The likely first suspect would be
the trigger logic, which is the wrong place to look. **Verify explicitly.**

### 3.3 FTDI flow-control de-inversion
FTDI pins are active low; internal signals are meaning-based:

| Internal | Pin | Mapping |
|---|---|---|
| `i_usb_can_accept_tx_byte` | CTS# | `s_usb_can_accept <= not i_ftdi_cts_n;` |
| `o_fpga_can_accept_rx_byte` | RTS# | `o_ftdi_rts_n <= '0';` (tied asserted) |

RTS is tied asserted deliberately: `rx_frame_parser` buffers and host→FPGA traffic is
a few bytes per command, so the FPGA can always accept. Route the pin, drive it true,
document why.

### 3.4 `rx_frame_parser` G_BYPASS
Set `G_BYPASS => true` for first bring-up so the link works before the host-side
Python emits framed commands. Flip to `false` on the flag day. **Do not** leave this
true in a release bitstream.

### 3.5 `i_cmd_opcode` tie-off — RESOLVED
`cmd_parser` now drives `o_cmd_opcode`. Wire it to `analyzer_fsm.i_cmd_opcode`; the
`x"00"` tie-off is no longer needed.

### 3.6 Debug header routing
Route selected RTL state/timing signals to the debug header pins, with series
resistance already present on the PCB. Candidates: `samp_tick`, capture FSM state,
`frame_tx` state, `o_resp_overflow`, `o_send_frame_req`.

### 3.7 Configuration / status indicators
`CDONE` indicator is driven via 2N7002 on the PCB, not from RTL. `o_USER_LED` comes
from `analyzer_fsm`.

---

## 4. Signal-name changes to apply when rewiring

| Old (Rev1 / early Rev2) | New | Module |
|---|---|---|
| `o_send_active` | *(removed)* | `send_engine` |
| `o_send_tx_byte/valid`, `i_send_tx_ready` | `o_pl_byte/valid`, `i_pl_ready` | `send_engine` |
| `o_fsm_tx_status_byte`, `o_fsm_tx_valid`, `i_fsm_tx_ready` | `o_resp_req/type/code/detail` | `analyzer_fsm` |
| `i_uart_tx_ready`, `o_mux_tx_byte/valid` | `i_pl_ready`, `o_pl_byte/valid` | `tx_mux` |
| `CLKS_PER_BIT` generic | `i_baud_sel` | `uart_tx`, `uart_rx` |

---

## 5. Generics to set at instantiation

| Module | Generic | Value |
|---|---|---|
| all | `DATA_LENGTH` | 8 |
| `capture_engine`, `send_engine`, `trace_buffer` | `ADDR_LENGTH` | 14 |
| `cmd_parser` | `G_TIMEOUT_CYCLES` | 48_000 (1 ms @ 48 MHz) |
| `rx_frame_parser` | `G_TIMEOUT_CYCLES` | 48_000 |
| `rx_frame_parser` | `G_MAX_PAYLOAD` | 8 |
| `rx_frame_parser` | `G_BYPASS` | `true` for bring-up, `false` for release |
| `resp_gen` | `QUEUE_DEPTH` | 4 |
| `config_regs` | `G_BAUD_CONFIRM_CYCLES` | 24_000_000 (500 ms @ 48 MHz) |

---

## 6. Post-elaboration verification checklist

Run in this order. Each catches a class of defect the one before it cannot.

1. **Elaborates at all** — port names, widths, directions.
2. **No undriven inputs, no multiply-driven signals** — check synthesis warnings, do
   not skip them.
3. **`s_rst_n` reaches every module** — grep the port maps.
4. **LVC14 inversion present on all 16 channels** (§3.2).
5. **Ground-truth capture** — static `0x00`, `0xFF`, one-hot per channel; confirms
   channel mapping *and* inversion polarity together.
6. **`frame_tx` grant is registered**, not combinational — mid-frame preemption check.
7. **Payload length matches emitted bytes** — 8-bit/4096, 8-bit/12288, 16-bit/2048,
   16-bit/6144. Deep 8-bit and deep 16-bit both give payload 12295.
8. **Post-route Fmax / WNS** — Rev1 baseline was ~60.26 MHz, WNS +4.238 ns.

---

## 7. Deferred to Rev3

| Item | Reason |
|---|---|
| Runtime logic-reset button | PCB already ordered; not worth a respin |
| Route FT2232H 12 MHz osc to FPGA pin | Would allow `SB_PLL40_CORE` for crystal-accurate baud; currently not routed, so 6 Mbaud depends on `SB_HFOSC` tolerance. Check oscillator fan-out and PLL lock time |
| SPRAM for capture depth | 128 kB unused vs 12 kB in EBR; Rev2 stays on EBR |
| `0xA2` ABORT opcode | Escapes an armed trigger that never fires without `CRESET_B` |
