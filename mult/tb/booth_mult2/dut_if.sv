interface dut_if (input bit clock);
	import dut_pkg::*;

    bit    reset, start;
    logic  [dut_pkg::DATA_WIDTH-1:0] A,B;
    logic  [2*dut_pkg::DATA_WIDTH-1:0] dout;
    bit    done;

	task reset_dut();
	  reset = 1'b1;
	  @(negedge clock);
	  @(negedge clock);
	  reset = 1'b0;
	endtask : reset_dut


	task do_mult(input logic   [dut_pkg::DATA_WIDTH-1:0] iA, input logic   [dut_pkg::DATA_WIDTH-1:0] iB, output logic    [2*dut_pkg::DATA_WIDTH-1:0] oRes);
		@(posedge clock);
		start = 1'b1;
		A =  iA;
		B =  iB;
		@(posedge clock);
		start = 1'b0;
		@(posedge done);
		@(negedge clock); oRes = dout;
	endtask : do_mult

	task get_mult(output logic   [dut_pkg::DATA_WIDTH-1:0] oA, output logic   [dut_pkg::DATA_WIDTH-1:0] oB, output logic   [2*dut_pkg::DATA_WIDTH-1:0] oRes);
	    @(posedge start);
	    @(negedge clock);
	    oA = A;
	    oB = B;
	    @(posedge done);
	    @(negedge clock);
	    oRes = dout;
	endtask : get_mult	

endinterface : dut_if
