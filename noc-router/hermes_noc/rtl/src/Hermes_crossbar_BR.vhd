----------------------------------------------------------------
--                                   CROSSBAR
--                                    --------------
--              DATA_AV ->|                 |
--              DATA_IN ->|                 |
--            DATA_ACK <-|                 |-> TX
--                 SENDER ->|                 |-> DATA_OUT
--                       FREE ->|                  |<- CREDIT_I
--                 TAB_IN ->|                  |
--              TAB_OUT ->|                  |
--                                    --------------
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.HermesPackage.all;

entity Hermes_crossbar_BR is
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
end Hermes_crossbar_BR;

architecture AlgorithmXY of Hermes_crossbar_BR is

begin
	tx(SOUTH) <= '0';
	data_out(SOUTH) <= (others=>'0');
	data_ack(SOUTH) <= '0';
	tx(EAST) <= '0';
	data_out(EAST) <= (others=>'0');
	data_ack(EAST) <= '0';
----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
	tx(LOCAL) <= data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			'0';

	data_out(LOCAL) <= data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			(others=>'0');

	data_ack(LOCAL) <= credit_i(WEST)  when tab_in(LOCAL)="001" and data_av(LOCAL)='1' else
			credit_i(NORTH) when tab_in(LOCAL)="010" and data_av(LOCAL)='1' else			
			'0';
