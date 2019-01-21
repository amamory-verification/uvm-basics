/*
base test. does not implement run_phase
*/
class base_test extends uvm_test;
`uvm_component_utils(base_test)

router_env          env_h;
hermes_env_config   env_cfg;
hermes_agent_config acfg[router_pkg::NPORT];
//hermes_agent_cfg ao_cfg[router_pkg::NPORT];

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

// Initialise the virtual sequence handles
function void init_vseq(base_vseq vseq);
  foreach (vseq.sequencer[i]) begin
    vseq.sequencer[i] = env_h.agent_master_h[i].sequencer_h;
  end
endfunction: init_vseq

function void end_of_elaboration_phase(uvm_phase phase); 
	super.end_of_elaboration_phase(phase); 
	if (uvm_top.get_report_verbosity_level() >= UVM_HIGH) begin
		this.print(); 
    uvm_top.print_topology();
		//factory.print(); 
    uvm_config_db #(int)::dump(); 
	end
endfunction 

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env_cfg = hermes_env_config::type_id::create("env_cfg",this);
  foreach(acfg[i]) begin
    acfg[i] =  hermes_agent_config::type_id::create($sformatf("acfg[%0d]",i),this);
    //ao_cfg[i] =  hermes_agent_cfg::type_id::create($sformatf("ao_cfg[%0d]",i),this);
    env_cfg.agent_cfg[i] = acfg[i];
    //env_cfg.agent_out_cfg[i] = acfg[i];
  end

/*
  foreach(acfg[i]) begin
    if ( ! uvm_config_db#( virtual router_if )::get( this, "", $sformatf("in_if[%0d]",i), ai_cfg[i].dut_if ) ) begin
      `uvm_error( "test", "in_if not found" )
    end

    if ( ! uvm_config_db#( virtual router_if )::get( this, "", $sformatf("out_if[%0d]",i), ao_cfg[i].dut_if ) ) begin
      `uvm_error( "test", "out_if not found" )
    end
    env_cfg.agent_in_cfg[i] = ai_cfg[i];
    env_cfg.agent_out_cfg[i] = ao_cfg[i];
  end
*/

  //env_h = router_env::type_id::create("env", this);
endfunction: build_phase

/*
function void set_acfg_db();
  foreach(acfg[i]) begin
    uvm_config_db#(hermes_agent_config)::set(null, $sformatf("uvm_test_top.env.agent_in_%0d",i), "cfg",acfg[i]);
    uvm_config_db#(hermes_agent_config)::set(null, $sformatf("uvm_test_top.env.agent_out_%0d",i), "cfg",acfg[i]);
  end
endfunction
*/

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
endfunction: connect_phase

endclass: base_test
