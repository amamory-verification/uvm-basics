class basic_seq extends uvm_sequence #(packet_t);
`uvm_object_utils(basic_seq)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  packet_t tx;
  repeat(5)
  begin
    tx = packet_t::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize());
    finish_item(tx);
  end
endtask: body

endclass: basic_seq

