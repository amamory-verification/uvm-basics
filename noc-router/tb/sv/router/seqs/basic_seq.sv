/*
 this flat sequence injects 'npackets' into a single port 'port'   
*/
class basic_seq extends base_vseq; 
`uvm_object_utils(basic_seq)


function new(string name = "basic_seq");
  super.new(name);
endfunction: new


task body;
  packet_t tx;
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
        tx.cycle2send == cfg.cycle2send;
        tx.cycle2flit == cfg.cycle2flit;
      }
    )
      `uvm_error("rand", "invalid seq item randomization"); 
    `uvm_info("basic_seq", cfg.convert2string(), UVM_HIGH)

    finish_item(tx);
  end
endtask: body

endclass: basic_seq

