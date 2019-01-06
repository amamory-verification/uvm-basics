/*
 this hierarchical sequence injects injects 5 'basic_seq' in sequential port order, starting with the port 'starting_port'.
*/
class sequential_seq extends base_vseq; 
`uvm_object_utils(sequential_seq)

// the initial port packets are injected. The next ports follows the order such that, for instance, if starting_port == 3, then the order is 3, 4, 0, 1, 2.
rand bit [3:0] starting_port;

constraint c_starting_port {
  starting_port inside { [0:router_pkg::NPORT-1] };
}

function new(string name = "sequential_seq");
  super.new(name);
endfunction: new

task body;
  basic_seq seq;
  seq_config bs_cfg;
  int j = starting_port;

  // configuring sequence parameters
  seq = basic_seq::type_id::create("seq");
  bs_cfg = seq_config::type_id::create("seq_cfg");
  bs_cfg.do_copy(cfg); 
  bs_cfg.rand_mode(0);
  bs_cfg.header.rand_mode(1); 
  bs_cfg.port.rand_mode(1); 
  //$display("%s",cfg.convert2string());
  //$display("%s",bs_cfg.convert2string());   
  for (int i = 0; i < router_pkg::NPORT; i++) begin

    // it is necessary to randomize since it is changing the port, which is related to the header field
    if( !bs_cfg.randomize() with { 
        // input port
        port == j % router_pkg::NPORT;
      }
    )
      `uvm_error("rand", "invalid cfg randomization"); 
    //$display("%s",bs_cfg.convert2string());
    // configure the sequence
    seq.set_seq_config(bs_cfg); 

    if( !seq.randomize())
      `uvm_error("rand", "invalid seq randomization"); 
    seq.start (sequencer[bs_cfg.port]);

    j = j +1;
  end
endtask: body

endclass: sequential_seq

