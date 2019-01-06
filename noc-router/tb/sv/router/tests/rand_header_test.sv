/*
simple test that injects 10 small packets into the west port targeting random routers
*/
class rand_header_test extends base_test;
`uvm_component_utils(rand_header_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

task run_phase(uvm_phase phase);
  rand_header_seq seq;
  seq_config cfg;

  // configuring sequence parameters
  cfg = seq_config::type_id::create("seq_cfg");
  if( !cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 10; 
      // set the timing behavior of the sequence
      cycle2send == 1;
      cycle2flit == 0;
      // this seq will inject packets into the NORTH port only
      port == router_pkg::WEST;
      // only small packets
      p_size == packet_t::SMALL;
    }
  )
    `uvm_error("rand", "invalid cfg randomization"); 

  phase.raise_objection(this);
  seq = rand_header_seq::type_id::create("seq");
  init_vseq(seq); 
  seq.set_seq_config(cfg);

  if( !seq.randomize())
    `uvm_error("rand", "invalid seq randomization"); 

  seq.start(null);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: rand_header_test
