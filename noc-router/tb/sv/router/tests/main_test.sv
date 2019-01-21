/*
test that injects packets in all input ports in parallel
*/
class main_test extends base_test;
`uvm_component_utils(main_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  // randomize here the agent configuration 
  /*
  foreach(acfg[i]) begin
    if( !acfg[i].randomize() )
      `uvm_error("test", "invalid agent cfg randomization"); 
  end
*/

  foreach(acfg[i]) begin
    if( !acfg[i].randomize() with { 
        cycle2send == 1;
        cycle2flit == 0;
        cred_distrib == 5;
      }
    )
      `uvm_error("test", "invalid agent cfg randomization"); 
  end


  // last thing to do is to the agent configuration  with config_db
  uvm_config_db#(hermes_env_config)::set(null, "uvm_test_top.env", "config", env_cfg);
  env_h = router_env::type_id::create("env", this);
  //set_acfg_db();
endfunction

task run_phase(uvm_phase phase);
  main_vseq seq = main_vseq::type_id::create("seq");
  seq_config cfg[router_pkg::NPORT];

  foreach(cfg[i]) begin
    cfg[i] = seq_config::type_id::create($sformatf("seq_cfg[%0d]",i));
    if( !cfg[i].randomize() with { 
        // number of packets to be simulated
        npackets == 5; 
        port == i; 
        // only small packets
        p_size == packet_t::SMALL;
      }
    )
      `uvm_error("rand", "invalid cfg randomization"); 
    // 
    uvm_config_db#(seq_config)::set(null, $sformatf("uvm_test_top.env.agent_master_%0d.sequencer",i), "config",cfg[i]);

  end

  phase.raise_objection(this);
  // start the virtual sequence
  init_vseq(seq); 
  //seq.set_seq_config(cfg);
  seq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: main_test
