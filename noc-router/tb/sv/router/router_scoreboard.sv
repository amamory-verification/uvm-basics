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
int packets_sent, packets_received; 


packet_t input_packet_queue[$];


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
  packet_matches = 0;
  packet_mismatches = 0;
  packets_sent = 0;
  packets_received = 0;
endfunction: build_phase


function void connect_phase(uvm_phase phase);
  drv_ap.connect(input_fifo.analysis_export);
  mon_ap.connect(output_fifo.analysis_export);
endfunction: connect_phase

// main task
task run_phase(uvm_phase phase);
  fork
    get_input_data(input_fifo);
    get_output_data(output_fifo);
  join
endtask: run_phase

// task for input packets
task get_input_data(uvm_tlm_analysis_fifo #(packet_t) fifo);
  packet_t tx;
  forever begin
    fifo.get(tx);
    input_packet_queue.push_back(tx);
    packets_sent++;
    `uvm_info("SCOREBOARD", "INPUT PACKET RECEIVED !!!!", UVM_LOW);
  end
endtask: get_input_data

// task for output packets
task get_output_data(uvm_tlm_analysis_fifo #(packet_t) fifo);
  packet_t tx;
  int i;
  bit found;
  forever begin
    tx = packet_t::type_id::create("tx");
    fifo.get(tx);
    packets_received++;
    `uvm_info("SCOREBOARD", "OUTPUT PACKET RECEIVED !!!!", UVM_LOW);
    if (input_packet_queue.size() == 0) begin
       `uvm_error("SB_MISMATCH", $sformatf("INPUT PACKET QUEUE IS EMPTY !!!!\n%s",tx.convert2string()));
       packet_mismatches++;
    end
    found = 0;
    for( i=0; i< input_packet_queue.size(); i++) begin
      //$display("%s",input_packet_queue[i].convert2string());
      if (input_packet_queue[i].compare(tx)) begin
        if (check_xy_routing (tx.x, tx.y, input_packet_queue[i].dport, tx.oport)) begin
          `uvm_info("SB_MATCH", $sformatf("packet received successfully !!!!\n%s",tx.convert2string()), UVM_LOW);
          packet_matches++;
          found = 1;
          input_packet_queue.delete(i);
          break;
        end else
          `uvm_error("SB_MISMATCH", $sformatf("INVALID ROUTING !!!!\n%s",tx.convert2string()));
      end
    end
    if (found == 0) begin  
       `uvm_error("SB_MISMATCH", $sformatf("PACKET MISMATCH !!!!\n%s",tx.convert2string()));
       packet_mismatches++;      
    end 
  end
endtask: get_output_data


// checks leftover packets in the FIFOs
virtual function void extract_phase( uvm_phase phase );
  packet_t t;

  super.extract_phase( phase );

  `uvm_info("msg", $sformatf("simulation summary:\n   sent packets: %0d\n   received packets: %0d\n   matches: %0d\n   mismatches: %0d"
      ,packets_sent, packets_received, packet_matches, packet_mismatches), UVM_NONE);

  if (packets_sent == 0)
    `uvm_error("SB_MISMATCH", $sformatf("no packets sent"));
  if (packets_received == 0)
    `uvm_error("SB_MISMATCH", $sformatf("no packets received"));
  if (packets_sent > 0 && (packets_sent != packets_received))
    `uvm_error("SB_MISMATCH", $sformatf("number of packets sent %0d is different from the number of packets received %0d",packets_sent, packets_received));
  if (packet_mismatches != 0)
    `uvm_error("SB_MISMATCH", $sformatf("%0d mismatches detected", packet_mismatches));
  if (packets_sent > 0 && (packet_matches != packets_sent))
    `uvm_error("SB_MISMATCH", $sformatf("number of packets sent %0d is different from the number of packets with match %0d",packets_sent, packet_matches));

  if (input_packet_queue.size() > 0)
    `uvm_error( "SB_MISMATCH", { "found %0d leftover packet at the input queue: ", input_packet_queue.size()} )

  if ( input_fifo.try_get( t ) ) 
    `uvm_error( "SB_MISMATCH", { "found a leftover packet at the input_fifo: ", t.convert2string() } )

  if ( output_fifo.try_get( t ) ) 
    `uvm_error( "SB_MISMATCH", { "found a leftover packet at the output_fifo: ", t.convert2string() } )
endfunction: extract_phase

/* check the XY routing algorithm

current router address is: 
  router_pkg::X_ADDR = 1;
  router_pkg::Y_ADDR = 1;
the routing logic is :  
        lx <= address((METADEFLIT - 1) downto QUARTOFLIT);
        ly <= address((QUARTOFLIT - 1) downto 0);

        tx <= header((METADEFLIT - 1) downto QUARTOFLIT);
        ty <= header((QUARTOFLIT - 1) downto 0);

        dirx <= WEST when lx > tx else EAST;
        diry <= NORTH when ly < ty else SOUTH
*/
function bit check_xy_routing (byte x, byte y, byte ip, byte op);
  const byte EAST  = 0;
  const byte WEST  = 1;
  const byte NORTH = 2;
  const byte SOUTH = 3;
  const byte LOCAL = 4;

  `uvm_info("SCOREBOARD", $sformatf("checking XY %0d %0d %0d %0d",x,y,ip,op), UVM_HIGH);
  // if the target is the router itself, then the ouput must be LOCAL
  if (router_pkg::X_ADDR == x && router_pkg::Y_ADDR == y) begin
    if(op==LOCAL) begin
      // Hermes router does not allow loopback
      if (ip==LOCAL)
        return 0;
      else
        return 1;
    end 
    else
      return 0;
  end


  // XY routing algorithm moves horizontaly until it reaches the correct Y axis
  if (router_pkg::X_ADDR > x) begin
    if(op==WEST) begin
      // the turn N->W or S-W is invalid
      if (ip == NORTH || ip == SOUTH) 
        return 0;
      else
        return 1;
    end
    else
      return 0;
  end 

  else begin
    if (router_pkg::X_ADDR < x) begin
      if(op==EAST) begin
        // the turn N->E or S-E is invalid
        if (ip == NORTH || ip == SOUTH) 
          return 0;
        else
          return 1; 
      end       
      else
        return 0;
    end else begin
      if (router_pkg::X_ADDR == x) begin
        // now checks the vertical movement
        if (router_pkg::Y_ADDR < y) begin
          if(op==NORTH)
            return 1;
          else
            return 0;
        end else begin
          if(op==SOUTH)
            return 1;
          else
            return 0;
        end
      end
    end
  end
  return 0;
endfunction: check_xy_routing 


endclass: router_scoreboard