library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.HermesPackage.all;

entity NOC is
port(
	clock         : in  regNrot;
	reset         : in  std_logic;
	clock_rxLocal : in  regNrot;
	rxLocal       : in  regNrot;
	data_inLocal  : in  arrayNrot_regflit;
	credit_oLocal : out regNrot;
	clock_txLocal : out regNrot;
	txLocal       : out regNrot;
	data_outLocal : out arrayNrot_regflit;
	credit_iLocal : in  regNrot);
end NOC;

architecture NOC of NOC is

	signal clock_rxN0000, clock_rxN0100, clock_rxN0200 : regNport;
	signal rxN0000, rxN0100, rxN0200 : regNport;
	signal data_inN0000, data_inN0100, data_inN0200 : arrayNport_regflit;
	signal credit_oN0000, credit_oN0100, credit_oN0200 : regNport;
	signal clock_txN0000, clock_txN0100, clock_txN0200 : regNport;
	signal txN0000, txN0100, txN0200 : regNport;
	signal data_outN0000, data_outN0100, data_outN0200 : arrayNport_regflit;
	signal credit_iN0000, credit_iN0100, credit_iN0200 : regNport;
	signal clock_rxN0001, clock_rxN0101, clock_rxN0201 : regNport;
	signal rxN0001, rxN0101, rxN0201 : regNport;
	signal data_inN0001, data_inN0101, data_inN0201 : arrayNport_regflit;
	signal credit_oN0001, credit_oN0101, credit_oN0201 : regNport;
	signal clock_txN0001, clock_txN0101, clock_txN0201 : regNport;
	signal txN0001, txN0101, txN0201 : regNport;
	signal data_outN0001, data_outN0101, data_outN0201 : arrayNport_regflit;
	signal credit_iN0001, credit_iN0101, credit_iN0201 : regNport;
	signal clock_rxN0002, clock_rxN0102, clock_rxN0202 : regNport;
	signal rxN0002, rxN0102, rxN0202 : regNport;
	signal data_inN0002, data_inN0102, data_inN0202 : arrayNport_regflit;
	signal credit_oN0002, credit_oN0102, credit_oN0202 : regNport;
	signal clock_txN0002, clock_txN0102, clock_txN0202 : regNport;
	signal txN0002, txN0102, txN0202 : regNport;
	signal data_outN0002, data_outN0102, data_outN0202 : arrayNport_regflit;
	signal credit_iN0002, credit_iN0102, credit_iN0202 : regNport;
