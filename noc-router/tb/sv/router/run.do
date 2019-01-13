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

# USEFULL PARAMETERS
# timeout of 1ms
# use '-sv_seed' to set the seed. example '-sv_seed=10'
# -sv_seed random 
# use +UVM_CONFIG_DB_TRACE to debug config_db
# to debug randomization errors -solvefaildebug
# to enable DB debug  db
# to enable SV class debug -classdebug
# to enable UVM debug -uvmcontrol=all
# to enable the fullest UVM-aware debug '-classdebug -msgmode both -uvmcontrol=all'
#### +uvm_set_config_int=uvm_test_top.env.agent4.monitor,cred_distrib,10
vsim top -coverage -classdebug -msgmode both -uvmcontrol=all +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=smoke_test 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
#do wave_full.do
do shutup.do
run -all
coverage attribute -name TESTNAME -value smoke_test
coverage save smoke_test.ucdb


vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=smoke_test2 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
do shutup.do
run -all
coverage attribute -name TESTNAME -value smoke_test2
coverage save smoke_test2.ucdb

vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=rand_header_test 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
do shutup.do
run -all
coverage attribute -name TESTNAME -value rand_header_test
coverage save rand_header_test.ucdb

vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=random_test 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
do shutup.do
run -all
coverage attribute -name TESTNAME -value random_test
coverage save random_test.ucdb

vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=sequential_test 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
do shutup.do
run -all
coverage attribute -name TESTNAME -value sequential_test
coverage save sequential_test.ucdb

vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=bottleneck_test 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
do shutup.do
run -all
coverage attribute -name TESTNAME -value bottleneck_test
coverage save bottleneck_test.ucdb

vsim top -coverage +UVM_TIMEOUT=1000000 +UVM_VERBOSITY=UVM_LOW +UVM_TESTNAME=main_test 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
do shutup.do
run -all
coverage attribute -name TESTNAME -value main_test
coverage save main_test.ucdb

vcover merge  -out router.ucdb main_test.ucdb bottleneck_test.ucdb sequential_test.ucdb random_test.ucdb rand_header_test.ucdb smoke_test2.ucdb  smoke_test.ucdb 
vcover report router.ucdb -cvg -details

