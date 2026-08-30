# rev2/fpga/tb — testbench conventions

Every testbench in this project follows the same shape, so all thirteen (one per
Rev2 module, plus `la_pkg_tb`) read alike regardless of who wrote them or when.

## Running a testbench

```
rev2\fpga\run_tb.bat <module_name>
```

For example, `rev2\fpga\run_tb.bat frame_tx` compiles `la_pkg.vhd`, then
`rtl\frame_tx.vhd`, then `tb\frame_tx_tb.vhd`, into a ModelSim work library at
`rev2/fpga/simulations/work/`, and runs it headless (`vsim -c`, no GUI). It works the
same way regardless of the caller's current directory (repo root or `rev2\fpga`),
like `check.bat`.

`tb/` holds only testbench `.vhd` sources (plus this README). Everything ModelSim
generates or reads at run time — the `work/` library, the transcript, per-module
`.log` files, `.wlf` waveform output — lives in `rev2/fpga/simulations/` instead,
which `run_tb.bat` creates on demand and which is entirely gitignored. This mirrors
the split Rev1 already used (`rev1/fpga/tb/` vs. `rev1/fpga/simulations/`).
`run_tb.do`, the do-script `run_tb.bat` drives `vsim` with, lives at
`rev2/fpga/run_tb.do`, next to `run_tb.bat` itself — it's tooling, not a testbench
source and not generated output, so it belongs with the script that owns it rather
than in either of the other two folders.

`run_tb.bat la_pkg` is the one exception: there is no separate DUT file to compile,
since `la_pkg.vhd` itself is what's under test.

The script's own exit code reflects the testbench's own summary line, not ModelSim's
process exit code (see "Pass/fail reporting" below) — `if errorlevel 1` after
`run_tb.bat` in a calling script or CI step means the testbench failed, not that the
tool crashed.

## Every testbench in this project is:

- **Fully self-checking.** Every check is a real VHDL `assert` with a descriptive
  message. A human should never have to read a waveform to know whether a
  testbench passed — the transcript alone must be enough.
- **Counted.** Every testbench keeps a running total of checks, passes and
  failures, and prints a final summary line: `<N> checks, <N> passed, <N> failed`,
  followed by an explicit `TEST PASSED` or `TEST FAILED` line. `run_tb.bat` greps
  the transcript for `TEST PASSED` — this exact string, on its own line, is the
  contract between a testbench and the run script. Missing it (a crash, a hang, a
  typo) is treated as failure, not ignored.
- **Deterministic.** A fixed 48 MHz clock (20.833 ns period) where the DUT has a
  clock at all, an explicit reset sequence, and no reliance on a signal's initial
  value doing the right thing by accident. (`la_pkg_tb` is the one exception: it
  tests a package of pure functions with no entity, no ports and no clock — see its
  own header for why a clock/reset would be meaningless there.)
- **Organized as one named procedure per test case.** A failing check's message
  identifies which test case broke (e.g. `"TC3 crc16_next purity: ..."`), not just
  a line number. Test cases are numbered and listed in the file's header comment
  block, in the same `========` style every other `.vhd` file in this project uses.
- **Terminated with `std.env.stop(<failure count>)`**, never an infinite `wait`.
  Passing `0` on success and a nonzero failure count otherwise also makes ModelSim
  propagate that count as its own process exit code, as a second, independent
  signal alongside the transcript grep.

## Pass/fail reporting, precisely

Each testbench maintains its own `v_checks` / `v_passes` / `v_failures` variables
(conventionally in the top-level stimulus process, shared with its nested test-case
procedures via ordinary VHDL lexical scoping — see any existing `tb/*.vhd` for the
pattern). A shared `check(condition, description)` procedure is the single place
that increments these and issues the `assert`, so the counters can never drift out
of sync with what was actually asserted. At the end of the run:

```
<N> checks, <N> passed, <N> failed
TEST PASSED        -- or TEST FAILED
```

`run_tb.bat` treats the presence of the literal string `TEST PASSED` in the
transcript as the pass signal, and its absence — for any reason, including a crash
that never reaches the summary line at all — as failure. This is deliberately the
safer direction: an ambiguous or missing result is a failure, not a pass.

## Structural conventions carried over from Rev1

Rev1's testbenches (`rev1/fpga/tb/`) established some structural patterns worth
keeping even though their pass/fail reporting predates the conventions above (they
use scattered `assert ... severity error` with no running counter, and end with
`assert false ... severity failure` rather than `std.env.stop` — superseded here,
not reused):

- A simple free-running clock process: `while true loop clk<='0'; wait for
  CLK_HALF; clk<='1'; wait for CLK_HALF; end loop;`, driven by `CLK_PERIOD`/`CLK_HALF`
  constants derived from `1 sec / CLK_FREQ`.
- An explicit reset procedure at the start of the stimulus process, not left to
  signal initial values.
- Nested named procedures for repeated stimulus/check patterns (e.g. Rev1's
  `uart_tx_tb.send_and_check_uart_frame`), declared inside the stimulus process so
  they share its local variables directly.
- For DUTs with real dependents (e.g. Rev1's `send_engine_tb` modeling
  `trace_buffer`'s synchronous read and `uart_tx`'s busy behaviour), separate
  concurrent "mock" and "monitor" processes: one drives a believable stand-in for a
  peripheral the DUT depends on, another passively watches DUT outputs and asserts
  invariants across the whole run, independent of the stimulus process's own
  linear script. Expect later, more complex Rev2 testbenches (`frame_tx`,
  `send_engine`) to need this.

One deliberate deviation from Rev1: DUT instantiation uses direct entity
instantiation (`dut: entity WORK.<module>(RTL)`), not a `component` declaration.
Rev1's testbenches used `component` throughout; this project's own house style
(`top.vhd`, see `CLAUDE.md`) already mandates direct instantiation for exactly this
reason once VHDL-2008 makes `component` unnecessary, and there's no reason for
testbenches to be the one place that still uses it.

## Compiling by hand (for debugging `run_tb.bat` itself)

```
cd rev2\fpga
if not exist simulations mkdir simulations
cd simulations
vlib work
vcom -2008 ..\rtl\la_pkg.vhd
vcom -2008 ..\rtl\<module>.vhd
vcom -2008 ..\tb\<module>_tb.vhd
vsim -c -do ..\run_tb.do <module>_tb
```

`rev2/fpga/simulations/` in its entirety is gitignored — never commit anything in
it. Delete it freely; `run_tb.bat` recreates it from scratch on the next run.
