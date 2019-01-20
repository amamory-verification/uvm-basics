/*
Using the 'The Configurable Sequence' as described in 
'Seven Separate Sequence Styles Speed Stimulus Scenarios'
*/
class base_vseq extends uvm_sequence #(uvm_sequence_item);  
`uvm_object_utils(base_vseq)

packet_sequencer sequencer[router_pkg::NPORT];

// Handle for sequence configuration object
seq_config cfg;


// test should create/randomize the config and pass it to the sequence
function void set_seq_config(seq_config cfg0);
	// pass the handle of the cfg created by the caller
	cfg = cfg0;
endfunction : set_seq_config


function new(string name = "base_vseq");
  super.new(name);
endfunction: new

endclass: base_vseq