----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
	tx(WEST) <= data_av(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			'0';

	data_out(WEST) <= data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			(others=>'0');

	data_ack(WEST) <= credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else			
			credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
	tx(NORTH) <= data_av(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else			
			data_av(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			'0';

	data_out(NORTH) <= data_in(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else			
			data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			(others=>'0');

	data_ack(NORTH) <= credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
			'0';
end AlgorithmXY;
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
architecture AlgorithmWFNM of Hermes_crossbar_BR is

begin
	tx(SOUTH) <= '0';
	data_out(SOUTH) <= (others=>'0');
	data_ack(SOUTH) <= '0';
	tx(EAST) <= '0';
	data_out(EAST) <= (others=>'0');
	data_ack(EAST) <= '0';
----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
	tx(LOCAL) <= data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			'0';

	data_out(LOCAL) <= data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			(others=>'0');

	data_ack(LOCAL) <= credit_i(WEST)  when tab_in(LOCAL)="001" and data_av(LOCAL)='1' else
			credit_i(NORTH) when tab_in(LOCAL)="010" and data_av(LOCAL)='1' else			
			'0';
----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
	tx(WEST) <= data_av(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			'0';

	data_out(WEST) <= data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			(others=>'0');

	data_ack(WEST) <= credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else
			credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
	tx(NORTH) <= data_av(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else
			data_av(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			'0';

	data_out(NORTH) <= data_in(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else
			data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			(others=>'0');

	data_ack(NORTH) <= credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
			'0';
end AlgorithmWFNM;
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
architecture AlgorithmNLNM of Hermes_crossbar_BR is

begin
	tx(SOUTH) <= '0';
	data_out(SOUTH) <= (others=>'0');
	data_ack(SOUTH) <= '0';
	tx(EAST) <= '0';
	data_out(EAST) <= (others=>'0');
	data_ack(EAST) <= '0';
----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
	tx(LOCAL) <= data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			'0';

	data_out(LOCAL) <= data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			(others=>'0');

	data_ack(LOCAL) <= credit_i(WEST)  when tab_in(LOCAL)="001" and data_av(LOCAL)='1' else
			credit_i(NORTH) when tab_in(LOCAL)="010" and data_av(LOCAL)='1' else
			'0';

----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
	tx(WEST) <= data_av(NORTH) when tab_out(WEST)="010" and free(WEST)='0' else
			data_av(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			'0';

	data_out(WEST) <= data_in(NORTH) when tab_out(WEST)="010" and free(WEST)='0' else
			data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			(others=>'0');

	data_ack(WEST) <= credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else				
			credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
	tx(NORTH) <= data_av(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else			
			data_av(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			'0';

	data_out(NORTH) <= data_in(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else			
			data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			(others=>'0');

	data_ack(NORTH) <= credit_i(WEST) when tab_in(NORTH)="001" and data_av(NORTH)='1' else 			
			credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
			'0';
end AlgorithmNLNM;
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
architecture AlgorithmNFNM of Hermes_crossbar_BR is

begin
	tx(SOUTH) <= '0';
	data_out(SOUTH) <= (others=>'0');
	data_ack(SOUTH) <= '0';
	tx(EAST) <= '0';
	data_out(EAST) <= (others=>'0');
	data_ack(EAST) <= '0';
----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
	tx(LOCAL) <= data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			'0';

	data_out(LOCAL) <= data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			(others=>'0');

	data_ack(LOCAL) <= credit_i(WEST)  when tab_in(LOCAL)="001" and data_av(LOCAL)='1' else
			credit_i(NORTH) when tab_in(LOCAL)="010" and data_av(LOCAL)='1' else			
			'0';
----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
	tx(WEST) <= data_av(NORTH)  when tab_out(WEST)="010" and free(WEST)='0' else
			data_av(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			'0';

	data_out(WEST) <= data_in(NORTH)  when tab_out(WEST)="010" and free(WEST)='0' else
			data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			(others=>'0');

	data_ack(WEST) <= credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else
			credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
	tx(NORTH) <= data_av(WEST) when tab_out(NORTH)="001" and free(NORTH)='0' else			
			data_av(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			'0';

	data_out(NORTH) <= data_in(WEST) when tab_out(NORTH)="001" and free(NORTH)='0' else		
			data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			(others=>'0');

	data_ack(NORTH) <= credit_i(WEST)  when tab_in(NORTH)="001" and data_av(NORTH)='1' else
			credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
			'0';
end AlgorithmNFNM;
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
architecture AlgorithmWFM of Hermes_crossbar_BR is

begin
	tx(SOUTH) <= '0';
	data_out(SOUTH) <= (others=>'0');
	data_ack(SOUTH) <= '0';
	tx(EAST) <= '0';
	data_out(EAST) <= (others=>'0');
	data_ack(EAST) <= '0';
----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
	tx(LOCAL) <= data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			'0';

	data_out(LOCAL) <= data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			(others=>'0');

	data_ack(LOCAL) <= credit_i(WEST)  when tab_in(LOCAL)="001" and data_av(LOCAL)='1' else
			credit_i(NORTH) when tab_in(LOCAL)="010" and data_av(LOCAL)='1' else			
			'0';
----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
	tx(WEST) <= data_av(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			'0';

	data_out(WEST) <= data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			(others=>'0');

	data_ack(WEST) <= credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else
			credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
	tx(NORTH) <= data_av(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else
			data_av(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			'0';

	data_out(NORTH) <= data_in(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else
			data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			(others=>'0');

	data_ack(NORTH) <= credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
			'0';
end AlgorithmWFM;
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
architecture AlgorithmNLM of Hermes_crossbar_BR is

begin
	tx(SOUTH) <= '0';
	data_out(SOUTH) <= (others=>'0');
	data_ack(SOUTH) <= '0';
	tx(EAST) <= '0';
	data_out(EAST) <= (others=>'0');
	data_ack(EAST) <= '0';
----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
	tx(LOCAL) <= data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			'0';

	data_out(LOCAL) <= data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			(others=>'0');

	data_ack(LOCAL) <= credit_i(WEST)  when tab_in(LOCAL)="001" and data_av(LOCAL)='1' else
			credit_i(NORTH) when tab_in(LOCAL)="010" and data_av(LOCAL)='1' else
			'0';

----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
	tx(WEST) <= data_av(NORTH) when tab_out(WEST)="010" and free(WEST)='0' else
			data_av(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			'0';

	data_out(WEST) <= data_in(NORTH) when tab_out(WEST)="010" and free(WEST)='0' else
			data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			(others=>'0');

	data_ack(WEST) <= credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else				
			credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
	tx(NORTH) <= data_av(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else			
			data_av(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			'0';

	data_out(NORTH) <= data_in(WEST)  when tab_out(NORTH)="001" and free(NORTH)='0' else			
			data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			(others=>'0');

	data_ack(NORTH) <= credit_i(WEST) when tab_in(NORTH)="001" and data_av(NORTH)='1' else 			
			credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
			'0';
end AlgorithmNLM;
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------
architecture AlgorithmNFM of Hermes_crossbar_BR is

begin
	tx(SOUTH) <= '0';
	data_out(SOUTH) <= (others=>'0');
	data_ack(SOUTH) <= '0';
	tx(EAST) <= '0';
	data_out(EAST) <= (others=>'0');
	data_ack(EAST) <= '0';
----------------------------------------------------------------------------------
-- PORTA LOCAL
----------------------------------------------------------------------------------
	tx(LOCAL) <= data_av(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_av(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			'0';

	data_out(LOCAL) <= data_in(WEST)  when tab_out(LOCAL)="001" and free(LOCAL)='0' else
			data_in(NORTH) when tab_out(LOCAL)="010" and free(LOCAL)='0' else			
			(others=>'0');

	data_ack(LOCAL) <= credit_i(WEST)  when tab_in(LOCAL)="001" and data_av(LOCAL)='1' else
			credit_i(NORTH) when tab_in(LOCAL)="010" and data_av(LOCAL)='1' else			
			'0';
----------------------------------------------------------------------------------
-- PORTA WEST
----------------------------------------------------------------------------------
	tx(WEST) <= data_av(NORTH)  when tab_out(WEST)="010" and free(WEST)='0' else
			data_av(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			'0';

	data_out(WEST) <= data_in(NORTH)  when tab_out(WEST)="010" and free(WEST)='0' else
			data_in(LOCAL) when tab_out(WEST)="100" and free(WEST)='0' else
			(others=>'0');

	data_ack(WEST) <= credit_i(NORTH) when tab_in(WEST)="010" and data_av(WEST)='1' else
			credit_i(LOCAL) when tab_in(WEST)="100" and data_av(WEST)='1' else
			'0';
----------------------------------------------------------------------------------
-- PORTA NORTH
----------------------------------------------------------------------------------
	tx(NORTH) <= data_av(WEST) when tab_out(NORTH)="001" and free(NORTH)='0' else			
			data_av(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			'0';

	data_out(NORTH) <= data_in(WEST) when tab_out(NORTH)="001" and free(NORTH)='0' else		
			data_in(LOCAL) when tab_out(NORTH)="100" and free(NORTH)='0' else
			(others=>'0');

	data_ack(NORTH) <= credit_i(WEST)  when tab_in(NORTH)="001" and data_av(NORTH)='1' else
			credit_i(LOCAL) when tab_in(NORTH)="100" and data_av(NORTH)='1' else
			'0';
end AlgorithmNFM;
