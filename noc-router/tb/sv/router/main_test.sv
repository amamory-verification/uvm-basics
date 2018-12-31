/*
test that injects packets in all input ports in parallel
*/
class main_test extends uvm_test;
`uvm_component_utils(main_test)

router_env env_h;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

// Initialise the virtual sequence handles
function void init_vseq(base_vseq vseq);
  foreach (vseq.sequencer[i]) begin
    vseq.sequencer[i] = env_h.agent_h[i].sequencer_h;
  end
endfunction: init_vseq

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env_h = router_env::type_id::create("env", this);
  `uvm_info("msg", "Building main_test DONE!", UVM_LOW)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("msg", "connecting main_test DONE!", UVM_LOW)
endfunction: connect_phase

task run_phase(uvm_phase phase);
  main_vseq vseq = main_vseq::type_id::create("vseq");

  phase.raise_objection(this);
  // start the virtual sequence
  init_vseq(vseq); 
  vseq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: main_test
