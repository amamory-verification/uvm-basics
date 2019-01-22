/*
 this flat sequence injects 'npackets' into a single port 'port'
 all packets will be sent to the same target address   
*/
class basic_seq extends base_vseq; 
`uvm_object_utils(basic_seq)

// sequence configuration 
seq_config cfg;

function new(string name = "basic_seq");
  super.new(name);
endfunction: new

task pre_body();
  super.pre_body();
  // the configuration and the sequencer must be set in the tests
  if(!uvm_config_db #(seq_config)::get(get_sequencer(), "", "config", cfg))
    `uvm_fatal(get_type_name(), "config config_db lookup failed")
endtask


task body;
  packet_t tx;

  repeat(cfg.npackets)
  begin
    tx = packet_t::type_id::create("tx");
    // set the driver port where these packets will be injected
    tx.dport = cfg.port;

    start_item(tx);
    if( ! tx.randomize() with {
        tx.p_size == cfg.p_size;
        tx.header == cfg.header;
      }
    )
      `uvm_error("basic_seq", "invalid seq item randomization"); 
    `uvm_info("basic_seq", cfg.convert2string(), UVM_HIGH)

    finish_item(tx);
  end
endtask: body

endclass: basic_seq

