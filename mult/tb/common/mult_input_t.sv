class mult_input_t extends uvm_sequence_item;
`uvm_object_utils(mult_input_t)

rand logic signed [dut_pkg::DATA_WIDTH-1:0]   A;
rand logic signed [dut_pkg::DATA_WIDTH-1:0]   B;
logic signed  [2*dut_pkg::DATA_WIDTH-1:0] dout;

/*
// TODO I have no ideia why this code below does not replace the code above.
// I would not need to replicate the mult_input_t if it worked as expected
`ifdef SIGNED_MULT == 1'b1
	rand logic signed  [dut_pkg::DATA_WIDTH-1:0]   A;
	rand logic signed [dut_pkg::DATA_WIDTH-1:0]   B;
	logic signed  [2*dut_pkg::DATA_WIDTH-1:0] dout;
`else
	rand logic  [dut_pkg::DATA_WIDTH-1:0]   A;
	rand logic [dut_pkg::DATA_WIDTH-1:0]   B;
	logic  [2*dut_pkg::DATA_WIDTH-1:0] dout;
`endif
*/
//constraint c_a { soft A >=1 ; soft A < dut_pkg::MAX_RAND_VAL; }
//constraint c_b { soft B >=1 ; soft B < dut_pkg::MAX_RAND_VAL; }

function new(string name = "");
  super.new(name);
endfunction: new

endclass: mult_input_t

typedef uvm_sequencer #(mult_input_t) mult_sequencer;

