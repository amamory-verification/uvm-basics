module top;
import uvm_pkg::*;
import dut_pkg::*;

dut_if       dut_if1();
mult_serial  dut1(.clock(dut_if1.clock), .reset(dut_if1.reset), .start(dut_if1.start), .A(dut_if1.A), .B(dut_if1.B), 
	.done(dut_if1.done), .dout(dut_if1.dout));

initial
begin: blk
	uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vi", dut_if1);

	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top