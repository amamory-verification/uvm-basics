/*
base test. does not implement run_phase
*/
class base_test extends uvm_test;
`uvm_component_utils(base_test)

hermes_router_env        env_h;
hermes_router_env_config env_cfg;
hermes_agent_config      acfg[hermes_pkg::NPORT];

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

// Initialise the virtual sequence handles
function void init_vseq(hermes_base_seq vseq);
  foreach (vseq.sequencer[i]) begin
    vseq.sequencer[i] = env_h.agent_master_h[i].sequencer_h;
  end
endfunction: init_vseq

// print debug messages
function void end_of_elaboration_phase(uvm_phase phase); 
	super.end_of_elaboration_phase(phase); 
	if (uvm_top.get_report_verbosity_level() >= UVM_HIGH) begin
		this.print(); 
    uvm_top.print_topology();
		//factory.print(); 
    uvm_config_db #(int)::dump(); 
	end
endfunction 

// create the env and cfgs
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env_cfg = hermes_router_env_config::type_id::create("env_cfg",this);
  foreach(acfg[i]) begin
    acfg[i] =  hermes_agent_config::type_id::create($sformatf("acfg[%0d]",i),this);
    // hook the env's config with the agent's config
    env_cfg.agent_cfg[i] = acfg[i];
  end

/*
  // in this TB i decided to leave the iterface out of the agent configuration. However, if it would be inside, 
  // then the base test would need to get the interface here (set by top) to assign to the agent configuration
  foreach(acfg[i]) begin
    if ( ! uvm_config_db#( virtual router_if )::get( this, "", $sformatf("in_if[%0d]",i), ai_cfg[i].dut_if ) ) begin
      `uvm_error( "test", "in_if not found" )
    end

    if ( ! uvm_config_db#( virtual router_if )::get( this, "", $sformatf("out_if[%0d]",i), ao_cfg[i].dut_if ) ) begin
      `uvm_error( "test", "out_if not found" )
    end
    env_cfg.agent_in_cfg[i]  = ai_cfg[i];
    env_cfg.agent_out_cfg[i] = ao_cfg[i];
  end
*/
endfunction: build_phase

/*
function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction: connect_phase
*/

endclass: base_test
