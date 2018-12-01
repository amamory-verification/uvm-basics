class mult_coverage extends uvm_subscriber #(mult_input_t #(width));
`uvm_component_utils(mult_coverage);

logic  [width-1:0] A,B;
logic [2*width-1:0] result;

  covergroup range_value;
    a_leg: coverpoint A { 
        bins neg    = {[$:-2]}; // negative values
        bins minus1 = {-1};     // zero
        bins zero   = {0};      // zero
        bins plus1  = {1};      // zero
        bins pos    = {[2:$]};  // positive values
    }
    b_leg: coverpoint B { 
        bins neg    = {[$:-2]}; // negative values
        bins minus1 = {-1};     // zero
        bins zero   = {0};      // zero
        bins plus1  = {1};      // zero
        bins pos    = {[2:$]};  // positive values
    }

    a_b:  cross a_leg, b_leg;
  endgroup: range_value

 
function void write(mult_input_t #(width) t);
  result = t.dout;
  A = t.A;
  B = t.B;
  `uvm_info("msg", "Transaction Received", UVM_HIGH)
  range_value.sample();
  //zeros_or_ones_or_neg.sample();
endfunction: write 

function new(string name, uvm_component parent);
  super.new(name,parent);
  range_value = new();
  //zeros_or_ones_or_neg = new();
endfunction: new


endclass: mult_coverage