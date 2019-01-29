---------------------------------------------------------------------------------------	
--                                    ROUTER
--
--
--                                    NORTH         LOCAL
--                      -----------------------------------
--                      |             ******       ****** |
--                      |             *FILA*       *FILA* |
--                      |             ******       ****** |
--                      |          *************          |
--                      |          *  ARBITRO  *          |
--                      | ******   *************   ****** |
--                 WEST | *FILA*   *************   *FILA* | EAST
--                      | ******   *  CONTROLE *   ****** |
--                      |          *************          |
--                      |             ******              |
--                      |             *FILA*              |
--                      |             ******              |
--                      -----------------------------------
--                                    SOUTH
--
--  As chaves realizam a transferýncia de mensagens entre nýcleos. 
--  A chave possui uma lýgica de controle de chaveamento e 5 portas bidirecionais:
--  East, West, North, South e Local. Cada porta possui uma fila para o armazenamento 
--  temporýrio de flits. A porta Local estabelece a comunicaýýo entre a chave e seu 
--  nýcleo. As demais portas ligam a chave ýs chaves vizinhas.
--  Os endereýos das chaves sýo compostos pelas coordenadas XY da rede de interconexýo, 
--  onde X ý a posiýýo horizontal e Y a posiýýo vertical. A atribuiýýo de endereýos ýs 
--  chaves ý necessýria para a execuýýo do algoritmo de chaveamento.
--  Os mýdulos principais que compýem a chave sýo: fila, ýrbitro e lýgica de 
--  chaveamento implementada pelo controle_mux. Cada uma das filas da chave (E, W, N, 
--  S e L), ao receber um novo pacote requisita chaveamento ao ýrbitro. O ýrbitro 
--  seleciona a requisiýýo de maior prioridade, quando existem requisiýýes simultýneas, 
--  e encaminha o pedido de chaveamento ý lýgica de chaveamento. A lýgica de 
--  chaveamento verifica se ý possývel atender ý solicitaýýo. Sendo possývel, a conexýo
--  ý estabelecida e o ýrbitro ý informado. Por sua vez, o ýrbitro informa a fila que 
--  comeýa a enviar os flits armazenados. Quando todos os flits do pacote foram 
--  enviados, a conexýo ý concluýda pela sinalizaýýo, por parte da fila, atravýs do 
--  sinal sender.
---------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.HermesPackage.all;

entity RouterTC is
generic( address: regmetadeflit);
port(
	clock:     in  std_logic;
	reset:     in  std_logic;
	clock_rx:  in  regNport;
	rx:        in  regNport;
	data_in:   in  arrayNport_regflit;
	credit_o:  out regNport;    
	clock_tx:  out regNport;
	tx:        out regNport;
	data_out:  out arrayNport_regflit;
	credit_i:  in  regNport);
end RouterTC;

architecture RouterTC of RouterTC is

signal h, ack_h, data_av, sender, data_ack: regNport := (others=>'0');
signal data: arrayNport_regflit := (others=>(others=>'0'));
signal mux_in, mux_out: arrayNport_reg3 := (others=>(others=>'0'));
signal free: regNport := (others=>'0');

begin

	FEast : Entity work.Hermes_buffer
	port map(
		clock => clock,
		reset => reset,
		data_in => data_in(0),
		rx => rx(0),
		h => h(0),
		ack_h => ack_h(0),
		data_av => data_av(0),
		data => data(0),
		sender => sender(0),
		clock_rx => clock_rx(0),
		data_ack => data_ack(0),
		credit_o => credit_o(0));

	FWest : Entity work.Hermes_buffer
	port map(
		clock => clock,
		reset => reset,
		data_in => data_in(1),
		rx => rx(1),
		h => h(1),
		ack_h => ack_h(1),
		data_av => data_av(1),
		data => data(1),
		sender => sender(1),
		clock_rx => clock_rx(1),
		data_ack => data_ack(1),
		credit_o => credit_o(1));

	--aterrando os sinais de entrada do buffer 2 removido
	h(2)<='0';
	data_av(2)<='0';
	data(2)<=(others=>'0');
	sender(2)<='0';
	credit_o(2)<='0';

	FSouth : Entity work.Hermes_buffer
	port map(
		clock => clock,
		reset => reset,
		data_in => data_in(3),
		rx => rx(3),
		h => h(3),
		ack_h => ack_h(3),
		data_av => data_av(3),
		data => data(3),
		sender => sender(3),
		clock_rx => clock_rx(3),
		data_ack => data_ack(3),
		credit_o => credit_o(3));

	FLocal : Entity work.Hermes_buffer
	port map(
		clock => clock,
		reset => reset,
		data_in => data_in(4),
		rx => rx(4),
		h => h(4),
		ack_h => ack_h(4),
		data_av => data_av(4),
		data => data(4),
		sender => sender(4),
		clock_rx => clock_rx(4),
		data_ack => data_ack(4),
		credit_o => credit_o(4));

	SwitchControl : Entity work.SwitchControl(AlgorithmXY)
	port map(
		clock => clock,
		reset => reset,
		h => h,
		ack_h => ack_h,
		address => address,
		data => data,
		sender => sender,
		free => free,
		mux_in => mux_in,
		mux_out => mux_out);

	CrossBar : Entity work.Hermes_crossbar_TC(AlgorithmXY)
	port map(
		data_av => data_av,
		data_in => data,
		data_ack => data_ack,
		sender => sender,
		free => free,
		tab_in => mux_in,
		tab_out => mux_out,
		tx => tx,
		data_out => data_out,
		credit_i => credit_i);

	CLK_TX : for i in 0 to(NPORT-1) generate
		clock_tx(i) <= clock;
	end generate CLK_TX;  

end RouterTC;
