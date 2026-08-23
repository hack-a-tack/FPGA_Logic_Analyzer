Simulate/synthesis commands:
- Compile-check (syntax/elaboration only, not synthesis): `rev2\fpga\check.bat` -- see `## Compiling` below for usage, reporting requirements, and how its dependency order was derived. GHDL's work library lives in `rev2/fpga/build/` (gitignored, `work-obj*.cf`), not at the repo root or in `rev2/fpga/rtl/`.
- Synthesis: Lattice iCEcube2 GUI project at `rev2/fpga/iCEcube2_rev2_logic_analyzer/` (`*_sbt.project` / `*_syn.prj`). `rev2\fpga\build.bat` is documented in `## Compiling` below as the intended CLI entry point but has **not been created yet** -- do not assume it exists until that changes. The underlying command it should wrap has been confirmed working (license already configured): from `rev2/fpga/iCEcube2_rev2_logic_analyzer/`, run `C:\lscc\iCEcube2.2020.12\synpbase\bin64\mbin\synbatch.exe -product synplify_pro -batch iCEcube2_rev2_logic_analyzer_syn.prj` (this only runs the Synplify logic-synthesis step -- compile/premap/map, producing the `.edf` netlist -- not place-and-route/bitstream; P&R is a separate, not-yet-scripted step via the GUI or `sbt_backend`). The `.prj`'s `add_file` list currently only contains `send_engine.vhd`; edit that list to change what gets synthesized. Prefer GHDL for routine per-module compile-checks -- it's much faster and doesn't require a license -- and reserve Synplify runs for when a synthesis-specific concern (inference, timing, resource usage) is actually in question.
- Simulation: no testbenches exist for rev2 yet. rev1 testbenches (one per module) live under `rev1/fpga/tb/`; rev2 modules changed enough (new ports/generics) that these are not directly reusable.

VHDL standard: 2008

Coding conventions:
## General
- Apart from that which is specifically outlined below, keep general comments relatively simple. Not overly long, and focus on using simple/direct language.
- Don't add "--" inside comments. Avoid semicolons as well.
- Let's stick to std_logic_vectors for entity declarations (in/out ports), but unsigned vectors for intra-module logic.
- whatever sits between two flip-flops has to finish in one tick, so keep it short. (wherever possible:) Compare against constants, not variables. Compute bounds once, not every cycle.

## File header (every .vhd file)
Every file opens and closes with a `-- ========================================` rule and includes, in this order:
- `MODULE:` filename
- `FUNCTION:` one-line summary of what the module does
- `AUTHOR:` Jakob Kieszek Ottesen
- `DATE:` creation date, explicitly noted as `(YYYY-MM-DD)`
- `MODIFIED:` one line per revision, each with a short reason in parentheses (e.g. `MODIFIED: 2026-05-14 (reset active low)`). Keep prior MODIFIED lines; append new ones rather than overwriting. (`LAST MODIFIED:` also appears in a couple of files — prefer `MODIFIED:` for new entries.)
- Blank line, then an `INPUTS` table and an `OUTPUTS` table: columns are signal name, bit width, and the module it's driven by / driven to (e.g. `i_rx_byte   8 bits   <- uart_rx`).
- `NOTES`: free-form design notes — timing math, hardware gotchas, encoding schemes, anything a reader needs to trust the RTL without re-deriving it. KEEP THESE RATHER MINIMAL AND USE SIMPLE WORDS. Should be easy to understand
- `PREFIXES`: lists which of the signal-name prefixes below are actually used in this file.
- `ITERATIVE PROCESS NOTES`: a living TODO/scratchpad kept *in* the file — deferred work, rejected approaches and why, reminders (e.g. "update VHDL entities in OneNote once module is locked"). Keep this section instead of deleting stale design discussion; it documents why something is *not* done yet.

## Libraries
Virtually every file uses:
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
```

## Naming
- Entity name matches the filename. Architecture name is `RTL` for real logic, `STRUCTURE` for the structural top-level, `sim` for simulation-only dummy primitives (e.g. `SB_HFOSC.vhd`). Group in/out ports in the entity declaration according to what modules they interface (and add a small comment above these groups to make this clear to the reader).
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



## TOP_TODO.md is mandatory
top.vhd is deliberately deferred until all module work is complete, so it is
currently stale and does not elaborate. rev2/fpga/TOP_TODO.md is the only record of what the eventual rewrite must do.

Before finishing ANY task that does one of the following, append a row to the
relevant table in TOP_TODO.md in the same pass:
  - adds, removes or renames a port on any module
  - adds a new module or package
  - adds or changes a generic that top.vhd must set
  - defers any behaviour to top level
  - resolves an item already listed (mark it RESOLVED, don't delete it)

Report at the end of every task either the row you added, or "TOP_TODO.md:
no change required" — explicitly, so a silent omission is visible.


## Compiling

Two tools, two purposes. Do not confuse them. Both scripts live in rev2/fpga/.

**After EVERY module edit — no exceptions:**
    rev2\fpga\check.bat rev2\fpga\rtl\<module>.vhd
Report the result explicitly: pass, or the exact error. Never claim a module is
done without running this.

**Before any commit touching multiple modules:**
    rev2\fpga\check.bat
Full dependency-ordered analysis. Catches cross-module port mismatches that
per-module checks cannot.

**Full synthesis — only when I ask, or before a commit touching top.vhd:**
    rev2\fpga\build.bat
Then report:
  - any undriven or multiply-driven signal warnings — treat these as errors
  - resource usage: LUTs, EBRs
  - post-route Fmax and WNS
Rev1 baseline: ~60.26 MHz Fmax, +4.238 ns WNS. Flag any drop below 48 MHz — that
is the system clock and there is no margin below it.

Synthesis needs a working top-level entity. top.vhd is stale (see TOP_TODO.md), so
build.bat will fail until it is rewritten. That is expected; use check.bat instead.
Do not "fix" top.vhd opportunistically — it is a deliberate single pass at the end.

GHDL is stricter than Synplify about VHDL-2008 legality. When check.bat rejects
something Synplify accepted, assume GHDL is right and fix the source — do not work
around it or loosen the standard flag.

## Timing patterns (learned the hard way)

- Declare every integer signal with an explicit `range`. A bare `integer` is 32 bits
  and infers a 32-bit carry chain.
- Prefer counting DOWN to a constant over counting UP to a variable. Comparing against
  a literal is a shallow tree; comparing against a signal costs a compare plus whatever
  computed that signal.
- Latch derived bounds once at frame/capture start. Never recompute `X - 1` every cycle
  to compare against it.
- Don't put wide multiplexers in series with a counter's clock enable.
- Do not expect registering a signal to keep it off the critical path -- the optimiser
  decides whether it lands in series or parallel with everything else feeding the same
  destination, regardless of how the RTL groups it into signals or processes. A register
  can't be flattened away, but where its read lands relative to other logic is still the
  tool's call, not something RTL structure can force. See rev2/fpga/timing_notes.md for
  the case this was learned from.