
if [file exists "work"] {vdel -all}
vlib work

# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

#VHDL DUT
vcom mult.vhd

# SystemVerilog DUT
# vlog ../misc/tinyalu.sv
#vlog dut.v

# TB
vlog -f tb.f

vsim top -coverage +UVM_VERBOSITY=UVM_HIGH +UVM_TESTNAME=smoke_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all