/*
 this hierarchical sequence injects injects 5 'basic_seq' in sequential port order, starting with the port 'starting_port'.
 It generates every port sends 20 small packets to the same target address*/
class sequential_test extends base_test;
`uvm_component_utils(sequential_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

task run_phase(uvm_phase phase);
  sequential_seq seq;
  seq_config cfg;

  // configuring sequence parameters
  cfg = seq_config::type_id::create("seq_cfg");
  assert(cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 10; 
      // set the timing behavior of the sequence
      cycle2send == 1;
      cycle2flit == 0;
      // only small packets
      p_size == packet_t::SMALL;
    }
  );
  phase.raise_objection(this);
  seq = sequential_seq::type_id::create("seq");
  init_vseq(seq); 
  seq.set_seq_config(cfg);

  // set the starting port
  assert(seq.randomize() with {
      starting_port == 3;  
    });
  seq.start(null);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: sequential_test
