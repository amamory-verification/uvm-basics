/*
 this virtual hierarchical sequence injects 5 'basic_seq' in all input ports in parallel
*/
class main_vseq extends base_vseq; 
`uvm_object_utils(main_vseq)

function new(string name = "main_vseq");
  super.new(name);
endfunction: new


task body();
	basic_seq seq[];
	//seq_config bs_cfg[];
	int j=0;
	seq    = new[router_pkg::NPORT];
	//bs_cfg = new[router_pkg::NPORT];
	//$display("%s",cfg.convert2string());
 	
	foreach (seq[i]) begin
		seq[i] = basic_seq::type_id::create($sformatf("seq_%0d",i));
		/*
		bs_cfg[i] = seq_config::type_id::create($sformatf("seq_cfg[%0d]",i));
		bs_cfg[i].do_copy(cfg); 
		bs_cfg[i].rand_mode(0);
		bs_cfg[i].header.rand_mode(1); 
		bs_cfg[i].port.rand_mode(1);		
		// set the input router port where the sequence will inject its packets
	    // it is necessary to randomize since it is changing the port, which is related to the header field
	    if( !bs_cfg[i].randomize() with { 
	        // input port
	        port == j;
	      }
	    )
	    	`uvm_error("rand", "invalid cfg randomization"); 
	    //$display("I: %d\n\n%s",i,bs_cfg[i].convert2string());
	    seq[i].set_seq_config(bs_cfg[i]); 	
		j = j +1 ;
	    */
	end 
	// solution from https://verificationacademy.com/forums/systemverilog/fork-within-loop-join-all
	// to wait all threads to finish
	fork 
	  begin : isolating_thread
	    for(int index=0;index<router_pkg::NPORT;index++)begin : for_loop
	      fork
	      automatic int idx=index;
	        begin
	        	if( !seq[idx].randomize() )
	        		`uvm_error("rand", "invalid cfg randomization"); 
	            seq[idx].start (sequencer[idx]);
	        end
	      join_none;
	    end : for_loop
	  wait fork; // This block the current thread until all child threads have completed. 
	  end : isolating_thread
	join

endtask: body

endclass: main_vseq

