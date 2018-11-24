class mult_agent extends uvm_agent;
`uvm_component_utils(mult_agent);

 uvm_analysis_port #(mult_input_t) aport;

 mult_sequencer sequencer_h;
 mult_driver    driver_h;
 mult_monitor   monitor_h;
 
function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  aport = new("aport", this); 
  `uvm_info("msg", "Building Agent", UVM_NONE)
  sequencer_h = mult_sequencer::type_id::create("sequencer", this);
  driver_h = mult_driver::type_id::create("driver", this);
  monitor_h = mult_monitor::type_id::create("monitor", this);
  `uvm_info("msg", "Building Agent DONE!", UVM_NONE)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  `uvm_info("msg", "Connecting Agent", UVM_NONE)
  driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
  monitor_h.aport.connect(aport);
  `uvm_info("msg", "Connecting Agent DONE!", UVM_NONE)
endfunction: connect_phase

endclass: mult_agent
