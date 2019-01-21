class hermes_env_config extends uvm_object;
`uvm_object_utils(hermes_env_config)

//==========================
// credit_i_driver timing knobs
//==========================
bit enable_coverage = 1;

hermes_agent_config agent_cfg[router_pkg::NPORT];
//hermes_agent_cfg agent_out_cfg[router_pkg::NPORT];


function new( string name = "" );
  super.new( name );
endfunction: new


endclass : hermes_env_config
