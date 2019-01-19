/*
base test. does not implement run_phase
*/
class base_test extends uvm_test;
`uvm_component_utils(base_test)

router_env env_h;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

// Initialise the virtual sequence handles
function void init_vseq(base_vseq vseq);
  foreach (vseq.sequencer[i]) begin
    vseq.sequencer[i] = env_h.agent_in_h[i].sequencer_h;
  end
endfunction: init_vseq

function void end_of_elaboration_phase(uvm_phase phase); 
	super.end_of_elaboration_phase(phase); 
	this.print(); 
	factory.print(); 
endfunction 

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env_h = router_env::type_id::create("env", this);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction: connect_phase

endclass: base_test
