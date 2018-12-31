class main_vseq extends base_vseq; 
`uvm_object_utils(main_vseq)


function new(string name = "main_vseq");
  super.new(name);
endfunction: new


task body();
	/*
	basic_seq seq0, seq1, seq2, seq3, seq4;
	seq0 = basic_seq::type_id::create("seq0");
	seq1 = basic_seq::type_id::create("seq1");
	seq2 = basic_seq::type_id::create("seq2");
	seq3 = basic_seq::type_id::create("seq3");
	seq4 = basic_seq::type_id::create("seq4");
	seq0.port = 0;
	seq1.port = 1;
	seq2.port = 2;
	seq3.port = 3;
	seq4.port = 4;
	fork
    	seq0.start(sequencer[0]);
    	seq1.start(sequencer[1]);
    	seq2.start(sequencer[2]);
    	seq3.start(sequencer[3]);
    	seq4.start(sequencer[4]);
  	join
*/

  basic_seq seq[];
  int j=0;
  seq = new[router_pkg::NPORT];
  foreach (seq[i]) begin
    seq[i] = basic_seq::type_id::create($sformatf("seq[%0d]",i));
    seq[i].port = j;
    j = j +1 ;
  end 
/*
  fork
    begin
  		foreach (seq[i]) begin
    		seq[i].start (sequencer[i]);
  		end
    end
  join  
 
*/

// solution from https://verificationacademy.com/forums/systemverilog/fork-within-loop-join-all
fork 
  begin : isolating_thread
    for(int index=0;index<router_pkg::NPORT;index++)begin : for_loop
      fork
      automatic int idx=index;
        begin
            seq[idx].start (sequencer[idx]);
        end
      join_none;
    end : for_loop
  wait fork; // This block the current thread until all child threads have completed. 
  end : isolating_thread
join


  //basic_seq seq0, seq1;
  //seq0 = basic_seq::type_id::create("seq0", this);
  //seq1 = basic_seq::type_id::create("seq1", this);

/*
  fork
    //seq[0].start (sequencer[0]);
    //seq[1].start (sequencer[1]);
    seq0.start (.sequencer(sequencer0), .parent_sequence( this ));
    seq1.start (.sequencer(sequencer1), .parent_sequence( this ));
  join
*/
endtask: body

endclass: main_vseq

