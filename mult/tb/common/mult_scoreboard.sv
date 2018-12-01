class mult_scoreboard extends uvm_subscriber #(mult_input_t #(width));
`uvm_component_utils(mult_scoreboard);

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void write(mult_input_t #(width) t);
  logic [2*width-1:0] expected_output; 
  string data_str;
  expected_output = t.A * t.B;

  data_str = $psprintf("%0d x %0d = %0d (actual); %0d (expected)",t.A, t.B, t.dout, expected_output);

  if (expected_output != t.dout)
    `uvm_error("SELF CHECKER", {"FAIL: ",data_str})
  else
    `uvm_info ("SELF CHECKER", {"PASS: ", data_str}, UVM_HIGH)
endfunction: write

endclass: mult_scoreboard