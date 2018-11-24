class mult_input_t extends uvm_sequence_item;
`uvm_object_utils(mult_input_t)

rand shortint   A;
rand shortint   B;
int dout;

constraint c_a { A >=1 ; A < 256; }
constraint c_b { B >=1 ; B < 256; }

function new(string name = "");
  super.new(name);
endfunction: new

endclass: mult_input_t

typedef uvm_sequencer #(mult_input_t) mult_sequencer;

