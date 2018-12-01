class mult_neg_seq extends uvm_sequence #(mult_input_t #(width));
`uvm_object_utils(mult_neg_seq)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  mult_input_t #(width) tx;
  // a == -1
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A == -1;});
    finish_item(tx);
  end
  // b == -1
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.B == -1;});
    finish_item(tx);
  end
  // a == neg, b== pos
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A inside {[$:-2]};});
    finish_item(tx);
  end
  // a == pos, b == neg
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.B inside {[$:-2]};});
    finish_item(tx);
  end  
  //  a == b == -1
  tx = mult_input_t #(width)::type_id::create("tx");
  start_item(tx);
  assert(tx.randomize() with {tx.A == -1; tx.B == -1;});
  finish_item(tx);
  //  a == -1, b == 1
  tx = mult_input_t #(width)::type_id::create("tx");
  start_item(tx);
  assert(tx.randomize() with {tx.A == -1; tx.B == 1;});
  finish_item(tx);  
  //  a == 1, b == -1
  tx = mult_input_t #(width)::type_id::create("tx");
  start_item(tx);
  assert(tx.randomize() with {tx.A == 1; tx.B == -1;});
  finish_item(tx);  
  //  a == 0, b == -1
  tx = mult_input_t #(width)::type_id::create("tx");
  start_item(tx);
  assert(tx.randomize() with {tx.A == 0; tx.B == -1;});
  finish_item(tx);
  //  a == -1, b == 0
  tx = mult_input_t #(width)::type_id::create("tx");
  start_item(tx);
  assert(tx.randomize() with {tx.A == -1; tx.B == 0;});
  finish_item(tx);

  // a == 0 , b == neg
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A == 0; tx.B inside {[$:-2]};});
    finish_item(tx);
  end
  // a == neg , b == 0
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A inside {[$:-2]}; tx.B == 0;});
    finish_item(tx);
  end

  // a == -1 , b == neg
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A == -1; tx.B inside {[$:-2]};});
    finish_item(tx);
  end
  // a == neg , b == -1
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A inside {[$:-2]}; tx.B == -1;});
    finish_item(tx);
  end
  //  a == b == neg
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.B inside {[$:-2]}; tx.A inside {[$:-2]};});
    finish_item(tx);
  end  

  // a == 1 , b == neg
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A == 1; tx.B inside {[$:-2]};});
    finish_item(tx);
  end
  // a == neg , b == 1
  repeat(10) begin
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize() with {tx.A inside {[$:-2]}; tx.B == 1;});
    finish_item(tx);
  end   
endtask: body

endclass: mult_neg_seq

