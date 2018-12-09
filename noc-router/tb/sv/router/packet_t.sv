class packet_t extends uvm_sequence_item;
`uvm_object_utils(packet_t)

typedef enum {ZERO, SMALL, MED, LARGE} packet_size_t;
rand packet_size_t p_size;
// weights for packet size
bit [4:0] w_zero=1, w_small=2, w_med=10, w_large=1;

typedef enum {ITSELF, NEIGHBOR, NEARBY, FARAWAY} address_t;
rand address_t addr;


rand bit [router_pkg::FLIT_WIDTH-1:0]   payload[];
rand shortint  x, y;

// max network size
//constraint c_x {  x >=0 ;  x < 2**(router_pkg::FLIT_WIDTH/2)-1; }
//constraint c_y {  y >=0 ;  y < 2**(router_pkg::FLIT_WIDTH/2)-1; }

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
		//payload_size == 0;
		payload.size() == 0;
	}else if (p_size == SMALL){
		//payload_size inside {[1:3]};
		payload.size() >= 1; payload.size() <= 3;
	
	}else if (p_size == LARGE){
		//payload_size inside {[100:128]};
		payload.size() >= 100; payload.size() <= 128;
	} else{
		//payload_size inside {[4:99]}; 
		payload.size() >= 4; payload.size() <= 99;
	}
}

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
			y == router_pkg::X_ADDR+1;
		}

		if (router_pkg::Y_ADDR > 0){
			y inside {router_pkg::Y_ADDR-1 , router_pkg::Y_ADDR+1};
		}
		else if (router_pkg::Y_ADDR == 0){
			y == router_pkg::Y_ADDR+1;
		}	
	}else if (addr == FARAWAY){ // send to distante routers === TODO fix for invalid negative address or addr > 128
		x inside {[router_pkg::X_ADDR-100 : router_pkg::X_ADDR-10] , [router_pkg::X_ADDR+10 : router_pkg::X_ADDR+100]};
		y inside {[router_pkg::Y_ADDR-100 : router_pkg::Y_ADDR-10] , [router_pkg::Y_ADDR+10 : router_pkg::Y_ADDR+100]};
	} else{
		x inside {[router_pkg::X_ADDR-9 : router_pkg::X_ADDR-2] , [router_pkg::X_ADDR+2 : router_pkg::X_ADDR+9]};
		y inside {[router_pkg::Y_ADDR-9 : router_pkg::Y_ADDR-2] , [router_pkg::Y_ADDR+2 : router_pkg::Y_ADDR+9]};
	}
}

// TODO confirmar se eh assim q eh formado o header
function void set_header(input bit [router_pkg::FLIT_WIDTH-1:0] h ); 
  x = h && 16'h00FF;
  y = h >> 8;
endfunction: set_header

function new(string name = "");
  super.new(name);
endfunction: new

endclass: packet_t

typedef uvm_sequencer #(packet_t) packet_sequencer;

