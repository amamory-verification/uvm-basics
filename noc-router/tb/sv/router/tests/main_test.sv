/*
test that injects packets in all input ports in parallel
*/
class main_test extends base_test;
`uvm_component_utils(main_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("msg", "Building main_test DONE!", UVM_LOW)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("msg", "connecting main_test DONE!", UVM_LOW)
endfunction: connect_phase

task run_phase(uvm_phase phase);
  main_vseq vseq = main_vseq::type_id::create("vseq");
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
  init_vseq(vseq); 
  vseq.set_seq_config(cfg);
  vseq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: main_test
