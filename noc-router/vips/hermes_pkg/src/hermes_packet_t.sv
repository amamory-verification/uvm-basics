import hermes_pkg::*;

class hermes_packet_t extends uvm_sequence_item;
`uvm_object_utils(hermes_packet_t)

parameter half_flit = hermes_pkg::FLIT_WIDTH/2;
parameter quarter_flit = hermes_pkg::FLIT_WIDTH/4;

// to ease randomization of packet size
//typedef enum {ZERO, SMALL, MED, LARGE} packet_size_t;
typedef enum {SMALL, MED, LARGE} packet_size_t; // zero is not supported by the router. enable only to generated invalid packets 
rand packet_size_t p_size;
// weights for packet size
//bit [4:0] w_zero=1, w_small=2, w_med=10, w_large=1;
bit [4:0] w_small=20, w_med=5, w_large=1;

// packet payload and size (payload.size())
// TODO optimize according to https://verificationacademy.com/forums/systemverilog/randomizing-dynamic-array-size
rand bit [hermes_pkg::FLIT_WIDTH-1:0]   payload[];
// packet header - only 7 : 0 is used, y is 3: 0 and x is 7: 4
rand bit [quarter_flit-1:0]  x, y;

rand bit [7:0] header;

/*
// randomize the number of cycles the driver waits to start sending the packet. used by driver
rand bit [3:0] cycle2send;
// used to change the random distribution of  cycle2send
bit [3:0] cycle2send_dist[16] = {10,10,10,1,1,1,1,1,1,1,1,1,1,1,1,1};


// randomize the number of cycles between flits. used by driver
rand bit [3:0] cycle2flit;
// used to change the random distribution of  cycle2flit
bit [3:0] cycle2flit_dist[16] = {15,5,5,1,1,1,1,1,1,1,1,1,1,1,1,1};
*/

// output port where the packet was captured
bit [3:0] oport;

// driver port where the packet was inserted
bit [3:0] dport;

// choose random packet size with weights
constraint c_p_size {
	p_size dist {
		//ZERO  := w_zero, // not supported by the router. enable only to generated invalid packets
		SMALL := w_small,
		MED   := w_med,
		LARGE := w_large
	};
}

/*
// choose random # of cycles to start sending this transaction
constraint c_cycle2send {
	// fixed distribution 
	//cycle2send dist { [0:2] := 10, [3:15] := 1 };
	// variable distribution. TODO: there must be a better way to do it !!!
	cycle2send dist { 0 := cycle2send_dist[0], 1 := cycle2send_dist[1], 2 := cycle2send_dist[2], 3 := cycle2send_dist[3], 4 := cycle2send_dist[4],
					  5 := cycle2send_dist[5], 6 := cycle2send_dist[6], 7 := cycle2send_dist[7], 8 := cycle2send_dist[8], 9 := cycle2send_dist[9],
					  10 := cycle2send_dist[10], 11 := cycle2send_dist[11], 12 := cycle2send_dist[12], 13 := cycle2send_dist[13], 
					  14 := cycle2send_dist[14], 15 := cycle2send_dist[15]
	};
}

// choose random # of cycles between flits
constraint c_cycle2flit {
	// fixed distribution 
	//cycle2flit dist { 0 := 15, [1:2] := 5, [3:15] := 1 };
	// variable distribution. TODO: there must be a better way to do it !!!
	cycle2flit dist { 0 := cycle2flit_dist[0], 1 := cycle2flit_dist[1], 2 := cycle2flit_dist[2], 3 := cycle2flit_dist[3], 4 := cycle2flit_dist[4],
					  5 := cycle2flit_dist[5], 6 := cycle2flit_dist[6], 7 := cycle2flit_dist[7], 8 := cycle2flit_dist[8], 9 := cycle2flit_dist[9],
					  10 := cycle2flit_dist[10], 11 := cycle2flit_dist[11], 12 := cycle2flit_dist[12], 13 := cycle2flit_dist[13], 
					  14 := cycle2flit_dist[14], 15 := cycle2flit_dist[15]
	};	
}
*/

// max packet size in flits
constraint c_size { 
	//if (p_size == ZERO){
	//	payload.size() == 0;
	//}else 
  if (p_size == SMALL){
		payload.size() >= 1; payload.size() <= 3;
	
	}else if (p_size == LARGE){
		payload.size() >= 100; payload.size() <= 128;
	} else{
		payload.size() >= 4; payload.size() <= 99;
	}
}

constraint c_header { 
  // given the input port 'dport', it returns the list of possible target address for the header
  header inside {hermes_pkg::valid_addrs(this.dport)};
  x == header[7:4];
	y == header[3:0];
  solve dport before header;
	solve header before x;
	solve header before y;
}


function void set_header(input bit [hermes_pkg::FLIT_WIDTH-1:0] h ); 
  y = h[quarter_flit-1:0];
  x = h[half_flit-1 : quarter_flit];  
endfunction: set_header

function bit [hermes_pkg::FLIT_WIDTH-1:0] get_header();
  return {8'b0,x, y};
endfunction: get_header

function new(string name = "");
  super.new(name);
  // when the transaction is input, them oport=-1
  // otherwise, when the transaction is output, them dport=-1
  dport = -1;
  oport = -1;

endfunction: new



virtual function bit do_compare( uvm_object rhs, uvm_comparer comparer );
  hermes_packet_t that;
  if ( ! $cast( that, rhs ) ) return 0;

  return ( super.do_compare( rhs, comparer )  &&
           this.x     == that.x     &&
           this.y      == that.y      &&
           this.payload.size() == that.payload.size() &&
           this.payload == that.payload );
endfunction: do_compare

virtual function void do_copy( uvm_object rhs );
  hermes_packet_t that;

  if ( ! $cast( that, rhs ) ) begin
     `uvm_error( get_name(), "rhs is not a hermes_packet_t" )
     return;
  end

  super.do_copy( rhs );
  this.x     = that.x;
  this.y     = that.y;
  this.dport = that.dport;
  this.oport = that.oport;
  this.payload = that.payload;