begin

	Router0000 : Entity work.RouterBL
	generic map( address => ADDRESSN0000 )
	port map(
		clock    => clock(N0000),
		reset    => reset,
		clock_rx => clock_rxN0000,
		rx       => rxN0000,
		data_in  => data_inN0000,
		credit_o => credit_oN0000,
		clock_tx => clock_txN0000,
		tx       => txN0000,
		data_out => data_outN0000,
		credit_i => credit_iN0000);

	Router0100 : Entity work.RouterBC
	generic map( address => ADDRESSN0100 )
	port map(
		clock    => clock(N0100),
		reset    => reset,
		clock_rx => clock_rxN0100,
		rx       => rxN0100,
		data_in  => data_inN0100,
		credit_o => credit_oN0100,
		clock_tx => clock_txN0100,
		tx       => txN0100,
		data_out => data_outN0100,
		credit_i => credit_iN0100);

	Router0200 : Entity work.RouterBR
	generic map( address => ADDRESSN0200 )
	port map(
		clock    => clock(N0200),
		reset    => reset,
		clock_rx => clock_rxN0200,
		rx       => rxN0200,
		data_in  => data_inN0200,
		credit_o => credit_oN0200,
		clock_tx => clock_txN0200,
		tx       => txN0200,
		data_out => data_outN0200,
		credit_i => credit_iN0200);

	Router0001 : Entity work.RouterCL
	generic map( address => ADDRESSN0001 )
	port map(
		clock    => clock(N0001),
		reset    => reset,
		clock_rx => clock_rxN0001,
		rx       => rxN0001,
		data_in  => data_inN0001,
		credit_o => credit_oN0001,
		clock_tx => clock_txN0001,
		tx       => txN0001,
		data_out => data_outN0001,
		credit_i => credit_iN0001);

	Router0101 : Entity work.RouterCC
	generic map( address => ADDRESSN0101 )
	port map(
		clock    => clock(N0101),
		reset    => reset,
		clock_rx => clock_rxN0101,
		rx       => rxN0101,
		data_in  => data_inN0101,
		credit_o => credit_oN0101,
		clock_tx => clock_txN0101,
		tx       => txN0101,
		data_out => data_outN0101,
		credit_i => credit_iN0101);

	Router0201 : Entity work.RouterCR
	generic map( address => ADDRESSN0201 )
	port map(
		clock    => clock(N0201),
		reset    => reset,
		clock_rx => clock_rxN0201,
		rx       => rxN0201,
		data_in  => data_inN0201,
		credit_o => credit_oN0201,
		clock_tx => clock_txN0201,
		tx       => txN0201,
		data_out => data_outN0201,
		credit_i => credit_iN0201);

	Router0002 : Entity work.RouterTL
	generic map( address => ADDRESSN0002 )
	port map(
		clock    => clock(N0002),
		reset    => reset,
		clock_rx => clock_rxN0002,
		rx       => rxN0002,
		data_in  => data_inN0002,
		credit_o => credit_oN0002,
		clock_tx => clock_txN0002,
		tx       => txN0002,
		data_out => data_outN0002,
		credit_i => credit_iN0002);

	Router0102 : Entity work.RouterTC
	generic map( address => ADDRESSN0102 )
	port map(
		clock    => clock(N0102),
		reset    => reset,
		clock_rx => clock_rxN0102,
		rx       => rxN0102,
		data_in  => data_inN0102,
		credit_o => credit_oN0102,
		clock_tx => clock_txN0102,
		tx       => txN0102,
		data_out => data_outN0102,
		credit_i => credit_iN0102);

	Router0202 : Entity work.RouterTR
	generic map( address => ADDRESSN0202 )
	port map(
		clock    => clock(N0202),
		reset    => reset,
		clock_rx => clock_rxN0202,
		rx       => rxN0202,
		data_in  => data_inN0202,
		credit_o => credit_oN0202,
		clock_tx => clock_txN0202,
		tx       => txN0202,
		data_out => data_outN0202,
		credit_i => credit_iN0202);

	-- ROUTER 0000
	-- EAST port
	clock_rxN0000(0)<=clock_txN0100(1);
	rxN0000(0)<=txN0100(1);
	data_inN0000(0)<=data_outN0100(1);
	credit_iN0000(0)<=credit_oN0100(1);
	-- WEST port
	clock_rxN0000(1)<='0';
	rxN0000(1)<='0';
	data_inN0000(1)<=(others=>'0');
	credit_iN0000(1)<='0';
	-- NORTH port
	clock_rxN0000(2)<=clock_txN0001(3);
	rxN0000(2)<=txN0001(3);
	data_inN0000(2)<=data_outN0001(3);
	credit_iN0000(2)<=credit_oN0001(3);
	-- SOUTH port
	clock_rxN0000(3)<='0';
	rxN0000(3)<='0';
	data_inN0000(3)<=(others=>'0');
	credit_iN0000(3)<='0';
	-- LOCAL port
	clock_rxN0000(4)<=clock_rxLocal(N0000);
	rxN0000(4)<=rxLocal(N0000);
	data_inN0000(4)<=data_inLocal(N0000);
	credit_iN0000(4)<=credit_iLocal(N0000);
	clock_txLocal(N0000)<=clock_txN0000(4);
	txLocal(N0000)<=txN0000(4);
	data_outLocal(N0000)<=data_outN0000(4);
	credit_oLocal(N0000)<=credit_oN0000(4);

	-- ROUTER 0100
	-- EAST port
	clock_rxN0100(0)<=clock_txN0200(1);
	rxN0100(0)<=txN0200(1);
	data_inN0100(0)<=data_outN0200(1);
	credit_iN0100(0)<=credit_oN0200(1);
	-- WEST port
	clock_rxN0100(1)<=clock_txN0000(0);
	rxN0100(1)<=txN0000(0);
	data_inN0100(1)<=data_outN0000(0);
	credit_iN0100(1)<=credit_oN0000(0);
	-- NORTH port
	clock_rxN0100(2)<=clock_txN0101(3);
	rxN0100(2)<=txN0101(3);
	data_inN0100(2)<=data_outN0101(3);
	credit_iN0100(2)<=credit_oN0101(3);
	-- SOUTH port
	clock_rxN0100(3)<='0';
	rxN0100(3)<='0';
	data_inN0100(3)<=(others=>'0');
	credit_iN0100(3)<='0';
	-- LOCAL port
	clock_rxN0100(4)<=clock_rxLocal(N0100);
	rxN0100(4)<=rxLocal(N0100);
	data_inN0100(4)<=data_inLocal(N0100);
	credit_iN0100(4)<=credit_iLocal(N0100);
	clock_txLocal(N0100)<=clock_txN0100(4);
	txLocal(N0100)<=txN0100(4);
	data_outLocal(N0100)<=data_outN0100(4);
	credit_oLocal(N0100)<=credit_oN0100(4);

	-- ROUTER 0200
	-- EAST port
	clock_rxN0200(0)<='0';
	rxN0200(0)<='0';
	data_inN0200(0)<=(others=>'0');
	credit_iN0200(0)<='0';
	-- WEST port
	clock_rxN0200(1)<=clock_txN0100(0);
	rxN0200(1)<=txN0100(0);
	data_inN0200(1)<=data_outN0100(0);
	credit_iN0200(1)<=credit_oN0100(0);
	-- NORTH port
	clock_rxN0200(2)<=clock_txN0201(3);
	rxN0200(2)<=txN0201(3);
	data_inN0200(2)<=data_outN0201(3);
	credit_iN0200(2)<=credit_oN0201(3);
	-- SOUTH port
	clock_rxN0200(3)<='0';
	rxN0200(3)<='0';
	data_inN0200(3)<=(others=>'0');
	credit_iN0200(3)<='0';
	-- LOCAL port
	clock_rxN0200(4)<=clock_rxLocal(N0200);
	rxN0200(4)<=rxLocal(N0200);
	data_inN0200(4)<=data_inLocal(N0200);
	credit_iN0200(4)<=credit_iLocal(N0200);
	clock_txLocal(N0200)<=clock_txN0200(4);
	txLocal(N0200)<=txN0200(4);
	data_outLocal(N0200)<=data_outN0200(4);
	credit_oLocal(N0200)<=credit_oN0200(4);

	-- ROUTER 0001
	-- EAST port
	clock_rxN0001(0)<=clock_txN0101(1);
	rxN0001(0)<=txN0101(1);
	data_inN0001(0)<=data_outN0101(1);
	credit_iN0001(0)<=credit_oN0101(1);
	-- WEST port
	clock_rxN0001(1)<='0';
	rxN0001(1)<='0';
	data_inN0001(1)<=(others=>'0');
	credit_iN0001(1)<='0';
	-- NORTH port
	clock_rxN0001(2)<=clock_txN0002(3);
	rxN0001(2)<=txN0002(3);
	data_inN0001(2)<=data_outN0002(3);
	credit_iN0001(2)<=credit_oN0002(3);
	-- SOUTH port
	clock_rxN0001(3)<=clock_txN0000(2);
	rxN0001(3)<=txN0000(2);
	data_inN0001(3)<=data_outN0000(2);
	credit_iN0001(3)<=credit_oN0000(2);
	-- LOCAL port
	clock_rxN0001(4)<=clock_rxLocal(N0001);
	rxN0001(4)<=rxLocal(N0001);
	data_inN0001(4)<=data_inLocal(N0001);
	credit_iN0001(4)<=credit_iLocal(N0001);
	clock_txLocal(N0001)<=clock_txN0001(4);
	txLocal(N0001)<=txN0001(4);
	data_outLocal(N0001)<=data_outN0001(4);
	credit_oLocal(N0001)<=credit_oN0001(4);

	-- ROUTER 0101
	-- EAST port
	clock_rxN0101(0)<=clock_txN0201(1);
	rxN0101(0)<=txN0201(1);
	data_inN0101(0)<=data_outN0201(1);
	credit_iN0101(0)<=credit_oN0201(1);
	-- WEST port
	clock_rxN0101(1)<=clock_txN0001(0);
	rxN0101(1)<=txN0001(0);
	data_inN0101(1)<=data_outN0001(0);
	credit_iN0101(1)<=credit_oN0001(0);
	-- NORTH port
	clock_rxN0101(2)<=clock_txN0102(3);
	rxN0101(2)<=txN0102(3);
	data_inN0101(2)<=data_outN0102(3);
	credit_iN0101(2)<=credit_oN0102(3);
	-- SOUTH port
	clock_rxN0101(3)<=clock_txN0100(2);
	rxN0101(3)<=txN0100(2);
	data_inN0101(3)<=data_outN0100(2);
	credit_iN0101(3)<=credit_oN0100(2);
	-- LOCAL port
	clock_rxN0101(4)<=clock_rxLocal(N0101);
	rxN0101(4)<=rxLocal(N0101);
	data_inN0101(4)<=data_inLocal(N0101);
	credit_iN0101(4)<=credit_iLocal(N0101);
	clock_txLocal(N0101)<=clock_txN0101(4);
	txLocal(N0101)<=txN0101(4);
	data_outLocal(N0101)<=data_outN0101(4);
	credit_oLocal(N0101)<=credit_oN0101(4);

	-- ROUTER 0201
	-- EAST port
	clock_rxN0201(0)<='0';
	rxN0201(0)<='0';
	data_inN0201(0)<=(others=>'0');
	credit_iN0201(0)<='0';
	-- WEST port
	clock_rxN0201(1)<=clock_txN0101(0);
	rxN0201(1)<=txN0101(0);
	data_inN0201(1)<=data_outN0101(0);
	credit_iN0201(1)<=credit_oN0101(0);
	-- NORTH port
	clock_rxN0201(2)<=clock_txN0202(3);
	rxN0201(2)<=txN0202(3);
	data_inN0201(2)<=data_outN0202(3);
	credit_iN0201(2)<=credit_oN0202(3);
	-- SOUTH port
	clock_rxN0201(3)<=clock_txN0200(2);
	rxN0201(3)<=txN0200(2);
	data_inN0201(3)<=data_outN0200(2);
	credit_iN0201(3)<=credit_oN0200(2);
	-- LOCAL port
	clock_rxN0201(4)<=clock_rxLocal(N0201);
	rxN0201(4)<=rxLocal(N0201);
	data_inN0201(4)<=data_inLocal(N0201);
	credit_iN0201(4)<=credit_iLocal(N0201);
	clock_txLocal(N0201)<=clock_txN0201(4);
	txLocal(N0201)<=txN0201(4);
	data_outLocal(N0201)<=data_outN0201(4);
	credit_oLocal(N0201)<=credit_oN0201(4);

	-- ROUTER 0002
	-- EAST port
	clock_rxN0002(0)<=clock_txN0102(1);
	rxN0002(0)<=txN0102(1);
	data_inN0002(0)<=data_outN0102(1);
	credit_iN0002(0)<=credit_oN0102(1);
	-- WEST port
	clock_rxN0002(1)<='0';
	rxN0002(1)<='0';
	data_inN0002(1)<=(others=>'0');
	credit_iN0002(1)<='0';
	-- NORTH port
	clock_rxN0002(2)<='0';
	rxN0002(2)<='0';
	data_inN0002(2)<=(others=>'0');
	credit_iN0002(2)<='0';
	-- SOUTH port
	clock_rxN0002(3)<=clock_txN0001(2);
	rxN0002(3)<=txN0001(2);
	data_inN0002(3)<=data_outN0001(2);
	credit_iN0002(3)<=credit_oN0001(2);
	-- LOCAL port
	clock_rxN0002(4)<=clock_rxLocal(N0002);
	rxN0002(4)<=rxLocal(N0002);
	data_inN0002(4)<=data_inLocal(N0002);
	credit_iN0002(4)<=credit_iLocal(N0002);
	clock_txLocal(N0002)<=clock_txN0002(4);
	txLocal(N0002)<=txN0002(4);
	data_outLocal(N0002)<=data_outN0002(4);
	credit_oLocal(N0002)<=credit_oN0002(4);

	-- ROUTER 0102
	-- EAST port
	clock_rxN0102(0)<=clock_txN0202(1);
	rxN0102(0)<=txN0202(1);
	data_inN0102(0)<=data_outN0202(1);
	credit_iN0102(0)<=credit_oN0202(1);
	-- WEST port
	clock_rxN0102(1)<=clock_txN0002(0);
	rxN0102(1)<=txN0002(0);
	data_inN0102(1)<=data_outN0002(0);
	credit_iN0102(1)<=credit_oN0002(0);
	-- NORTH port
	clock_rxN0102(2)<='0';
	rxN0102(2)<='0';
	data_inN0102(2)<=(others=>'0');
	credit_iN0102(2)<='0';
	-- SOUTH port
	clock_rxN0102(3)<=clock_txN0101(2);
	rxN0102(3)<=txN0101(2);
	data_inN0102(3)<=data_outN0101(2);
	credit_iN0102(3)<=credit_oN0101(2);
	-- LOCAL port
	clock_rxN0102(4)<=clock_rxLocal(N0102);
	rxN0102(4)<=rxLocal(N0102);
	data_inN0102(4)<=data_inLocal(N0102);
	credit_iN0102(4)<=credit_iLocal(N0102);
	clock_txLocal(N0102)<=clock_txN0102(4);
	txLocal(N0102)<=txN0102(4);
	data_outLocal(N0102)<=data_outN0102(4);
	credit_oLocal(N0102)<=credit_oN0102(4);

	-- ROUTER 0202
	-- EAST port
	clock_rxN0202(0)<='0';
	rxN0202(0)<='0';
	data_inN0202(0)<=(others=>'0');
	credit_iN0202(0)<='0';
	-- WEST port
	clock_rxN0202(1)<=clock_txN0102(0);
	rxN0202(1)<=txN0102(0);
	data_inN0202(1)<=data_outN0102(0);
	credit_iN0202(1)<=credit_oN0102(0);
	-- NORTH port
	clock_rxN0202(2)<='0';
	rxN0202(2)<='0';
	data_inN0202(2)<=(others=>'0');
	credit_iN0202(2)<='0';
	-- SOUTH port
	clock_rxN0202(3)<=clock_txN0201(2);
	rxN0202(3)<=txN0201(2);
	data_inN0202(3)<=data_outN0201(2);
	credit_iN0202(3)<=credit_oN0201(2);
	-- LOCAL port
	clock_rxN0202(4)<=clock_rxLocal(N0202);
	rxN0202(4)<=rxLocal(N0202);
	data_inN0202(4)<=data_inLocal(N0202);
	credit_iN0202(4)<=credit_iLocal(N0202);
	clock_txLocal(N0202)<=clock_txN0202(4);
	txLocal(N0202)<=txN0202(4);
	data_outLocal(N0202)<=data_outN0202(4);
	credit_oLocal(N0202)<=credit_oN0202(4);

	-- the component below, router_output, must be commented to simulate without SystemC
	router_output: Entity work.outmodulerouter
	port map(
		clock           => clock(N0000),
		reset           => reset,
		tx_r0p0         => txN0000(EAST),
		out_r0p0        => data_outN0000(EAST),
		credit_ir0p0    => credit_iN0000(EAST),
		tx_r0p2         => txN0000(NORTH),
		out_r0p2        => data_outN0000(NORTH),
		credit_ir0p2    => credit_iN0000(NORTH),
		tx_r1p0         => txN0100(EAST),
		out_r1p0        => data_outN0100(EAST),
		credit_ir1p0    => credit_iN0100(EAST),
		tx_r1p1         => txN0100(WEST),
		out_r1p1        => data_outN0100(WEST),
		credit_ir1p1    => credit_iN0100(WEST),
		tx_r1p2         => txN0100(NORTH),
		out_r1p2        => data_outN0100(NORTH),
		credit_ir1p2    => credit_iN0100(NORTH),
		tx_r2p1         => txN0200(WEST),
		out_r2p1        => data_outN0200(WEST),
		credit_ir2p1    => credit_iN0200(WEST),
		tx_r2p2         => txN0200(NORTH),
		out_r2p2        => data_outN0200(NORTH),
		credit_ir2p2    => credit_iN0200(NORTH),
		tx_r3p0         => txN0001(EAST),
		out_r3p0        => data_outN0001(EAST),
		credit_ir3p0    => credit_iN0001(EAST),
		tx_r3p2         => txN0001(NORTH),
		out_r3p2        => data_outN0001(NORTH),
		credit_ir3p2    => credit_iN0001(NORTH),
		tx_r3p3         => txN0001(SOUTH),
		out_r3p3        => data_outN0001(SOUTH),
		credit_ir3p3    => credit_iN0001(SOUTH),
		tx_r4p0         => txN0101(EAST),
		out_r4p0        => data_outN0101(EAST),
		credit_ir4p0    => credit_iN0101(EAST),
		tx_r4p1         => txN0101(WEST),
		out_r4p1        => data_outN0101(WEST),
		credit_ir4p1    => credit_iN0101(WEST),
		tx_r4p2         => txN0101(NORTH),
		out_r4p2        => data_outN0101(NORTH),
		credit_ir4p2    => credit_iN0101(NORTH),
		tx_r4p3         => txN0101(SOUTH),
		out_r4p3        => data_outN0101(SOUTH),
		credit_ir4p3    => credit_iN0101(SOUTH),
		tx_r5p1         => txN0201(WEST),
		out_r5p1        => data_outN0201(WEST),
		credit_ir5p1    => credit_iN0201(WEST),
		tx_r5p2         => txN0201(NORTH),
		out_r5p2        => data_outN0201(NORTH),
		credit_ir5p2    => credit_iN0201(NORTH),
		tx_r5p3         => txN0201(SOUTH),
		out_r5p3        => data_outN0201(SOUTH),
		credit_ir5p3    => credit_iN0201(SOUTH),
		tx_r6p0         => txN0002(EAST),
		out_r6p0        => data_outN0002(EAST),
		credit_ir6p0    => credit_iN0002(EAST),
		tx_r6p3         => txN0002(SOUTH),
		out_r6p3        => data_outN0002(SOUTH),
		credit_ir6p3    => credit_iN0002(SOUTH),
		tx_r7p0         => txN0102(EAST),
		out_r7p0        => data_outN0102(EAST),
		credit_ir7p0    => credit_iN0102(EAST),
		tx_r7p1         => txN0102(WEST),
		out_r7p1        => data_outN0102(WEST),
		credit_ir7p1    => credit_iN0102(WEST),
		tx_r7p3         => txN0102(SOUTH),
		out_r7p3        => data_outN0102(SOUTH),
		credit_ir7p3    => credit_iN0102(SOUTH),
		tx_r8p1         => txN0202(WEST),
		out_r8p1        => data_outN0202(WEST),
		credit_ir8p1    => credit_iN0202(WEST),
		tx_r8p3         => txN0202(SOUTH),
		out_r8p3        => data_outN0202(SOUTH),
		credit_ir8p3    => credit_iN0202(SOUTH));

end NOC;
