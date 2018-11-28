
#if [file exists "work"] {vdel -all}
#vlib work

# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

#VHDL DUT
vcom mult.vhd

# SystemVerilog DUT
# vlog ../misc/tinyalu.sv
#vlog dut.v

# TB
vlog -f tb.f

vsim top -coverage +UVM_VERBOSITY=UVM_FULL +UVM_TESTNAME=smoke_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value smoke_test
coverage save smoke_test.ucdb

vsim top -coverage +UVM_VERBOSITY=UVM_FULL +UVM_TESTNAME=zeros_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value zeros_test
coverage save zeros_test.ucdb

vcover merge  smoke_test.ucdb zeros_test.ucdb 
vcover report smoke_test.ucdb -cvg -details
