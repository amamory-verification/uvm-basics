class my_test extends uvm_test;

my_dut_config dut_config_0;

function void build_phase(uvm_phase phase);
	dut_config_0 = new();

endfunction : build_phase

