class router_monitor extends uvm_monitor;
`uvm_component_utils(router_monitor);

uvm_analysis_port #(packet_t) aport; // used to send the output packet to the sb

virtual router_if dut_vi;
bit [3:0] port;

function new(string name, uvm_component parent);
  super.new(name,parent);
endfunction: new

function void build_phase(uvm_phase phase);
  aport = new("aport", this); 
  if (!uvm_config_db #(virtual router_if)::get (null,"*", "dut_vi", dut_vi) )
    `uvm_fatal("monitor", "No DUT_IF");  
  if (!uvm_config_db #(bit [3:0])::get (this,"", "port", port) )
    `uvm_fatal("monitor", "No port");
  $display("PORT number: %s - %0d",get_full_name() ,port);
  `uvm_info("msg", "MONITOR Done !!!", UVM_HIGH)
endfunction: build_phase

task run_phase(uvm_phase phase);
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
    @(posedge dut_vi.tx[port]);
    @(negedge dut_vi.clock);
    tx.set_header(dut_vi.data_out[port]);
    `uvm_info("monitor", $sformatf("%s got header %H",get_full_name(),dut_vi.data_out[port]), UVM_HIGH)
      
    //credit_i[port] = 1'b1;
      
    // get the packet size from the 1st flits
    while (1'b1)
    begin
      @(negedge dut_vi.clock);
      if (dut_vi.tx[port] == 1'b1) begin
        size = dut_vi.data_out[port];
        `uvm_info("monitor", $sformatf("%s got size %0d",get_full_name(),size), UVM_HIGH)
        break;
      end
    end
    tx.payload = new[size];
    // get the payload
    i=0;
    while(i<tx.payload.size()) // size() accounts only for the payload size
    begin
      @(negedge dut_vi.clock);
      if (dut_vi.tx[port] == 1'b1) begin
        tx.payload[i] = dut_vi.data_out[port];
        `uvm_info("monitor", $sformatf("%s got flit %0d %H",get_full_name(),i,tx.payload[i]), UVM_HIGH)
        i ++;
      end
    end
    `uvm_info("monitor", $sformatf("%s got payload",get_full_name()), UVM_HIGH)

    tx.oport = port; // set the sb output ap for verification
    aport.write(tx);
  end
endtask: run_phase

endclass : router_monitor
