class main_vseq extends base_vseq; 
`uvm_object_utils(main_vseq)
//`uvm_declare_p_sequencer (my_virtual_sequencer)

function new(string name = "main_vseq");
  super.new(name);
endfunction: new

task pre_body();
	
endtask

task body;
  basic_seq seq[router_pkg::NPORT];
  foreach (seq[i]) begin
    seq[i] = basic_seq::type_id::create($sformatf("seq%0d",i), this);
  end  

  fork
    //seq[0].start (sequencer[0]);
    //seq[1].start (sequencer[1]);
    seq[0].start (.sequencer(sequencer0), .parent_sequence( this ));
    seq[1].start (.sequencer(sequencer1), .parent_sequence( this ));
  join
endtask: body

endclass: main_vseq

