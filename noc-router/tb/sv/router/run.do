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
# use +UVM_CONFIG_DB_TRACE to debug config_db
vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=smoke_test 
#### +uvm_set_config_int=uvm_test_top.env.agent4.monitor,cred_distrib,10
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
#do wave_full.do
run -all
coverage attribute -name TESTNAME -value smoke_test
coverage save smoke_test.ucdb

vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=sequential_test 
#### +uvm_set_config_int=uvm_test_top.env.agent4.monitor,cred_distrib,10
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value sequential_test
coverage save sequential_test.ucdb

# timeout of 1ms
vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=main_test 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value main_test
coverage save main_test.ucdb

vcover merge  -out router.ucdb main_test.ucdb smoke_test.ucdb sequential_test.ucdb
vcover report router.ucdb -cvg -details

