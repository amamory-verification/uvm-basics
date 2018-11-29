---------------------------------------------------------------------------------------------
-- Author:          Martin Kumm
-- Contact:         kumm@uni-kassel.de
-- License:         LGPL
-- Date:            31.10.2014
-- Compatibility:   Xilinx FPGAs of Virtex 5-7, Spartan 6 and Series 7 architectures
--
-- Description:
-- Simple register chain for a delay with arbitrary length (set by generic delay)
---------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity register_chain is
  generic(
    word_size : integer;
    delay : integer
  );
  port(
      clk_i : in std_logic;
      rst_i : in std_logic;
	  ce_i  : in  std_logic;
      d_i : in std_logic_vector(word_size-1 downto 0);
      q_o : out std_logic_vector(word_size-1 downto 0)
  );
end register_chain;

architecture register_chain_arch of register_chain is

type register_line is array(0 to delay-1) of std_logic_vector(word_size-1 downto 0);

signal d_delayed : register_line;

begin

implement_register_chain: if delay > 0 generate
	process (clk_i, rst_i)
	begin
		if rst_i = '1' then
	    for i in 0 to delay-1 loop
	      d_delayed(i) <= (others => '0');
	    end loop;
		elsif clk_i'event and clk_i = '1' then
			if ce_i = '1' then
		    d_delayed(0) <= d_i;
		
		    for i in 0 to delay-2 loop
		      d_delayed(i+1) <= d_delayed(i);
		    end loop;
	    end if;
	  end if;
	end process;
	q_o <= d_delayed(delay-1);
end generate;

implement_wire: if delay = 0 generate
	q_o <= d_i;
end generate;

end register_chain_arch;