---------------------------------------------------------------------------------------------
-- Author:          Martin Kumm
-- Contact:         kumm@uni-kassel.de
-- License:         LGPL
-- Date:            31.10.2014
-- Compatibility:   Xilinx FPGAs of Virtex 5-7, Spartan 6 and Series 7 architectures
--
-- Description:
-- Top-Level entity of the implementation of an area efficient Booth Array Multiplier 
-- for Xilinx FPGAs as proposed in:
--
-- M. Kumm, S. Abbas, and P. Zipf, An Efficient Softcore Multiplier Architecture for 
-- Xilinx FPGAs, IEEE Symposium on Computer Arithmetic (ARITH), 2015, pp. 1825
-- DOI: https://doi.org/10.1109/ARITH.2015.17
---------------------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity mult_booth_array is
  generic(
    word_size_a   : integer := 8;
    word_size_b   : integer := 8;
    sync_in_out   : boolean := false;
    use_pipelining : boolean := true
  );
  port(
    clk_i   : in  std_logic;
    rst_i   : in  std_logic;
    ce_i    : in  std_logic;
    a_i     : in std_logic_vector(word_size_a-1 downto 0);
    b_i     : in std_logic_vector(word_size_b-1 downto 0);
    p_o     : out std_logic_vector(word_size_a+word_size_b-1 downto 0)
  );
end entity;

architecture mult_booth_array_arch of mult_booth_array is

	constant no_of_rows : integer := integer(floor(real(word_size_b+2)/2.0));
	constant no_of_slices_per_row : integer := integer(ceil(real(word_size_a+4)/4.0));
	constant no_of_cols : integer := no_of_slices_per_row*4;
	constant unused_luts_in_last_slice : integer := 4*no_of_slices_per_row-no_of_cols;
	
	type pp_type is array(0 to no_of_rows) of std_logic_vector(no_of_cols-1 downto 0);	
	signal pp_i : pp_type;
	signal pp_o : pp_type;

	type carry_type is array(0 to no_of_rows-1) of std_logic_vector(no_of_slices_per_row downto 0);	
	signal carry : carry_type;
	
	signal p_asyn : std_logic_vector(word_size_a+word_size_b-1 downto 0);
	signal a_syn : std_logic_vector(word_size_a-1 downto 0);
	signal b_syn : std_logic_vector(word_size_b-1 downto 0);
	
	type a_type is array(0 to no_of_rows) of std_logic_vector(no_of_cols downto 0);	
	signal a_ext : a_type;
	
	type b_type is array(0 to no_of_rows-1) of std_logic_vector(2 downto 0);	
	signal b_delayed : b_type;

	signal b_ext : std_logic_vector(word_size_b+2 downto 0); --b extended by zeros (1 at LSB and 1 or 2 at MSB)

