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
  repeat(this.npackets)
  begin
    tx = packet_t::type_id::create("tx");
    // set the driver port where these packets will be injected
    tx.dport = this.port;
    // disable packets with zero payload
    tx.w_zero = 0;
    start_item(tx);
    // this.header is the default value, then it means that it must be randomized, else, it must use the assinged value
    if (this.header == 8'hFF) 
      assert(tx.randomize() with {tx.p_size == psize;});
    else begin
      //tx.header.mode(0);
      assert(tx.randomize() with {tx.p_size == psize; tx.header == header;});
    end
    
    //assert(tx.randomize());
    //assert(tx.randomize() with {tx.payload.size() == 1;});
    finish_item(tx);
  end
endtask: body

endclass: basic_seq

