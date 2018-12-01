class mult_basic_seq extends uvm_sequence #(mult_input_t);
`uvm_object_utils(mult_basic_seq)

//int width;

function new(string name = "");
  super.new(name);
endfunction: new

function void build_phase(uvm_phase phase);
  //if (!uvm_config_db #(int)::get (null,"*", "width", width) )
  //  `uvm_fatal("mult_basic_seq", "No WIDTH");  
endfunction: build_phase

task body;
  repeat(5)
  begin
    mult_input_t #(width) tx;
    tx = mult_input_t #(width)::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize());
    finish_item(tx);
  end
  //#200 // wait a little bit to check the last stimuli in the scoreboard
endtask: body

endclass: mult_basic_seq

