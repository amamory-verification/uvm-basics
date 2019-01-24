/*
 this virtual hierarchical sequence injects 5 'repeat_seq' in all input ports in parallel
*/
class parallel_seq extends hermes_base_seq; 
`uvm_object_utils(parallel_seq)

function new(string name = "parallel_seq");
  super.new(name);
endfunction: new

task body();
	repeat_seq seq[hermes_pkg::NPORT];
 	

	foreach (seq[i]) begin
		seq[i] = repeat_seq::type_id::create($sformatf("seq_%0d",i));
		// the repeat_seq gets the seq configuration from pre_body
	end 
	// solution from https://verificationacademy.com/forums/systemverilog/fork-within-loop-join-all
	// to wait all threads to finish
	fork 
	  begin : isolating_thread
	    for(int index=0;index<hermes_pkg::NPORT;index++)begin : for_loop
	      fork
	      automatic int idx=index;
	        begin
	        	if( !seq[idx].randomize() )
	        		`uvm_error("parallel_seq", "invalid cfg randomization"); 
	            seq[idx].start (sequencer[idx]);
	        end
	      join_none;
	    end : for_loop
	  wait fork; // This block the current thread until all child threads have completed. 
	  end : isolating_thread
	join

endtask: body

endclass: parallel_seq

