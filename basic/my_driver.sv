class my_driver extends uvm_driver #(my_transaction);
`uvm_component_utils(my_driver);

virtual dut_if dut_vi;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
	`uvm_info("msg", "Building DRIVER", UVM_NONE)
	
	if (!uvm_config_db #(virtual dut_if)::get (null,"*", "dut_vi", dut_vi) )
		`uvm_fatal("my_driver", "No DUT_IF");
	`uvm_info("msg", "DRIVER Done!!!", UVM_NONE)
endfunction : build_phase

task run_phase(uvm_phase phase);
	my_transaction tx;
	dut_vi.reset_dut();
	forever
	begin
	  seq_item_port.get_next_item(tx);
	  dut_vi.do_dut(tx.cmd,tx.data,tx.addr,tx.dout);
	  seq_item_port.item_done();
	  `uvm_info("msg", "transaction done !", UVM_HIGH)
	end
endtask: run_phase

endclass: my_driver
