package hermes_pkg;

   import uvm_pkg::*;
   import hermes_pkg_hdl::*;

   `include "uvm_macros.svh"

	// ##### parameters #####
	`include "src/hermes_typedefs.sv"

	// ##### transactions / seq_item #####
	`include "src/hermes_packet_t.sv"

	// #### configuration classes #####
	//`include "seq_config.sv"
	`include "src/hermes_agent_config.sv"

	// #### sequences #####
	`include "src/hermes_base_seq.sv"

	// ##### agent modules #####
	`include "src/hermes_base_driver.sv"
	`include "src/hermes_slave_driver.sv"
	`include "src/hermes_master_driver.sv"
	`include "src/hermes_monitor.sv"
	`include "src/hermes_agent.sv"
endpackage
