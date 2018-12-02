module top;
	import uvm_pkg::*;
	import dut_pkg::*;

dut_if dut_if1();
dut    dut1(.clk(dut_if1.clk), .rst(dut_if1.rst), .cmd(dut_if1.cmd), .data(dut_if1.data), .addr(dut_if1.addr), .dout(dut_if1.dout));

initial
begin: blk
	uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vi", dut_if1);

	//run_test("my_test");
	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top