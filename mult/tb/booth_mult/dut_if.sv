/// usar template de tipo p parametrizar o tipo dos parametros
//class Register #(parameter type T = int);
//  T data;

interface dut_if #(parameter byte unsigned WIDTH = 32) (input bit clock);
	import dut_pkg::*;

    bit    reset, start;
    logic  [WIDTH-1:0] A,B;
    logic  [2*WIDTH-1:0] dout;
    bit    done;

/*
    import dut_if_pkg::*;
    class concrete_dut_if extends dut_if_base;
		//`uvm_object_utils(concrete_dut_if)

		function new(string name = "");
		  super.new(name);
		endfunction: new
*/
		task reset_dut();
		  reset = 1'b1;
		  @(negedge clock);
		  @(negedge clock);
		  reset = 1'b0;
		endtask : reset_dut


		task do_mult(input  logic  [WIDTH-1:0] iA, input  logic  [WIDTH-1:0] iB, output logic  [2*WIDTH-1:0] oRes);
			@(posedge clock);
			start = 1'b1;
			A = iA;
			B = iB;
			@(posedge clock);
			start = 1'b0;
			@(posedge done);
			@(negedge clock); oRes = dout;
		endtask : do_mult

		task get_mult(output  logic  [WIDTH-1:0] oA, output  logic  [WIDTH-1:0] oB, output logic  [2*WIDTH-1:0] oRes);
		    @(posedge start);
		    @(negedge clock);
		    oA = A;
		    oB = B;
		    @(posedge done);
		    @(negedge clock);
		    oRes = dout;
		endtask : get_mult	
/*		
		task do_nothing();
			@(negedge clock);
		endtask : do_nothing	

    endclass : concrete_dut_if

    concrete_dut_if concrete_inst;

    function dut_if_base get_concrete_bfm();
    	concrete_inst = new("if");
    	return concrete_inst;
    endfunction : get_concrete_bfm
*/
endinterface : dut_if
