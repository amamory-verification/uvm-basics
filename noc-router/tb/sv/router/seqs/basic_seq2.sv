/*
 this flat sequence injects 'npackets' into a single port 'port'.
 the difference compared to basic_seq.sv is the use of config_db   
*/
class basic_seq2 extends base_vseq; 
`uvm_object_utils(basic_seq2)


rand bit [3:0] cycle2send;

function new(string name = "basic_seq");
  super.new(name);
endfunction: new


task body;
  packet_t tx;
  //$display("%s",get_full_name());

  // one example of another way to get individual config values
  uvm_config_db#(bit [3:0]):: get(null, get_full_name(), "cycle2send", cycle2send);
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
        tx.cycle2send == cycle2send;
        tx.cycle2flit == cfg.cycle2flit;
      }
    )
      `uvm_error("rand", "invalid seq item randomization"); 
    `uvm_info("basic_seq", cfg.convert2string(), UVM_HIGH)

    finish_item(tx);
  end
endtask: body

endclass: basic_seq2

