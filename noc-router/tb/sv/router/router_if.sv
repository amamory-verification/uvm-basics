interface dut_if (input bit clock);
	import dut_pkg::*;

	bit reset;

/*
Each of the five interfaces has the following ports:
--                             PORT
--                         _____________
--                   RX ->|             |-> TX
--              DATA_IN ->|             |-> DATA_OUT
--             CLOCK_RX ->|             |-> CLOCK_TX
--             CREDIT_O <-|             |<- CREDIT_I
--                        |             |
                           _____________
*/

	// input interface
    bit [dut_pkg::NPORT-1:0]   clock_rx,rx, credit_o;
    logic [dut_pkg::NPORT-1:0][dut_pkg::FLIT_WIDTH-1:0]   data_in;
    //output interface
    bit [dut_pkg::NPORT-1:0]   clock_tx,tx, credit_i;
    logic [dut_pkg::NPORT-1:0][dut_pkg::FLIT_WIDTH-1:0]   data_out;

    task reset_dut();
	  reset = 1'b1;
	  @(negedge clock);
	  @(negedge clock);
	  reset = 1'b0;    	
    endtask : reset_dut;

	assign clock_rx = {clock,clock,clock,clock,clock}; 	

	// send entire packet 
    task send_packet(input packet_t   p, input unsigned port);
    	int i=0;
    	@(posedge clock_rx[port]);
    	while(i<p.size()){
    		if (credit_o[port] == 1'b1){ // dont send if buffer is full
    			rx[port] = 1'b1;
    			data_in[port] = p[i];
    			i++;
    		}
    		@(posedge clock_rx[port]);
    	}
    	rx[port] = 1'b0;
    	data_in[port] = 0;
    	@(posedge clock_rx[port]);
    endtask : send_packet

    task get_packet(output packet_t   p, input unsigned port);
    	unsigned size=0,i=1;
    	@(posedge clock_tx[port]);
    	credit_i[port] = 1'b1;
		// get the packet size from the 1st flit
    	while (true){
    		if (tx[port] == 1'b1){
				size = data_out[];
				p[0] = data_out;
				break;
			}
    		@(posedge clock_tx[port]);
    	}
    	
    	while(i<size){
    		if (tx[port] == 1'b1){
    			p[i] = data_out;
    			i ++;
    		}
    		@(posedge clock_tx[port]);
    	}
    	credit_i[port] = 1'b0;
    endtask : get_packet