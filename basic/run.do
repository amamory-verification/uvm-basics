
if [file exists "work"] {vdel -all}
vlib work

# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

#VHDL DUT
#vcom -f dut.f

# SystemVerilog DUT
# vlog ../misc/tinyalu.sv

vlog dut.v
vlog -f tb.f

vsim top -coverage +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=test2
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all