
#if [file exists "work"] {vdel -all}
#vlib work

# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

#VHDL DUT
vcom ../../dut/unsigned_multi/mult.vhd

# SystemVerilog DUT
# vlog ../misc/tinyalu.sv
#vlog dut.v

# TB
vlog +incdir+../common  -f tb.f

vsim top -coverage +UVM_VERBOSITY=UVM_FULL +UVM_TESTNAME=smoke_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value smoke_test
coverage save smoke_test.ucdb

vsim top -coverage +UVM_VERBOSITY=UVM_FULL +UVM_TESTNAME=zeros_ones_test
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
# it is an unsigned mult, so there is no point in testing negative numbers
#coverage exclude -cvgpath /dut_pkg/mult_coverage/range_value/a_leg/neg
coverage attribute -name TESTNAME -value zeros_ones_test
coverage save zeros_ones_test.ucdb

vcover merge  -out unsigned_multi.ucdb smoke_test.ucdb zeros_ones_test.ucdb 
vcover report unsigned_multi.ucdb -cvg -details
