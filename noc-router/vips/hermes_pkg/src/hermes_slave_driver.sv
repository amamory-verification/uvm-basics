//class used to implement the random credit logic 
class credit_class;
  // the probability to have credit to send flits outside the router. 
  // cred_distrib == 10 ==> 100%, i.e. the next router is always free to send flits
  // cred_distrib == 1 ==> 10%, i.e. the next router is always free only 10% of the time
  bit [3:0] cred_distrib;
  rand bit credit;


  constraint cred {
    // the sum of the probs must be 10
    credit dist {
      0  := 10-cred_distrib,
      1  := cred_distrib
    };
  }

  // dist == 5 means 50% of the time there will be credit
  function new (input bit [3:0] disto = 5);
    cred_distrib = disto;
  endfunction
endclass


/////////////////////
// This driver generates the input credit signal in the router output ports.
// It allows to change the random prob of asserting this signal.
// It is only used when the agent is attached with a unconnected output port 
// TODO setar range de 0.0 a 1.0
/////////////////////
// hermes driver for outgoing packets
class hermes_slave_driver extends hermes_base_driver;
`uvm_component_utils(hermes_slave_driver);

// logic used to randomize credit at the output port
credit_class credit;

function new(string name, uvm_component parent);
  super.new(name, parent);
endfunction : new

function void build_phase(uvm_phase phase);
	bit [3:0] distrib;
	super.build_phase(phase);

  	// print config_db
	//print_config();

	// this should be set by the test, for each output agent
	if (!uvm_config_db #(bit [3:0])::get (this,"", "cred_distrib", distrib) )
		`uvm_fatal("monitor", "No cred_distrib");
	`uvm_info("driver", $sformatf("got cred_distrib %0d",distrib), UVM_HIGH)
	if ( !(distrib >= 1 && distrib <= 10))
		`uvm_fatal("monitor", "cred_distrib must be between 1 and 10");

	// the random distribution is set only once per driver. does not seem necessary to change it during runtime
	credit = new(distrib);

	`uvm_info("msg", "DRIVER Done!!!", UVM_HIGH)
endfunction : build_phase


// generates random credit signal at the output port, simulating neighbor congested routers with full buffers
task run_phase(uvm_phase phase);
	dut_vi.credit = 0;
	@(negedge dut_vi.reset);
	forever
	begin
		if( !credit.randomize() )
			`uvm_error("monitor", "invalid credit randomization"); 
		dut_vi.credit = credit.credit;
		@(posedge dut_vi.clock);
	end
endtask: run_phase

endclass: hermes_slave_driver
