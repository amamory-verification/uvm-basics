class mult_basic_seq extends uvm_sequence #(mult_input_t);
`uvm_object_utils(mult_basic_seq)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  forever
  begin
    mult_input_t tx;
    tx = mult_input_t::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize());
    finish_item(tx);
  end
endtask: body

endclass: mult_basic_seq

