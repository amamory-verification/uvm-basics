/*
simple test that injects 10 packets into the north port.
the difference compared to smoke_test.sv is the use of config_db  
*/
class smoke_test2 extends base_test;
`uvm_component_utils(smoke_test2)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new


function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  // randomize here the agent configuration 
  foreach(acfg[i]) begin
    if( !acfg[i].randomize() )
      `uvm_error("test", "invalid agent cfg randomization"); 
  end
  
  // or disable the master drivers 
  foreach(acfg[i]) begin
    acfg[i].rand_mode(0);
    acfg[i].master_driver_enabled = 0;
  end

  // this test uses only the north port
  acfg[router_pkg::NORTH].rand_mode(1);
  acfg[router_pkg::NORTH].master_driver_enabled = 1;
  if( !acfg[router_pkg::NORTH].randomize() with { 
      cycle2send == 1;
      cycle2flit == 0;
    }
  )
    `uvm_error("test", "invalid agent cfg randomization"); 

  // last thing to do is to the agent configuration  with config_db
  uvm_config_db#(hermes_env_config)::set(null, "uvm_test_top.env", "config", env_cfg);
  env_h = router_env::type_id::create("env", this);
  //set_acfg_db();
endfunction

task run_phase(uvm_phase phase);
  basic_seq2 seq;
  seq_config seq_cfg;

  // configuring sequence parameters and send it to the sequencer
  //uvm_config_db#(bit [3:0])::set(null, "uvm_test_top.env.agent_master_*.sequencer.seq", "cycle2send",1);
  seq_cfg = seq_config::type_id::create("seq_cfg");
  if( !seq_cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 10; 
      // set the timing behavior of the sequence
      //cycle2send == 1;
      //cycle2flit == 0;
      // this seq will inject packets into the NORTH port only
      port == router_pkg::NORTH;
      // all packets will be sent to the router 8'h11
      header == 8'h11;
      // only small packets
      p_size == packet_t::SMALL;
    }
  )
    `uvm_error("rand", "invalid cfg randomization"); 
  uvm_config_db#(seq_config)::set(null, "", "config",seq_cfg);

  phase.raise_objection(this);

  // create the sequence and initialize it 
  seq = basic_seq2::type_id::create("seq");
  init_vseq(seq); 
  //seq.set_seq_config(cfg);

  if( !seq.randomize())
    `uvm_error("rand", "invalid seq randomization"); 

  seq.start(seq.sequencer[seq_cfg.port]);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: smoke_test2
