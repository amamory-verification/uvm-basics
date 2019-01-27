/*
test that injects packets in all input ports in parallel
*/
class parallel_test extends base_test;
`uvm_component_utils(parallel_test)

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

  // in this test, all agents have the same behaviour
  foreach(acfg[i]) begin
    if( !acfg[i].randomize() with { 
        cycle2send == 1;   // a new packet is sent 1 clock cycle after the last one
        cycle2flit == 0;   // a new flit is sent every cycle after the transaction starts
        cred_distrib == 5; // the slave ports have 50% availability
      }
    )
      `uvm_error("test", "invalid agent cfg randomization"); 
  end


  // last thing to do is to the agent configuration  with config_db
  uvm_config_db#(hermes_router_env_config)::set(null, "uvm_test_top.env", "config", env_cfg);
  env_h = hermes_router_env::type_id::create("env", this);
endfunction

task run_phase(uvm_phase phase);
  parallel_seq seq = parallel_seq::type_id::create("seq");
  hermes_router_seq_config cfg[hermes_pkg::NPORT];

  foreach(cfg[i]) begin
    cfg[i] = hermes_router_seq_config::type_id::create($sformatf("seq_cfg[%0d]",i));
    if( !cfg[i].randomize() with { 
        // number of packets to be simulated per sequencer
        npackets == 5; 
        port == i; 
        // only small packets
        p_size == hermes_packet_t::SMALL;
      }
    )
      `uvm_error("test", "invalid cfg randomization"); 
    // send the sequence configuration to each sequencer
    uvm_config_db#(hermes_router_seq_config)::set(null, $sformatf("uvm_test_top.env.agent_master_%0d.sequencer",i), "config",cfg[i]);

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

endclass: parallel_test
