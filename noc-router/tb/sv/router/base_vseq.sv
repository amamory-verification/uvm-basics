class base_vseq extends uvm_sequence #(uvm_sequence_item); 
`uvm_object_utils(base_vseq)

packet_sequencer sequencer[router_pkg::NPORT];

function new(string name = "base_vseq");
  super.new(name);
endfunction: new

endclass: base_vseq

