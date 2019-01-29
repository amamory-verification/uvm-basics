--------------------------------------------------------------------------
-- package com tipos basicos
--------------------------------------------------------------------------
library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.std_logic_unsigned.all;
use ieee.math_real.log2;
use ieee.math_real.ceil;

package HermesPackage is

---------------------------------------------------------
-- CONSTANTS INDEPENDENTES
---------------------------------------------------------
	constant NPORT: integer := 5;

	constant EAST  : integer := 0;
	constant WEST  : integer := 1;
	constant NORTH : integer := 2;
	constant SOUTH : integer := 3;
	constant LOCAL : integer := 4;
---------------------------------------------------------
-- CONSTANT DEPENDENTE DA LARGURA DE BANDA DA REDE
---------------------------------------------------------
	constant TAM_FLIT : integer range 1 to 64 := 16;
	constant METADEFLIT : integer range 1 to 32 := (TAM_FLIT/2);
	constant QUARTOFLIT : integer range 1 to 16 := (TAM_FLIT/4);
---------------------------------------------------------
-- CONSTANTS DEPENDENTES DA PROFUNDIDADE DA FILA
---------------------------------------------------------
	constant TAM_BUFFER: integer := 16;
        constant TAM_POINTER : integer range 1 to 32 := INTEGER(CEIL(LOG2(REAL(TAM_BUFFER))));

---------------------------------------------------------
-- CONSTANTS DEPENDENTES DO NUMERO DE ROTEADORES
---------------------------------------------------------
	constant NROT: integer := 9;

	constant MIN_X : integer := 0;
	constant MIN_Y : integer := 0;
	constant MAX_X : integer := 2;
	constant MAX_Y : integer := 2;

---------------------------------------------------------
-- CONSTANT TB
---------------------------------------------------------
	constant TAM_LINHA : integer := 2; --4;

	constant N0000: integer :=0;
	constant ADDRESSN0000: std_logic_vector(7 downto 0) :="00000000";
	constant N0100: integer :=1;
	constant ADDRESSN0100: std_logic_vector(7 downto 0) :="00010000";
	constant N0200: integer :=2;
	constant ADDRESSN0200: std_logic_vector(7 downto 0) :="00100000";
	constant N0001: integer :=3;
	constant ADDRESSN0001: std_logic_vector(7 downto 0) :="00000001";
	constant N0101: integer :=4;
	constant ADDRESSN0101: std_logic_vector(7 downto 0) :="00010001";
	constant N0201: integer :=5;
	constant ADDRESSN0201: std_logic_vector(7 downto 0) :="00100001";
	constant N0002: integer :=6;
	constant ADDRESSN0002: std_logic_vector(7 downto 0) :="00000010";
	constant N0102: integer :=7;
	constant ADDRESSN0102: std_logic_vector(7 downto 0) :="00010010";
	constant N0202: integer :=8;
	constant ADDRESSN0202: std_logic_vector(7 downto 0) :="00100010";

---------------------------------------------------------
-- SUBTIPOS, TIPOS E FUNCOES
---------------------------------------------------------

	subtype reg3 is std_logic_vector(2 downto 0);
	subtype reg8 is std_logic_vector(7 downto 0);
	subtype reg32 is std_logic_vector(31 downto 0);
	subtype regNrot is std_logic_vector((NROT-1) downto 0);
	subtype regNport is std_logic_vector((NPORT-1) downto 0);
	subtype regflit is std_logic_vector((TAM_FLIT-1) downto 0);
	subtype regmetadeflit is std_logic_vector(((TAM_FLIT/2)-1) downto 0);
	subtype regquartoflit is std_logic_vector((QUARTOFLIT-1) downto 0);
	subtype pointer is std_logic_vector((TAM_POINTER-1) downto 0);

	type buff is array(0 to TAM_BUFFER-1) of regflit;

	type arrayNport_reg3 is array((NPORT-1) downto 0) of reg3;
	type arrayNport_reg8 is array((NPORT-1) downto 0) of reg8;
	type arrayNport_regflit is array((NPORT-1) downto 0) of regflit;
	type arrayNrot_reg3 is array((NROT-1) downto 0) of reg3;
	type arrayNrot_regflit is array((NROT-1) downto 0) of regflit;
	type arrayNrot_regmetadeflit is array((NROT-1) downto 0) of regmetadeflit;

	function CONV_VECTOR( int: integer ) return std_logic_vector;

