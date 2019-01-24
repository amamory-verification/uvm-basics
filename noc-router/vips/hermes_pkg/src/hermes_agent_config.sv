// these are the agent configuration parameters that can be changed at the test level
class hermes_agent_config extends uvm_object;
`uvm_object_utils(hermes_agent_config)

uvm_active_passive_enum is_active = UVM_ACTIVE;
bit master_driver_enabled = 1;


//==========================
// credit_i_driver timing knobs
//==========================
// the probability to have credit to send flits outside the router. 
// cred_distrib == 10 ==> 100%, i.e. the next router is always free to send flits
// cred_distrib == 1 ==> 10%, i.e. the next router is always free only 10% of the time
rand bit [3:0] cred_distrib;
// default distribution for credit. only values from [1:10] are allowed. 0 and [11:15] have 0% of selection 
bit [3:0] cred_dist[11] = {0,5,5,1,1,1,1,1,1,5,30};

constraint c_cred_distrib {
	// fixed distribution 
	//cred_distrib dist { [0:2] := 10, [3:15] := 1 };
	// variable distribution. TODO: there must be a better way to do it !!!
	cred_distrib dist { 0  := 0,  1  := cred_dist[1],  2  := cred_dist[2],  3  := cred_dist[3], 4 := cred_dist[4],
					    5  := cred_dist[5],  6  := cred_dist[6],  7  := cred_dist[7],  8  := cred_dist[8], 9 := cred_dist[9],
					    10 := cred_dist[10]
	};
	! (cred_distrib inside { [11:15] });
/*
	cred_distrib dist { 0  := cred_dist[0],  1  := cred_dist[1],  2  := cred_dist[2],  3  := cred_dist[3], 4 := cred_dist[4],
					    5  := cred_dist[5],  6  := cred_dist[6],  7  := cred_dist[7],  8  := cred_dist[8], 9 := cred_dist[9],
					    10 := cred_dist[10], 11 := cred_dist[11], 12 := cred_dist[12], 13 := cred_dist[13], 
					    14 := cred_dist[14], 15 := cred_dist[15]
	};
	*/
}


//==========================
// hermes_driver timing knobs
//==========================
 // randomize the number of cycles the driver waits to start sending the packet. used by driver
rand bit [3:0] cycle2send;
// used to change the random distribution of  cycle2send
bit [3:0] cycle2send_dist[16] = {10,10,10,1,1,1,1,1,1,1,1,1,1,1,1,1};


// randomize the number of cycles between flits. used by driver
rand bit [3:0] cycle2flit;
// used to change the random distribution of  cycle2flit
bit [3:0] cycle2flit_dist[16] = {15,5,5,1,1,1,1,1,1,1,1,1,1,1,1,1};

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


function void do_copy( uvm_object rhs );
  hermes_agent_config that;

  if ( ! $cast( that, rhs ) ) begin
     `uvm_error( get_name(), "rhs is not a seq_config" )
     return;
  end

  super.do_copy( rhs );
  this.cred_distrib    = that.cred_distrib;
  this.cred_dist       = that.cred_dist;
  this.cycle2send      = that.cycle2send;
  this.cycle2send_dist = that.cycle2send_dist;
  this.cycle2flit      = that.cycle2flit;
  this.cycle2flit_dist = that.cycle2flit_dist;
endfunction: do_copy


virtual function string convert2string();
  string s = super.convert2string();      
  s = { s, $psprintf( "\n cred_distrib : %0d", cred_distrib) };
  s = { s, $psprintf( "\n cycle2send   : %0d", cycle2send) };
  s = { s, $psprintf( "\n cycle2flit   : %0d", cycle2flit) };
  return s;
endfunction: convert2string

function new( string name = "" );
  super.new( name );
endfunction: new

endclass : hermes_agent_config
