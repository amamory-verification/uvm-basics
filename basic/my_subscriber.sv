class my_subscriber extends uvm_subscriber #(my_transaction);
`uvm_component_utils(my_subscriber);

cmd_t cmd;
logic unsigned [31:0] data;

covergroup cover_bus (int max_val);
  coverpoint cmd;
  coverpoint data { bins d[16] = {[0:max_val]};}
endgroup: cover_bus
 
function void write(my_transaction t);
  cmd = t.cmd;
  data = t.data;
  //`uvm_info("msg", "Transaction Received", UVM_HIGH)
  // UVM_NONE - msg always apper
  // UVM_LOW, UVM_MEDIUM, UVM_HIGH
  // UVM_FULL - usualyy filtered out
  // +UVM_VERBOSITY=UVM_LOW
  cover_bus.sample();
endfunction: write 

function new(string name, uvm_component parent);
  my_param_container params;
  super.new(name,parent);
  if (!uvm_config_db #(my_param_container)::get(this, "","my_param",params) )
    `uvm_fatal("my_subscriber", "No config");  
  cover_bus = new(2**params.data_width-1);
endfunction: new


endclass: my_subscriber
