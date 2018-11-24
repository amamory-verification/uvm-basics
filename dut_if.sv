interface dut_if;

    logic clk, rst;
    logic cmd;
    logic  [7:0] addr;
    logic  [7:0] data;
    //logic  [7:0] dout;


	task reset_dut();
	  rst = 1'b0;
	  @(negedge clk);
	  @(negedge clk);
	  rst = 1'b1;
	endtask : reset_dut
	   
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
