module dut(
	input clk,
	input rst, 
	input cmd,
	input [7:0] data, addr,
	output [7:0] dout
	);
  reg [7:0] sig;

  always @(posedge clk)
    if (!rst) begin
     sig <= 0;
    end else begin
    	if (cmd == 0) 
      		sig <= data + 1;
      	else
      		sig <= data - 1;
    end

  assign dout = sig;
	//$display("data is %0d",_if.data);
	//$display("addr is %0d",_if.addr);
	//$display("cmd is %0b",_if.cmd);
	//#7;
	
endmodule
