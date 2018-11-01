package dut_pkg;
   import uvm_pkg::*;
`include "uvm_macros.svh"
   
typedef enum bit {READ  = 1'b0, WRITE = 1'b1} cmd_t;
      
`include "my_transaction.sv"


`include "read_modify_write_sequence.sv"
`include "my_sequence.sv"
//`include "my_sequences.sv"
`include "commands_sequence.sv"


`include "my_subscriber.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
//`include "my_component.sv"

`include "my_env.sv"

//`include "my_test.sv"
`include "test1.sv"
`include "test2.sv"

   
endpackage : dut_pkg