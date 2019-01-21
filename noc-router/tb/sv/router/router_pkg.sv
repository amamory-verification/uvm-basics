package router_pkg;
   import uvm_pkg::*;
`include "uvm_macros.svh"

// channel width
parameter FLIT_WIDTH = 16;
// # of port of a router 
parameter NPORT = 5;
// max packet size
parameter MAX_FLITS = 128;
// router address
parameter X_ADDR = 1;
parameter Y_ADDR = 1;

// NoC size . used to set the target routers
parameter X_MAX = 2;
parameter Y_MAX = 2;

// input port hard constraint  
parameter EAST  = 0;
parameter WEST  = 1;
parameter NORTH = 2;
parameter SOUTH = 3;
parameter LOCAL = 4;
 
typedef bit [7:0] bitstream8_t[$];
typedef bit [3:0] bitstream4_t[$];

// given a router addr h, give me the ports that can send packets to it
function bitstream4_t valid_ports(input bit [7:0] h);
	bitstream8_t vaddrs;

	valid_ports = {};
	for (int i = 0; i <= router_pkg::NPORT-1; i++) begin
		vaddrs = {};
		vaddrs = valid_addrs(i);
		// if h is in vaddrs, then i is a possible port to send packet to h
		if (vaddrs.sum with (item==h))
			valid_ports.push_back(i);
	end
	$display("%H --- %p\n",h, valid_ports);
endfunction


// create the list of valid target addresses following XY routing algorithm assuming the 'dport' incomming port
function bitstream8_t valid_addrs(input bit [3:0] dport);
	bit [3:0] i,j;
	//$display("%p",valid_addrs);
	valid_addrs = {}; // delete all
	if (!(dport >= 0 && dport <= router_pkg::NPORT-1))
		`uvm_fatal("", "set the dport before randomization" )
	for (i = 0; i <= router_pkg::X_MAX; i++) begin
		for (j = 0; j <= router_pkg::Y_MAX; j++) begin
			// exclude loopback from the local port
			if (dport == router_pkg::LOCAL) begin
				if (!((i == router_pkg::X_ADDR) && (j == router_pkg::Y_ADDR))) begin
					//$display("LOCAL TARGETS %h %0d %0d",{i,j}, i,j );
					valid_addrs.push_back({i,j});
				end
			end
			// exclude target address to the left hand side of the current router addr
			if (dport == router_pkg::WEST) begin
				if (i >= router_pkg::X_ADDR) begin
					//$display("WEST TARGETS %h %0d %0d",{i,j}, i,j );
					valid_addrs.push_back({i,j});
				end
			end
			// exclude target address to the right hand side of the current router addr
			if (dport == router_pkg::EAST) begin
				if (i <= router_pkg::X_ADDR) begin
					//$display("EAST TARGETS %h %0d %0d",{i,j}, i,j );
					valid_addrs.push_back({i,j});
				end
			end
			// exclude target address above the current router addr. turns are forbiden
			if (dport == router_pkg::NORTH) begin
				if ((i == router_pkg::X_ADDR) && (j <= router_pkg::Y_ADDR)) begin
					//$display("NORTH TARGETS %h %0d %0d",{i,j}, i,j );
					valid_addrs.push_back({i,j});
				end
			end
			// exclude target address below the current router addr. turns are forbiden
			if (dport == router_pkg::SOUTH) begin
				if ((i == router_pkg::X_ADDR) && (j >= router_pkg::Y_ADDR)) begin
					//$display("SOUTH TARGETS %h %0d %0d",{i,j}, i,j );
					valid_addrs.push_back({i,j});
				end
			end
		end // for j
	end // for i
endfunction


// ##### transactions / seq_item #####
`include "packet_t.sv"


// #### configuration classes #####
`include "seq_config.sv"
`include "hermes_agent_config.sv"
`include "hermes_env_config.sv"

// #### sequences #####
`include "./seqs/base_vseq.sv"
`include "./seqs/basic_seq.sv"
`include "./seqs/basic_seq2.sv" // example using config_db
`include "./seqs/rand_header_seq.sv"
`include "./seqs/sequential_seq.sv"
`include "./seqs/main_vseq.sv"
`include "./seqs/bottleneck_seq.sv"

// ##### tb modules #####
`include "router_base_driver.sv"
`include "router_driver.sv"
`include "credit_i_driver.sv"
`include "router_monitor.sv"
`include "router_coverage.sv"
`include "router_agent.sv"
`include "router_scoreboard.sv"
`include "router_env.sv"

// ##### tests #####
`include "./tests/base_test.sv"
`include "./tests/smoke_test.sv"
`include "./tests/smoke_test2.sv" // example using config_db
//`include "./tests/rand_header_test.sv"
//`include "./tests/random_test.sv"
//`include "./tests/sequential_test.sv"
`include "./tests/main_test.sv"
//`include "./tests/bottleneck_test.sv"
   
endpackage : router_pkg
