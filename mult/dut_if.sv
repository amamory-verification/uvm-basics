/// usar template de tipo p parametrizar o tipo dos parametros
//class Register #(parameter type T = int);
//  T data;

interface dut_if #(parameter WIDTH = 16) (input bit clock);
	import dut_pkg::*;

    bit    reset, start;
    logic  [WIDTH-1:0] A,B;
    logic  [2*WIDTH-1:0] dout;
    bit    done;


    //import dut_if_pkg::*;
    class concrete_dut_if extends dut_if_base;
		task reset_dut();
		  reset = 1'b1;
		  @(negedge clock);
		  @(negedge clock);
		  reset = 1'b0;
		endtask : reset_dut
		   /*
		initial begin
		  clock = 0;
		  fork
		     forever begin
		        #10;
		        clock = ~clock;
		     end
		  join_none
		end
		*/

		task do_mult(input int iA, input int iB, output int result);
			@(posedge clock);
			start = 1'b1;
			A = iA;
			B = iB;
			@(posedge clock);
			start = 1'b0;
			@(posedge done);
			@(negedge clock); result = dout;
		endtask : do_mult
    endclass : concrete_dut_if

    concrete_dut_if concrete_inst;

    function dut_if_base get_concrete_bfm();
    	concrete_inst = new;
    	return concrete_inst;
    endfunction : get_concrete_bfm

endinterface : dut_if
