# Rev2 Timing Notes

## Bottom line

**Rev2 does not currently close timing at 48 MHz.**

Final measured state: **Fmax 42.47 MHz, WNS -2.715 ns, EBR 24/30, LUT ~963 (18%)**.

This is a measured, well-characterised gap with a documented cause (below) and a
specific Rev3 fix (also below) — not an open question and not a regression nobody
understands. It should not be read past or assumed fixed by a later note; it is the
headline of this file.

---

## Progression across five optimisation rounds

| Round | Fmax | WNS | What changed |
|---|---|---|---|
| 1 (baseline) | 30.87 MHz | -11.563 ns | Starting point for this pass, measured after the earlier RAM-mapping fix in `trace_buffer.vhd` (a separate, already-resolved issue — see `TOP_TODO.md`). Nothing timing-specific fixed yet. |
| 2 | 30.63 MHz | -11.814 ns | `capture_engine.vhd`: `r_pre_samples`/`r_post_samples`/`r_prefill_count`/`r_post_remaining` were bare unconstrained `integer`s (32-bit by default); constrained to their real maximum, 9216. This fixed `capture_engine`'s own worst path outright (its critical path improved by ~7.5 ns in isolation), but overall Fmax barely moved — `frame_tx.r_pl_count` was an equally-bad co-bottleneck the whole time and simply became the sole worst path once this one was gone. |
| 3 | 36.44 MHz | -6.609 ns | `frame_tx.vhd`: `r_pl_count` (up-counter compared against a live `r_frame_len - 1` subtraction every cycle) replaced with `r_bytes_remaining` (down-counter tested against the constant `1`). |
| 4 | 39.39 MHz | -4.556 ns | `send_engine.vhd`: `r_sample_index` (up-counter vs. live `r_sample_count - 1`) replaced with `r_samples_remaining` (down-counter vs. `1`); the circular-buffer wraparound compare (`r_ram_rd_addr = r_sample_count - 1`, recomputed every cycle) replaced with `r_last_addr`, latched once at send-start. |
| 5 | 42.47 MHz | -2.715 ns | Four fixes landed together in one Implementation run: (A) `trace_buffer.o_ram_rd_data` registered after its mode-mux — it had been driven combinationally all the way into `frame_tx`'s CRC register across four modules with zero pipeline stages; `send_engine` got a matching `WAIT_RAM_2` state. (B) `capture_engine.r_prefill_count`'s *remaining* issue after round 2's width fix — still an up-counter tested against a live `r_pre_samples - 1`; replaced with `r_prefill_remaining`, a down-counter vs. `1`. (C) `capture_engine`'s edge-trigger detection: `r_prev_sample` (16-bit, muxed by `r_edge_trigger_ch` three times inline) replaced with `r_trig_ch_prev` (1-bit register) + `s_trig_ch_cur` (1-bit, computed once) — removed a duplicate 16-way mux that sat in series with `r_edge_trigger_type`/`r_state` and fed `r_post_remaining`'s clock enable. (D) `config_regs.r_confirm_count` (one ~25-bit counter) replaced with a two-stage prescaler (1 ms, 16-bit) driving a millisecond counter (500, 9-bit). |

**The failed sixth round** (attempted, measured, reverted — not in the table above
because it made things worse): a further attempt to decouple `r_post_remaining`'s
clock enable from `r_state`'s decode via a dedicated `r_in_post_trigger` flag, plus
registering `r_edge_trigger_type` as three mutually-exclusive one-bit flags
(rising/falling/either) instead of decoding a 2-bit value inline. Both changes were
proven logically equivalent by an explicit inductive trace before being measured — the
values and timing were identical to the pre-change RTL. Measured result: **Fmax 37.71
MHz, WNS -5.682 ns** — a **4.8 MHz drop** from round 5. Read the actual post-route
path: the two new registers (`r_in_post_trigger`, `r_edge_is_falling`) appeared *in
series* between the channel-select mux and the final clock-enable mux, not in
parallel with `r_state`'s decode as intended — Synplify's optimizer fused them into
one longer chain instead of two shorter independent ones. Reverted in full back to
round 5's RTL.

