class mult_one_seq extends uvm_sequence #(mult_input_t);
`uvm_object_utils(mult_one_seq)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  mult_input_t tx;
  // a == 1
  repeat(10) begin
    tx = mult_input_t::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A == 1;});
    finish_item(tx);
  end
  // b == 1
  repeat(10) begin
    tx = mult_input_t::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.B == 1;});
    finish_item(tx);
  end
  //  a == b == 1
  repeat(1) begin
    tx = mult_input_t::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A == 1; tx.B == 1;});
    finish_item(tx);
  end
endtask: body

endclass: mult_one_seq

