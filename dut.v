module dut(
	input clk,
	input rst, 
	input cmd,
	input [7:0] data, addr,
	output reg [7:0] dout
	);

  always @(posedge clk)
    if (!rst) begin
      dout <= 0;
    end else begin
    	if (cmd == 0) 
      		dout <= data + 1;
      	else
      		dout <= data - 1;
    end
	//$display("data is %0d",_if.data);
	//$display("addr is %0d",_if.addr);
	//$display("cmd is %0b",_if.cmd);
	//#7;
	
endmodule