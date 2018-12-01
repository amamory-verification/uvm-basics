class mult_zero_seq extends uvm_sequence #(mult_input_t);
`uvm_object_utils(mult_zero_seq)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  mult_input_t tx;
  // a == 0
  repeat(10) begin
    tx = mult_input_t::type_id::create("tx");
    start_item(tx);
    //tx.A.rand_mode(0); // disable randomization of attribute A
    assert(tx.randomize() with {tx.A == 0;});
    finish_item(tx);
  end
  // b == 0
  repeat(10) begin
    tx = mult_input_t::type_id::create("tx");
    start_item(tx);
    //tx.B.rand_mode(0); // disable randomization of attribute B
    assert(tx.randomize() with {tx.B == 0;});
    finish_item(tx);
  end
  // a == 0, b== 1
  tx = mult_input_t::type_id::create("tx");
  start_item(tx);
  //tx.A.rand_mode(0); // disable randomization of attribute A
  assert(tx.randomize() with {tx.A == 0; tx.B == 1;});
  finish_item(tx);
  // a == 1, b== 0
  tx = mult_input_t::type_id::create("tx");
  start_item(tx);
  //tx.A.rand_mode(0); // disable randomization of attribute A
  assert(tx.randomize() with {tx.A == 1; tx.B == 0;});
  finish_item(tx);  
  //  a == b == 0
  tx = mult_input_t::type_id::create("tx");
  start_item(tx);
  //tx.rand_mode(0); // disable randomization of attribute A and B
  assert(tx.randomize() with {tx.A == 0; tx.B == 0;});
  finish_item(tx);
endtask: body

endclass: mult_zero_seq

