package dut_pkg;
   import uvm_pkg::*;
`include "uvm_macros.svh"

// ##### packages #####
//`include "dut_if_base.sv"
parameter DATA_WIDTH = 16;
// max val for unsigned mults
// check if it is a signed multiplier. used by the scoreboard and i tried to use it in the seq_item, with no success
parameter SIGNED_MULT = 1'b1;

//parameter MAX_RAND_VAL = 2**DATA_WIDTH-1;
// max val for signed mults
//parameter MAX_RAND_VAL = 2**(DATA_WIDTH-1)-1;

   
// ##### transactions #####
`include "mult_input_t.sv"
//`include "output_transaction.sv"


// #### sequences #####
`include "mult_basic_seq.sv"
`include "mult_zero_seq.sv"
`include "mult_one_seq.sv"
//`include "mult_neg_seq.sv"


// ##### tb modules #####
`include "mult_driver.sv"
`include "mult_monitor.sv"
`include "mult_coverage_unsigned.sv"
`include "mult_scoreboard.sv"
`include "mult_agent.sv"
`include "mult_env.sv"

// ##### tests #####
`include "smoke_test.sv"
`include "zeros_ones_test.sv"
//`include "neg_test.sv"

//`include "test1.sv"
//`include "test2.sv"

   
endpackage : dut_pkg
