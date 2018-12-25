class basic_seq extends uvm_sequence #(packet_t); 
`uvm_object_utils(basic_seq)

bit [3:0] port;

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  packet_t tx;
  repeat(50)
  begin
    tx = packet_t::type_id::create("tx");
    tx.dport = port;
    tx.w_zero = 0;
    start_item(tx);
    assert(tx.randomize() with {tx.p_size == SMALL;});
    //assert(tx.randomize());
    //assert(tx.randomize() with {tx.payload.size() == 1;});
    finish_item(tx);
  end
endtask: body

endclass: basic_seq

