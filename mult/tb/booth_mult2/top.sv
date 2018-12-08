`timescale 1 ns / 1 ns
module top;
import uvm_pkg::*;
import dut_pkg::*;

bit clock;
always #10 clock = ~clock; // clock generator

dut_if   dut_if(clock);
Booth_Multiplier #(.pN($clog2(dut_pkg::DATA_WIDTH))) dut1(.Clk(clock), .Rst(dut_if.reset), 
	.Ld(dut_if.start), .M(dut_if.A), .R(dut_if.B), 
	.Valid(dut_if.done), .P(dut_if.dout));

initial
begin: blk
	//uvm_config_db#(virtual dut_if_base)::set(null, "*", "dut_vi", unsigned_dut_if.get_concrete_bfm());
	uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vi", dut_if);

	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top