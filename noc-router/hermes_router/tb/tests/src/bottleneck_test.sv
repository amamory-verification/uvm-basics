/*
test that injects packets in all input ports in parallel 
*/
class bottleneck_test extends base_test;
`uvm_component_utils(bottleneck_test)

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

task run_phase(uvm_phase phase);
  bottleneck_seq seq = bottleneck_seq::type_id::create("seq");
  seq_config cfg = seq_config::type_id::create("seq_cfg");

  if (!cfg.randomize() with { 
      // number of packets to be simulated
      npackets == 20; 
      // set the timing behavior of the sequence
      cycle2send == 1;
      cycle2flit == 0;
      // WARNING: It is necessary to set the port even if it makes no sense due te randomization
      // so it is up to you to assign a port coherent with the header. For instance, 
      // port == router_pkg::LOCAL; and header == 8'h11; is invalid because the router does not support loopback
      // port == router_pkg::NORTH; and header == 8'h01; is invalid because the XY routing algo (turn N -> W is invalid)
      port == router_pkg::NORTH;
      // they are all sending packets to the same output port, creating a bottleneck
      header == 8'h11;
      // only small packets
      p_size == packet_t::SMALL;
    }
  )
    `uvm_error("rand", "invalid cfg randomization"); 

  phase.raise_objection(this);
  // start the virtual sequence
  init_vseq(seq); 
  seq.set_seq_config(cfg);
  seq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: bottleneck_test
