class test1 extends uvm_test;
`uvm_component_utils(test1)

my_env my_env_h;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

task run_phase(uvm_phase phase);
  `uvm_info("msg", "Running TEST1", UVM_NONE)
  read_modify_write seq;
  seq = read_modify_write::type_id::create("seq");
  phase.raise_objection(this);
  `uvm_info("msg", "Starting  SEQ", UVM_NONE)
  seq.start(my_env_h.my_agent_h.my_sequencer_h);
  `uvm_info("msg", "SEQ STARTED!!!", UVM_NONE)
  phase.drop_objection(this);
endtask

endclass: test1