begin

  process
  begin
		wait until rst_i'event and rst_i='0';
		report "word size a: " & integer'image(word_size_a);
		report "word size b: " & integer'image(word_size_b);
		report "output word size: " & integer'image(word_size_a+word_size_b);
		report "no of rows: " & integer'image(no_of_rows);
		report "no of cols: " & integer'image(no_of_cols);
		report "unused LUTs in last slice: " & integer'image(unused_luts_in_last_slice);
		report "no of slices per row: " & integer'image(no_of_slices_per_row);
		report "no of slices in total: " & integer'image(no_of_rows*no_of_slices_per_row);
		report "using pipelined design: " & boolean'image(use_pipelining);
  end process;

	g_sync_in_out: if sync_in_out generate
		process(rst_i,clk_i)
		begin
			if rst_i ='1' then
				a_syn <= (others => '0');
				b_syn <= (others => '0');
				p_o <= (others => '0');
			elsif clk_i'event and clk_i='1' then
				a_syn <= a_i;
				b_syn <= b_i;
				p_o <= p_asyn;
			end if;
		end process;
	end generate;
	
	g_async_in_out: if not sync_in_out generate
		a_syn <= a_i;
		b_syn <= b_i;
		p_o <= p_asyn;
	end generate;	
	
	a_ext(0)(no_of_cols downto word_size_a+2) <= (others => '0');
	a_ext(0)(word_size_a+1 downto 0) <= a_syn & "00";
	
	
	b_ext <= "00" & b_syn & '0';
	
	
	pp_i(0)(no_of_cols-1 downto no_of_cols-2) <= "11";
	pp_i(0)(no_of_cols-3 downto 0) <= (others => '0');

	b_delayed(0) <= b_ext(2 downto 0);
	delay_b: for r in 1 to no_of_rows-1 generate
		--- construct delays for b
		
		delay_b: if use_pipelining generate
			b0_delay : entity work.register_chain generic map(word_size => 1, delay => 1) port map(clk_i => clk_i, rst_i => rst_i, ce_i => ce_i, d_i => b_delayed(r-1)(2 downto 2), q_o => b_delayed(r)(0 downto 0));
			br_delay : entity work.register_chain generic map(word_size => 2, delay => r) port map(clk_i => clk_i, rst_i => rst_i, ce_i => ce_i, d_i => b_ext(2*r+2 downto 2*r+1), q_o => b_delayed(r)(2 downto 1));
		end generate;

		not_delay_b: if not use_pipelining generate
			b_delayed(r) <= b_ext(2*r+2 downto 2*r);
		end generate;
	end generate;		

	rows: for r in 0 to no_of_rows-1 generate
		--- construct row ---

		carry(r)(0) <= '1';

		slices: for s in 0 to no_of_slices_per_row-2 generate
			bd_mult_slice_s: entity work.bd_mult_slice
				generic map(
			    use_output_ff => use_pipelining
				)
				port map(
					clk_i   => clk_i,
					rst_i   => rst_i,
					ce_i    => ce_i,
					a0_i    => a_ext(r)(4*s+3 downto 4*s),
					a1_i    => a_ext(r)(4*s+4 downto 4*s+1),
					b0_i    => b_delayed(r)(0),
					b1_i    => b_delayed(r)(1),
					b2_i    => b_delayed(r)(2),
					p_i     => pp_i(r)(4*s+3 downto 4*s),
					carry_i => carry(r)(s),
					carry_o => carry(r)(s+1),
					a0_o    => a_ext(r+1)(4*s+3 downto 4*s),
					p_o     => pp_o(r)(4*s+3 downto 4*s)
				);
				
		end generate;
		
		bd_mult_slice_last: entity work.bd_mult_slice
			generic map(
		    use_output_ff => use_pipelining,
		    lut_type => (0,0,1,2)
			)
			port map(
				clk_i   => clk_i,
				rst_i   => rst_i,
				ce_i    => ce_i,
				a0_i    => a_ext(r)(4*no_of_slices_per_row-1 downto 4*no_of_slices_per_row-4),
				a1_i    => a_ext(r)(4*no_of_slices_per_row downto 4*no_of_slices_per_row-3),
				b0_i    => b_delayed(r)(0),
				b1_i    => b_delayed(r)(1),
				b2_i    => b_delayed(r)(2),
				p_i     => pp_i(r)(4*no_of_slices_per_row-1 downto 4*no_of_slices_per_row-4),
				carry_i => carry(r)(no_of_slices_per_row-1),
				carry_o => carry(r)(no_of_slices_per_row),
				a0_o    => a_ext(r+1)(4*no_of_slices_per_row-1 downto 4*no_of_slices_per_row-4),
				p_o     => pp_o(r)(4*no_of_slices_per_row-1 downto 4*no_of_slices_per_row-4)
			);

		pp_i(r+1)(no_of_cols-3 downto 0) <= pp_o(r)(no_of_cols-1 downto 3) & '0';	
		pp_i(r+1)(no_of_cols-1) <= '1';	
		delay_carry: if use_pipelining generate
			carry_delay : entity work.register_chain generic map(word_size => 1, delay => 1) port map(clk_i => clk_i, rst_i => rst_i, ce_i => ce_i, d_i => carry(r)(no_of_slices_per_row downto no_of_slices_per_row), q_o => pp_i(r+1)(no_of_cols-2 downto no_of_cols-2));
		end generate;

		forward_carry: if not use_pipelining generate
			pp_i(r+1)(no_of_cols-2) <= carry(r)(no_of_slices_per_row);	
		end generate;

		
		a_ext(r+1)(no_of_cols downto 4*no_of_slices_per_row) <= (others => '0');
		
		delay_results: if use_pipelining generate
			res_delay : entity work.register_chain generic map(word_size => 2, delay => no_of_rows-r-1) port map(clk_i => clk_i, rst_i => rst_i, ce_i => ce_i, d_i => pp_o(r)(2 downto 1), q_o => p_asyn(2*r+1 downto 2*r));
		end generate;

		forward_results: if not use_pipelining generate
			p_asyn(2*r+1 downto 2*r) <= pp_o(r)(2 downto 1);
		end generate;
			
	end generate;
	
	p_asyn(word_size_a+word_size_b-1 downto 2*no_of_rows) <= pp_o(no_of_rows-1)(word_size_a+word_size_b-2*no_of_rows+2 downto 3);
	
end architecture;
