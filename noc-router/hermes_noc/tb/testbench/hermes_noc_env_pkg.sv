package hermes_noc_env_pkg;

   import uvm_pkg::*;
   import hermes_pkg::*;
   import hermes_router_env_pkg::*;

   `include "uvm_macros.svh"

	// #### configuration classes #####
	`include "./hermes_noc_env_config.sv"

	// ##### env modules #####
	//`include "src/hermes_router_coverage.sv"
	`include "./hermes_noc_scoreboard.sv"
	`include "hermes_noc_env.sv"
endpackage
