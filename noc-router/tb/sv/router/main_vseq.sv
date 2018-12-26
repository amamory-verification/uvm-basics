class main_vseq extends uvm_sequence #(packet_t); 
`uvm_object_utils(main_vseq)
//`uvm_declare_p_sequencer (my_virtual_sequencer)

packet_sequencer sequencer0;
packet_sequencer sequencer1;
basic_seq seq0, seq1;


function new(string name = "main_vseq");
  super.new(name);
endfunction: new


task pre_body();
  seq0 = basic_seq::type_id::create("seq0", this);
endtask


task body();
	/*
  basic_seq seq[router_pkg::NPORT];
  foreach (seq[i]) begin
    seq[i] = basic_seq::type_id::create($sformatf("seq%0d",i), this);
  end 
  */
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

