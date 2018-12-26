class base_vseq extends uvm_sequence #(packet_t); 
`uvm_object_utils(base_vseq)

//packet_sequencer sequencer[router_pkg::NPORT];
packet_sequencer sequencer0;
packet_sequencer sequencer1;

function new(string name = "base_vseq");
  super.new(name);
endfunction: new

endclass: base_vseq

