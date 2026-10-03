# IntelliWatt RTL starter

SystemVerilog foundation for an FPGA demonstration and eventual ASIC IP.
No Jupyter Notebook or processor software is required for this starter.

## Layout

| Path | Purpose |
| --- | --- |
| `rtl/` | Synthesizable, portable design |
| `tb/` | Self-checking simulation |
| `constraints/` | Board constraint template; verified mappings still needed |
| `scripts/` | Icarus simulation and Vivado batch builds |
| `docs/` | Architecture and ZCU104 implementation plan |
| `build/` | Generated outputs, ignored by Git |

## Run

Install Icarus Verilog with SystemVerilog support, then run `make sim`.
The testbench checks reset priority, enable/hold behavior, rollover, and
random enable sequences using a small counter width.

With Vivado and Zynq UltraScale+ device support installed, run `make synth`.
This produces a synthesis checkpoint and utilization report for
`xczu7ev-ffvc1156-2-e`. It is not a timing-qualified hardware build.

After completing the board integration described in [docs/ZCU104.md](docs/ZCU104.md),
run `make bitstream XDC=/absolute/path/to/verified.xdc`.
For a new board wrapper, update the Tcl source list and synthesis top first.
Outputs are under `build/vivado/`. `make clean` removes generated outputs.

The demo is a resettable enabled counter with a heartbeat output. It proves
an RTL/simulation/build foundation; it does not yet implement IntelliWatt
power measurement, DVFS, or a power management algorithm.
