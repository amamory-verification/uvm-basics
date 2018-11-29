library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity tb_mult_booth_array is
  generic(
    word_size_a   : integer := 8;
    word_size_b   : integer := 8;
    use_pipelining : boolean := true
  );
end tb_mult_booth_array;

architecture tb_arch of tb_mult_booth_array is

	constant no_of_rows : integer := integer(floor(real(word_size_b+2)/2.0));

  signal clk : std_logic := '1';
  signal rst : std_logic;

  signal a : std_logic_vector(word_size_a-1 downto 0);
  signal b : std_logic_vector(word_size_b-1 downto 0);
  signal p_dut,p_ref,p_refd : std_logic_vector(word_size_a+word_size_b-1 downto 0);

begin

  clk <= not clk after 5 ns;
  rst <= '1', '0' after 10 ns;

	mult_booth_array_inst : entity work.mult_booth_array
  generic map (
    word_size_a   => word_size_a,
    word_size_b   => word_size_b,
    use_pipelining => use_pipelining
  )
  port map (
    clk_i => clk,
    rst_i => rst,
    ce_i  => '1',
    a_i   => a,
    b_i   => b,
    p_o   => p_dut
  );


  process
    variable seed1, seed2: positive;
    variable rand : real;
  begin
    a <= (others => '0');
    b <= (others => '0');
    loop
      uniform(seed1, seed2, rand);
      wait until clk'event and clk='0';
      a <= std_logic_vector(to_unsigned(integer(trunc(rand*real(2**word_size_a-1))),word_size_a));
      uniform(seed1, seed2, rand);
      b <= std_logic_vector(to_unsigned(integer(trunc(rand*real(2**word_size_b-1))),word_size_b));
    	p_ref <= std_logic_vector(unsigned(a) * unsigned(b));
    end loop;
  end process;

	delay_ref: if use_pipelining generate
		ref_delay : entity work.register_chain generic map(word_size => word_size_a+word_size_b, delay => no_of_rows-1) port map(clk_i => clk, rst_i => rst, ce_i => '1', d_i => p_ref, q_o => p_refd);
	end generate;

	forward_ref: if not use_pipelining generate
		p_refd <= p_ref;
	end generate;

  process
    variable seed1, seed2: positive;
    variable rand : real;
  begin
    wait until rst'event and rst='0';
    for i in 0 to no_of_rows-1 loop
  		wait until clk'event and clk='0';
  	end loop;
    loop
    	wait until clk'event and clk='0';
      assert (p_dut = p_refd) report "Test failure" severity warning;
    end loop;
  end process;

end architecture;