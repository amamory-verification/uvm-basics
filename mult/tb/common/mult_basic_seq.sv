class mult_basic_seq extends uvm_sequence #(mult_input_t);
`uvm_object_utils(mult_basic_seq)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  repeat(5)
  begin
    mult_input_t tx;
    tx = mult_input_t::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize());
    finish_item(tx);
  end
  //#200 // wait a little bit to check the last stimuli in the scoreboard
endtask: body

endclass: mult_basic_seq