**Why it failed, and the general lesson**: the four successful rounds (2 through 5)
all removed *arithmetic* the tool cannot reinvent — a 32-bit carry chain is a 32-bit
carry chain regardless of how the optimizer looks at it, and a live subtraction is a
live subtraction. The failed round instead reshaped *boolean structure* — which
signal reads happen in what order relative to each other — and Synplify's technology
mapper rebuilds boolean logic from a flattened representation of the whole design
regardless of how the RTL groups it into signals or processes. A register's
existence can't be optimized away, but *where its read lands relative to everything
else feeding the same destination* is still entirely the placer/mapper's call, not
something the RTL's structure can force. **RTL structure is a suggestion to the
optimizer, not a specification.** Recorded here so this exact approach is not
retried without a different lever (e.g. actual floorplanning/placement constraints).

---

## Where restructuring stopped paying

At round 5 (the current best-measured state), the worst path is:
**67% routing delay, 33% logic delay** — measured from the timer's own per-hop delay
table (16 logic stages / 7,802 ps vs. 42 routing stages / 15,745 ps), not assumed —
**on an 18%-full die** (963 of 5,280 LUTs; EBR is fixed at 24/30 by design, not
congestion).

That combination — routing-dominated, on a device that's nowhere near full — is a
placement-distance signature, not a logic-depth one. The signals involved
(`r_state`, `r_edge_trigger_ch`, etc.) have high fanout and get read from many
scattered points in the design, and the placer evidently isn't keeping their
consumers physically close together. Further gains from here need floorplanning or
placement-constraint work, not more RTL restructuring — the cheap, high-leverage bug
classes (below) are exhausted; this is where that category of fix stopped paying.

---

## The four bug classes found

1. **Unconstrained 32-bit integers.** A bare `integer` signal (no `range` clause)
   defaults to VHDL's full 32-bit signed range, so Synplify builds a real 32-bit
   counter/comparator even when the value only ever needs a handful of bits. Found
   in `capture_engine.vhd` (round 2); owned the single worst path in the design at
   that point (~11.3 ns of unnecessary carry chain).
2. **Live `X - 1` subtraction feeding a same-cycle compare.** Comparing a counter
   against `some_signal - 1`, recomputed fresh every cycle, forces a live subtractor
   into the same-cycle path alongside the compare and whatever it gates. Found in
   `frame_tx.vhd` (round 3), `send_engine.vhd` (round 4, twice — the termination
   test and the wraparound compare), and `capture_engine.vhd` (round 5B). Fix in all
   four cases: a down-counter latched once from the bound, tested against the
   constant `1`.
3. **Wide multiplexers in series with a counter's clock enable.** A 16-way (or
   wider) select feeding directly into whether a register updates puts the full
   depth of that mux on the register's own timing budget every cycle, even on
   cycles where the register doesn't actually need to change. Found in
   `capture_engine.vhd`'s edge-trigger detection (round 5C) — a 16-way channel-select
   mux was duplicated (once for the current sample, once for the previous sample)
   and both copies sat in series with `r_edge_trigger_type`/`r_state`, feeding
   `r_post_remaining`'s enable.
4. **A wide counter where a two-stage prescaler suffices.** `config_regs.r_confirm_count`
   is a genuine ~25-bit counter (500 ms at 48 MHz) — not a declaration bug, since it
   really does need to count real time. But incrementing all 25 bits every clock is
   unnecessary precision for a timeout with no requirement to be exact. Fix (round
   5D): a 16-bit prescaler ticking a 9-bit millisecond counter, same total duration
   (verified cycle-for-cycle, not just by aggregate duration), two short carry
   chains instead of one long one.

