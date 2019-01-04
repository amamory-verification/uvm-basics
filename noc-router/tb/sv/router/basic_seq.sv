/*
 this sequence inject packets in a single port 
*/
class basic_seq extends base_vseq; 
`uvm_object_utils(basic_seq)

function new(string name = "basic_seq");
  super.new(name);
endfunction: new

task body;
  packet_t tx;
  repeat(npackets)
  begin
    tx = packet_t::type_id::create("tx");
    // set the driver port where these packets will be injected
    tx.dport = port;
    // disable packets with zero payload
    tx.w_zero = 0;
    start_item(tx);
    // create only small packets
    assert(tx.randomize() with {tx.p_size == SMALL;});
    //assert(tx.randomize());
    //assert(tx.randomize() with {tx.payload.size() == 1;});
    finish_item(tx);
  end
endtask: body

endclass: basic_seq

