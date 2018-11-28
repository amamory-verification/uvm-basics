//top module, a 64-bit signed multiplier and divider

`timescale 1ns/10ps

module mudi64 (result, opera1, opera2, muordi, clock, reset, start, valid);
parameter full = 63;		//full length of data bits 64-1
parameter half = 31;		//half length of data bits 32-1
output [full:0] result;
output valid;
input [half:0] opera1;
input [full:0] opera2;
input muordi, clock, reset, start;
reg [half:0] A, times;
reg [full:0] result, B;
reg valid, OPE, signA, signB, cin;
reg [1:0] wait_state;
wire [half:0] D, E, F, new_remainder, new_times, AA, G;
wire [full:0] BB;
wire cout, cout1, cout2;

add32 mu_main (.sum(D), .cout(cout1), .a(A), .b(B[full:half+1]), .cin(cin));
add32 di_main_add (.sum(E), .cout(cout), .a(A), .b(B[full:half+1]), .cin(1'b0));
add32 di_main_sub (.sum(F), .cout(cout), .a(~A), .b(B[full:half+1]), .cin(1'b1));
add32 counter (.sum(new_times), .cout(cout), .a(times), .b(32'b1), .cin(1'b0));
add32 neg_A (.sum(AA), .cout(cout), .a(~A), .b(32'b0), .cin(1'b1));
add32 neg_B1 (.sum(BB[half:0]), .cout(cout2), .a(~B[half:0]), .b(32'b0), .cin(1'b1));
add32 neg_B2 (.sum(BB[full:half+1]), .cout(cout), .a(~B[full:half+1]), .b(32'b0), .cin(cout2));
add32 neg_di (.sum(G), .cout(cout), .a(~E), .b(32'b0), .cin(1'b1));

assign new_remainder = OPE ? F : E;

always @(posedge clock or posedge reset) begin
//	$monitor("times=%d, A=%b, B=%b,%h, result=%b",times,A,B,B,result);
	if (reset) begin
		result = 0;
		valid =0;
		cin = 0;
		times = 0;
		OPE = 0;
		A = 0;
		B = 0;
		signA = 0;
		signB = 0;
		wait_state = 0;
	end
	else if (start==0 & wait_state==0) begin	//bounce down the button
		result = 0;
		valid = 0;
		cin = 0;
		times = 0;
		OPE = muordi;		//change all muordi to 0 or 1 can go through all process only multiplier or divider
		A = opera1;
		B = opera2;
		signA = A[half];
		signB = muordi ? B[full] : B[half];
		wait_state = 1;
	end
	else if (start==0 & wait_state==1) begin
		wait_state = 2;
		A = signA ? AA : A;
		B = signB ? BB : B;
	end
	else if (start==0 & wait_state==2) times = 0;
	else if (start) begin		//bounce up the button
		if (~muordi) begin	//mutiplier
			OPE = B[0];
			if (times<half+1) begin
				B = B >> 1;
				B[full-1:half] = OPE ? D : B[full-1:half];
				B[full] = OPE ? cout1 : B[full];
				times = new_times;
			end
			else if (times==half+1) begin
				result = (signA^signB) ? BB : B;
				valid = 1;
				times = new_times;
//				wait (~start);
			end
			else	wait_state = 0;
		end
		else begin		//divider
			B[full:half+1] = new_remainder;
			OPE = ~B[full];
			if (times<half+1) begin
				B = B << 1 | OPE;
				times = new_times;
			end
			else if (times==half+1) begin
				B[half:0] = (B[half:0] << 1) | OPE;		//ex. 27 / 13 = 2 ... -12 <- wrong when answer is even
				times = new_times;				//add one more state to wait until BB is ready
			end
			else if (times==half+2) begin
				if (signA == 0 & signB == 0)			//ex. 27 / 13 = 2 ... 1
					B[full:half+1] = B[0] ? B[full:half+1] : E;
				else if (signA == 1 & signB == 0) begin		//ex. 27 / -13 = -2 ... 1
					B[half:0] = BB[half:0];
					B[full:half+1] = B[0] ? B[full:half+1] : E;
				end
				else if (signA == 0 & signB == 1) begin		//ex. -27 / 13 = -2 ... -1
					B[half:0] = BB[half:0];
					B[full:half+1] = B[0] ? BB[full:half+1] : G;
				end
				else						//ex. -27 / -13 = 2 ... -1
					B[full:half+1] = B[0] ? BB[full:half+1] : G;
				result = B;
				valid = 1;
				times = new_times;
//				wait (~start);
			end
			else	wait_state = 0;
		end
	end
	else times = times;
end
endmodule

