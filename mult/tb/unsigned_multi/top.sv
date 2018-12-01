module top;
import uvm_pkg::*;
import dut_pkg::*;

bit clock;
always #10 clock = ~clock; // clock generator

dut_if  #(.WIDTH(16))   unsigned_dut_if(clock);
mult_serial  dut1(.clock(clock), .reset(unsigned_dut_if.reset), 
	.start(unsigned_dut_if.start), .A(unsigned_dut_if.A), .B(unsigned_dut_if.B), 
	.done(unsigned_dut_if.done), .dout(unsigned_dut_if.dout));

initial
begin: blk
	//uvm_config_db#(virtual dut_if_base)::set(null, "*", "dut_vi", unsigned_dut_if.get_concrete_bfm());
	uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vi", unsigned_dut_if);

	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top