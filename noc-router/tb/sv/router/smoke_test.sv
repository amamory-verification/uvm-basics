class smoke_test extends uvm_test;
`uvm_component_utils(smoke_test)

router_env env_h;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  env_h = router_env::type_id::create("env", this);
  `uvm_info("msg", "Building Environment DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  basic_seq seq[router_pkg::NPORT];
  int k;
  //`uvm_info("msg", "Running TEST1", UVM_LOW)
  phase.raise_objection(this);

  k = 4;
  seq[k] = basic_seq::type_id::create($psprintf("seq[%0d]",k));
  seq[k].port = k;
  seq[k].start(env_h.agent_h[k].sequencer_h);  

/*  
  k = 2;
  seq[k] = basic_seq::type_id::create($psprintf("seq[%0d]",k));
  seq[k].start(env_h.agent_h[k].sequencer_h);  

  for(int j=0; j < router_pkg::NPORT; ++j) begin
    fork
      automatic int k = j;
      begin
        $display(" START SEQ %0d at time %0t",k,$time);
        seq[k] = basic_seq::type_id::create($psprintf("seq[%0d]",k));
        seq[k].start(env_h.agent_h[k].sequencer_h);
      end
    join_none
    $display(" END SEQ %0d at time %0t",j,$time);

    wait fork; // wait for all the above fork-join_none to complete
    $display(" ALL SEQS ENDED at %0t !!!", $time);
  end
*/  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: smoke_test
