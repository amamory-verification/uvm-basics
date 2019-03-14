/*
 this flat sequence injects 'npackets' into a single port 'port'
 all packets will be sent to the same target address     
*/
class repeat_seq extends hermes_noc_base_seq; 
`uvm_object_utils(repeat_seq)

// sequence configuration 
hermes_noc_seq_config cfg;

function new(string name = "repeat_seq");
  super.new(name);
endfunction: new

task pre_body();
  super.pre_body();
  // the configuration and the sequencer must be set in the tests
  if(!uvm_config_db #(hermes_noc_seq_config)::get(get_sequencer(), "", "config", cfg))
    `uvm_fatal(get_type_name(), "config config_db lookup failed")
endtask


task body;
  hermes_packet_t tx;

  repeat(cfg.npackets)
  begin
    tx = hermes_packet_t::type_id::create("tx");
    // when testing the noc, the driver will always inject packets into a local port.
    tx.dport = hermes_pkg::LOCAL;
    // disable the header randomization because it will always be defined by the seq_cfg
    tx.header.rand_mode(0);
    tx.x.rand_mode(0);
    tx.y.rand_mode(0);
    

    start_item(tx);
    if( ! tx.randomize() with {
        tx.p_size == cfg.p_size;
        //tx.header == cfg.header;
      }
    )
      `uvm_error("repeat_seq", "invalid seq item randomization"); 
    `uvm_info("repeat_seq", cfg.convert2string(), UVM_HIGH)

    tx.header = cfg.header;
    tx.x = cfg.header[7:4];
    tx.y = cfg.header[3:0];

    finish_item(tx);
  end
endtask: body

endclass: repeat_seq

