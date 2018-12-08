`timescale 1ns/10ps

module top;
import uvm_pkg::*;
import dut_pkg::*;

bit clock;
always #10 clock = ~clock; // clock generator

dut_if   dut_if(clock);
mudi64   dut1(.clock(clock), .reset(dut_if.reset), 
	.start(!dut_if.start), .opera1(dut_if.A), .opera2({32'h00000000 , dut_if.B}), .muordi(1'b0), 
	.valid(dut_if.done), .result(dut_if.dout));

initial
begin: blk
	//uvm_config_db#(virtual dut_if_base)::set(null, "*", "dut_vi", unsigned_dut_if.get_concrete_bfm());
	uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vi", dut_if);

	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top