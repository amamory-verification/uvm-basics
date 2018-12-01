//class mult_input_t #(parameter byte unsigned WIDTH = 16) extends uvm_sequence_item;
class mult_input_t #(parameter byte unsigned WIDTH = 16) extends uvm_sequence_item;
`uvm_object_utils(mult_input_t)

rand logic  [WIDTH-1:0]   A;
rand logic  [WIDTH-1:0]   B;
int dout;

constraint c_a { soft A >=1 ; soft A < 256; }
constraint c_b { soft B >=1 ; soft B < 256; }

function new(string name = "");
  super.new(name);
endfunction: new

endclass: mult_input_t

typedef uvm_sequencer #(mult_input_t  #(width)) mult_sequencer;

