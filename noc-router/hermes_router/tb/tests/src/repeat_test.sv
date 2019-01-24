/*
simple test that injects 10 packets into the north port.
*/
class repeat_test extends base_test;
`uvm_component_utils(repeat_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new


function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  // randomize here the agent configuration 
  foreach(acfg[i]) begin
    if( !acfg[i].randomize() )
      `uvm_error("repeat_test", "invalid agent cfg randomization"); 
  end
  
  // or disable the master drivers 
  foreach(acfg[i]) begin
    acfg[i].rand_mode(0);
    acfg[i].master_driver_enabled = 0;
  end

  // this test uses only the north port
  acfg[hermes_pkg::NORTH].rand_mode(1);
  acfg[hermes_pkg::NORTH].master_driver_enabled = 1;
  if( !acfg[hermes_pkg::NORTH].randomize() with { 
      cycle2send == 1;
      cycle2flit == 0;
    }
  )
    `uvm_error("repeat_test", "invalid agent cfg randomization"); 


  // change any env and agent configuration here, before sending it to the config_db 

  // last thing to do is to the agent configuration  with config_db
  uvm_config_db#(hermes_router_env_config)::set(null, "uvm_test_top.env", "config", env_cfg);
  env_h = hermes_router_env::type_id::create("env", this);
endfunction


task run_phase(uvm_phase phase);
  repeat_seq seq;
  hermes_router_seq_config seq_cfg;
  
  // set the sequence configuration, to be read by the sequencer
  seq_cfg = hermes_router_seq_config::type_id::create("seq_cfg");
  if( !seq_cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 10; 
      // this seq will inject packets into the NORTH port only
      port == hermes_pkg::NORTH;
      // all packets will be sent to the router 8'h11
      header == 8'h11;
      // only small packets
      p_size == hermes_packet_t::SMALL;
    }
  )
    `uvm_error("rand", "invalid cfg randomization"); 
  uvm_config_db#(hermes_router_seq_config)::set(null, "", "config",seq_cfg);

  phase.raise_objection(this);

  // create the sequence and initialize it 
  seq = repeat_seq::type_id::create("seq");
  init_vseq(seq); 

  if( !seq.randomize())
    `uvm_error("rand", "invalid seq randomization"); 

  seq.start(seq.sequencer[seq_cfg.port]);  

  // end the simulation a little bit latter
  //phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: repeat_test
