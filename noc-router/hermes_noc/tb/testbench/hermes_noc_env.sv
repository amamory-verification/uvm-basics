//----------------
// environment
//----------------
class hermes_noc_env extends uvm_env;
`uvm_component_utils(hermes_noc_env);

  virtual hermes_if m_if;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    `uvm_info("LABEL", "Started connect phase.", UVM_HIGH);
    // Get the interface from the resource database.
    //assert(uvm_resource_db#(virtual add_sub_if)::read_by_name(get_full_name(), "add_sub_if", m_if));
    `uvm_info("LABEL", "Finished connect phase.", UVM_HIGH);
  endfunction: connect_phase

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    `uvm_info("LABEL", "Started run phase.", UVM_HIGH);
    begin
      // do something here
    end
    `uvm_info("LABEL", "Finished run phase.", UVM_HIGH);
    phase.drop_objection(this);
  endtask: run_phase
  
endclass