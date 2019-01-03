/*
 this hierarchical sequence injects injects 5 'basic_seq' in sequential port order, starting with the port 'starting_port'.
 It generates 20 small packets per port
*/
class sequential_seq extends base_vseq; 
`uvm_object_utils(sequential_seq)

// the initial port packets are injected. The next ports follows the order such that, for instance, if starting_port == 3, then the order is 3, 4, 0, 1, 2.
bit [3:0] starting_port;

function new(string name = "sequential_seq");
  super.new(name);
endfunction: new

task body;
  basic_seq seq;
  int j = starting_port;
  for (int i = 0; i < router_pkg::NPORT; i++) begin
    seq = basic_seq::type_id::create("seq");
    seq.port = j % router_pkg::NPORT;
    seq.npackets = 20;
    seq.psize = packet_t::SMALL;
    seq.start (sequencer[seq.port]);
    j = j +1;
  end
endtask: body

endclass: sequential_seq

