class main_test extends uvm_test;
`uvm_component_utils(main_test)

router_env env_h;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  env_h = router_env::type_id::create("env", this);
  `uvm_info("msg", "Building Environment DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  // create the virtual sequence
  main_vseq seq = main_vseq::type_id::create("vseq");

  phase.raise_objection(this);
  // init virtual sequences
  seq.sequencer0 = env_h.agent_h[0].sequencer_h;
  seq.sequencer1 = env_h.agent_h[1].sequencer_h;
  // start the virtual sequence
  seq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: main_test
