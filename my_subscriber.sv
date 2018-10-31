class my_subscriber extends uvm_subscriber;
`uvm_component_utils(my_subscriber);

bit cmd;
int addr;
int data;

covergroup cover_bus;
  coverpoint cmd;
  coverpoint addr { bins a[16] = {[0:255]};}
  coverpoint data { bins d[16] = {[0:255]};}
endcovergroup: cover_bus
 
function write(my_transaction t);
  cmd = t.cmd;
  addr = t.addr;
  data = t.data;
  `uvm_info("msg", "Transaction Received", UVM_NONE)
  // UVM_NONE - msg always apper
  // UVM_LOW, UVM_MEDIUM, UVM_HIGH
  // UVM_FULL - usualyy filtered out
  // +UVM_VERBOSITY=UVM_LOW
  cover_bus.sample();
endfunction: new 

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new


endclass: my_subscriber
