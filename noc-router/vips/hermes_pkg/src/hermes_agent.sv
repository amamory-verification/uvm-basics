class hermes_agent extends uvm_agent;
`uvm_component_utils(hermes_agent); 

 packet_sequencer     sequencer_h;
 hermes_base_driver   driver_h;
 hermes_monitor       monitor_h;
 hermes_agent_config  cfg;
 string mode; // agent mode = master / slave. master mode uses the master driver and the slave mode uses the slave driver

 
function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  virtual hermes_if duv_if;
  bit [3:0] port;
  //print config_db
  if (uvm_top.get_report_verbosity_level() >= UVM_HIGH)
    print_config();  

  if (!uvm_config_db #(hermes_agent_config)::get (this,"", "config", cfg) )
    `uvm_fatal("agent", "No cfg");    

  if (!uvm_config_db #(virtual hermes_if)::get (this,"", "if", duv_if) )
    `uvm_fatal("agent", "No agent_if");    
  // set the correct interface to its monitor and agent. 
  uvm_config_db #(virtual hermes_if)::set (this,"monitor", "if", duv_if);
  uvm_config_db #(virtual hermes_if)::set (this,"driver", "if", duv_if);

  if (!uvm_config_db #(string)::get (this,"", "mode", mode) )
    `uvm_fatal("agent", "No mode");    
  if (mode != "slave" && mode != "master") 
    `uvm_fatal("agent", "unexpected mode value");    

  // port id
  if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
    `uvm_fatal("agent", "No port"); 
  `uvm_info("agent", $sformatf("PORT number: %0d",port), UVM_HIGH)
  // set the correct interface to its monitor and agent. 
  uvm_config_db #(bit [3:0])::set (this,"monitor", "port", port);
  uvm_config_db #(bit [3:0])::set (this,"driver", "port", port);

  // create and set drivers
  if (cfg.is_active) begin
    // select the driver behavior depending on the agent direction
    if (mode == "master") begin
      // only the input agent has an actual driver/sequencer   
      sequencer_h = packet_sequencer::type_id::create("sequencer", this);
      set_inst_override_by_type( {get_full_name(), ".driver"},  hermes_base_driver::get_type(), hermes_master_driver::get_type() );
      driver_h = hermes_master_driver::type_id::create("driver", this);
      uvm_config_db #(bit [3:0])::set (this,"driver", "cycle2send", cfg.cycle2send);
      uvm_config_db #(bit [3:0])::set (this,"driver", "cycle2flit", cfg.cycle2flit);
      uvm_config_db #(bit)      ::set (this,"driver", "enabled", cfg.master_driver_enabled);
    end
    else if (mode == "slave") begin
      // override the behavior of the driver to an slave agent
      set_inst_override_by_type( {get_full_name(), ".driver"},  hermes_base_driver::get_type(), hermes_slave_driver::get_type() );
      driver_h = hermes_slave_driver::type_id::create("driver", this);
      uvm_config_db #(bit [3:0])::set (this,"driver", "cred_distrib", cfg.cred_distrib);
    end
  end

  // create and set monitors
  monitor_h = hermes_monitor::type_id::create("monitor", this);
  `uvm_info("msg", "Building Agent DONE!", UVM_HIGH)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  // the output drinver does not use sequence. so, no need to connect
  if (cfg.is_active && mode == "master") begin
    driver_h.seq_item_port.connect(sequencer_h.seq_item_export);
  end
  `uvm_info("msg", "Connecting Agent DONE!", UVM_HIGH)
endfunction: connect_phase

endclass: hermes_agent
