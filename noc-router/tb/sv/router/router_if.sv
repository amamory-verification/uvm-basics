interface router_if (input bit clock, input bit reset);
	import router_pkg::*;

//	bit reset;

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
/*
	// input interface
    bit [router_pkg::NPORT-1:0]        clock_rx, rx,  credit_o;
    bit [router_pkg::FLIT_WIDTH-1:0]   data_in [router_pkg::NPORT-1:0];
    //output interface
    bit [router_pkg::NPORT-1:0]        clock_tx,tx, credit_i;
    bit [router_pkg::FLIT_WIDTH-1:0]   data_out [router_pkg::NPORT-1:0];
*/

    logic        clk, avail,  credit;
    logic [15:0]  data;

    modport datain (
            input clk, avail, data,
            output credit
        );
    modport dataout (
            output clk, avail, data,
            input credit
        );     
/*
    task reset_dut();
	  reset = 1'b1;
	  @(negedge clock);
	  @(negedge clock);
	  reset = 1'b0;    	
    endtask : reset_dut;
*/

	//assign clock_rx = {clock,clock,clock,clock,clock}; 	
	//assign clock_rx = 5'b00000; 	
/*
	// send entire packet 
    task send_packet(input packet_t   p);
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

    // TODO task not working. logic transfered to the monitor
    task get_packet(output packet_t   p, input unsigned port);
        int i,size;
        i=0;
        // wait for the header
        @(posedge tx[port]);
        @(negedge clock);
        p.set_header(data_out[port]);
        $display("MONITOR %0d got header %H",port,data_out[port]);

        //credit_i[port] = 1'b1;

        // get the packet size from the 1st flits
        while (1'b1)
        begin
        @(negedge clock);
        if (tx[port] == 1'b1) begin
          size = data_out[port];
          $display("MONITOR %0d got size %0d",port,size);
          break;
        end
        //@(negedge clock);
        end
        p.payload = new[size];
        i=0;
        // get the payload
        while(i<p.payload.size()) // size() accounts only for the payload size
        begin
        @(negedge clock);
        if (tx[port] == 1'b1) begin
          p.payload[i] = data_out[port];
          $display("MONITOR %0d got flit %0d %H",port,i,p.payload[i]);
          i ++;
        end
        end
        $display("MONITOR got payload!!!");
    	//credit_i[port] = 1'b0;
    endtask : get_packet
*/
endinterface : router_if
