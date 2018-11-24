class mult_zero_seq extends uvm_sequence #(mult_input_t);
`uvm_object_utils(mult_zero_seq)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  forever
  begin
    mult_input_t tx;
    tx = mult_input_t::type_id::create("tx");
    start_item(tx);
    tx.A.rand_mode(0); // disable randomization of attribute A
    assert(tx.randomize() with {tx.A == 0;});
    finish_item(tx);
  end
endtask: body

endclass: mult_zero_seq

