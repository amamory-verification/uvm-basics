if [file exists "work"] {vdel -all}
vlib work

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

# timeout of 1ms
# use '-sv_seed' to set the seed. example '-sv_seed=10'
vsim top -coverage +UVM_CONFIG_DB_TRACE +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_FULL +UVM_TESTNAME=smoke_test 
#### +uvm_set_config_int=uvm_test_top.env.agent4.monitor,cred_distrib,10
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
