module top;
import uvm_pkg::*;
import dut_pkg::*;

bit clock;
always #10 clock = ~clock; // clock generator

dut_if  #(32)   dut_if(clock);
boothmult #(32) dut1(.clk(clock), .reset(dut_if.reset), 
	.start(dut_if.start), .multiplier(dut_if.A), .multiplicand(dut_if.B), 
	.done(dut_if.done), .product(dut_if.dout));

initial
begin: blk
	//uvm_config_db#(virtual dut_if_base)::set(null, "*", "dut_vi", unsigned_dut_if.get_concrete_bfm());
	uvm_config_db#(virtual dut_if  #(width))::set(null, "*", "dut_vi", dut_if);
	//uvm_config_db#(unsigned)::set(null, "*", "width", 32);

	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top