class router_coverage extends uvm_subscriber #(packet_t);
`uvm_component_utils(router_coverage);

logic  [router_pkg::FLIT_WIDTH-1:0] A,B;

covergroup range_value;
  a_leg: coverpoint A { 
      bins zero   = {0};      // zero
      bins plus1  = {1};      // 1
      bins pos    = {[2:$]};  // positive values
  }
  b_leg: coverpoint B { 
      bins zero   = {0};      // zero
      bins plus1  = {1};      // 1
      bins pos    = {[2:$]};  // positive values
  }

  a_b:  cross a_leg, b_leg;
endgroup: range_value

 
function void write(packet_t t);

  //`uvm_info("msg", "Transaction Received", UVM_HIGH)
  range_value.sample();
endfunction: write 

function new(string name, uvm_component parent);
  super.new(name,parent);
  range_value = new();
endfunction: new


endclass: router_coverage