class zeros_test extends uvm_test;
`uvm_component_utils(zeros_test)

mult_env env_h;
//int a;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  env_h = mult_env::type_id::create("env", this);
  /*
  according to https://www.synopsys.com/content/dam/synopsys/services/whitepapers/hierarchical-testbench-configuration-using-uvm.pdf
  it is possible to pass parameter to the simulator avoiding recompilation
  +uvm _ set _ config _ int=<comp>,<filed>,<value>
  +uvm _ set _ config _ string=<comp>,<field>,<value>
  exemple:
  +uvm_set_config_int=uvm_test_top.env_i, a, 6 
  +uvm_set_config_string=uvm_test_top.env_i, color, red

  uvm_config_ db #( uvm_bitstream_t )::set(this, “env _ i”, “a”, a);
  usar isso p passar parametro se o teste eh signed ou unsigned, passar o width
  */
  `uvm_info("msg", "Building Environment DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  mult_zero_seq seq;
  mult_one_seq seq1;
  
  seq = mult_zero_seq::type_id::create("seq");
  phase.raise_objection(this);
  seq.start(env_h.agent_h.sequencer_h);
  phase.drop_objection(this);

  
  seq1 = mult_one_seq::type_id::create("seq1");
  phase.raise_objection(this);
  seq1.start(env_h.agent_h.sequencer_h);
  phase.drop_objection(this);
endtask

endclass: zeros_test
