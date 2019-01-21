/*
 this flat sequence injects 'npackets' into a single port 'port'.
*/
class basic_seq2 extends base_vseq; 
`uvm_object_utils(basic_seq2)

// sequence configuration 
seq_config cfg;

function new(string name = "basic_seq2");
  super.new(name);
endfunction: new

task pre_body();
  super.pre_body();
  if(!uvm_config_db #(seq_config)::get(get_sequencer(), "", "config", cfg))
    `uvm_fatal(get_type_name(), "config config_db lookup failed")
endtask


task body;
  packet_t tx;
  //$display("%s",get_full_name());

  // one example of another way to get individual config values
  //uvm_config_db#(bit [3:0]):: get(null, get_full_name(), "cycle2send", cycle2send);
  //if( !uvm_config_db#( seq_config )::get(get_sequencer(), "", "config", cfg) )
  //  `uvm_error( "basic_seq2", {"Configuration wasn't set for ", get_name(), ". Default config was used."} )
  repeat(cfg.npackets)
  begin
    tx = packet_t::type_id::create("tx");
    // set the driver port where these packets will be injected
    tx.dport = cfg.port;
    // disable packets with zero payload
    //tx.w_zero = 0;
    start_item(tx);
    if( ! tx.randomize() with {
        tx.p_size == cfg.p_size;
        tx.header == cfg.header;
        //tx.cycle2send == cfg.cycle2send;
        //tx.cycle2send == cycle2send;
        //tx.cycle2flit == cfg.cycle2flit;
      }
    )
      `uvm_error("rand", "invalid seq item randomization"); 
    `uvm_info("basic_seq2", cfg.convert2string(), UVM_HIGH)

    finish_item(tx);
  end
endtask: body

endclass: basic_seq2

