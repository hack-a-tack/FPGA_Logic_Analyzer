# FPGA Timing Closure — Working Notes

Rev2 logic analyzer, iCE40UP5K SG48. Written 2026-08-19 during the first
post-integration implementation run.

---

## 1. Terminology

The full flow is **implementation**, in two stages:

- **Synthesis** — RTL to a gate-level netlist. This is where RAM *inference* happens.
- **Place and route (P&R)** — netlist to physical resources. This is where **timing
  numbers come from**.

"Compile" is not used for FPGA flows. The RAM inference failure was a synthesis/mapping
problem; the 30.87 MHz result is a P&R result.

---

## 2. Why timing exists at all

Flip-flops are the only elements that remember. Everything between them — LUTs, wires,
EBR outputs — is combinational: signals ripple through as fast as physics allows.

On every clock edge, a flip-flop captures **whatever is on its input at that instant**.
It does not wait and does not check whether the value has settled.

So the requirement is: between one clock edge and the next, a signal must leave flop A,
traverse all intervening logic and routing, and arrive **stable** at flop B.

At 48 MHz that budget is 20.8 ns. At the 52.8 MHz constraint, 18.9 ns.

---

## 3. The critical path

A design contains thousands of flop-to-flop paths. The slowest one is the **critical
path**, and it alone sets the maximum clock frequency — the clock must be slow enough
for the worst path to complete.

Group-hike principle: twenty walkers, the group arrives when the slowest does. Speeding
up the fast ones changes nothing.

**Rev2's current numbers:**

| Quantity | Value | Meaning |
|---|---|---|
| Constraint | 18.9 ns (52.8 MHz) | Time available per clock period |
| Critical path | ~32 ns | Time actually needed |
| WNS | −11.563 ns | 18.9 − 32; negative means failure |
| Fmax | 30.87 MHz | 1 / 32 ns — fastest clock this path tolerates |

Fmax and WNS are two views of one measurement: WNS is slack against the constraint;
Fmax is the frequency at which slack reaches zero.

---

## 4. Pipelining

Split one long journey into shorter legs by inserting a flip-flop partway.

Before — one 32 ns path:

    RAM read -> mux -> compare -> adder -> destination flop

After — two shorter paths:

    Cycle 1: RAM read -> mux            (~15 ns) -> new flop
    Cycle 2: compare -> adder           (~17 ns) -> destination flop

The total work is unchanged. The **longest single leg** drops from 32 ns to 17 ns, which
fits the budget. Relay race rather than one runner.

**The cost is latency:** data now takes two cycles to cross that stretch instead of one.

**Pipelining buys throughput with latency.** When the consumer is slow, it is nearly
free. In this design, `send_engine` hands each sample byte to a UART that needs at least
8 clocks per bit — 80 per byte. One extra clock of RAM latency against 80 clocks of
transmission is invisible.

---

## 5. Fmax above the oscillator frequency is NOT wasted

`SB_HFOSC` provides 48 MHz, so Fmax above 48 MHz buys no additional operating speed.
It is still valuable, for three reasons:

1. **Room for future logic** — added logic on the critical path consumes slack. Positive
   WNS means it can be absorbed without re-pipelining.
2. **PVT margin** — timing is reported at one process/voltage/temperature corner. A
   design closing at exactly 0.0 ns can fail on a warm board or a slow silicon lot.
   Margin is reliability, not just growth room.
3. **Oscillator drift** — `SB_HFOSC` is an untrimmed RC oscillator and can run fast.

The 52.8 MHz constraint (18.939 ns) is itself deliberate margin: 48 MHz + 10%. Closing
at 52.8 means the design still works if the oscillator drifts high.

**Rev1 reference:** Fmax ~60.26 MHz, WNS +4.238 ns against the same 52.8 MHz constraint
— roughly 14% headroom above the constraint, 25% above the actual clock.

---

## 6. Logic delay vs routing delay

A failing path is not always fixed by pipelining. The timing report splits total delay
into two components:

| Dominant component | Meaning | Typical fix |
|---|---|---|
| **Logic** | Too many levels of combinational logic in series | Insert a pipeline stage |
| **Routing** | Signal spends its time on wires crossing the chip | Reduce fanout, improve placement, lower utilisation |

