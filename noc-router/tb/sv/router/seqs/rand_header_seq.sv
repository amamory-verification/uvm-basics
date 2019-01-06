/*
 this hier sequence injects 'npackets' with random header
*/
class rand_header_seq extends base_vseq; 
`uvm_object_utils(rand_header_seq)


function new(string name = "rand_header_seq");
  super.new(name);
endfunction: new


task body;
  basic_seq seq;
  seq_config bs_cfg;
  seq = basic_seq::type_id::create("seq");
  bs_cfg = seq_config::type_id::create("seq_cfg");
  // copy the configuration to the basic_seq
  bs_cfg.do_copy(cfg);
  //$display("%s",cfg.convert2string());
  //$display("%s",bs_cfg.convert2string());
  // disables randomization, except for the packet header
  bs_cfg.rand_mode(0);
  bs_cfg.npackets = 1; // # of packets sent before the header is randomized again
  bs_cfg.header.rand_mode(1);

  repeat(cfg.npackets)
  begin
    // randomize the header only
    if(!bs_cfg.randomize())
      `uvm_error("rand", "invalid cfg randomization"); 
    //$display("%s",bs_cfg.convert2string());
    seq.set_seq_config(bs_cfg); 
    if( !seq.randomize())
      `uvm_error("rand", "invalid seq randomization"); 
    seq.start (sequencer[bs_cfg.port]);
  end
endtask: body

endclass: rand_header_seq

