class read_modify_write extends uvm_sequence #(my_transaction);
`uvm_object_utils(read_modify_write)

function new(string name = "");
  super.new(name);
endfunction: new

task body;
  forever
  begin
    my_transaction tx;
    int a,d;
    tx = my_transaction::type_id::create("tx");
    start_item(tx);
    assert(tx.randomize());
    tx.cmd = READ;
    finish_item(tx);
    a = tx.addr;
    d = tx.data;
    ++d;
    assert(tx.randomize() 
       with {cmd = WRITE; addr == a; data == d; });
    finish_item(tx);
  end
endtask: body

endclass: read_modify_write

