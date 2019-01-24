package hermes_router_env_pkg;

   import uvm_pkg::*;
   import hermes_pkg::*;

   `include "uvm_macros.svh"

	// #### configuration classes #####
	`include "src/hermes_router_env_config.sv"

	// ##### env modules #####
	`include "src/hermes_router_coverage.sv"
	`include "src/hermes_router_scoreboard.sv"
	`include "src/hermes_router_env.sv"
endpackage
