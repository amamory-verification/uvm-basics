------------------------------------------------------------------------------------------------
--
--  DISTRIBUTED HEMPS  - version 5.0
--
--  Research group: GAPH-PUCRS    -    contact   fernando.moraes@pucrs.br
--
--  Distribution:  September 2013
--
--  Source name:  Hermes_crossbar.vhd
--
--  Brief description: Description of NoC ports
--
----------------------------------------------------------------
--                                   CROSSBAR
--                         --------------
--              DATA_AV ->|              |
--              DATA_IN ->|              |
--             DATA_ACK <-|              |-> TX
--               SENDER ->|              |-> DATA_OUT
--                 FREE ->|              |<- CREDIT_I
--               TAB_IN ->|              |
--              TAB_OUT ->|              |
--                        --------------
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.HeMPS_defaults.all;
use work.HemPS_PKG.all;

entity Hermes_crossbar is
port(
        data_av:     in  regNport;
        data_in:     in  arrayNport_regflit;
        data_ack:    out regNport;
        sender:      in  regNport;
        free:        in  regNport;
        tab_in:      in  arrayNport_reg3;
        tab_out:     in  arrayNport_reg3;
        tx:          out regNport;
        data_out:    out arrayNport_regflit;
        credit_i:    in  regNport);
end Hermes_crossbar;

architecture Hermes_crossbar of Hermes_crossbar is

begin

----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
        tx(LOCAL) <= data_av(EAST) when tab_out(LOCAL)="000" and free(LOCAL)='0' else
                        data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
                        data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else
                        data_av(SOUTH) when tab_out(LOCAL)="011" and free(LOCAL)='0' else
                        '0';

        data_out(LOCAL) <= data_in(EAST) when tab_out(LOCAL)="000" and free(LOCAL)='0' else
                        data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
                        data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else
                        data_in(SOUTH) when tab_out(LOCAL)="011" and free(LOCAL)='0' else
                        (others=>'0');

        data_ack(LOCAL) <= credit_i(EAST) when tab_in(LOCAL)="000" and data_av(LOCAL)='1' else
                        credit_i(WEST)  when tab_in(LOCAL)="001" and data_av(LOCAL)='1' else
                        credit_i(NORTH) when tab_in(LOCAL)="010" and data_av(LOCAL)='1' else
                        credit_i(SOUTH) when tab_in(LOCAL)="011" and data_av(LOCAL)='1' else
                        '0';
----------------------------------------------------------------------------------
-- PORTA EAST
----------------------------------------------------------------------------------
        tx(EAST) <= data_av(WEST) when tab_out(EAST)="001" and free(EAST)='0' else
                        data_av(LOCAL) when tab_out(EAST)="100" and free(EAST)='0' else
                        '0';

        data_out(EAST) <= data_in(WEST) when tab_out(EAST)="001" and free(EAST)='0' else
                        data_in(LOCAL) when tab_out(EAST)="100" and free(EAST)='0' else
                        (others=>'0');

        data_ack(EAST) <= credit_i(WEST) when tab_in(EAST)="001" and data_av(EAST)='1' else
                        credit_i(NORTH) when tab_in(EAST)="010" and data_av(EAST)='1' else
                        credit_i(SOUTH) when tab_in(EAST)="011" and data_av(EAST)='1' else
                        credit_i(LOCAL) when tab_in(EAST)="100" and data_av(EAST)='1' else
                        '0';
----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
        tx(WEST) <= data_av(EAST) when tab_out(WEST)="000" and free(WEST)='0' else
                        data_av(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
                        '0';

        data_out(WEST) <= data_in(EAST) when tab_out(WEST)="000" and free(WEST)='0' else
                        data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
                        (others=>'0');

        data_ack(WEST) <= credit_i(EAST) when tab_in(WEST)="000" and data_av(WEST)='1' else
                        credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else
                        credit_i(SOUTH) when tab_in(WEST)="011" and data_av(WEST)='1' else
                        credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
                        '0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
        tx(NORTH) <= data_av(EAST) when tab_out(NORTH)="000" and free(NORTH)='0' else
                        data_av(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else
                        data_av(SOUTH) when tab_out(NORTH)="011" and free(NORTH)='0' else
                        data_av(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
                        '0';

        data_out(NORTH) <= data_in(EAST) when tab_out(NORTH)="000" and free(NORTH)='0' else
                        data_in(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else
                        data_in(SOUTH) when tab_out(NORTH)="011" and free(NORTH)='0' else
                        data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
                        (others=>'0');

        data_ack(NORTH) <= credit_i(SOUTH) when tab_in(NORTH)="011" and data_av(NORTH)='1' else
                        credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
                        '0';
----------------------------------------------------------------------------------
-- PORTA SOUTH
----------------------------------------------------------------------------------
        tx(SOUTH) <= data_av(EAST) when tab_out(SOUTH)="000" and free(SOUTH)='0' else
                        data_av(WEST)  when tab_out(SOUTH)="001" and free(SOUTH)='0' else
                        data_av(NORTH) when tab_out(SOUTH)="010" and free(SOUTH)='0' else
                        data_av(LOCAL) when tab_out(SOUTH)="100" and free(SOUTH)='0' else
                        '0';

        data_out(SOUTH) <= data_in(EAST) when tab_out(SOUTH)="000" and free(SOUTH)='0' else
                        data_in(WEST)  when tab_out(SOUTH)="001" and free(SOUTH)='0' else
                        data_in(NORTH) when tab_out(SOUTH)="010" and free(SOUTH)='0' else
                        data_in(LOCAL) when tab_out(SOUTH)="100" and free(SOUTH)='0' else
                        (others=>'0');

        data_ack(SOUTH) <= credit_i(NORTH) when tab_in(SOUTH)="010" and data_av(SOUTH)='1' else
                        credit_i(LOCAL) when tab_in(SOUTH)="100" and data_av(SOUTH)='1' else
                        '0';

end Hermes_crossbar;
