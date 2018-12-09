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
	dut_vi.reset_dut();
	forever
	begin
	  seq_item_port.get_next_item(tx);
	  dut_vi.send_packet(tx,port);
	  seq_item_port.item_done();
	  //aport.write(tx); // send the incomming seq_item to the scoreboard/coverage
	  //`uvm_info("driver", "transaction done !", UVM_HIGH)
	end
endtask: run_phase

endclass: router_driver
