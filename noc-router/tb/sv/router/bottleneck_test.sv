/*
test that injects packets in all input ports in parallel 
*/
class bottleneck_test extends base_test;
`uvm_component_utils(bottleneck_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("msg", "Building bottleneck_test DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  main_vseq vseq = main_vseq::type_id::create("seq");

  phase.raise_objection(this);

  // all sequences will send packets to this network address
  vseq.header = 8'h11; 
  // set the # of packets generated by each port.
  vseq.npackets = 20;
  assert( vseq.randomize() );

  // start the virtual sequence
  init_vseq(vseq); 
  vseq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: bottleneck_test
