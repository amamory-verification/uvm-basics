/*
simple test that injects 10 packets into the north port
*/
class smoke_test extends base_test;
`uvm_component_utils(smoke_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

task run_phase(uvm_phase phase);
  basic_seq seq;
  seq_config cfg;

  // configuring seqe=uence parameters
  cfg = seq_config::type_id::create("seq_cfg");
  assert(cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 10; 
      // set the timing behavior of the sequence
      cycle2send == 1;
      cycle2flit == 0;
      // this seq will inject packets into the NORTH port only
      port == router_pkg::NORTH;
      // all packets will be sent to the router 8'h11
      header == 8'h11;
      // only small packets
      p_size == packet_t::SMALL;
    }
  );

  phase.raise_objection(this);

  // create the sequence and initialize it 
  seq = basic_seq::type_id::create("seq");
  init_vseq(seq); 
  seq.set_seq_config(cfg);

  assert(seq.randomize());

  seq.start(seq.sequencer[cfg.port]);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: smoke_test
