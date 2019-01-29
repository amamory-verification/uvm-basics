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

entity RouterBR is
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
end RouterBR;

architecture RouterBR of RouterBR is

signal h, ack_h, data_av, sender, data_ack: regNport := (others=>'0');
signal data: arrayNport_regflit := (others=>(others=>'0'));
signal mux_in, mux_out: arrayNport_reg3 := (others=>(others=>'0'));
signal free: regNport := (others=>'0');

begin

	--aterrando os sinais de entrada do buffer 0 removido
	h(0)<='0';
	data_av(0)<='0';
	data(0)<=(others=>'0');
	sender(0)<='0';
	credit_o(0)<='0';

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

	FNorth : Entity work.Hermes_buffer
	port map(
		clock => clock,
		reset => reset,
		data_in => data_in(2),
		rx => rx(2),
		h => h(2),
		ack_h => ack_h(2),
		data_av => data_av(2),
		data => data(2),
		sender => sender(2),
		clock_rx => clock_rx(2),
		data_ack => data_ack(2),
		credit_o => credit_o(2));

	--aterrando os sinais de entrada do buffer 3 removido
	h(3)<='0';
	data_av(3)<='0';
	data(3)<=(others=>'0');
	sender(3)<='0';
	credit_o(3)<='0';

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

	CrossBar : Entity work.Hermes_crossbar_BR(AlgorithmXY)
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

end RouterBR;
