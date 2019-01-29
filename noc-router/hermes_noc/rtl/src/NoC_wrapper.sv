import hermes_pkg::*;
 
module NoC_wrapper (clock, reset, din, dout );

input logic clock, reset; 
hermes_if.datain din[hermes_pkg::NROT];
hermes_if.dataout dout[hermes_pkg::NROT];

logic [hermes_pkg::NROT-1:0] clock_rx, rx, credit_o;
logic [hermes_pkg::FLIT_WIDTH-1:0] data_in[hermes_pkg::NROT-1:0];

logic [hermes_pkg::NROT-1:0] clock_tx, tx, credit_i;
logic [hermes_pkg::FLIT_WIDTH-1:0] data_out[hermes_pkg::NROT-1:0];

generate
	for (genvar i = 0; i < hermes_pkg::NROT; i++) begin
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

NOC CC ( .clock(clock_rx), .reset(reset),
	//Local ports
	.clock_rxLocal(clock_rx),
	.rxLocal(rx),
	.data_inLocal(data_in),
	.credit_oLocal(credit_o),

	.clock_txLocal(clock_tx),
	.txLocal(tx),
	.data_outLocal(data_out),
	.credit_iLocal(credit_i)
	);

endmodule // NoC_wrapper
