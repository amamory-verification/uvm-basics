package dut_pkg;
   import uvm_pkg::*;
`include "uvm_macros.svh"

// ##### packages #####
//`include "dut_if_base.sv"

// multiplier data width
parameter DATA_WIDTH = 32;
// check if it is a signed multiplier. used by the scoreboard and i tried to use it in the seq_item, with no success
parameter SIGNED_MULT = 1'b1;
/*
// max val for signed mults
parameter MAX_RAND_VAL = 2**(DATA_WIDTH-1)-1;
// max val for unsigned mults
parameter MAX_RAND_VAL = 2**DATA_WIDTH-1;
*/
//parameter MAX_RAND_VAL = (SIGNED_MULT == 1'b1)? 2**(DATA_WIDTH-1)-1 : 2**DATA_WIDTH-1;

// TODO mult_input_t nao aceitou mult_type. funcionou como unsigned
/*
`ifdef SIGNED_MULT == 1'b1
	typedef logic signed mult_type;
`else
	typedef logic unsigned mult_type;
`endif
*/
 
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
`include "mult_coverage_signed.sv"
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
