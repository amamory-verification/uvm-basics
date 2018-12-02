class seq_of_commands extends uvm_sequence #(my_transaction);
`uvm_object_utils(seq_of_commands)

rand int n;

constraint how_many {n inside {[2:4]}; }


function new(string name = "");
  super.new(name);
endfunction: new

task body();
  int count = 0;
  repeat(n)
  begin
    read_modify_write seq;
    seq = read_modify_write::type_id::create("rmw_seq");
    //`uvm_info("msg", $sformatf("starting sequence - %0d", count), UVM_NONE)
    seq.start(m_sequencer, this);
    count++;
  end
endtask: body

endclass: seq_of_commands

