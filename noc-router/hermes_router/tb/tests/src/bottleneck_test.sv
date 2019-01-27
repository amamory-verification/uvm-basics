/*
test that injects packets in all input ports in parallel to the same target address, creating a bottleneck 
*/
class bottleneck_test extends base_test;
`uvm_component_utils(bottleneck_test)

// all valid ports will send packets to this address 
// configure (in command line with, e,g, +uvm_set_config_int=*,target_address,1) the test to change the target router
// the parameter must be a valid router address, i.e. 8'h00, 8'h01, ...,  8'h11, ..., 8'h22,
bit [7:0] target_address;

function new (string name, uvm_component parent);
  super.new(name,parent);
endfunction : new

function void build_phase(uvm_phase phase);
  bit [7:0] valid_addr []= '{8'h00, 8'h01,8'h02, 8'h10, 8'h11,8'h12, 8'h20, 8'h21,8'h22};
  bit [7:0] aux[];
  super.build_phase(phase);

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

  if(!uvm_config_db #(uvm_bitstream_t)::get(null, "", "target_address", target_address))
    target_address = 8'h11; // defaul value, the central router
  else begin
    // check if the target address is valid
    aux = valid_addr.find(x) with (x == target_address);
    if (aux.size == 0 ) 
      `uvm_fatal("test", $sformatf("invalid target address 8'h%H",target_address)); 
  end




  // last thing to do is to the agent configuration  with config_db
  uvm_config_db#(hermes_router_env_config)::set(null, "uvm_test_top.env", "config", env_cfg);
  env_h = hermes_router_env::type_id::create("env", this);
endfunction

task run_phase(uvm_phase phase);
  parallel_seq seq = parallel_seq::type_id::create("seq");
  hermes_router_seq_config cfg[hermes_pkg::NPORT];
  bit [3:0] val_ports[$]; 
  bit [3:0] aux[$];

  // get all ports that can (due to xy routing algo and the loopback design constraint) send packet to this address
  val_ports = hermes_pkg::valid_ports(target_address);  

  foreach(cfg[i]) begin
    // check if 'i' is a valid port
    aux = val_ports.find(x) with (x == i);
    if (aux.size > 0 ) begin
      // only the valid seq are configured
      seq.enable_port[i] = 1;
      cfg[i] = hermes_router_seq_config::type_id::create($sformatf("seq_cfg[%0d]",i));
      if( !cfg[i].randomize() with { 
          // number of packets to be simulated per sequencer
          npackets == 5; 
          port == i; 
          // all valid ports will send packets to the same router address
          header == target_address; 
          // only small packets
          p_size == hermes_packet_t::SMALL;
        }
      )
        `uvm_error("test", "invalid cfg randomization"); 
      // send the sequence configuration to each sequencer
      uvm_config_db#(hermes_router_seq_config)::set(null, $sformatf("uvm_test_top.env.agent_master_%0d.sequencer",i), "config",cfg[i]);
    end else
      // disable the sequences that will not be used
      seq.enable_port[i] = 0;
  end

  phase.raise_objection(this);
  init_vseq(seq); 
  seq.start(null);  
  // end the simulation a little bit latter
  phase.phase_done.set_drain_time(this, 100ns);
  phase.drop_objection(this);
endtask

endclass: bottleneck_test
