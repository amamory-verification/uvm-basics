class my_monitor extends uvm_monitor;
`uvm_component_utils(my_monitor);

uvm_analysis_port #(my_transaction) aport;
virtual dut_if dut_vi;

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  `uvm_info("msg", "Building MONITOR", UVM_NONE)
  aport = new("aport", this); 
  if (!uvm_config_db #(virtual dut_if)::get (null,"*", "dut_vi", dut_vi) )
    `uvm_fatal("my_monitor", "No DUT_IF");  
  `uvm_info("msg", "MONITOR Done !!!", UVM_NONE)
endfunction: build_phase

task run_phase(uvm_phase phase);
  forever
  begin
    my_transaction tx;
    @(posedge dut_vi.clk);
    tx = my_transaction::type_id::create("tx");
    $cast(tx.cmd, dut_vi.cmd);
    tx.addr = dut_vi.addr;
    tx.data = dut_vi.data;
    
    aport.write(tx);
    `uvm_info("msg", "New transaction", UVM_HIGH)
  end
endtask: run_phase

endclass : my_monitor
