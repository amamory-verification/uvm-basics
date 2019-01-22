/*
 this virtual hierarchical sequence injects 5 'basic_seq' in all input ports in parallel
*/
class main_vseq extends base_vseq; 
`uvm_object_utils(main_vseq)

function new(string name = "main_vseq");
  super.new(name);
endfunction: new

task body();
	basic_seq seq[router_pkg::NPORT];
 	

	foreach (seq[i]) begin
		seq[i] = basic_seq::type_id::create($sformatf("seq_%0d",i));
		// the basic_seq gets the seq configuration from pre_body
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
	        		`uvm_error("main_vseq", "invalid cfg randomization"); 
	            seq[idx].start (sequencer[idx]);
	        end
	      join_none;
	    end : for_loop
	  wait fork; // This block the current thread until all child threads have completed. 
	  end : isolating_thread
	join

endtask: body

endclass: main_vseq

