interface router_if (input bit clock);
	import router_pkg::*;

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
    bit [router_pkg::NPORT-1:0]        clock_rx, rx,  credit_o;
    bit [router_pkg::FLIT_WIDTH-1:0]   data_in [router_pkg::NPORT];
    //output interface
    bit [router_pkg::NPORT-1:0]        clock_tx,tx, credit_i;
    bit [router_pkg::FLIT_WIDTH-1:0]   data_out [router_pkg::NPORT];

    task reset_dut();
	  reset = 1'b1;
	  @(negedge clock);
	  @(negedge clock);
	  reset = 1'b0;    	
    endtask : reset_dut;

	assign clock_rx = {clock,clock,clock,clock,clock}; 	
	//assign clock_rx = 5'b00000; 	

	// send entire packet 
    task send_packet(input packet_t   p, input unsigned port);
    	int i;
    	i=0;
    	@(posedge clock_rx[port]);
		// send the header
    	while (1'b1)
    	begin
    		if (credit_o[port] == 1'b1) begin
    			rx[port] = 1'b1;
    			data_in[port] = p.get_header();
				@(posedge clock_rx[port]);
				break;
			end
			rx[port] = 1'b0;
    		@(posedge clock_rx[port]);
    	end
		// send the packet size from the 1st flit
    	while (1'b1)
    	begin
    		if (credit_o[port] == 1'b1) begin
    			rx[port] = 1'b1;
    			data_in[port] = p.payload.size();
				@(posedge clock_rx[port]);
				break;
			end
			rx[port] = 1'b0;
    		@(posedge clock_rx[port]);
    	end		    	
    	while (i<p.payload.size())  // size() accounts only for the payload size
    	begin
    		if (credit_o[port] == 1'b1) begin // dont send if buffer is full
    			rx[port] = 1'b1;
    			data_in[port] = p.payload[i];
    			i++;
    		end else begin
    			rx[port] = 1'b0;
    			data_in[port] = 0;
    		end
    		@(posedge clock_rx[port]);
    	end
    	rx[port] = 1'b0;
    	data_in[port] = 0;
    	@(posedge clock_rx[port]);
    endtask : send_packet

    task get_packet(output packet_t   p, input unsigned port);
    	int i,size;
    	i=0;
        // wait for the header
    	$display("get_packet STARTED !!!");
        while(tx[port] !== 0'b1) begin
            $display("clock %0d !!!", port );
             i++;
            @(negedge clock_tx[port]);
        end;                
        p.set_header(data_out[port]);
        $display("MONITOR got header!!!");
        
    	//credit_i[port] = 1'b1;
		// get the header
    	/*
        while (1'b1)
    	begin
    		if (tx[port] == 1'b1) begin
				p.set_header(data_out[port]);
                $display("MONITOR got size!!!");
				@(posedge clock_tx[port]);
				break;
			end
    		@(posedge clock_tx[port]);
    	end
        */
		// get the packet size from the 1st flit
    	while (1'b1)
    	begin
    		if (tx[port] == 1'b1) begin
				size = data_out[port];
                $display("MONITOR got size!!!");
				@(posedge clock_tx[port]);
				break;
			end
    		@(posedge clock_tx[port]);
    	end
    	p.payload = new[size];
    	$display("MONITOR getting payload!!!");
        while(i<p.payload.size()) // size() accounts only for the payload size
    	begin
    		if (tx[port] == 1'b1) begin
    			p.payload[i] = data_out[port];
    			i ++;
    		end
    		@(posedge clock_tx[port]);
    	end
        $display("MONITOR got payload!!!");
    	//credit_i[port] = 1'b0;
    endtask : get_packet

endinterface : router_if
