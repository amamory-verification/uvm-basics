class packet_t extends uvm_sequence_item;
`uvm_object_utils(packet_t)

parameter half_flit = router_pkg::FLIT_WIDTH/2;
parameter quarter_flit = router_pkg::FLIT_WIDTH/4;

// to ease randomization of packet size
typedef enum {ZERO, SMALL, MED, LARGE} packet_size_t;
rand packet_size_t p_size;
// weights for packet size
bit [4:0] w_zero=1, w_small=2, w_med=10, w_large=1;

// to ease randomization of packet destination
//typedef enum {ITSELF, NEIGHBOR, NEARBY, FARAWAY} address_t;
//rand address_t addr;

// packet payload and size (payload.size())
// TODO optimize according to https://verificationacademy.com/forums/systemverilog/randomizing-dynamic-array-size
rand bit [router_pkg::FLIT_WIDTH-1:0]   payload[];
// packet header - only 7 : 0 is used, y is 3: 0 and x is 7: 4
rand bit [quarter_flit-1:0]  x, y;

rand bit [7:0] header;

// output port where the packet was captured
bit [3:0] oport;

// driver port where the packet was inserted
bit [3:0] dport;

// it contains the valid target addresses
bit [7:0] valid_target_addr[$];

// max network size
//constraint c_x {  x >=0 ;  x < 2**(router_pkg::FLIT_WIDTH/2)-1; }
//constraint c_y {  y >=0 ;  y < 2**(router_pkg::FLIT_WIDTH/2)-1; }

//constraint c_i_port {  iport inside {[0:4]};}


// choose random packet size with weights
constraint c_p_size {
	p_size dist {
		ZERO  := w_zero,
		SMALL := w_small,
		MED   := w_med,
		LARGE := w_large
	};
}


// max packet size in flits
constraint c_size { 
	if (p_size == ZERO){
		payload.size() == 0;
	}else if (p_size == SMALL){
		payload.size() >= 1; payload.size() <= 3;
	
	}else if (p_size == LARGE){
		payload.size() >= 100; payload.size() <= 128;
	} else{
		payload.size() >= 4; payload.size() <= 99;
	}
}

/*
// packet destination in number of hops
constraint c_addr { 
	if (addr == ITSELF){ // loopback
		x == router_pkg::X_ADDR;
		y == router_pkg::Y_ADDR;
	}else if (addr == NEIGHBOR){ // send to a next router
		if (router_pkg::X_ADDR > 0){
			x inside {router_pkg::X_ADDR-1 , router_pkg::X_ADDR+1};
		}
		else if (router_pkg::X_ADDR == 0){
			x inside {router_pkg::X_ADDR , router_pkg::X_ADDR+1};
		}

		if (router_pkg::Y_ADDR > 0){
			y inside {router_pkg::Y_ADDR-1 , router_pkg::Y_ADDR+1};
		}
		else if (router_pkg::Y_ADDR == 0){
			y inside {router_pkg::Y_ADDR , router_pkg::Y_ADDR+1};
		}	
	}else if (addr == FARAWAY){ // send to distante routers === TODO fix for invalid negative address or addr > 15
		x inside {[router_pkg::X_ADDR-15 : router_pkg::X_ADDR-5] , [router_pkg::X_ADDR+5 : router_pkg::X_ADDR+15]};
		y inside {[router_pkg::Y_ADDR-15 : router_pkg::Y_ADDR-5] , [router_pkg::Y_ADDR+5 : router_pkg::Y_ADDR+15]};
	} else{
		x inside {[router_pkg::X_ADDR-4 : router_pkg::X_ADDR-2] , [router_pkg::X_ADDR+2 : router_pkg::X_ADDR+4]};
		y inside {[router_pkg::Y_ADDR-4 : router_pkg::Y_ADDR-2] , [router_pkg::Y_ADDR+2 : router_pkg::Y_ADDR+4]};
	}
}
*/

constraint c_header { 
	header inside {valid_target_addr};
	x == header[7:4];
	y == header[3:0];
	solve header before x;
	solve header before y;
}



// create the list of valid target addresses following XY routing algorithm
function void pre_randomize();
begin
	bit [3:0] i,j;
	if (dport == -1)
		`uvm_fatal(get_name(), "set the dport before randomization" )
	for (i = 0; i <= router_pkg::X_MAX; i++) begin
		for (j = 0; j <= router_pkg::Y_MAX; j++) begin
			// exclude loopback from the local port
		if (dport == router_pkg::LOCAL) begin
			if (!((i == router_pkg::X_ADDR) && (j == router_pkg::Y_ADDR))) begin
				//$display("LOCAL TARGETS %h %0d %0d",{i,j}, i,j );
				valid_target_addr.push_back({i,j});
			end
		end
		// exclude target address to the left hand side of the current router addr
		if (dport == router_pkg::WEST) begin
			if (i >= router_pkg::X_ADDR) begin
				//$display("WEST TARGETS %h %0d %0d",{i,j}, i,j );
				valid_target_addr.push_back({i,j});
			end
		end
		// exclude target address to the right hand side of the current router addr
		if (dport == router_pkg::EAST) begin
			if (i <= router_pkg::X_ADDR) begin
				//$display("EAST TARGETS %h %0d %0d",{i,j}, i,j );
				valid_target_addr.push_back({i,j});
			end
		end
		// exclude target address above the current router addr. turns are forbiden
		if (dport == router_pkg::NORTH) begin
			if ((i == router_pkg::X_ADDR) && (j <= router_pkg::Y_ADDR)) begin
				//$display("NORTH TARGETS %h %0d %0d",{i,j}, i,j );
				valid_target_addr.push_back({i,j});
			end
		end
		// exclude target address below the current router addr. turns are forbiden
		if (dport == router_pkg::SOUTH) begin
			if ((i == router_pkg::X_ADDR) && (j >= router_pkg::Y_ADDR)) begin
				//$display("SOUTH TARGETS %h %0d %0d",{i,j}, i,j );
				valid_target_addr.push_back({i,j});
			end
		end
	end
	end	
end
endfunction

function void set_header(input bit [router_pkg::FLIT_WIDTH-1:0] h ); 
  y = h[quarter_flit-1:0];
  x = h[half_flit-1 : quarter_flit];  
endfunction: set_header

function bit [router_pkg::FLIT_WIDTH-1:0] get_header();
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
  packet_t that;
  if ( ! $cast( that, rhs ) ) return 0;

  return ( super.do_compare( rhs, comparer )  &&
           this.x     == that.x     &&
           this.y      == that.y      &&
           this.payload.size() == that.payload.size() &&
           this.payload == that.payload );
endfunction: do_compare

virtual function void do_copy( uvm_object rhs );
  packet_t that;

  if ( ! $cast( that, rhs ) ) begin
     `uvm_error( get_name(), "rhs is not a packet_t" )
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

endclass: packet_t



/*
   `uvm_object_utils_begin( jelly_bean_transaction )
      `uvm_field_enum( flavor_e, flavor, UVM_ALL_ON )
      `uvm_field_enum( color_e,  color,  UVM_ALL_ON )
      `uvm_field_int ( sugar_free,       UVM_ALL_ON )
      `uvm_field_int ( sour,             UVM_ALL_ON )
      `uvm_field_enum( taste_e,  taste,  UVM_ALL_ON )
   `uvm_object_utils_end
*/
typedef uvm_sequencer #(packet_t) packet_sequencer;

