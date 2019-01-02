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


// reset generator
bit reset = 1;
initial begin
reset = 1;
repeat (5) begin
  @(posedge clock);
end
reset = 0;
end

router_if   in_if0(clock, reset);
router_if   in_if [5](clock, reset);
router_if   out_if[5](clock, reset);

// instantiate a central router 
RouterCC_wrapper  dut1(.clock(clock), 
	.reset(reset), 
	// input ports
	.din(in_if), 
	.dout(out_if)
	); 

/*
router_if   dut_if(clock, reset);

// instantiate a central router 
RouterCC #(.address(8'h11)) dut1(.clock(clock), 
	.reset(dut_if.reset), 
	// input ports
	.clock_rx(dut_if.clock_rx), 
	.rx(dut_if.rx),  
	.data_in(dut_if.data_in),
	.credit_o(dut_if.credit_o), 
	// output ports
	.credit_i(dut_if.credit_i) ,
	.clock_tx(dut_if.clock_tx), 
	.tx(dut_if.tx),  
	.data_out(dut_if.data_out)
	); 
*/

initial
begin: blk
	//uvm_config_db#(virtual dut_if_base)::set(null, "*", "dut_vi", unsigned_dut_if.get_concrete_bfm());
	/*
	foreach (in_if[i]) begin
		uvm_config_db#(virtual router_if)::set(null, "*", $sformatf("in_if[%0d]",i), in_if[i]); // used by drivers
		uvm_config_db#(virtual router_if)::set(null, "*", $sformatf("out_if[%0d]",i), out_if[i]); // used my monitores
	end
	*/	
		$display("TOP - CFG");
	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",0), $sformatf("in_if%0d",0), in_if0); // used by drivers
		$display("TOP - CFG2");

	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",0), $sformatf("out_if%0d",0), out_if[0]); // used my monitores

	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",1), $sformatf("in_if%0d",1), in_if[1]); // used by drivers
	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",1), $sformatf("out_if%0d",1), out_if[1]); // used my monitores

	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",2), $sformatf("in_if%0d",2), in_if[2]); // used by drivers
	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",2), $sformatf("out_if%0d",2), out_if[2]); // used my monitores

	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",3), $sformatf("in_if%0d",3), in_if[3]); // used by drivers
	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",3), $sformatf("out_if%0d",3), out_if[3]); // used my monitores

	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",4), $sformatf("in_if%0d",4), in_if[4]); // used by drivers
	uvm_config_db#(virtual router_if)::set(null, $sformatf("agent%0d*",4), $sformatf("out_if%0d",4), out_if[4]); // used my monitores



	run_test(); // vsim +UVM_TESTNAME=my_test
	//#10000 // wait to output the last packets
  	//repeat (500) @(posedge clock);

end // blk

endmodule: top