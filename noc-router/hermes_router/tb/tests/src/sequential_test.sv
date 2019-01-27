/*
 this hierarchical sequence injects packets in sequential port order, starting with the port 0.
 */
class sequential_test extends base_test;
`uvm_component_utils(sequential_test)

// configure (in command line with, e,g, +uvm_set_config_int=*,repeat_sequence,3) the test to repeat the sequence
int repeat_sequence;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  // randomize here the agent configuration 
  foreach(acfg[i]) begin
    if( !acfg[i].randomize() with { 
      //cycle2send == 1;
      cycle2flit == 0;
      cred_distrib == 8;
      }
    )
      `uvm_error("test", "invalid agent cfg randomization"); 
  end

  // change any env and agent configuration here, before sending it to the config_db 

  if(!uvm_config_db #(uvm_bitstream_t)::get(null, "", "repeat_sequence", repeat_sequence))
    repeat_sequence = 10; // defaul value

  // last thing to do is to the agent configuration  with config_db
  uvm_config_db#(hermes_router_env_config)::set(null, "uvm_test_top.env", "config", env_cfg);
  env_h = hermes_router_env::type_id::create("env", this);
endfunction


task run_phase(uvm_phase phase);
  repeat_seq seq;
  hermes_router_seq_config seq_cfg;

  phase.raise_objection(this);

  for (int i = 0; i < hermes_pkg::NPORT; i++)
  begin
    repeat(repeat_sequence)
    begin
      // set the sequence configuration, to be read by the sequencer
      seq_cfg = hermes_router_seq_config::type_id::create("seq_cfg");
      if( !seq_cfg.randomize() with { 
          // number of packets to be simulated
          npackets == 1; 
          // input port
          port == i;
          // only small packets
          p_size == hermes_packet_t::SMALL;
        }
      )
        `uvm_error("test", "invalid cfg randomization"); 
      uvm_config_db#(hermes_router_seq_config)::set(null, "", "config",seq_cfg);

      // create the sequence and initialize it 
      seq = repeat_seq::type_id::create("seq");
      init_vseq(seq); 

      if( !seq.randomize())
        `uvm_error("test", "invalid seq randomization"); 

      seq.start(seq.sequencer[seq_cfg.port]);
    end
  end
  // end the simulation a little bit latter
  //phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: sequential_test
