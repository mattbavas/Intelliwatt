# TEMPLATE ONLY: no physical pins are assigned intentionally.
# Copy to constraints/zcu104.xdc after checking the board revision,
# AMD ZCU104 User Guide UG1267, schematic, and chosen PL clock source.
# Generic RTL ports: clk, rst, enable, heartbeat.
# For every external port, provide verified PACKAGE_PIN and IOSTANDARD.
# A differential board oscillator requires an FPGA wrapper with IBUFDS;
# do not connect this single-ended clk port to half a differential pair.
# External switches/buttons need synchronization; reset also needs a
# documented startup strategy. See docs/ZCU104.md.
# Example syntax (replace placeholders, do not enable as-is):
# set_property PACKAGE_PIN <verified_pin> [get_ports heartbeat]
# set_property IOSTANDARD <verified_standard> [get_ports heartbeat]
# create_clock -name pl_clk -period <verified_period_ns> [get_ports clk]
