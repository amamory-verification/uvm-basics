class mult_scoreboard extends uvm_subscriber #(mult_input_t);
`uvm_component_utils(mult_scoreboard);

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void write(mult_input_t t);
  logic  [2*dut_pkg::DATA_WIDTH-1:0] expected_output; 
  string data_str, expected_output_str;
  expected_output = t.A * t.B;

  // generates the correct output format (signed or unsigned) for the expected ouput value
  if (dut_pkg::SIGNED_MULT == 1'b1)
  		expected_output_str = $psprintf("%0d", $signed(expected_output));
  else 
  		expected_output_str = $psprintf("%0d", expected_output);
  data_str = $psprintf("%0d x %0d = %0d (actual); %s (expected)",t.A, t.B, t.dout, expected_output_str);

  if (expected_output != t.dout)
    `uvm_error("SELF CHECKER", {"FAIL: ",data_str})
  else
    `uvm_info ("SELF CHECKER", {"PASS: ", data_str}, UVM_HIGH)
endfunction: write

endclass: mult_scoreboard