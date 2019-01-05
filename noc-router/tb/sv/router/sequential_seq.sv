/*
 this hierarchical sequence injects injects 5 'basic_seq' in sequential port order, starting with the port 'starting_port'.
 It generates 20 small packets per port
*/
class sequential_seq extends base_vseq; 
`uvm_object_utils(sequential_seq)

// the initial port packets are injected. The next ports follows the order such that, for instance, if starting_port == 3, then the order is 3, 4, 0, 1, 2.
rand bit [3:0] starting_port;

constraint c_starting_port {
  starting_port inside { [0:router_pkg::NPORT-1] };
}

function new(string name = "sequential_seq");
  super.new(name);
endfunction: new

task body;
  basic_seq seq;
  int j = starting_port;
  for (int i = 0; i < router_pkg::NPORT; i++) begin
    // configuring seqe=uence parameters
    cfg = seq_config::type_id::create("seq_cfg");
    assert(cfg.randomize() with { 
        // number of packets to be simulated
        npackets == 20; 
        // set the timing behavior of the sequence
        cycle2send == 1;
        cycle2flit == 0;
        // input port
        port == j % router_pkg::NPORT;
        // only small packets
        p_size == packet_t::SMALL;
      }
    )
    // configure the sequence
    seq = basic_seq::type_id::create("seq");
    seq.set_seq_config(cfg); 

    assert(seq.randomize());
    seq.start (sequencer[cfg.port]);

    j = j +1;
  end
endtask: body

endclass: sequential_seq

