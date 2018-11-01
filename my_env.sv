class my_env extends uvm_env;
`uvm_component_utils(my_env);

 my_agent       my_agent_h;
 my_subscriber  my_subscriber_h;
 
function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  //aport = new("aport", this); 
  my_agent_h = my_agent::type_id::create("my_agent", this);
  my_subscriber_h = my_subscriber::type_id::create("my_subscriber", this);
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  my_agent_h.aport.connect(my_subscriber_h.analisis_export);
endfunction: connect_phase

endclass: my_env
