class my_transaction extends uvm_sequence_item;
`uvm_object_utils(my_transaction)

rand cmd_t cmd;
rand logic unsigned [dut_pkg::DATA_WIDTH-1:0]   data;
logic unsigned [dut_pkg::DATA_WIDTH-1:0] dout;

constraint c_data { data >=0 ; data < dut_pkg::MAX_RAND_VAL; }

function new(string name = "");
  //my_param_container params;
  //string data_str;
  super.new(name);
  //if (!uvm_config_db #(my_param_container)::get(this, "","my_param",params) )
  //  `uvm_fatal("my_transaction", "No config");  
  //data_str = $psprintf("data width: %0d, max_val: %0d",params.data_width, params.max_val);
  //`uvm_info (" ==== TRANS ===== ", {"PASS: ", data_str}, UVM_HIGH) 
endfunction: new

endclass: my_transaction

typedef uvm_sequencer #(my_transaction) my_sequencer;

