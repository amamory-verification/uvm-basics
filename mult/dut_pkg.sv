package dut_pkg;
   import uvm_pkg::*;
`include "uvm_macros.svh"

// ##### packages #####
`include "dut_if_base.sv"

   
// ##### transactions #####
`include "mult_input_t.sv"
//`include "output_transaction.sv"


// #### sequences #####
`include "mult_basic_seq.sv"
`include "mult_zero_seq.sv"
`include "mult_one_seq.sv"
`include "mult_neg_seq.sv"


// ##### tb modules #####
`include "mult_driver.sv"
`include "mult_monitor.sv"
`include "mult_coverage.sv"
`include "mult_scoreboard.sv"
`include "mult_agent.sv"
`include "mult_env.sv"

// ##### tests #####
`include "smoke_test.sv"
`include "zeros_ones_test.sv"
`include "neg_test.sv"

//`include "test1.sv"
//`include "test2.sv"

   
endpackage : dut_pkg
