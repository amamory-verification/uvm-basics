module dut(
	input clk,
	input rst, 
	input cmd,
	input [7:0] data, addr,
	output [7:0] dout
	);
  reg [7:0] count;

  always @(posedge clk or negedge rst)
    if (!rst) begin
 		count <= 0;
    end else begin
		if (cmd == 1'b0) begin 
			count <= data;
		end else begin
			count <= count + 1;
		end
		$display("DUT count is %0d, %0d, %0d",count, data, cmd);
    end

  assign dout = count;
	
endmodule
