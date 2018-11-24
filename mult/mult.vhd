library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mult_serial is
 port (
	A, B : in std_logic_vector(31 downto 0);
	start, reset, clock : in std_logic;
	end_mul : out std_logic;
	produto : out std_logic_vector(63 downto 0)
 );
end mult_serial;

architecture arc of mult_serial is
 signal regP : std_logic_vector(64 downto 0);
 signal cont : std_logic_vector(5 downto 0);

 type state is(init, sum, shift, fim);
 signal EA, PE : state;

begin
 process(clock, reset)
  begin
   if reset = '1' then
    EA <= init;
   elsif rising_edge(clock) then
    EA <= PE;
  end if;
 end process;

 process(EA, start, cont)
  begin
    case EA is
     when init => 
		if start = '1' then
		 PE <= sum;
		elsif start = '0' then
		 PE <= init;
		end if;

     when sum => 
		PE <= shift;

     when shift => 
		   if cont /= 0 then
		    PE <= sum;
		   elsif cont = 0 then
		    PE <= fim;
		   end if;

     when fim =>
		 PE <= init;
   end case;
 end process;


 process(reset, clock)
  begin
   if reset = '1' then
    regP <= (others => '0');
    produto <= (others => '0');
    cont <= (others => '0');
   elsif rising_edge(clock) then
    case EA is
     when init => regP(64 downto 32) <= (others => '0');
		regP(31 downto 0) <= A;
		cont <= "100000";
		end_mul <= '0';

     when sum => cont <= cont-1;
		if regP(0) = '1' then
		 regP(64 downto 32) <= regP(64 downto 32) + ('0' & B);
		end if;

     when shift => 
		   regP <= '0' & regP(64 downto 1);

     when fim => produto <= regP(63 downto 0);
		    end_mul <= '1';
   end case;
  end if;
 end process;
end arc;

------------------------------------------------------------------------
-- verificacao da multiplicador    -  FERNANDO GEHM MORAES   30/out/2017
------------------------------------------------------------------------
library ieee,work;
use ieee.std_logic_1164.all;

entity tb is
end tb;

architecture a1 of tb is 
   signal op1, op2: std_logic_vector(31 downto 0);
   signal produto : std_logic_vector(63 downto 0);
   signal reset, start, end_mul  : std_logic;
   signal clock : std_logic := '0';

 begin
    mu: entity work.mult_serial
             port map( clock => clock, reset => reset, start => start,
                       A => op1, B=> op2, end_mul => end_mul,
                       produto => produto
                     );  
    
    reset <= '1', '0' after 5 ns;    
    clock <= not clock after 5 ns;

    op1 <=  x"12345678",   x"FFFFFFFF" after 800 ns,  x"00123045" after 1600 ns;
    op2 <=  x"33333333",   x"FFFFFFFF" after 800 ns,  x"33333333" after 1600 ns;


---0x3A4114B2F8F21E8,  0x7FFFFFFFFFFFFFFF, 0x3A340FFFC5CBF 


    start <= '0' , '1' after   30 ns, '0' after   50 ns,
                   '1' after  830 ns, '0' after  850 ns,
                   '1' after 1630 ns, '0' after 1650 ns;

        
end architecture;