//a testbench for mudi64.v
`timescale 1ns/10ps

module mudi64_tb ();

parameter full = 63;
parameter half = 31;
reg [half:0] opera1;
reg [full:0] opera2;
reg muordi, clock, reset, start;
wire [full:0] result;
wire valid;

mudi64 U1 (result, opera1, opera2, muordi, clock, reset, start, valid);

initial begin
	$dumpfile("mudi64.vcd");
	$dumpvars(0, mudi64_tb);
end

initial muordi = 0;	//0 for multiplication; 1 for divition

initial begin
	clock = 0;
	forever
	#10 clock = ~clock;
end

initial begin
	reset = 0;
	#1 reset = ~reset;
	#1 reset = ~reset;
end

initial begin
	start = 1;
	#100	start = 0;
		opera1 = 32'h15555555;
		opera2 = 32'h55555555;		//Q=4, R=1
	#100 start = ~start;
	#1000	start = ~start;
		opera1 = -32'h15555555;
		opera2 = 32'h55555555;		//Q=fc, R=1
	#100 start = ~start;
	#1000	start = ~start;
		opera1 = 32'h15555555;
		opera2 = -32'h55555555;		//Q=fc, R=ff
	#100 start = ~start;
	#1000	start = ~start;
		opera1 = -32'h15555555;
		opera2 = -32'h55555555;		//Q=4, R=ff
	#100 start = ~start;
	#1000	start = ~start;
		opera1 = 0;
		opera2 = 0;
end

initial begin
	#20000;
	$finish;
end

endmodule
