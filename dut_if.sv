interface dut_if;

	logic clk, rst;
    logic cmd;
    logic  [7:0] addr;
    logic  [7:0] data;
    logic  [7:0] dout;

endinterface : dut_if