---------------------------------------------------------
-- FUNCOES TB
---------------------------------------------------------
	function CONV_VECTOR( letra : string(1 to TAM_LINHA);  pos: integer ) return std_logic_vector;
	function CONV_HEX( int : integer ) return string;
	function CONV_STRING_4BITS( dado : std_logic_vector(3 downto 0)) return string;
	function CONV_STRING_8BITS( dado : std_logic_vector(7 downto 0)) return string;
	function CONV_STRING_16BITS( dado : std_logic_vector(15 downto 0)) return string;
	function CONV_STRING_32BITS( dado : std_logic_vector(31 downto 0)) return string;

end HermesPackage;

package body HermesPackage is
	--
	-- converte um inteiro em um std_logic_vector(2 downto 0)
	--
	function CONV_VECTOR( int: integer ) return std_logic_vector is
		variable bin: reg3;
	begin
		case(int) is
			when 0 => bin := "000";
			when 1 => bin := "001";
			when 2 => bin := "010";
			when 3 => bin := "011";
			when 4 => bin := "100";
			when 5 => bin := "101";
			when 6 => bin := "110";
			when 7 => bin := "111";
			when others => bin := "000";
		end case;
		return bin;
	end CONV_VECTOR;
	---------------------------------------------------------
	-- FUNCOES TB
	---------------------------------------------------------
	--
	-- converte um caracter de uma dada linha em um std_logic_vector
	--
	function CONV_VECTOR( letra:string(1 to TAM_LINHA);  pos: integer ) return std_logic_vector is
		variable bin: std_logic_vector(3 downto 0);
	begin
		case (letra(pos)) is
			when '0' => bin := "0000";
			when '1' => bin := "0001";
			when '2' => bin := "0010";
			when '3' => bin := "0011";
			when '4' => bin := "0100";
			when '5' => bin := "0101";
			when '6' => bin := "0110";
			when '7' => bin := "0111";
			when '8' => bin := "1000";
			when '9' => bin := "1001";
			when 'A' => bin := "1010";
			when 'B' => bin := "1011";
			when 'C' => bin := "1100";
			when 'D' => bin := "1101";
			when 'E' => bin := "1110";
			when 'F' => bin := "1111";
			when others =>  bin := "0000";
		end case;
		return bin;
	end CONV_VECTOR;

-- converte um inteiro em um string
	function CONV_HEX( int: integer ) return string is
		variable str: string(1 to 1);
	begin
		case(int) is
			when 0 => str := "0";
			when 1 => str := "1";
			when 2 => str := "2";
			when 3 => str := "3";
			when 4 => str := "4";
			when 5 => str := "5";
			when 6 => str := "6";
			when 7 => str := "7";
			when 8 => str := "8";
			when 9 => str := "9";
			when 10 => str := "A";
			when 11 => str := "B";
			when 12 => str := "C";
			when 13 => str := "D";
			when 14 => str := "E";
			when 15 => str := "F";
			when others =>  str := "U";
		end case;
		return str;
	end CONV_HEX;

	function CONV_STRING_4BITS(dado : std_logic_vector(3 downto 0)) return string is
		variable str: string(1 to 1);
	begin
		str := CONV_HEX(CONV_INTEGER(dado));
		return str;
	end CONV_STRING_4BITS;

	function CONV_STRING_8BITS(dado : std_logic_vector(7 downto 0)) return string is
		variable str1,str2: string(1 to 1);
		variable str: string(1 to 2);
	begin
		str1 := CONV_STRING_4BITS(dado(7 downto 4));
		str2 := CONV_STRING_4BITS(dado(3 downto 0));
		str := str1 & str2;
		return str;
	end CONV_STRING_8BITS;

	function CONV_STRING_16BITS(dado : std_logic_vector(15 downto 0)) return string is
		variable str1,str2: string(1 to 2);
		variable str: string(1 to 4);
	begin
		str1 := CONV_STRING_8BITS(dado(15 downto 8));
		str2 := CONV_STRING_8BITS(dado(7 downto 0));
		str := str1 & str2;
		return str;
	end CONV_STRING_16BITS;

	function CONV_STRING_32BITS(dado : std_logic_vector(31 downto 0)) return string is
		variable str1,str2: string(1 to 4);
		variable str: string(1 to 8);
	begin
		str1 := CONV_STRING_16BITS(dado(31 downto 16));
		str2 := CONV_STRING_16BITS(dado(15 downto 0));
		str := str1 & str2;
		return str;
	end CONV_STRING_32BITS;

end HermesPackage;
