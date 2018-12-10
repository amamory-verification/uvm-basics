/*
UVM testbench for the router described in the follwoing paper

@article{moraes2004hermes,
  title={HERMES: an infrastructure for low area overhead packet-switching networks on chip},
  author={Moraes, Fernando and Calazans, Ney and Mello, Aline and M{\"o}ller, Leandro and Ost, Luciano},
  journal={INTEGRATION, the VLSI journal},
  volume={38},
  number={1},
  pages={69--93},
  year={2004},
  publisher={Elsevier}
}

*/


module top;
import uvm_pkg::*;
import router_pkg::*;

bit clock;
always #10 clock = ~clock; // clock generator

router_if   dut_if(clock);

// instantiate a central router 
RouterCC #(.address(16'h0101)) dut1(.clock(clock), 
	.reset(dut_if.reset), 
	.clock_rx(dut_if.clock_rx), 
	.rx(dut_if.rx),  
	.data_in(dut_if.data_in),
	.credit_o(dut_if.credit_o), // input ports
	//.credit_i(dut_if.credit_i) , // TODO
	.credit_i(5'b11111) ,
	.clock_tx(dut_if.clock_tx), 
	.tx(dut_if.tx),  
	.data_out(dut_if.data_out)
	); // output ports


initial
begin: blk
	//uvm_config_db#(virtual dut_if_base)::set(null, "*", "dut_vi", unsigned_dut_if.get_concrete_bfm());
	uvm_config_db#(virtual router_if)::set(null, "*", "dut_vi", dut_if);

	run_test(); // vsim +UVM_TESTNAME=my_test
	//#10000 // wait to output the last packets
  	//repeat (500) @(posedge clock);

end // blk

endmodule: top