endfunction: do_copy

virtual function string convert2string();
  string s = super.convert2string();      
  s = { s, $psprintf( "\nx    : %0d", x) };
  s = { s, $psprintf( "\ny    : %0d", y) };
  s = { s, $psprintf( "\nip   : %0d", dport) };
  s = { s, $psprintf( "\nop   : %0d", oport) };
  s = { s, $psprintf( "\nsize : %0d", payload.size()) };
  s = { s, $psprintf( "\npayload : ") };
  foreach(payload[i]) begin
  	s = { s, $psprintf( "\n\t%H ",payload[i])};
  end
  return s;
endfunction: convert2string

function void do_record(uvm_recorder recorder);
  super.do_record(recorder);

  `uvm_record_attribute(recorder.tr_handle, "x",x);
  `uvm_record_attribute(recorder.tr_handle, "y",y);
  `uvm_record_attribute(recorder.tr_handle, "ip",dport);
  `uvm_record_attribute(recorder.tr_handle, "op",oport);
  `uvm_record_attribute(recorder.tr_handle, "size",payload.size());
  //`uvm_record_attribute(recorder.tr_handle, "payload",payload);
endfunction

endclass: hermes_packet_t


/*
   `uvm_object_utils_begin( jelly_bean_transaction )
      `uvm_field_enum( flavor_e, flavor, UVM_ALL_ON )
      `uvm_field_enum( color_e,  color,  UVM_ALL_ON )
      `uvm_field_int ( sugar_free,       UVM_ALL_ON )
      `uvm_field_int ( sour,             UVM_ALL_ON )
      `uvm_field_enum( taste_e,  taste,  UVM_ALL_ON )
   `uvm_object_utils_end
*/
typedef uvm_sequencer #(hermes_packet_t) packet_sequencer;

