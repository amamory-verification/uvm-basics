/*
Using the 'The Configurable Sequence' as described in 
'Seven Separate Sequence Styles Speed Stimulus Scenarios' 
*/
class hermes_noc_base_seq extends uvm_sequence #(uvm_sequence_item);  
`uvm_object_utils(hermes_noc_base_seq)

packet_sequencer sequencer[hermes_pkg::NROT];

function new(string name = "hermes_noc_base_seq");
  super.new(name);
endfunction: new

endclass: hermes_noc_base_seq

