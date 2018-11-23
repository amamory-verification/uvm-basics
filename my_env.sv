class my_env extends uvm_env;
`uvm_component_utils(my_env);

 my_agent       my_agent_h;
 my_subscriber  my_subscriber_h;
 
function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  `uvm_info("msg", "Building ENV", UVM_NONE)
  my_agent_h = my_agent::type_id::create("my_agent", this);
  my_subscriber_h = my_subscriber::type_id::create("my_subscriber", this);
  `uvm_info("msg", "ENV Done !", UVM_NONE)
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  `uvm_info("msg", "Connecting ENV", UVM_NONE)
  my_agent_h.aport.connect(my_subscriber_h.analysis_export);
  `uvm_info("msg", "Connecting ENV Done !", UVM_NONE)
endfunction: connect_phase

endclass: my_env
