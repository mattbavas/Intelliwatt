# Starter architecture

`intelliwatt_top` accepts a clock, synchronous active-high reset, and
synchronous enable. On each enabled clock edge the counter increments;
when disabled it holds. Reset takes priority. The most significant counter
bit is the heartbeat output. COUNTER_WIDTH must be at least 1 (default 26).
The enabled heartbeat frequency is f_clk / 2^COUNTER_WIDTH.

Use clock enables rather than combinationally gating a clock. This portable
core has no FPGA primitives, initial register values, vendor IP, or software
dependency. Testbench timing constructs are confined to tb/.

Future IP boundaries: activity monitors -> sampled counters -> policy engine
-> registered control requests. Define sampling windows, counter widths,
overflow rules, thresholds, hysteresis, and control handshakes before adding
these blocks. A synthetic activity counter is not a calibrated power sensor.
Actual voltage/frequency control needs a separately specified board interface.

For ASIC work, keep pad/clock primitives in wrappers, add lint and CDC checks,
and define reset, DFT, timing, and any UPF power intent with the implementation
team. FPGA clock-enable behavior alone does not establish ASIC power savings.
