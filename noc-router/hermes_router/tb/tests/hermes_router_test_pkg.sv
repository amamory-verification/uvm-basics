package hermes_router_test_pkg;

   import uvm_pkg::*;
   import hermes_pkg::*;
   import hermes_router_env_pkg::*;
   import hermes_router_seq_pkg::*;
  
   `include "uvm_macros.svh"

   `include "src/base_test.sv"
   //`include "src/single_test.sv"
   `include "src/repeat_test.sv"
   `include "src/random_test.sv"
   `include "src/bottleneck_test.sv"
   `include "src/parallel_test.sv"
   `include "src/sequential_test.sv"

endpackage
