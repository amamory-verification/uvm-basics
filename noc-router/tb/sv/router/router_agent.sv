class router_agent extends uvm_agent;
`uvm_component_utils(router_agent);

 packet_sequencer sequencer_h;
 router_driver    driver_h;
 router_monitor   monitor_h;
 bit [3:0] port;

 
function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  //aport = new("aport", this); 
  if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
    `uvm_fatal("agent", "No port"); 
  if (!uvm_config_db #(uvm_active_passive_enum)::get (this,"", "is_active", is_active) )
    `uvm_fatal("agent", "No port");   
  if (get_is_active()) begin
    sequencer_h = packet_sequencer::type_id::create("sequencer", this);
    driver_h = router_driver::type_id::create("driver", this);
  end
  monitor_h = router_monitor::type_id::create("monitor", this);
  `uvm_info("msg", "Building Agent DONE!", UVM_NONE)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  if (get_is_active()) begin
    driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
  end
  `uvm_info("msg", "Connecting Agent DONE!", UVM_NONE)
endfunction: connect_phase

endclass: router_agent
