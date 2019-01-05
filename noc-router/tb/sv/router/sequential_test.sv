/*
 this hierarchical sequence injects injects 5 'basic_seq' in sequential port order, starting with the port 'starting_port'.
 It generates every port sends 20 small packets to the same target address
 */
class sequential_test extends base_test;
`uvm_component_utils(sequential_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

task run_phase(uvm_phase phase);
  sequential_seq seq;

  phase.raise_objection(this);
  seq = sequential_seq::type_id::create("seq");
  init_vseq(seq); 

  // set the starting port
  assert(seq.randomize() with {
      starting_port == 3;
    });
  seq.start(null);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: sequential_test
