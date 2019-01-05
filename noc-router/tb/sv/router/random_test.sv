/*
simple test that injects 10 packets into a single randomly selected port
*/
class random_test extends base_test;
`uvm_component_utils(random_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("msg", "Building test DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  basic_seq seq;
  seq_config cfg;

  // configuring sequence parameters
  cfg = seq_config::type_id::create("seq_cfg");
  assert(cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 10; 
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

endclass: random_test
