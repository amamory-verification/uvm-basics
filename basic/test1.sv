class test1 extends uvm_test;
`uvm_component_utils(test1)

my_env my_env_h;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  my_env_h = my_env::type_id::create("my_env", this);
  `uvm_info("msg", "Building Environment DONE!", UVM_NONE)
endfunction: build_phase

task run_phase(uvm_phase phase);
  read_modify_write seq;
  `uvm_info("msg", "Running TEST1", UVM_NONE)
  seq = read_modify_write::type_id::create("seq");
  phase.raise_objection(this);
  `uvm_info("msg", "Starting  SEQ", UVM_NONE)
  seq.start(my_env_h.my_agent_h.my_sequencer_h);
  `uvm_info("msg", "SEQ STARTED!!!", UVM_NONE)
  phase.drop_objection(this);
endtask

endclass: test1
