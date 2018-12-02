package dut_pkg;
   import uvm_pkg::*;
`include "uvm_macros.svh"
   
typedef enum bit {READ  = 1'b0, WRITE = 1'b1} cmd_t;
  
  // 1st and simplest method to pass parameter. used by my_transaction 
  parameter MAX_RAND_VAL = 20000;
  parameter DATA_WIDTH = 16;

`include "my_transaction.sv"
 // 2nd method to pass parameter. the env creates the classe and set with uvm_config_db. the subscriber gets the config
 // this approach based on uvm_config_db has performance issues, so it is better to avoid get config from frequently acesses class like seq_item
 `include "my_param_container.sv"


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