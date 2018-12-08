module top;
	import uvm_pkg::*;
	import dut_pkg::*;


dut_if dut_if1();
dut  #(.N(dut_pkg::DATA_WIDTH))  dut1(.clk(dut_if1.clk), .rst(dut_if1.rst), .cmd(dut_if1.cmd), 
	.data(dut_if1.data[dut_pkg::DATA_WIDTH-1:0]), 
	.dout(dut_if1.dout[dut_pkg::DATA_WIDTH-1:0]));

initial
begin: blk
	uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vi", dut_if1);


	// testing range of the main configuration parameters
	data_width_check: assert (dut_pkg::DATA_WIDTH <= 31) $display ("parameter DATA_WIDTH is OK");
    else $fatal("INVALID parameter DATA_WIDTH");

	max_val_check: assert (dut_pkg::MAX_RAND_VAL <= 2**dut_pkg::DATA_WIDTH-1) $display ("parameter MAX_RAND_VAL is OK");
    else $fatal("INVALID parameter MAX_RAND_VAL");

	//run_test("my_test");
	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top