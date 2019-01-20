class router_agent extends uvm_agent;
`uvm_component_utils(router_agent); 

 packet_sequencer   sequencer_h;
 router_base_driver driver_h;
 router_monitor     monitor_h;
 bit [3:0] port;
 string port_dir; // in or out
 hermes_agent_cfg cfg;
 
function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  virtual router_if duv_if;
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

  if (!uvm_config_db #(hermes_agent_cfg)::get (this,"", "cfg", cfg) )
    `uvm_fatal("agent", "No cfg");    

  // port id
  if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
    `uvm_fatal("agent", "No port"); 
  `uvm_info("agent", $sformatf("PORT number: %0d",port), UVM_HIGH)
  // set the correct interface to its monitor and agent. 
  uvm_config_db #(bit [3:0])::set (this,"monitor", "port", port);
  uvm_config_db #(bit [3:0])::set (this,"driver", "port", port);

  if (!uvm_config_db #(uvm_active_passive_enum)::get (this,"", "is_active", is_active) )
    `uvm_fatal("agent", "No is_active");

  // create and set drivers
  if (get_is_active()) begin
    // select the driver behavior depending on the agent direction
    if (port_dir == "in") begin
      // only the input agent has an actual driver/sequencer   
      sequencer_h = packet_sequencer::type_id::create("sequencer", this);
      set_inst_override_by_type( {get_full_name(), ".driver"},  router_base_driver::get_type(), router_driver::get_type() );
      driver_h = router_driver::type_id::create("driver", this);
      uvm_config_db #(bit [3:0])::set (this,"driver", "cycle2send", cfg.cycle2send);
      uvm_config_db #(bit [3:0])::set (this,"driver", "cycle2flit", cfg.cycle2flit);
    end
    else if (port_dir == "out") begin
      //`uvm_info("agent", {get_full_name(), ".driver"}, UVM_NONE)
      // override the behavior of the driver if it is and output agent
      set_inst_override_by_type( {get_full_name(), ".driver"},  router_base_driver::get_type(), credit_i_driver::get_type() );
      driver_h = credit_i_driver::type_id::create("driver", this);
      uvm_config_db #(bit [3:0])::set (this,"driver", "cred_distrib", cfg.cred_distrib);
    end
  end

  // create and set monitors
  monitor_h = router_monitor::type_id::create("monitor", this);
  `uvm_info("msg", "Building Agent DONE!", UVM_HIGH)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  // the output drinver does not use sequence. so, no need to connect
  if (get_is_active() && port_dir == "in") begin
    driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
  end
  `uvm_info("msg", "Connecting Agent DONE!", UVM_HIGH)
endfunction: connect_phase

endclass: router_agent
