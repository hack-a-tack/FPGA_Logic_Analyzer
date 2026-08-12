Simulate/synthesis commands:
- Synthesis: Lattice iCEcube2 GUI project at `rev2/fpga/iCEcube2_rev2_logic_analyzer/` (`*_sbt.project` / `*_syn.prj`). No CLI build script found yet.
- Simulation: no testbenches exist for rev2 yet. rev1 testbenches (one per module) live under `rev1/fpga/tb/`; rev2 modules changed enough (new ports/generics) that these are not directly reusable.

VHDL standard: 2008

Coding conventions:

## File header (every .vhd file)
Every file opens and closes with a `-- ========================================` rule and includes, in this order:
- `MODULE:` filename
- `FUNCTION:` one-line summary of what the module does
- `AUTHOR:` Jakob Kieszek Ottesen
- `DATE:` creation date, explicitly noted as `(YYYY-MM-DD)`
- `MODIFIED:` one line per revision, each with a short reason in parentheses (e.g. `MODIFIED: 2026-05-14 (reset active low)`). Keep prior MODIFIED lines; append new ones rather than overwriting. (`LAST MODIFIED:` also appears in a couple of files — prefer `MODIFIED:` for new entries.)
- Blank line, then an `INPUTS` table and an `OUTPUTS` table: columns are signal name, bit width, and the module it's driven by / driven to (e.g. `i_rx_byte   8 bits   <- uart_rx`).
- `NOTES`: free-form design notes — timing math, hardware gotchas, encoding schemes, anything a reader needs to trust the RTL without re-deriving it.
- `PREFIXES`: lists which of the signal-name prefixes below are actually used in this file.
- `ITERATIVE PROCESS NOTES`: a living TODO/scratchpad kept *in* the file — deferred work, rejected approaches and why, reminders (e.g. "update VHDL entities in OneNote once module is locked"). Keep this section instead of deleting stale design discussion; it documents why something is *not* done yet.

## Libraries
Every file uses:
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
```

## Naming
- Entity name matches the filename. Architecture name is `RTL` for real logic, `STRUCTURE` for the structural top-level, `sim` for simulation-only dummy primitives (e.g. `SB_HFOSC.vhd`).
- Generics: `ALL_CAPS_WITH_UNDERSCORES` (`CLK_FREQ_HZ`, `ADDR_LENGTH`, `DATA_LENGTH`). Large numeric defaults use `_` separators for readability (`48_000_000`).
- Constants (opcodes, sync bytes): `ALL_CAPS`, hex literals via `x".."` (e.g. `CMD_CAPTURE : std_logic_vector(7 downto 0) := x"A0"`).
- Ports: `i_`/`o_` prefix required (see below). Signals tied to physical top-level pins keep `ALL_CAPS` after the prefix (`i_LA0`, `o_UART_TX`); internal module-to-module signals are `lower_snake_case` after the prefix (`i_clk`, `o_capture_start_pulse`).
- Single-cycle strobes are suffixed `_pulse` (`o_capture_done_pulse`).
- Newer/rev2 modules (`uart_tx`, `tx_mux`) use explicit `_valid`/`_ready` handshake pairs instead of a bare start pulse — prefer this pattern for new handshakes over introducing more `_start_pulse` signals.

## Signal prefixes inside architectures
- `i_` input, `o_` output
- `r_` registered signal (current value, updated only in the sequential process)
- `n_` next-state value for the matching `r_` signal (computed in the combinational process)
- `v_` process-local variable
- `s_` output-only signal driven by a dedicated combinational output process (used sparingly, e.g. `send_engine.vhd`)

## Reset
- Reset is **active-low** everywhere (tied to a physical DIP switch): checked as `if i_rst_n = '0' then`.
- Newer files name the port `i_rst_n` to make polarity explicit in the name. `uart_rx.vhd` still calls it `i_rst` despite being active-low — treat `i_rst_n` as the standard for any new or touched port, not `i_rst`.

## FSM / process structure
Stateful modules use a two-process style:
1. `seq_proc: process(i_clk)` — rising-edge only; on `i_rst_n = '0'` drives every `r_*` signal to its reset value, otherwise does a flat `r_x <= n_x` for every register. No combinational logic here.
2. `fsm_proc: process(all)` (or `<name>_proc`) — combinational. Starts with a defaults block setting every `n_x <= r_x` (hold-by-default), then a `case r_state is` with one branch per state. Outputs that should pulse for one cycle are defaulted to `'0'` here so they don't need to be cleared explicitly in every branch.
Simple non-FSM modules (`trace_buffer.vhd`, `config_regs.vhd`) collapse this into a single clocked process instead of the r_/n_ split — that's fine for straight register files / RAM, reserve the two-process split for actual state machines.
Extra synchronization (e.g. the UART RX 2FF input synchronizer) gets its own dedicated process (`sync_proc`) rather than being folded into `fsm_proc`.

## Structural instantiation (top.vhd)
Submodules are instantiated with sequential labels (`E1`, `E2`, ...) in signal-flow order, using direct entity instantiation (`entity WORK.modname(RTL)`) with named `generic map` / `port map` — no `component` declarations.

## Misc
- Indentation uses tabs.
- `case` statements on command/opcode bytes end in `when others =>`, typically raising an error pulse.
- Status byte encodings are documented inline with both hex and binary (`x"55"  -- 0x55 (OK), 0b01010101`).
- Obsolete/disabled logic is kept as a `/* ... */` block comment with a note explaining why it's disabled, rather than deleted (see the watchdog block in `analyzer_fsm.vhd`) — VHDL-2008 allows `/* */`, so this is intentional, not a typo.

## Known current state / gotchas
- `top.vhd` has not been updated for the rev2 rewrite of `analyzer_fsm`, `tx_mux`, `uart_tx`, `capture_engine`, `send_engine`, and `trace_buffer` — it port-maps to signal/port names (e.g. `o_fsm_tx_start_pulse`) that no longer exist on those entities, uses stale generics, and never instantiates `config_regs`. It will not currently elaborate. Re-wiring `top.vhd` is a prerequisite for any full-design simulation or synthesis.
- No rev2 testbenches exist yet; rev1's (`rev1/fpga/tb/`) don't match the current rev2 port lists.

Off-limit directories: no directories are off-limits per se. But nothing shall be changed in the rev1 folder. All of this material is just for reference now that rev2 (eventually rev3) is the main priority.
