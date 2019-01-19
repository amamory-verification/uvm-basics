/*
simple test that injects 10 packets into the north port.
the difference compared to smoke_test.sv is the use of config_db  
*/
class smoke_test extends base_test;
`uvm_component_utils(smoke_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new


function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  uvm_config_db#(bit [3:0])::set(null, "uvm_test_top.env.agent_out_*.driver", "cred_distrib",3);
/*
  uvm_config_db#(bit [3:0])::set(null, "uvm_test_top.env.agent_out_0.driver", "cred_distrib",3);
  uvm_config_db#(bit [3:0])::set(null, "uvm_test_top.env.agent_out_1.driver", "cred_distrib",4);
  uvm_config_db#(bit [3:0])::set(null, "uvm_test_top.env.agent_out_2.driver", "cred_distrib",5);
  uvm_config_db#(bit [3:0])::set(null, "uvm_test_top.env.agent_out_3.driver", "cred_distrib",6);
  uvm_config_db#(bit [3:0])::set(null, "uvm_test_top.env.agent_out_4.driver", "cred_distrib",7);
*/  
endfunction


task run_phase(uvm_phase phase);
  basic_seq seq;
  seq_config cfg;

  // configuring sequence parameters
  cfg = seq_config::type_id::create("seq_cfg");
  if( !cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 10; 
      // set the timing behavior of the sequence
      cycle2send == 1;
      cycle2flit == 0;
      // this seq will inject packets into the NORTH port only
      port == router_pkg::NORTH;
      // all packets will be sent to the router 8'h11
      header == 8'h11;
      // only small packets
      p_size == packet_t::SMALL;
    }
  )
    `uvm_error("rand", "invalid cfg randomization"); 

  phase.raise_objection(this);

  // create the sequence and initialize it 
  seq = basic_seq::type_id::create("seq");
  init_vseq(seq); 
  seq.set_seq_config(cfg);

  if( !seq.randomize())
    `uvm_error("rand", "invalid seq randomization"); 

  seq.start(seq.sequencer[cfg.port]);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: smoke_test
