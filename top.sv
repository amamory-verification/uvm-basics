module top;
	import uvm_pkg::*;
	import dut_pkg::*;

dut_if dut_if1();

initial
begin: blk
	uvm_config_db#(virtual dut_if)::set(null, "uvm_test_top", "dut_vi", dut_if1);

	//run_test("my_test");
	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top