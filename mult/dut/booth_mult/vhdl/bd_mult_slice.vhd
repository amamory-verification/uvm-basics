---------------------------------------------------------------------------------------------
-- Author:          Martin Kumm
-- Contact:         kumm@uni-kassel.de
-- License:         LGPL
-- Date:            31.10.2014
-- Compatibility:   Xilinx FPGAs of Virtex 5-7, Spartan 6 and Series 7 architectures
--
-- Description:
-- Implementation of a slice used in the Booth Array Multiplier for Xilinx FPGAs 
-- as proposed in:
--
-- M. Kumm, S. Abbas, and P. Zipf, An Efficient Softcore Multiplier Architecture for 
-- Xilinx FPGAs, IEEE Symposium on Computer Arithmetic (ARITH), 2015, pp. 1825
-- DOI: https://doi.org/10.1109/ARITH.2015.17
---------------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package mult_types_pkg is

	type lut_type_array_t is array (0 to 3) of integer;
	
	type lut_content_array_t is array (0 to 2) of bit_vector(63 downto 0);

end package mult_types_pkg;


library ieee;
use ieee.std_logic_1164.all;

library unisim;
use unisim.vcomponents.all;

use work.mult_types_pkg.all;

entity bd_mult_slice is
  generic(
    use_output_ff    : boolean := true;
    no_of_luts_used  : integer := 4;
    lut_type : lut_type_array_t := (0,0,0,0)
  );
  port(
    clk_i   : in  std_logic;
    rst_i   : in  std_logic;
    ce_i    : in  std_logic;
    a0_i    : in  std_logic_vector(3 downto 0);
    a1_i    : in  std_logic_vector(3 downto 0);
    b0_i     : in  std_logic;
    b1_i     : in  std_logic;
    b2_i     : in  std_logic;
    p_i     : in  std_logic_vector(3 downto 0);
    carry_i : in  std_logic;
    carry_o : out  std_logic;
    a0_o    : out  std_logic_vector(3 downto 0); --registered/not registered a0_i in case use_output_ff=true/false
    p_o     : out std_logic_vector(3 downto 0)
  );
end entity;

architecture bd_mult_slice_arch of bd_mult_slice is

	signal lut_out : std_logic_vector(3 downto 0);
	signal p_comb : std_logic_vector(3 downto 0);
	signal cc_co : std_logic_vector(3 downto 0);

	constant lut_content_array : lut_content_array_t := (x"FCCA533F0335ACC0",x"0FFF0000F000FFFF",x"FFFFFFFF00000000"); --0 is booth en/dec, 1 is not(compl) add configuration, 2 is simple adder (with i5)

begin
	
	luts: for i in 0 to no_of_luts_used-1 generate
	
		lut6_2_i: lut6_2
			generic map(
				init => lut_content_array(lut_type(i))
			)
			port map(
				i0	=> a0_i(i),
				i1	=> a1_i(i),
				i2	=> b0_i,
				i3	=> b1_i,
				i4	=> b2_i,
				i5	=> p_i(i),
				o5	=> open,
				o6  => lut_out(i)
			);
	end generate;

	carry_chain: carry4
		port map(
			co			=> cc_co,
			o			  => p_comb,
			cyinit	=> '0',
			ci 	    => carry_i,
			di			=> p_i,
			s			  => lut_out
		);	
	
	-- creating the flip flops
	use_ffs: if use_output_ff = true generate
		ffs_p_o: for i in 0 to no_of_luts_used-1 generate
			ff_i: fdce
				generic map(
					init => '0' -- initialize flip flops with '0'
				)
				port map(
					clr	=> rst_i,
					ce    => ce_i,
					d		=> p_comb(i),
					c		=> clk_i,
					q		=> p_o(i)
				);
		end generate;

		ffs_a0_o: for i in 0 to no_of_luts_used-1 generate
			ff_i: fdce
				generic map(
					init => '0' -- initialize flip flops with '0'
				)
				port map(
					clr	=> rst_i,
					ce    => ce_i,
					d		=> a0_i(i),
					c		=> clk_i,
					q		=> a0_o(i)
				);
		end generate;
	end generate;
	
	-- bypassing the flip flops in case of a asynchronous circuit
	bypass: if use_output_ff = false generate
		p_o <= p_comb;
		a0_o <= a0_i;
	end generate;

	carry_o <= cc_co(3);
	
end architecture;