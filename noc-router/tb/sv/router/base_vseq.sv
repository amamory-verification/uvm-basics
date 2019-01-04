class base_vseq extends uvm_sequence #(uvm_sequence_item);  
`uvm_object_utils(base_vseq)

packet_sequencer sequencer[router_pkg::NPORT];

// set the input router port where the sequence will inject its packets. default is 0 
rand bit [3:0] port;
// set the random distribution for port 
bit [3:0] port_dist[router_pkg::NPORT] = {1,1,1,1,1};

constraint c_port {
  port inside { [0:router_pkg::NPORT-1] };
  port dist { 
  	0 := port_dist[0],
  	1 := port_dist[1],
  	2 := port_dist[2],
  	3 := port_dist[3],
  	4 := port_dist[4]
  };
}


// say the packet size used in the sequence. default is SMALL
//rand packet_t::packet_size_t psize;
// the target address to the packets. default is FF, which is a invalid header. this means that header must be randomized
//rand bit [7:0] header;

function new(string name = "base_vseq");
  super.new(name);
  //tx = packet_t::type_id::create("tx");
  // disable packets with zero payload
  //tx.w_zero = 0;
  //npackets = 50;
  //port = 0;
  //psize = packet_t::SMALL;
  //header = 16'hFF;
endfunction: new

endclass: base_vseq

