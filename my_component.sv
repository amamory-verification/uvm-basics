class my_component extends uvm_component;
`uvm_component_utils(my_component);

virtual dut_if dur_if_h;

 my_sequencer my_sequencer_h;
 my_driver    my_driver_h;
 my_monitor   my_monitor_h;

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  // ...
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  // ...
endfunction: connect_phase


function void start_of_simulation;

task run_phase(uvm_phase phase);
	phase.raise_objection(this);
	#10 dut_vi.data = 0;
	#10 dut_vi.data = 1;
	#10 phase.drop_objection(this);
endtask: run_phase

task report_phase(uvm_phase phase);

endtask: report_phase

endclass: my_component
