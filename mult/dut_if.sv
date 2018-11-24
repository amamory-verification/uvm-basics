interface dut_if;

    bit    clock, reset, start;
    logic  [15:0] A,B;
    logic  [31:0] dout;
    bit    done;


	task reset_dut();
	  reset = 1'b1;
	  @(negedge clock);
	  @(negedge clock);
	  reset = 1'b0;
	endtask : reset_dut
	   
	initial begin
	  clock = 0;
	  fork
	     forever begin
	        #10;
	        clock = ~clock;
	     end
	  join_none
	end

	task do_mult(input shortint iA, input shortint iB, output int result);
		@(posedge clock);
		start = 1'b1;
		A = iA;
		B = iB;
		@(posedge clock);
		start = 1'b0;
		A = 0;
		B = 0;
		@(posedge done) result = dout;
	endtask : do_mult

endinterface : dut_if
