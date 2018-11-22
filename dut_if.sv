interface dut_if;

	logic clock, reset;
    logic cmd;
    logic  [3:0] addr;
    logic  [3:0] data;

endinterface : dut_if
