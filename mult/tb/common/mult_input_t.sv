class mult_input_t extends uvm_sequence_item;
`uvm_object_utils(mult_input_t)

rand logic  [dut_pkg::DATA_WIDTH-1:0]   A;
rand logic  [dut_pkg::DATA_WIDTH-1:0]   B;
logic  [2*dut_pkg::DATA_WIDTH-1:0] dout;

constraint c_a { soft A >=1 ; soft A < 256; }
constraint c_b { soft B >=1 ; soft B < 256; }

function new(string name = "");
  super.new(name);
endfunction: new

endclass: mult_input_t

typedef uvm_sequencer #(mult_input_t) mult_sequencer;

