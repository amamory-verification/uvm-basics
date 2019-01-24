// the monitor class
class hermes_monitor extends uvm_monitor;
`uvm_component_utils(hermes_monitor);

uvm_analysis_port #(hermes_packet_t) aport; // used to send the output packet to the sb

virtual hermes_if dut_vi;
bit [3:0] port;

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  aport = new("aport", this); 

  // print config_db
  if (uvm_top.get_report_verbosity_level() >= UVM_HIGH)
    print_config();

  if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
    `uvm_fatal("monitor", "No port");
  `uvm_info("monitor", $sformatf("PORT number: %0d",port), UVM_HIGH)

  if(!uvm_config_db#(virtual hermes_if)::get (this,"", "if", dut_vi))
      `uvm_fatal("monitor", "No if");

  `uvm_info("msg", "MONITOR Done !!!", UVM_HIGH)
endfunction: build_phase

/*
function void end_of_elaboration();
  uvm_report_info(get_full_name(),"End_of_elaboration", UVM_LOW);
endfunction
*/

// extract packets from the output interface and send them to the scoreboard
task run_phase(uvm_phase phase);
  hermes_packet_t tx;
  int i,size;
  @(negedge dut_vi.reset);
  @(negedge dut_vi.clock);

  forever
  begin
    tx = hermes_packet_t::type_id::create("tx");
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
    `uvm_info("monitor", tx.convert2string(), UVM_MEDIUM)
    aport.write(tx);
  end  
endtask

endclass : hermes_monitor
