//class router_scoreboard extends uvm_subscriber #(packet_t);
class router_scoreboard extends uvm_scoreboard;

`uvm_component_utils(router_scoreboard);

//uvm_analysis_port # (packet_t) drv_ap[router_pkg::NPORT]; // from driver  to sb
//uvm_analysis_port # (packet_t) mon_ap[router_pkg::NPORT]; // from monitor to sb

uvm_analysis_port # (packet_t) drv_ap; // from driver  to sb
uvm_analysis_port # (packet_t) mon_ap; // from monitor to sb

uvm_tlm_analysis_fifo #(packet_t) input_fifo;
uvm_tlm_analysis_fifo #(packet_t) output_fifo;

int packet_matches, packet_mismatches; 


function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new


function void build_phase(uvm_phase phase);
  // build the driver's and monitor's analysis ports to connecto to the sb
  /*
  foreach drv_ap[i] begin
    drv_ap[i] = new( $sformatf("drv_ap%0d",i)), this); 
  end
  foreach mon_ap[i] begin
    mon_ap[i] = new( $sformatf("mon_ap%0d",i)), this); 
  end
  */
  drv_ap = new( "drv_ap", this);
  mon_ap = new( "mon_ap", this); 
  input_fifo  = new( "input_fifo", this); 
  output_fifo = new( "output_fifo", this); 
endfunction: build_phase


function void connect_phase(uvm_phase phase);
  drv_ap.connect(input_fifo.analysis_export);
  mon_ap.connect(output_fifo.analysis_export);
endfunction: connect_phase

/*
task run();
  packet_t out_packet;

  forever begin
    output_fifo.get(out_packet);
    compare();
  end
endtask: run
*/

task run_phase(uvm_phase phase);
  fork
    get_data(input_fifo,1);
    get_data(output_fifo,0);
  join
endtask: run_phase


task get_data(uvm_tlm_analysis_fifo #(packet_t) fifo , input bit in);
  packet_t tx;
  forever begin
    fifo.get(tx);
    if (in == 1) begin  
      `uvm_info("SCOREBOARD", "INPUT PACKET RECEIVED !!!!", UVM_LOW);
    end else begin
      `uvm_info("SCOREBOARD", "OUTPUT PACKET RECEIVED !!!!", UVM_LOW);
    end
  end
endtask: get_data


virtual function void compare( );
/*
  if(transaction_before.out == transaction_after.out) begin
    `uvm_info("compare", {"Test: OK!"}, UVM_LOW);
  end else begin
    `uvm_info("compare", {"Test: Fail!"}, UVM_LOW);
  end
  */
  `uvm_info("SCOREBOARD", "PACKET RECEIVED !!!!", UVM_LOW);
endfunction: compare

/*
// checks leftover packets in the FIFOs
virtual function void extract_phase( uvm_phase phase );
  packet_t t;

  super.extract_phase( phase );
  if ( input_fifo.try_get( t ) ) begin
     `uvm_error( "input_fifo", 
                 { "found a leftover packet: ", t.convert2string() } )
  end

  if ( output_fifo.try_get( jelly_bean ) ) begin
     `uvm_error( "output_fifo",
                 { "found a leftover packet: ", t.convert2string() } )
  end
endfunction: extract_phase
*/


endclass: router_scoreboard