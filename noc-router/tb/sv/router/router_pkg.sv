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
 
typedef bit [7:0] bitstream_t[$];

// create the list of valid target addresses following XY routing algorithm assuming the 'dport' incomming port
function bitstream_t valid_addrs(input bit [3:0] dport);
	
	//bitstream_t valid_addr_q;
	bit [3:0] i,j;
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
	//return valid_addr_q;
	
endfunction


// ##### transactions / seq_item #####
`include "packet_t.sv"


// #### sequences #####
`include "base_vseq.sv"
`include "basic_seq.sv"
//`include "sequential_seq.sv"
//`include "main_vseq.sv"
//`include "bottleneck_seq.sv"

////`include "small_packets_seq.sv"
////`include "big_packets_seq.sv"
////`include "stress_seq.sv"
////`include "random_time_seq.sv"


// ##### tb modules #####
`include "router_driver.sv"
`include "router_monitor.sv"
`include "router_coverage.sv"
`include "router_agent.sv"
`include "router_scoreboard.sv"
`include "router_env.sv"

// ##### tests #####
`include "base_test.sv"
`include "smoke_test.sv"
//`include "sequential_test.sv"
//`include "main_test.sv"
//`include "bottleneck_test.sv"
   


endpackage : router_pkg
