class router_driver extends uvm_driver #(packet_t);
`uvm_component_utils(router_driver);

//uvm_analysis_port #(packet_t) aport; 
virtual router_if dut_vi;
bit [3:0] port;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
	if (!uvm_config_db #(virtual router_if)::get (null,"*", "dut_vi", dut_vi) )
		`uvm_fatal("driver", "No DUT_IF");
	if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
		`uvm_fatal("driver", "No port");
	`uvm_info("msg", "DRIVER Done!!!", UVM_NONE)
endfunction : build_phase

task run_phase(uvm_phase phase);
	packet_t tx;
	int i;
	//dut_vi.reset_dut();
	@(negedge dut_vi.reset);
	@(posedge dut_vi.clock);
	@(posedge dut_vi.clock);
	forever
	begin
		seq_item_port.get_next_item(tx);
		//dut_vi.send_packet(tx,port);

		i=0;
		@(posedge dut_vi.clock);
		// send the header
		while (1'b1)
		begin
			if (dut_vi.credit_o[port] == 1'b1) begin
				dut_vi.rx[port] = 1'b1;
				dut_vi.data_in[port] = tx.get_header();
				@(posedge dut_vi.clock);
				break;
			end
			dut_vi.rx[port] = 1'b0;
			@(posedge dut_vi.clock);
		end
		// send the packet size from the 1st flit
		while (1'b1)
		begin
			if (dut_vi.credit_o[port] == 1'b1) begin
				dut_vi.rx[port] = 1'b1;
				dut_vi.data_in[port] = tx.payload.size();
				@(posedge dut_vi.clock);
				break;
			end
			dut_vi.rx[port] = 1'b0;
			@(posedge dut_vi.clock);
		end
		i=0;	
		while (i<tx.payload.size())  // size() accounts only for the payload size
		begin
			if (dut_vi.credit_o[port] == 1'b1) begin // dont send if buffer is full
				dut_vi.rx[port] = 1'b1;
				dut_vi.data_in[port] = tx.payload[i];
				i++;
			end else begin
				dut_vi.rx[port] = 1'b0;
				dut_vi.data_in[port] = 0;
			end
			@(posedge dut_vi.clock);
		end
		dut_vi.rx[port] = 1'b0;
		dut_vi.data_in[port] = 0;
		@(posedge dut_vi.clock);

		seq_item_port.item_done();
	end
  	repeat (500) @(posedge dut_vi.clock);
endtask: run_phase

endclass: router_driver
