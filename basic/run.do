
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

coverage attribute -name TESTNAME -value test2
coverage save test2.ucdb

#vcover merge  smoke_test.ucdb zeros_test.ucdb neg_test.ucdb
vcover report test2.ucdb -cvg -details