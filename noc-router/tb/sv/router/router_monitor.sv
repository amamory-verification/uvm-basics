class router_monitor extends uvm_monitor;
`uvm_component_utils(router_monitor);

uvm_analysis_port #(packet_t) aport;
virtual router_if dut_vi;
bit [3:0] port;

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  aport = new("aport", this); 
  if (!uvm_config_db #(virtual router_if)::get (null,"*", "dut_vi", dut_vi) )
    `uvm_fatal("monitor", "No DUT_IF");  
  if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
    `uvm_fatal("monitor", "No port");
  $display("PORT number: %s - %0d",get_full_name() ,port);
  `uvm_info("msg", "MONITOR Done !!!", UVM_NONE)
endfunction: build_phase

task run_phase(uvm_phase phase);
  @(negedge dut_vi.reset);
  @(posedge dut_vi.clock);
  $display("MON %0d",port);
  $display("PORT number: %s - %0d",get_full_name() ,port);
  forever
  begin
    packet_t tx;
    tx = packet_t::type_id::create("tx");
    `uvm_info("monitor", "Getting New transaction", UVM_NONE)
    $display("PORT number: %s - %0d",get_full_name() ,port);
    dut_vi.get_packet(tx, port);
    `uvm_info("monitor", "Got New transaction", UVM_NONE)
    aport.write(tx);
    //
  end
endtask: run_phase

endclass : router_monitor
