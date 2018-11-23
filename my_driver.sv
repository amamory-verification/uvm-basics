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
	phase.raise_objection(this);
	#10 dut_vi.data = 0;
	#10 dut_vi.data = 1;
	#10 phase.drop_objection(this);
	
	forever
	begin
	  my_transaction tx;
	  `uvm_info("msg", "New transaction", UVM_NONE)  /// <=== parou aqui
	  @(posedge dut_vi.clk);
	  seq_item_port.get_next_item(tx);
	  `uvm_info("msg", "Got new transaction", UVM_NONE)
	  dut_vi.cmd = tx.cmd;
	  dut_vi.addr = tx.addr;
	  dut_vi.data = tx.data;
	  `uvm_info("msg", "waiting transaction done", UVM_NONE)
	  @(posedge dut_vi.clk) seq_item_port.item_done();
	  `uvm_info("msg", "transaction done !", UVM_NONE)
	  
	end
endtask: run_phase

endclass: my_driver
