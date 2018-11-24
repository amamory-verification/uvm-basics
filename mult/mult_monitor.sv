class mult_monitor extends uvm_monitor;
`uvm_component_utils(mult_monitor);

uvm_analysis_port #(mult_input_t) aport;
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
    mult_input_t tx;
    tx = mult_input_t::type_id::create("tx");
    @(posedge dut_vi.start);
    @(negedge dut_vi.clock);
    tx.A = dut_vi.A;
    tx.B = dut_vi.B;
    @(posedge dut_vi.done);
    @(negedge dut_vi.clock);
    tx.dout = dut_vi.dout;
    aport.write(tx);
    `uvm_info("msg", "New transaction", UVM_HIGH)
  end
endtask: run_phase

endclass : mult_monitor
