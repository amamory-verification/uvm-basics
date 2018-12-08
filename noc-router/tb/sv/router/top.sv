module top;
import uvm_pkg::*;
import dut_pkg::*;

bit clock;
always #10 clock = ~clock; // clock generator

router_if   dut_if(clock);

// instantiate a central router 
RouterCC #(.address(16h0101)) dut1(.clock(clock), .clock_rx(clock_rx), .reset(dut_if.reset), 
	.rx(rx), .data_in(data_in), .credit_o(credit_o), // input ports
	.credit_i(credit_i) ); // output ports


initial
begin: blk
	//uvm_config_db#(virtual dut_if_base)::set(null, "*", "dut_vi", unsigned_dut_if.get_concrete_bfm());
	uvm_config_db#(virtual dut_if)::set(null, "*", "dut_vi", dut_if);

	run_test(); // vsim +UVM_TESTNAME=my_test
end // blk

endmodule: top