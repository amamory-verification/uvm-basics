class hermes_router_coverage extends uvm_subscriber #(hermes_packet_t);
`uvm_component_utils(hermes_router_coverage);

bit [3:0] oport, iport, x, y;
bit [7:0] packet_size;


// used to check if all input ports sent packets to all output ports, except in case of loopback
covergroup cg_ports;
  cp_iport: coverpoint iport { 
      bins port[]    = {[0:4]};  // input ports. one bin per port
  }
  cp_oport: coverpoint oport { 
      bins port[]    = {[0:4]};  // output ports. one bin per port
  }

  x_io_ports:  cross cp_iport, cp_oport{
    // exclude invalid turns, like N-> W
    // example from https://www.amiq.com/consulting/2014/09/17/how-to-ignore-cross-coverage-bins-using-expressions-in-systemverilog/
    function CrossQueueType createIgnoreBins();
      createIgnoreBins.push_back('{hermes_pkg::NORTH,hermes_pkg::EAST});
      createIgnoreBins.push_back('{hermes_pkg::NORTH,hermes_pkg::WEST});
      createIgnoreBins.push_back('{hermes_pkg::SOUTH,hermes_pkg::EAST});
      createIgnoreBins.push_back('{hermes_pkg::SOUTH,hermes_pkg::WEST});
    endfunction
    ignore_bins ignore_invalid_turns = createIgnoreBins();    
    // exclude loopback from cross_coverage
    ignore_bins loopback = x_io_ports with (cp_iport == cp_oport);
  }
endgroup: cg_ports

// used to checke whether all routers in the noc received packets from this router
covergroup cg_noc_addr;
  cp_x: coverpoint x { 
      bins addr[]    = {[0:hermes_pkg::X_MAX]};  // x noc addr. 
  }
  cp_y: coverpoint y { 
      bins addr[]    = {[0:hermes_pkg::Y_MAX]};  // y noc addr
  }

  x_noc_addr:  cross cp_x, cp_y;
endgroup: cg_noc_addr

// used to check if packets from all possible sizes were simulated
covergroup cg_packet_sizes;
  cp_sizes: coverpoint packet_size { 
      bins port[]    = {[0:128]};  // valid packet lenghts. one bin per size
  }
endgroup: cg_packet_sizes
 
function void write(hermes_packet_t t);
  oport = t.oport;
  iport = t.dport;
  x = t.x;
  y = t.y;
  packet_size = t.payload.size();

  cg_ports.sample();
  cg_packet_sizes.sample();
  cg_noc_addr.sample();
  `uvm_info("COVERAGE", "PACKET RECEIVED !!!!", UVM_HIGH);
endfunction: write 

function new(string name, uvm_component parent);
  super.new(name,parent);
  cg_ports = new();
  cg_packet_sizes = new();
  cg_noc_addr = new();
endfunction: new


endclass: hermes_router_coverage