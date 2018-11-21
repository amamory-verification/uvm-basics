module dut (dut_if _if);

always @(posedge _if.clock) 
begin : 
	if(~_if.reset) begin
		_if.dout <= 0;
	end else begin
		_if.dout <= 1;
	end
end

endmodule