library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mult_serial is
 port (
	A, B : in std_logic_vector(15 downto 0);
	start, reset, clock : in std_logic;
	done : out std_logic;
	dout : out std_logic_vector(31 downto 0)
 );
end mult_serial;

architecture arc of mult_serial is
  signal regP : std_logic_vector(32 downto 0);
  signal cont : std_logic_vector(4 downto 0);

  type state is(init, sum, shift, fim);
  signal EA, PE : state;
begin

 -- reg FSM
 process(clock, reset)
  begin
   if reset = '1' then
    EA <= init;
   elsif rising_edge(clock) then
    EA <= PE;
  end if;
 end process;

 -- next state FSM
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
    cont <= (others => '0');
    dout <= (others => '0');
    done <=  '0';
   elsif rising_edge(clock) then
    case EA is
     when init => 
        regP(32 downto 16) <= (others => '0');
        regP(15 downto 0) <= A;
        cont <= "10000"; -- 16
        done <= '0';

     when sum => 
        cont <= cont-1;
        if regP(0) = '1' then
          regP(32 downto 16) <= regP(32 downto 16) + ('0' & B);
        end if;

     when shift => 
        regP <= '0' & regP(32 downto 1);

     when fim => 
        dout <= regP(31 downto 0);
        done <= '1';
   end case;
  end if;
 end process;

end architecture arc;

