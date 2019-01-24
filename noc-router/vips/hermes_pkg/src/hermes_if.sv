interface hermes_if (input bit clock, input bit reset);
	import hermes_pkg::*;

//	bit reset;

/*
Each of the five interfaces has the following ports:
--                             PORT
--                         _____________
--                   RX ->|             |-> TX
--              DATA_IN ->|             |-> DATA_OUT
--             CLOCK_RX ->|             |-> CLOCK_TX
--             CREDIT_O <-|             |<- CREDIT_I
--                        |             |
                           _____________
*/

    logic        clk, avail,  credit;
    logic [15:0]  data;

    modport datain (
            input clk, avail, data,
            output credit
        );
    modport dataout (
            output clk, avail, data,
            input credit
        );     

endinterface : hermes_if
