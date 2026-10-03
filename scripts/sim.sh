#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
command -v iverilog >/dev/null || { echo "Install Icarus Verilog (iverilog and vvp)." >&2; exit 1; }
command -v vvp >/dev/null
mkdir -p build/sim
iverilog -g2012 -Wall -s intelliwatt_top_tb -o build/sim/demo.vvp rtl/intelliwatt_top.sv tb/intelliwatt_top_tb.sv
vvp build/sim/demo.vvp
