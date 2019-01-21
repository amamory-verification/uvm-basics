/*
 this hierarchical sequence injects 5 'basic_seq' in all input ports in parallel to the same output port, creating a bottleneck
*/
class bottleneck_seq extends base_vseq; 
`uvm_object_utils(bottleneck_seq)

function new(string name = "bottleneck_seq");
  super.new(name);
endfunction: new


task body();
	basic_seq seq[];
	seq_config bs_cfg[], cfg;
	int j=0;
	bit [3:0] val_ports[$]; 

	//$display("CFG: %s",cfg.convert2string());
	// get all ports that can send packet to this address
 	val_ports = router_pkg::valid_ports(cfg.header);
 	//$display("%p\n",val_ports);
	seq    = new[val_ports.size()];
	bs_cfg = new[val_ports.size()];

	foreach (val_ports[i]) begin
		seq[i] = basic_seq::type_id::create($sformatf("seq[%0d]",i));
		bs_cfg[i] = seq_config::type_id::create($sformatf("seq_cfg[%0d]",i));
		bs_cfg[i].do_copy(cfg); 
		bs_cfg[i].rand_mode(0);
		bs_cfg[i].port.rand_mode(1);
		// set the input router port where the sequence will inject its packets
	    // it is necessary to randomize since it is changing the port, which is related to the header field
	    if (! bs_cfg[i].randomize() with { 
	        // input port
	        port == val_ports[i];
	      }
	    )
	    	`uvm_error("rand", "invalid cfg randomization"); 
	    //$display("BS_CFG\nI: %d\n\n%s",i,bs_cfg[i].convert2string());
	    //seq[i].set_seq_config(bs_cfg[i]); 	
	end 
	// solution from https://verificationacademy.com/forums/systemverilog/fork-within-loop-join-all
	// to wait all threads to finish
	fork 
	  begin : isolating_thread
	    for(int index=0;index<val_ports.size();index++)begin : for_loop
	      fork
	      automatic int idx=index;
	        begin
	        	if (! seq[idx].randomize() )
	        		`uvm_error("rand", "invalid seq randomization"); 
	            seq[idx].start (sequencer[seq[idx].cfg.port]);
	        end
	      join_none;
	    end : for_loop
	  wait fork; // This block the current thread until all child threads have completed. 
	  end : isolating_thread
	join

endtask: body

endclass: bottleneck_seq

