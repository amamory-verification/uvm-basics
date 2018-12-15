class smoke_test extends uvm_test;
`uvm_component_utils(smoke_test)

router_env env_h;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  env_h = router_env::type_id::create("env", this);
  `uvm_info("msg", "Building Environment DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  basic_seq seq;
  //`uvm_info("msg", "Running TEST1", UVM_LOW)
  seq = basic_seq::type_id::create("seq");
  phase.raise_objection(this);
  //`uvm_info("msg", "Starting  SEQ", UVM_LOW)
  seq.start(env_h.agent_h[4].sequencer_h);
  /// Set a drain time for the Test
  phase.phase_done.set_drain_time(this, 1500ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: smoke_test
