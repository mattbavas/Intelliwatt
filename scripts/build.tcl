# Usage: vivado -mode batch -source scripts/build.tcl -tclargs synth
# Or: ... -tclargs bitstream /absolute/path/to/verified.xdc
set root [file normalize [file join [file dirname [info script]] ..]]
set mode synth
if {$argc > 0} { set mode [lindex $argv 0] }
if {$mode ni {synth bitstream}} { error "Mode must be synth or bitstream" }
if {$mode eq "bitstream"} {
    if {$argc != 2} { error "Bitstream mode requires a verified XDC path" }
    set xdc [file normalize [lindex $argv 1]]
    if {![file isfile $xdc]} { error "XDC not found: $xdc" }
    if {[file tail $xdc] eq "zcu104_template.xdc"} { error "Template XDC is not board-ready" }
}
set out [file join $root build vivado $mode]
file mkdir $out
create_project -in_memory -part xczu7ev-ffvc1156-2-e
read_verilog -sv [file join $root rtl intelliwatt_top.sv]
if {$mode eq "bitstream"} { read_xdc $xdc }
synth_design -top intelliwatt_top
report_utilization -file [file join $out utilization_synth.rpt]
write_checkpoint -force [file join $out synth.dcp]
if {$mode eq "bitstream"} {
    if {[llength [get_clocks]] == 0} { error "A verified clock constraint is required" }
    opt_design
    place_design
    route_design
    report_drc -file [file join $out drc.rpt]
    report_timing_summary -report_unconstrained -file [file join $out timing.rpt]
    check_timing -verbose -file [file join $out timing_checks.rpt]
    set paths [get_timing_paths -delay_type min_max -max_paths 10]
    foreach path $paths {
        if {[get_property SLACK $path] < 0} { error "Timing failed; review timing.rpt" }
    }
    write_checkpoint -force [file join $out routed.dcp]
    # Vivado's standard DRC checks remain enabled (including UCIO/NSTD).
    write_bitstream -force [file join $out intelliwatt_top.bit]
}
