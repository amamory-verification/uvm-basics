/*
UVM testbench for the router described in the following paper

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

This TB simulates a 3x3 NoC with these addresses:

 02 12 22
 01 11 21
 00 10 20 

 6 7 8
 3 4 5
 0 1 2

	constant N0000: integer :=0;
	constant ADDRESSN0000: std_logic_vector(7 downto 0) :="00000000";
	constant N0100: integer :=1;
	constant ADDRESSN0100: std_logic_vector(7 downto 0) :="00010000";
	constant N0200: integer :=2;
	constant ADDRESSN0200: std_logic_vector(7 downto 0) :="00100000";
	constant N0001: integer :=3;
	constant ADDRESSN0001: std_logic_vector(7 downto 0) :="00000001";
	constant N0101: integer :=4;
	constant ADDRESSN0101: std_logic_vector(7 downto 0) :="00010001";
	constant N0201: integer :=5;
	constant ADDRESSN0201: std_logic_vector(7 downto 0) :="00100001";
	constant N0002: integer :=6;
	constant ADDRESSN0002: std_logic_vector(7 downto 0) :="00000010";
	constant N0102: integer :=7;
	constant ADDRESSN0102: std_logic_vector(7 downto 0) :="00010010";
	constant N0202: integer :=8;
	constant ADDRESSN0202: std_logic_vector(7 downto 0) :="00100010";

The port's code number
      N2
   --------
W1 |      | E0
   |      |
   /------- 
 L4   S3

*/

`timescale 1 ns / 1 ps

module top;
import uvm_pkg::*;
import hermes_pkg::*;
import hermes_noc_test_pkg::*;

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
hermes_if   master_if[hermes_pkg::NROT](clock, reset);
hermes_if   slave_if [hermes_pkg::NROT](clock, reset);

// pass the interfaces to the agents and they will pass it to their monitors and drivers 
genvar i;
for(i=0; i< hermes_pkg::NROT; i++) 
begin : dut_inst
	initial 
	begin
	  uvm_config_db#(virtual hermes_if)::set(null,$sformatf("uvm_test_top.env.agent_master_%0d",i),"if",master_if[i]);
	  uvm_config_db#(virtual hermes_if)::set(null,$sformatf("uvm_test_top.env.agent_slave_%0d",i),"if",slave_if[i]);
	  // this is read by the base test
	  //uvm_config_db#(virtual hermes_if)::set(null,"uvm_test_top",$sformatf("in_if[%0d]",i),in_if[i]);
	  //uvm_config_db#(virtual hermes_if)::set(null,"uvm_test_top",$sformatf("out_if[%0d]",i),out_if[i]);
	end
end


// instantiate a central router 
NoC_wrapper  dut1(.clock(clock), 
	.reset(reset), 
	.din(master_if), 
	.dout(slave_if)
	); 


initial
begin: blk
	//print_config(); 
	// enable uvm transaction recording. must be executed before creating the uvm components 
	uvm_config_db# (int) :: set (null, "*", "recording_detail",1);

	run_test(); // vsim +UVM_TESTNAME=my_test

end // blk

endmodule: top
