class router_driver extends uvm_driver #(packet_t);
`uvm_component_utils(router_driver);

uvm_analysis_port #(packet_t) aport; // used to send the incomming packet to the sb 

virtual router_if dut_vi;
bit [3:0] port;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
	aport = new("aport", this); 

  	// print config_db
	//print_config();

	if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
		`uvm_fatal("driver", "No port");

	//if(!uvm_config_db#(virtual router_if)::read_by_name($sformatf("driver%0d",port), "in_if", dut_vi))
    if(!uvm_config_db#(virtual router_if)::get (this,"", "if", dut_vi))
	    `uvm_fatal("driver", "No in_if"); 	

	`uvm_info("msg", "DRIVER Done!!!", UVM_HIGH)
endfunction : build_phase

task wait_cycles(int cycles);
	dut_vi.avail = 1'b0;
	repeat (cycles) begin
		@(posedge dut_vi.clock);
	end
	dut_vi.avail = 1'b1;
endtask

task run_phase(uvm_phase phase);
	packet_t tx;
	int i;
	// zero the input ports at time zero
	dut_vi.avail=0;
	dut_vi.data=0;
	@(negedge dut_vi.reset);
	@(posedge dut_vi.clock);
	@(posedge dut_vi.clock);

	forever 
	begin
		tx = packet_t::type_id::create("tx");
		seq_item_port.get_next_item(tx);
		//dut_vi.send_packet(tx,port);
		//`uvm_info("msg", tx.convert2string(), UVM_LOW)
		i=0;
		//send header after some random number of clock cycles, from 0 to 15 cycles
		wait_cycles(tx.cycle2send);
		dut_vi.data = tx.get_header();	
		// wait until there is space in the input buffer
		@(negedge dut_vi.clock iff dut_vi.credit == 1'b1);	
		@(posedge dut_vi.clock);
		// send the size after some random number of clock cycles, from 0 to 15 cycles
		wait_cycles(tx.cycle2flit);
		dut_vi.data = tx.payload.size();
		@(negedge dut_vi.clock iff dut_vi.credit == 1'b1);
		// send payload after some random number of clock cycles, from 0 to 15 cycles
		i=0;	
		while (i<tx.payload.size())  // size() accounts only for the payload size
		begin
			@(posedge dut_vi.clock);
			wait_cycles(tx.cycle2flit);
			dut_vi.data = tx.payload[i];
			i++;
			// wait until the buffer it not full again
			@(negedge dut_vi.clock iff dut_vi.credit == 1'b1);;
		end
		@(posedge dut_vi.clock);	
		dut_vi.avail = 1'b0;
		dut_vi.data = 0;

		tx.dport = port; // set the output port for sb verification
		aport.write(tx); // send it to the sb
		seq_item_port.item_done();			
	end
endtask: run_phase

endclass: router_driver
