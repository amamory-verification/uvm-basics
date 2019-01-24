 
# these are the knobs you might want to change. 
set SEED      random
set VERBOSITY UVM_LOW
set COVERAGE  1       # set 1 to enable coverage
set RTL_SIM   1       # if 1, simulate RTL, otherwise, simulates the netlist
set DEBUG_SIM 1       # if 1, simulate for debug, therwise simulate for speed/regression

if {$DEBUG_SIM == 1} {
	set DEBUG_ARGS "-permit_unmatched_virtual_intf +notimingchecks -suppress 8887   -i -uvmcontrol=all -msgmode both -classdebug -assertdebug +uvm_set_config_int=*,enable_transaction_viewing,1 "
} else {
	set DEBUG_ARGS ""
}

# lsits of tests to be executed
set TEST_NAME {repeat_test parallel_test}

set ::env(VIP_LIBRARY_HOME) /home/ale/repos/verif/uvm-basics/noc-router/vips
set ::env(PROJECT_DIR) /home/ale/repos/verif/uvm-basics/noc-router/hermes_router

file delete -force *~ *.ucdb vsim.dbg *.vstf *.log work *.mem *.transcript.txt certe_dump.xml *.wlf covhtmlreport VRMDATA
file delete -force design.bin qwave.db dpiheader.h visualizer*.ses
file delete -force veloce.med veloce.wave veloce.map tbxbindings.h modelsim.ini edsenv velrunopts.ini
file delete -force sv_connect.*
vlib work 
# interfaces
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(VIP_LIBRARY_HOME)/hermes_pkg -F $env(VIP_LIBRARY_HOME)/hermes_pkg/hvl.f 
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(VIP_LIBRARY_HOME)/hermes_pkg -F $env(VIP_LIBRARY_HOME)/hermes_pkg/hdl.f 

# environment
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(VIP_LIBRARY_HOME)/hermes_router_env_pkg $env(VIP_LIBRARY_HOME)/hermes_router_env_pkg/hermes_router_env_pkg.sv

# tests and seqs
#vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(PROJECT_DIR)/tb/parameters $env(PROJECT_DIR)/tb/parameters/wb2spi_parameters_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(PROJECT_DIR)/tb/seqs $env(PROJECT_DIR)/tb/seqs/hermes_router_seq_pkg.sv
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(PROJECT_DIR)/tb/tests $env(PROJECT_DIR)/tb/tests/hermes_router_test_pkg.sv

#dut
if {$RTL_SIM == 1} {
	vcom -suppress 2223 -suppress 2286 -F $env(PROJECT_DIR)/rtl/hdl_vhd.f
	vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(PROJECT_DIR)/rtl -F $env(PROJECT_DIR)/rtl/hdl_v.f
} else {
	vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(PROJECT_DIR)/syn -F $env(PROJECT_DIR)/syn/hdl.f
}

#testbench
vlog -sv -suppress 2223 -suppress 2286 +incdir+$env(PROJECT_DIR)/tb/testbench $env(PROJECT_DIR)/tb/testbench/top.sv

if {$DEBUG_SIM == 1} {
vopt +acc top  -o optimized_debug_top_tb
set top optimized_debug_top_tb
} else {
vopt      top  -o optimized_batch_top_tb
set top optimized_batch_top_tb
}

# execute all the tests in TEST_NAME 
for {set i 0} {$i<[llength $TEST_NAMES]} {incr i} {
    set test [lindex $list $i]
    puts $test
	vsim -sv_seed $(SEED) +UVM_TESTNAME=$(test) +UVM_VERBOSITY=$(VERBOSITY) $(DEBUG_ARGS) $top
	onbreak {resume}
	log /* -r
	#do wave_full.do
	do shutup.do
	run -all
	if {$COVERAGE == 1} {
		coverage attribute -name TESTNAME -value $(test)
		coverage save $(test).ucdb	
	}
}

if {$COVERAGE == 1} {
	set list_tests ""
	for {set i 0} {$i<[llength $TEST_NAMES]} {incr i} {
	    set test [lindex $list $i]
	    append list_tests ".ucdb " $test
	}
	puts $list_tests

	vcover merge  -out hermes_router.ucdb $list_tests
	vcover report hermes_router.ucdb -cvg -details
}
