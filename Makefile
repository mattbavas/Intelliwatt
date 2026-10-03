.PHONY: sim synth bitstream clean
sim:
	bash scripts/sim.sh
synth:
	vivado -mode batch -source scripts/build.tcl -tclargs synth
bitstream:
	@test -n "$(XDC)" || (echo 'Use make bitstream XDC=/path/to/verified.xdc'; exit 1)
	vivado -mode batch -source scripts/build.tcl -tclargs bitstream "$(XDC)"
clean:
	rm -rf build
