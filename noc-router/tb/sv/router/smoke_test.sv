/*
simple test that injects 10 packets into the local port
*/
class smoke_test extends base_test;
`uvm_component_utils(smoke_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("msg", "Building Environment DONE!", UVM_LOW)
endfunction: build_phase

task run_phase(uvm_phase phase);
  basic_seq seq;

  phase.raise_objection(this);
  seq = basic_seq::type_id::create("seq");
  init_vseq(seq); 

  assert(seq.randomize() with { 
      // number of packets to be simulated
      npackets == 1; 
      // set the timing behavior of the sequence
      seq.cycle2send == 1;
      seq.cycle2flit == 0;
      // this seq will inject packets into the NORTH port only
      seq.port == router_pkg::NORTH;
      // all packets will be sent to the router 8'h11
      seq.header == 8'h11;
      // only small packets
      seq.p_size == packet_t::SMALL;
    }
  );

  seq.start(env_h.agent_h[router_pkg::NORTH].sequencer_h);  

  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  //`uvm_info("msg", "SEQ STARTED!!!", UVM_LOW)
  phase.drop_objection(this);
endtask

endclass: smoke_test
