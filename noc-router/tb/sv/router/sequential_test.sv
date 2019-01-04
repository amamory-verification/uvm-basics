/*
 this hierarchical sequence injects injects 5 'basic_seq' in sequential port order, starting with the port 'starting_port'.
 It generates 20 small packets per port
 */
class sequential_test extends base_test;
`uvm_component_utils(sequential_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("msg", "Building Environment DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  sequential_seq seq;
  seq = sequential_seq::type_id::create("seq");

  phase.raise_objection(this);
  init_vseq(seq); 

  // set the starting port
  seq.starting_port = $urandom_range(0,router_pkg::NPORT-1);
  seq.start(null);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: sequential_test
