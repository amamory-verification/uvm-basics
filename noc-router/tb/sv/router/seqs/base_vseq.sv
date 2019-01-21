/*
Using the 'The Configurable Sequence' as described in 
'Seven Separate Sequence Styles Speed Stimulus Scenarios'
*/
class base_vseq extends uvm_sequence #(uvm_sequence_item);  
`uvm_object_utils(base_vseq)

packet_sequencer sequencer[router_pkg::NPORT];

// sequence configuration 
//seq_config cfg;
//seq_config cfg[router_pkg::NPORT];

/*
virtual task pre_body();
	super.pre_body();
	if(!uvm_config_db #(seq_config)::get(get_sequencer(), "", "config", cfg))
		`uvm_fatal(get_type_name(), "config config_db lookup failed")

	foreach(cfg[i]) begin
		if(!uvm_config_db #(seq_config)::get(get_sequencer(), "", $sformatf("config[%0d]",i), cfg[i]))
			`uvm_fatal(get_type_name(), "config config_db lookup failed")
	end

endtask
*/

/*
// test should create/randomize the config and pass it to the sequence
function void set_seq_config(seq_config cfg0);
	// pass the handle of the cfg created by the caller
	cfg = cfg0;
endfunction : set_seq_config
*/

function new(string name = "base_vseq");
  super.new(name);
endfunction: new

endclass: base_vseq

