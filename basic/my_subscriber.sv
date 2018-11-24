class my_subscriber extends uvm_subscriber #(my_transaction);
`uvm_component_utils(my_subscriber);

cmd_t cmd;
int addr;
int data;

covergroup cover_bus;
  coverpoint cmd;
  coverpoint addr { bins a[16] = {[0:255]};}
  coverpoint data { bins d[16] = {[0:255]};}
endgroup: cover_bus
 
function void write(my_transaction t);
  cmd = t.cmd;
  addr = t.addr;
  data = t.data;
  `uvm_info("msg", "Transaction Received", UVM_HIGH)
  // UVM_NONE - msg always apper
  // UVM_LOW, UVM_MEDIUM, UVM_HIGH
  // UVM_FULL - usualyy filtered out
  // +UVM_VERBOSITY=UVM_LOW
  cover_bus.sample();
endfunction: write 

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new


endclass: my_subscriber
