// hermes base driver 
class router_base_driver extends uvm_driver #(packet_t);
`uvm_component_utils(router_base_driver);

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
	`uvm_info("driver", $sformatf("PORT number: %0d",port), UVM_HIGH)

    if(!uvm_config_db#(virtual router_if)::get (this,"", "if", dut_vi))
	    `uvm_fatal("driver", "No if"); 	

endfunction : build_phase

endclass: router_base_driver