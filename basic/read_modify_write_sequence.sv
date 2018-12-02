class read_modify_write extends uvm_sequence #(my_transaction);
`uvm_object_utils(read_modify_write)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  
  begin
    my_transaction tx;
    int d;
    tx = my_transaction::type_id::create("tx");
    start_item(tx);
    //`uvm_info("msg", "read transaction started", UVM_LOW)
    assert(tx.randomize());
    tx.cmd = READ;
    finish_item(tx);
    d = tx.data;
    ++d;

    tx = my_transaction::type_id::create("tx");
    start_item(tx);    
    //`uvm_info("msg", "write transaction started", UVM_LOW)
    assert(tx.randomize() 
       with {cmd == WRITE; data == d; });
    finish_item(tx);
    //`uvm_info("msg", "sequence read_modify_write finished", UVM_LOW)
  end
endtask: body

endclass: read_modify_write

