class mult_coverage extends uvm_subscriber #(mult_input_t);
`uvm_component_utils(mult_coverage);

shortint A,B;
int result;

  covergroup cover_bus;
    //coverpoint result;
    //coverpoint A { bins a[16] = {[0:255]};}
    //coverpoint B { bins d[16] = {[0:255]};}
  endgroup: cover_bus

   covergroup zeros_or_ones_or_neg;

      a_leg: coverpoint A {
         bins zeros = {'h0000};
         bins others= {['h0001:'h00FE]};
         bins ones  = {'hFFFF};
      }

      b_leg: coverpoint B {
         bins zeros = {'h0000};
         bins others= {['h0001:'h00FE]};
         bins ones  = {'hFFFF};
      }

      a_b:  cross a_leg, b_leg {
         bins a_00_b00 = (binsof (a_leg.zeros) && binsof (b_leg.zeros));

         bins a_00_b_FF = (binsof (a_leg.zeros) && binsof (b_leg.ones));

         bins b_00_a_FF = (binsof (a_leg.ones) && binsof (b_leg.zeros));

      }

    endgroup
 
function void write(mult_input_t t);
  result = t.dout;
  A = t.A;
  B = t.B;
  `uvm_info("msg", "Transaction Received", UVM_HIGH)
  cover_bus.sample();
endfunction: write 

function new(string name, uvm_component parent);
  super.new(name,parent);
  cover_bus = new();
  zeros_or_ones_or_neg = new();
endfunction: new


endclass: mult_coverage