A fifth, related finding that doesn't fit these four categories but mattered just as
much: **a missing pipeline register across module boundaries** (round 5A) — `trace_buffer`'s
RAM output reached `frame_tx`'s CRC register through `send_engine` and `tx_mux` with
zero registers anywhere in that chain, so its combinational depth was whatever four
modules' worth of muxing happened to add up to. Fixed by registering the RAM output
after its own mode-mux and adding one matching wait state (`send_engine.WAIT_RAM_2`).

---

## The SDC clock never binds — measurements are against the wrong target

The design's own timing constraint, `clk52` (52.8 MHz / 18.939 ns, chosen as a ±10%
margin over the nominal 48 MHz system clock — see
`rev2/fpga/constraints/synopsys_design_constraints.sdc`), **does not bind** inside
the Lattice place-and-route chain. Every stage (`sbtplacer`, `sbrouter`, `sbtimer`)
logs `Info-1409: Inferred clock at E1.HF_OSC/CLKHF` and falls back to an
auto-inferred 48 MHz default instead — `clk52` shows up in every summary table with
`Frequency: N/A` and zero paths attributed to it.

This was tested deliberately, not assumed: four different `create_clock` target
phrasings were tried side by side in one diagnostic run — `get_nets{E1.o_clk}`,
`get_nets{CLK}`, `get_pins{E1.HF_OSC/CLKHF}`, `get_pins{E1/HF_OSC/CLKHF}`. Every
valid net-based target Synplify accepts gets auto-retargeted, internally, to the
identical downstream pin reference `get_pins{E1.HF_OSC/CLKHF}` — and that exact
string is what the Lattice tools fail to resolve, regardless of which source-level
phrasing produced it. This is not fixable by editing the `.sdc` text: the failing
string is generated by Synplify's own net-to-pin retargeting during synthesis, not
authored in the source file at all.

**Practical consequence**: every Fmax/WNS number in the progression table above is
measured against 48 MHz, not the intended 52.8 MHz. Synplify's own pre-route
estimate — from its `fpga_mapper` stage timer, which *does* bind `clk52` correctly,
since the binding failure is specific to the downstream Lattice P&R tools — puts the
true gap at roughly **-2.15 ns against the real 52.8 MHz target**, measured at the
equivalent point in the RTL's evolution. The reported numbers are pessimistic
relative to the actual design intent, not optimistic.

---

## Rev1 comparison

Rev1 baseline: **Fmax ~60.26 MHz, WNS +4.238 ns** (positive — Rev1 closed timing with
real margin). Rev2's best measured state (42.47 MHz / -2.715 ns against 48 MHz, or
effectively closer to -2.15 ns against the real 52.8 MHz target per the Synplify
estimate above) is behind that baseline. This reflects Rev2 adding substantially more
logic (full protocol framing, CRC, sequence tracking, response queueing, runtime-configurable
everything) than Rev1 had, on top of the specific bugs documented above — not a
mystery regression.

---

## Rev3 remedy

Route the FT2232H's 12 MHz reference oscillator to an FPGA pin and drive
`SB_PLL40_CORE` from it, giving a crystal-accurate 48 MHz system clock in place of
`SB_HFOSC`'s internal RC oscillator. This removes the drift the 52.8 MHz margin
existed to cover in the first place — the SDC's own comment on `clk52` says exactly
this: "account for internal oscillator (48MHz) with tolerance of +-10%." With a
crystal-accurate clock, that ±10% margin requirement goes away, and the real target
becomes a tight, well-defined 48 MHz rather than a padded 52.8 MHz — which the
current RTL may already be close enough to for a real close, once the SDC binding
issue above is also resolved (e.g. via iCEcube2's GUI constraint editor rather than
hand-written SDC text). This item already exists in `TOP_TODO.md` §7 (Deferred to
Rev3), originally justified for 6 Mbaud UART accuracy — it now carries this
timing-closure rationale too.
