class hermes_router_env_config extends uvm_object;
`uvm_object_utils(hermes_router_env_config)

bit enable_coverage = 1;

hermes_agent_config agent_cfg[hermes_pkg::NPORT];


function new( string name = "" );
  super.new( name );
endfunction: new

endclass : hermes_router_env_config
