module top;
import uvm_pkg::*;
import dut_pkg::*;

bit clock;
always #10 clock = ~clock; // clock generator

dut_if   dut_if(clock);
boothmult #(.N(16)) dut1(.clk(clock), .reset(dut_if.reset), 
	.start(dut_if.start), .multiplier(dut_if.A[15:0]), .multiplicand(dut_if.B[15:0]), 
	.done(dut_if.done), .product(dut_if.dout[31:0]));

initial
begin: blk
	//uvm_config_db#(virtual dut_if_base)::set(null, "*", "dut_vi", unsigned_dut_if.get_concrete_bfm());
	uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vi", dut_if);

	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top