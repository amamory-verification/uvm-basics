package hermes_router_seq_pkg;

   import uvm_pkg::*;
   import hermes_pkg::*;
  
   `include "uvm_macros.svh"

   `include "src/hermes_router_seq_config.sv"

   `include "src/single_seq.sv"
   `include "src/repeat_seq.sv"
   //`include "src/bottleneck_seq.sv"
   `include "src/parallel_seq.sv"
   //`include "src/sequential_seq.sv"

endpackage