High device utilisation inflates routing delay because the router runs out of short
paths. Check utilisation before assuming a logic problem.

---

## 7. `set_false_path` and asynchronous inputs

Static timing analysis asks: did the signal depart flop A early enough to arrive at flop
B before the capture edge? Answering that requires knowing **when it departed**, which
requires a clock at the source.

An external input pin has no source clock. `i_FTDI_CTS_N` changes when the FT2232H
decides; `i_LA0..15` change when the circuit under test does. There is no edge
relationship to compute, so the tool either invents one and reports meaningless
violations, or is told not to time the path.

`set_false_path` is that instruction: *do not time this path, it is handled another way.*

**The synchroniser is the "another way."** A flop sampling an input that changes near the
clock edge can go metastable — output hovering between valid levels. A second flop gives
it a full clock period to settle, making failure improbable rather than impossible. This
substitutes a **probabilistic guarantee for a timing guarantee**.

The two must go together. `set_false_path` without a synchroniser does not fix
metastability; it only hides the warning. Hence: RTL synchroniser first, constraint
second.

Constrained as false paths in this design:

- `i_LA0..i_LA15` — 2-FF synchroniser in `capture_engine` (added 2026-08-19)
- `i_UART_RX` — 2-FF synchroniser in `uart_rx`
- `i_FTDI_CTS_N` — 2-FF synchroniser in `uart_tx`

No output-delay constraints: nothing downstream of the LEDs, debug pins or
`o_FTDI_RTS_N` has a setup/hold requirement, and UART bit timing is governed by
`uart_tx`'s internal counter rather than pin timing.

`SAMP_TICK` is **not** a generated clock. It is a clock enable read inside
clock-domain registers, never a register clock input. This remains a single-clock design.

---

## 8. Block RAM inference

**Inference is pattern-matching, not analysis.** The synthesiser looks for a specific
shape: one array, one clocked access, address from a single expression. Anything
obscuring that shape falls back to flip-flops.

The failure is loud but the *cause* is silent — the fatal error reports a register-count
overflow, not "your RAM did not infer."

**What went wrong here:** `trace_buffer`'s `ram_proc` read each bank from inside
mode-dependent branches, with a different address expression per branch. Synplify saw
several distinct memories rather than one array read two ways, roughly doubling EBR
demand. When EBR ran out, the remainder dissolved into flip-flops: 98,327 registers
against a 5,280 budget.

**The fix — canonical form:** read both banks unconditionally at a single address every
cycle, then apply mode selection *afterwards*, combinationally, on the already-read
values. Reading both banks is free — they are separate EBR instances with independent
ports, and the unused result is discarded.

**Capacity was never the issue.** 2 × 6144 × 8 = 98,304 bits against 120 kbit of EBR
(30 × 4 kbit) — 24 of 30 EBRs, ~80% utilisation, with 6 spare. The `98321` figure in the
log was a flip-flop count after dissolution, not a memory geometry.

**Caution:** moving the selection mux after the RAM read is correct for inference, but it
appends combinational logic to a path that already begins at an EBR output — and EBR
clock-to-out is slow on this device. This is the leading suspect for the current
critical path.

---

## 9. Diagnostic order

Do not pipeline on a hunch. Adding a stage in the wrong place costs latency and buys
nothing.

1. Read the P&R timing report; identify the actual worst path end to end.
2. Check whether the top failing paths share a common segment — that usually means one
   structure owns the problem.
3. Check the logic-vs-routing split for each (§6).
4. Check total utilisation — high utilisation points the fix elsewhere.
5. Fix the single worst path.
6. Re-run implementation. The next-worst path may now be critical; repeat.

A 71% gap (30.87 vs 52.8 MHz) is usually one bad structure, but can be two paths
requiring separate fixes.

---

## 10. Open items

- Read the P&R timing report and identify the true critical path — **not yet done**.
- Confirm EBR usage is ≤24 after the inference fix.
- Decide whether the 52.8 MHz constraint is a real requirement or conservatism. Note
  that reconstraining to 48 MHz (20.833 ns) would **not** rescue a −11.563 ns miss; the
  gap is far too wide.
- Zero testbenches exist. Implementation success proves the design is buildable, not
  correct.