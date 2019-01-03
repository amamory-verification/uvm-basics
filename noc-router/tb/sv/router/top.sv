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

// generate interfaces
router_if   in_if [router_pkg::NPORT](clock, reset);
router_if   out_if[router_pkg::NPORT](clock, reset);

// pass the interfaces to the drivers and monitors
genvar i;
for(i=0; i< router_pkg::NPORT; i++) 
begin : dut_inst
	initial 
	begin
	  uvm_config_db#(virtual router_if)::set(null,$sformatf("driver%0d",i),"in_if",in_if[i]);
	  uvm_config_db#(virtual router_if)::set(null,$sformatf("monitor%0d",i),"out_if",out_if[i]);
	end
end


// instantiate a central router 
RouterCC_wrapper  dut1(.clock(clock), 
	.reset(reset), 
	.din(in_if), 
	.dout(out_if)
	); 


initial
begin: blk

	run_test(); // vsim +UVM_TESTNAME=my_test

end // blk

endmodule: top