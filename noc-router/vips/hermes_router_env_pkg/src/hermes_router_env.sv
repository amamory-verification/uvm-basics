class hermes_router_env extends uvm_env;
`uvm_component_utils(hermes_router_env);

hermes_agent       agent_master_h [hermes_pkg::NPORT];
hermes_agent       agent_slave_h [hermes_pkg::NPORT];
hermes_router_coverage    coverage_h;
hermes_router_scoreboard  scoreboard_h;
hermes_router_env_config  cfg;

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  // build the agent and pass its parameters 
  if (uvm_top.get_report_verbosity_level() >= UVM_HIGH)
    print_config(); 

  if (!uvm_config_db #(hermes_router_env_config)::get(this, "", "config", cfg))
    `uvm_fatal("env", "No cfg");

  foreach (agent_master_h[i]) begin
    uvm_config_db #(hermes_agent_config)::set(this, $sformatf("agent_master_%0d",i), "config", cfg.agent_cfg[i]);
    // the following configuration sent to the agent are not supposed to be changed in the tes level, so they were separated
    uvm_config_db #(string)             ::set(this, $sformatf("agent_master_%0d",i), "mode", "master");
    uvm_config_db #(bit [3:0])          ::set(this, $sformatf("agent_master_%0d",i), "port", i);

    agent_master_h[i] = hermes_agent::type_id::create($sformatf("agent_master_%0d",i), this);
  end
  foreach (agent_slave_h[i]) begin
    uvm_config_db #(hermes_agent_config)::set(this, $sformatf("agent_slave_%0d",i), "config", cfg.agent_cfg[i]);
    // the following configuration sent to the agent are not supposed to be changed in the tes level, so they were separated
    uvm_config_db #(string)             ::set(this, $sformatf("agent_slave_%0d",i), "mode", "slave");
    uvm_config_db #(bit [3:0])          ::set(this, $sformatf("agent_slave_%0d",i), "port", i);

    agent_slave_h[i] = hermes_agent::type_id::create($sformatf("agent_slave_%0d",i), this);
  end

  if (cfg.enable_coverage == 1)
    coverage_h   = hermes_router_coverage::type_id::create("coverage", this);
  scoreboard_h = hermes_router_scoreboard::type_id::create("scoreboard", this);
  `uvm_info("msg", "ENV Done !", UVM_HIGH)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  `uvm_info("msg", "Connecting ENV", UVM_HIGH)
  foreach (agent_master_h[i]) begin
    // connect in monitors with the sb
    agent_master_h[i].monitor_h.aport.connect(scoreboard_h.in_mon_ap);
  end
  foreach (agent_slave_h[i]) begin
    // connect out monitors with the sb
    agent_slave_h[i].monitor_h.aport.connect(scoreboard_h.out_mon_ap);
  end
  // conenct sb with coverage
  if (cfg.enable_coverage == 1)
    scoreboard_h.cov_ap.connect(coverage_h.analysis_export);
  `uvm_info("msg", "Connecting ENV Done !", UVM_HIGH)
endfunction: connect_phase

endclass: hermes_router_env
