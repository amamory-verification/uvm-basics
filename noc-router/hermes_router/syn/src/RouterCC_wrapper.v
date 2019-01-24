import hermes_pkg::*;

module RouterCC_wrapper (clock, reset, din, dout );

input logic clock, reset; 
hermes_if.datain din[5];
hermes_if.dataout dout[5];

logic [4:0] clock_rx, rx, credit_o;
logic [15:0] data_in[4:0];

logic [4:0] clock_tx, tx, credit_i;
logic [15:0] data_out[4:0];

generate
	for (genvar i = 0; i < 5; i++) begin
		// input port
		assign clock_rx[i]    = clock;
		assign rx[i]          = din[i].avail;
		assign din[i].credit  = credit_o[i];
		assign data_in[i]     = din[i].data;
		// output port
		assign dout[i].clk    = clock_tx[i];
		assign dout[i].avail  = tx[i];
		assign credit_i[i]    = dout[i].credit;
		assign dout[i].data   = data_out[i];
	end
endgenerate

RouterCC CC ( .clock(clock), .reset(reset),
	//EAST port
	.clock_rx(clock_rx),
	.rx(rx),
	//.data_in(data_in),
	.\data_in[0] (data_in[0]),
	.\data_in[1] (data_in[1]),
	.\data_in[2] (data_in[2]),
	.\data_in[3] (data_in[3]),
	.\data_in[4] (data_in[4]),
	.credit_o(credit_o),

	.clock_tx(clock_tx),
	.tx(tx),
	//.data_out(data_out),
	.\data_out[0] (data_out[0]),
	.\data_out[1] (data_out[1]),
	.\data_out[2] (data_out[2]),
	.\data_out[3] (data_out[3]),
	.\data_out[4] (data_out[4]),
	.credit_i(credit_i)
	);

endmodule // RouterCC_wrapper


