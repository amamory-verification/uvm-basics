class mult_env extends uvm_env;
`uvm_component_utils(mult_env);

 mult_agent       agent_h;
 mult_coverage    coverage_h;
 mult_scoreboard  scoreboard_h;
 
function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  `uvm_info("msg", "Building ENV", UVM_NONE)
  agent_h = mult_agent::type_id::create("agent", this);
  coverage_h = mult_coverage::type_id::create("coverage", this);
  scoreboard_h = mult_scoreboard::type_id::create("scoreboard", this);
  `uvm_info("msg", "ENV Done !", UVM_NONE)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  `uvm_info("msg", "Connecting ENV", UVM_NONE)
  agent_h.aport.connect(coverage_h.analysis_export);
  agent_h.aport.connect(scoreboard_h.analysis_export);
  `uvm_info("msg", "Connecting ENV Done !", UVM_NONE)
endfunction: connect_phase

endclass: mult_env
