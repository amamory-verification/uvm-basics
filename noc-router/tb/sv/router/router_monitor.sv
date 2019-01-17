
// the monitor class
class router_monitor extends uvm_monitor;
`uvm_component_utils(router_monitor);

uvm_analysis_port #(packet_t) aport; // used to send the output packet to the sb

virtual router_if dut_vi;
bit [3:0] port;

// logic used to randomize credit at the output port
//credit_class credit;


function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  bit [3:0] cred_distrib;
  aport = new("aport", this); 


  // print config_db
  //print_config();

  if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
    `uvm_fatal("monitor", "No port");
  `uvm_info("monitor", $sformatf("PORT number: %0d",port), UVM_HIGH)

  //if(!uvm_config_db#(virtual router_if)::read_by_name($sformatf("monitor%0d",port), "out_if", dut_vi))
  if(!uvm_config_db#(virtual router_if)::get (this,"", "if", dut_vi))
      `uvm_fatal("monitor", "No in_if");

//  if (!uvm_config_db #(bit [3:0])::get (this,"", "cred_distrib", cred_distrib) )
//    `uvm_fatal("monitor", "No cred_distrib");
//  `uvm_info("monitor", $sformatf("got cred_distrib %0d",cred_distrib), UVM_HIGH)
  //credit = new(cred_distrib);

  `uvm_info("msg", "MONITOR Done !!!", UVM_HIGH)
endfunction: build_phase

/*
function void end_of_elaboration();
  uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW);
endfunction
*/

// generates random credit signal at the output port, simulating neighbor congested routers with full buffers
task set_credit;
  dut_vi.credit = 0;
  @(negedge dut_vi.reset);
  dut_vi.credit = 1;
  /*
  forever
  begin
    if( !credit.randomize() )
      `uvm_error("monitor", "invalid credit randomization"); 
    dut_vi.credit = credit.credit;
    @(posedge dut_vi.clock);
  end
  */
endtask

// extract packets from the output interface and send them to the scoreboard
task extract_packets;
  packet_t tx;
  int i,size;
  @(negedge dut_vi.reset);
  @(negedge dut_vi.clock);

  forever
  begin
    tx = packet_t::type_id::create("tx");
    `uvm_info("monitor", $sformatf("%s getting new transaction",get_full_name()), UVM_HIGH)
    // TODO ideally I would call a task from the BFM to let the monitor cleaner. however, it is not working. 
    // I will investigate more in the future
    //dut_vi.get_packet(tx, port);

    // get the header
    @(negedge dut_vi.clock iff (dut_vi.credit == 1'b1 && dut_vi.avail == 1'b1) );
    tx.set_header(dut_vi.data);
    `uvm_info("monitor", $sformatf("%s got header %H",get_full_name(),dut_vi.data), UVM_HIGH)
      
    // get the packet size from the 1st flits
    @(negedge dut_vi.clock iff (dut_vi.credit == 1'b1 && dut_vi.avail == 1'b1) );
    size = dut_vi.data;
    `uvm_info("monitor", $sformatf("%s got size %0d",get_full_name(),size), UVM_HIGH)  

    tx.payload = new[size];
    // get the payload
    i=0;
    while(i<tx.payload.size()) // size() accounts only for the payload size
    begin
      @(negedge dut_vi.clock iff (dut_vi.credit == 1'b1 && dut_vi.avail == 1'b1) );
      tx.payload[i] = dut_vi.data;
      `uvm_info("monitor", $sformatf("%s got flit %0d %H",get_full_name(),i,tx.payload[i]), UVM_HIGH)
      i ++;
    end
    `uvm_info("monitor", $sformatf("%s got payload",get_full_name()), UVM_HIGH)

    tx.oport = port; // set the sb output ap for verification
    aport.write(tx);
  end  
endtask


task run_phase(uvm_phase phase);
  fork
    extract_packets();
    set_credit();
  join_none

endtask: run_phase

endclass : router_monitor
