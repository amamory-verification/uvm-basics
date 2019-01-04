/*
simple test that injects 10 packets into the local port
*/
class smoke_test extends base_test;
`uvm_component_utils(smoke_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("msg", "Building Environment DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  basic_seq seq;
  phase.raise_objection(this);

  seq = basic_seq::type_id::create("seq");
  // this seq will inject packets into the local port only
  seq.port = router_pkg::LOCAL;
  // number of packets to be simulated
  seq.npackets = 10;
  seq.header = 8'h10;
  seq.start(env_h.agent_h[seq.port].sequencer_h);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: smoke_test
