class test1 extends uvm_test;
`uvm_component_utils(test1)

my_env my_env_h;

task run_phase(uvm_phase phase);
  read_modify_write seq;
  seq = read_modify_write::type_id::create("seq");
  phase.raise_objection(this);
  seq.start(my_env_h.my_agent_h.my_seqeuncer_h);
  phase.drop_objection(this);
endtask
endclass: test1
