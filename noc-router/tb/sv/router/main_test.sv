class main_test extends uvm_test;
`uvm_component_utils(main_test)

router_env env_h;
main_vseq seqr;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env_h = router_env::type_id::create("env", this);
  // create the virtual sequence
  seqr = main_vseq::type_id::create("vseq");
  `uvm_info("msg", "Building main_test DONE!", UVM_LOW)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  seq.sequencer0 = env_h.agent_h[0].sequencer_h;
  seq.sequencer1 = env_h.agent_h[1].sequencer_h;
  env_h = router_env::type_id::create("env", thi
  `uvm_info("msg", "connecting main_test DONE!", UVM_LOW)
endfunction: connect_phase

task run_phase(uvm_phase phase);
  phase.raise_objection(this);
  // start the virtual sequence
  seq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: main_test
