// hermes base driver 
class hermes_base_driver extends uvm_driver #(hermes_packet_t);
`uvm_component_utils(hermes_base_driver);

uvm_analysis_port #(hermes_packet_t) aport; // used to send the incomming packet to the sb 

virtual hermes_if dut_vi;
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
	`uvm_info("driver", $sformatf("PORT number: %0d",port), UVM_HIGH)

    if(!uvm_config_db#(virtual hermes_if)::get (this,"", "if", dut_vi))
	    `uvm_fatal("driver", "No if"); 	

endfunction : build_phase

endclass: hermes_base_driver