class my_test extends uvm_test;

my_dut_config dut_config_0;

function void build_phase(uvm_phase phase);
	dut_config_0 = new();
	
	if (!uvm_config_db #(virtual dut_if)::get (this,"", "dut_vi", dut_config_0.dut_vi) )
		`uvm_fatal("MY_TEST", "No DUT_IF");
	// other DUT configuration
	uvm_config_db# (my_dut_config)::set(this,"*", "dut_config", dut_config_0);

endfunction : build_phase

endclass: my_test
