
#if [file exists "work"] {vdel -all}
#vlib work

# Comment out either the SystemVerilog or VHDL DUT.
# There can be only one!

#VHDL DUT
vcom ../../../dut/HeMPS_defaults.vhd 
vcom ../../../dut/Hermes_buffer.vhd
vcom ../../../dut/Hermes_crossbar.vhd  
vcom ../../../dut/Hermes_switchcontrol.vhd  
vcom ../../../dut/RouterCC.vhd

# SystemVerilog DUT
# vlog ../misc/tinyalu.sv
#vlog dut.v

# TB
vlog -f tb.f


vsim top -coverage +UVM_TIMEOUT=1ms +UVM_VERBOSITY=UVM_FULL +UVM_TESTNAME=main_test 
#### +uvm_set_config_int=uvm_test_top.env.agent4.monitor,cred_distrib,10
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all

coverage attribute -name TESTNAME -value smoke_test
coverage save smoke_test.ucdb

#vcover merge  -out multi.ucdb smoke_test.ucdb zeros_ones_test.ucdb neg_test.ucdb
vcover report smoke_test.ucdb -cvg -details