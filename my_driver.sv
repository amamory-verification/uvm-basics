class my_driver extends uvm_driver;
`uvm_component_utils(my_driver);

virtual dut_if dut_vi;

function new(string name, uvm_component parent);

function void build_phase(uvm_phase phase);
	dut_config_0 = new();
	
	if (!uvm_config_db #(virtual dut_if)::get (this,"", "dut_vi", dut_config_0.dut_vi) )
		`uvm_fatal("MY_TEST", "No DUR_IF");
	// other DUT configuration
	uvm_config_db# (my_dut_config)::set(this,"*", "dut_config", dut_config_0);

endfunction : build_phase

task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	#10 dut_vi.data = 0;
	#10 dut_vi.data = 1;
	#10 phase.drop_objection(this);
	
	forever
	begin
	  my_transaction tx;
	  @(posedge dut_vi.clock);
	  seq_item_port.get_next_item(tx);
	  dut_vi.cmd = tx.cmd;
	  dut_vi.addr = tx.addr;
	  dut_vi.data = tx.data;
	  @(posedge dut_vi.clock) seq_item_port.item_done();
	  
	end
endtask: run_phase

endclass: my_driver
