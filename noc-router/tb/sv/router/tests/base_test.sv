/*
base test. does not implement run_phase
*/
class base_test extends uvm_test;
`uvm_component_utils(base_test)

router_env env_h;
hermes_agent_cfg acfg[router_pkg::NPORT];

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
	if (uvm_top.get_report_verbosity_level() >= UVM_HIGH) begin
		this.print(); 
    uvm_top.print_topology();
		factory.print(); 
    uvm_config_db #(int)::dump(); 
	end
endfunction 

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env_h = router_env::type_id::create("env", this);
  foreach(acfg[i]) begin
    acfg[i] =  hermes_agent_cfg::type_id::create($sformatf("acfg[%0d]",i),this);
  end
endfunction: build_phase

function void set_acfg_db();
  foreach(acfg[i]) begin
    uvm_config_db#(hermes_agent_cfg)::set(null, $sformatf("uvm_test_top.env.agent_in_%0d",i), "cfg",acfg[i]);
    uvm_config_db#(hermes_agent_cfg)::set(null, $sformatf("uvm_test_top.env.agent_out_%0d",i), "cfg",acfg[i]);
  end
endfunction


function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction: connect_phase

endclass: base_test
