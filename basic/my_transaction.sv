class my_transaction extends uvm_sequence_item;
`uvm_object_utils(my_transaction)

rand cmd_t cmd;
rand int   addr;
rand int   data;

constraint c_addr { addr >=0 ; addr < 256; }
constraint c_data { data >=0 ; data < 256; }

function new(string name = "");
  super.new(name);
endfunction: new

endclass: my_transaction

typedef uvm_sequencer #(my_transaction) my_sequencer;

