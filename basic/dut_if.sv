interface dut_if;

    logic clk, rst;
    logic cmd;
    logic unsigned [31:0] data;
    logic unsigned [31:0] dout;


	task reset_dut();
	  rst = 1'b0;
	  @(negedge clk);
	  @(negedge clk);
	  rst = 1'b1;
	endtask : reset_dut

	task do_dut(input bit iCmd, input logic  [31:0] iData, output logic  [31:0] oDout);
		@(posedge clk);
		cmd = iCmd;
		data = iData;
		@(posedge clk);
		oDout = dout;
	endtask : do_dut

	initial begin
	  clk = 0;
	  fork
	     forever begin
	        #10;
	        clk = ~clk;
	     end
	  join_none
	end

endinterface : dut_if
