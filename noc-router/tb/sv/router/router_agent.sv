class router_agent extends uvm_agent;
`uvm_component_utils(router_agent); 

 packet_sequencer sequencer_h;
 router_driver    driver_h;
 //uvm_component    driver_h;
 router_monitor   monitor_h;
 bit [3:0] port;
 bit [3:0] cred_distrib;
 string port_dir; // in or out
virtual router_if duv_if;
 
function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  
  //print config_db
  //print_config();  

  if (!uvm_config_db #(virtual router_if)::get (this,"", "if", duv_if) )
    `uvm_fatal("agent", "No agent_if");    
  // set the correct interface to its monitor and agent. 
  uvm_config_db #(virtual router_if)::set (this,"monitor", "if", duv_if);
  uvm_config_db #(virtual router_if)::set (this,"driver", "if", duv_if);

  if (!uvm_config_db #(string)::get (this,"", "port_dir", port_dir) )
    `uvm_fatal("agent", "No port_dir");    
  if (port_dir != "out" && port_dir != "in") 
    `uvm_fatal("agent", "unexpected port_dir value");    

  // the output agent's driver 
  /*
  if (get_is_active() && port_dir == "out") 
  begin
    if (!uvm_config_db #(bit [3:0])::get (this,"", "cred_distrib", cred_distrib) )
      `uvm_fatal("agent", "No cred_distrib"); 
    uvm_config_db #(bit [3:0])::set (this,"driver", "cred_distrib", cred_distrib);
  end
  */

  // port id
  if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
    `uvm_fatal("agent", "No port"); 
  `uvm_info("agent", $sformatf("PORT number: %0d",port), UVM_HIGH)
  // set the correct interface to its monitor and agent. 
  uvm_config_db #(bit [3:0])::set (this,"monitor", "port", port);
  uvm_config_db #(bit [3:0])::set (this,"driver", "port", port);

  if (!uvm_config_db #(uvm_active_passive_enum)::get (this,"", "is_active", is_active) )
    `uvm_fatal("agent", "No is_active");
  // only the input agent has an actual driver/sequencer   
  if (get_is_active()) begin
    // select the driver behavior depending on the agent direction
    if (port_dir == "in") begin
      sequencer_h = packet_sequencer::type_id::create("sequencer", this);
      //set_inst_override_by_type( {get_full_name(), ".driver"},  uvm_component::get_type(), router_driver::get_type() );
      driver_h = router_driver::type_id::create("driver", this);
    end
    else if (port_dir == "out") begin
      `uvm_info("agent", get_full_name(), UVM_NONE)
      `uvm_info("agent", {get_full_name(), ".driver"}, UVM_NONE)
      set_inst_override_by_type( {get_full_name(), ".driver"},  router_driver::get_type(), credit_i_driver::get_type() );
      driver_h = credit_i_driver::type_id::create("driver", this);
    end
  end
  monitor_h = router_monitor::type_id::create("monitor", this);
  `uvm_info("msg", "Building Agent DONE!", UVM_HIGH)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  if (get_is_active() && port_dir == "in") begin
    driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
  end
  `uvm_info("msg", "Connecting Agent DONE!", UVM_HIGH)
endfunction: connect_phase

endclass: router_agent
