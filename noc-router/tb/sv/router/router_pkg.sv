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

 
// ##### transactions / seq_item #####
`include "packet_t.sv"


// #### sequences #####
`include "basic_seq.sv"
`include "base_vseq.sv"
`include "main_vseq.sv"
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
`include "smoke_test.sv"
`include "main_test.sv"
   
endpackage : router_pkg
