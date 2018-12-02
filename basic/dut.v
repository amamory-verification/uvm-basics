module dut (clk, rst, cmd, data, dout );
	parameter N=8;
	input clk;
	input rst; 
	input cmd;
	input [N-1:0] data;
	output [N-1:0] dout;

  reg [N-1:0] count;

  always @(posedge clk or negedge rst)
    if (!rst) begin
 		count <= 0;
    end else begin
		if (cmd == 1'b0) begin 
			count <= data;
		end else begin
			count <= count + 1;
		end
		//$display("DUT count is %0d, %0d, %0d",count, data, cmd);
    end

  assign dout = count;
	
endmodule
