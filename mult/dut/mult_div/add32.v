//sub-module, a 32-bit adder including eight sequential 4-bit ripple-carry-adder

module add32 (sum, cout, a, b, cin);
output [31:0] sum;
output cout;
input [31:0] a, b;
input cin;
wire cin4, cin8, cin12, cin16, cin20, cin24, cin28;
add_4 U1 (sum[3:0], cin4, a[3:0], b[3:0], cin);
add_4 U2 (sum[7:4], cin8, a[7:4], b[7:4], cin4);
add_4 U3 (sum[11:8], cin12, a[11:8], b[11:8], cin8);
add_4 U4 (sum[15:12], cin16, a[15:12], b[15:12], cin12);
add_4 U5 (sum[19:16], cin20, a[19:16], b[19:16], cin16);
add_4 U6 (sum[23:20], cin24, a[23:20], b[23:20], cin20);
add_4 U7 (sum[27:24], cin28, a[27:24], b[27:24], cin24);
add_4 U8 (sum[31:28], cout, a[31:28], b[31:28], cin28);
endmodule

module add_half (sum, cout, a, b);
input a, b;
output cout, sum;
xor (sum, a, b);
and (cout, a, b);
endmodule

module add_full (sum, cout, a, b, cin);
input a, b, cin;
output cout, sum;
wire w1, w2, w3;
add_half U1 (w1, w2, a, b);
add_half U2 (sum, w3, cin, w1);
or (cout, w2, w3);
endmodule

module add_4 (sum, cout, a, b, cin);
output [3:0] sum;
output cout;
input [3:0] a, b;
input cin;
wire cin1, cin2, cin3;
add_full U1 (sum[0], cin1, a[0], b[0], cin);
add_full U2 (sum[1], cin2, a[1], b[1], cin1);
add_full U3 (sum[2], cin3, a[2], b[2], cin2);
add_full U4 (sum[3], cout, a[3], b[3], cin3);
endmodule

