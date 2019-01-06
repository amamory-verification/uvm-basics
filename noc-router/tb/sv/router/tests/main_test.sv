/*
test that injects packets in all input ports in parallel
*/
class main_test extends base_test;
`uvm_component_utils(main_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

task run_phase(uvm_phase phase);
  main_vseq seq = main_vseq::type_id::create("seq");
  seq_config cfg = seq_config::type_id::create("seq_cfg");

  assert(cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 20; 
      // set the timing behavior of the sequence
      cycle2send == 1;
      cycle2flit == 0;
      // only small packets
      p_size == packet_t::SMALL;
    }
  );


  phase.raise_objection(this);
  // start the virtual sequence
  init_vseq(seq); 
  seq.set_seq_config(cfg);
  seq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: main_test
