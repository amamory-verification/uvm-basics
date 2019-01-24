// hermes driver for incomming packets
class hermes_master_driver extends hermes_base_driver;
`uvm_component_utils(hermes_master_driver);

bit [3:0] cycle2send; // send header after some random number of clock cycles, from 0 to 15 cycles
bit [3:0] cycle2flit; // send the size after some random number of clock cycles, from 0 to 15 cycles
bit enabled;          // if off, this port is not supposed to send any packet. 

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

  	// print config_db
  	if (uvm_top.get_report_verbosity_level() >= UVM_HIGH)
		print_config();

    if(!uvm_config_db#(bit [3:0])::get (this,"", "cycle2send", cycle2send))
	    `uvm_fatal("driver", "No cycle2send"); 	

    if(!uvm_config_db#(bit [3:0])::get (this,"", "cycle2flit", cycle2flit))
	    `uvm_fatal("driver", "No cycle2flit");

    if(!uvm_config_db#(bit)      ::get (this,"", "enabled", enabled))
	    `uvm_fatal("driver", "No enabled"); 	

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
	hermes_packet_t tx;
	int i;
	// zero the input ports at time zero
	dut_vi.avail=0;
	dut_vi.data=0;
	@(negedge dut_vi.reset);
	@(posedge dut_vi.clock);
	@(posedge dut_vi.clock);

	forever 
	begin
		tx = hermes_packet_t::type_id::create("tx");
		seq_item_port.get_next_item(tx);
		if (!enabled)
			`uvm_error("driver", "this driver is disabled and was not supposed to send any packet");
		//dut_vi.send_packet(tx,port);
		//`uvm_info("driver", tx.convert2string(), UVM_MEDIUM)
		i=0;
		
		wait_cycles(cycle2send);
		dut_vi.data = tx.get_header();	
		// wait until there is space in the input buffer
		@(negedge dut_vi.clock iff dut_vi.credit == 1'b1);	
		@(posedge dut_vi.clock);
		
		wait_cycles(cycle2flit);
		dut_vi.data = tx.payload.size();
		@(negedge dut_vi.clock iff dut_vi.credit == 1'b1);
		// send payload after some random number of clock cycles, from 0 to 15 cycles
		i=0;	
		while (i<tx.payload.size())  // size() accounts only for the payload size
		begin
			@(posedge dut_vi.clock);
			wait_cycles(cycle2flit);
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

endclass: hermes_master_driver
