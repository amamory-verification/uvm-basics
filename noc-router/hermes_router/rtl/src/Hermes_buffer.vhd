---------------------------------------------------------------------------------------
---- atualizado em 2013 - Fernando Moraes e Guilherme Heck
---------------------------------------------------------------------------------------
--                            BUFFER
--                        --------------
--                   RX ->|            |-> H
--              DATA_IN ->|            |<- ACK_H
--             CLOCK_RX ->|            |
--             CREDIT_O <-|            |-> DATA_AV
--                        |            |-> DATA
--                        |            |<- DATA_ACK
--                        |            |
--                        |            |   
--                        |            |=> SENDER
--                        |            |   all ports
--                        --------------
--
--  Quando o algoritmo de chaveamento resulta no bloqueio dos flits de um pacote, 
--  ocorre uma perda de desempenho em toda rede de interconexao, porque os flits sao 
--  bloqueados nao somente na chave atual, mas em todas as intermediarias. 
--  Para diminuir a perda de desempenho foi adicionada uma fila em cada porta de 
--  entrada da chave, reduzindo as chaves afetadas com o bloqueio dos flits de um 
--  pacote. E importante observar que quanto maior for o tamanho da fila menor sera o 
--  numero de chaves intermediarias afetadas. 
--  As filas usadas contem dimensao e largura de flit parametrizaveis, para altera-las
--  modifique as constantes TAM_BUFFER e TAM_FLIT no arquivo "Hermes_packet.vhd".
--  As filas funcionam como FIFOs circulares. Cada fila possui dois ponteiros: read_pointer e 
--  write_pointer. read_pointer aponta para a posicao da fila onde se encontra o flit a ser consumido. 
--  write_pointer aponta para a posicao onde deve ser inserido o proximo flit.
---------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.HermesPackage.all;

-- interface da Hermes_buffer
entity Hermes_buffer is
port(
	clock:      in  std_logic;
	reset:      in  std_logic;
	clock_rx:   in  std_logic;
	rx:         in  std_logic;
	data_in:    in  regflit;
	credit_o:   out std_logic;
	h:          out std_logic;
	ack_h:      in  std_logic;
	data_av:    out std_logic;
	data:       out regflit;
	data_ack:   in  std_logic;
	sender:     out std_logic);
end Hermes_buffer;

architecture Hermes_buffer of Hermes_buffer is

type fifo_out is (S_INIT, S_HEADER, S_SENDHEADER, S_PAYLOAD, S_END);
signal EA : fifo_out;

signal buf: buff := (others=>(others=>'0'));
signal read_pointer,write_pointer: pointer ;
signal counter_flit: regflit ;

signal data_available : std_logic;

begin

	-------------------------------------------------------------------------------------------
	-- IF:
	--   write_pointer    /= read_pointer      :   FIFO WITH SPACE TO WRITE
	--   read_pointer + 1 == write_pointer     :   FIFO EMPTY
	--   write_pointer   == read_pointer       :   FIFO FULL
	-------------------------------------------------------------------------------------------

	-------------------------------------------------------------------------------------------
	-- PROCESS TO WRITE INTO THE FIFO
	-------------------------------------------------------------------------------------------
	process(reset, clock)
	begin
		if reset='1' then
			write_pointer <= (others => '0');
		elsif clock'event and clock='1' then
                -- if receiving data and fifo isn't empty, record data on fifo and increase write pointer
			if rx = '1' and write_pointer /= read_pointer then
				buf(CONV_INTEGER(write_pointer)) <= data_in;
				write_pointer <= write_pointer + 1;
			end if;
		end if;
	end process;
	
	-- If fifo isn't empty, credit is high. Else, low
	credit_o <= '1' when write_pointer /= read_pointer else '0';

	-------------------------------------------------------------------------------------------
	-- PROCESS TO READ THE FIFO
	-------------------------------------------------------------------------------------------

	-- Available the data to transmission (asynchronous read)
	data <= buf(CONV_INTEGER(read_pointer));

	process(reset, clock)
	begin
		if reset='1' then
			counter_flit <= (others=>'0');
			h <= '0';
			data_available <= '0';
			sender <=  '0';
			-- Initialize the read pointer with one position before the write pointer
			read_pointer <= (others=>'1'); 
			EA <= S_INIT;
		elsif clock'event and clock='1' then
			case EA is
				when S_INIT =>
					counter_flit <= (others=>'0');
					h<='0';
					data_available <= '0';
					-- If fifo isn`t empty
					if (read_pointer + 1 /= write_pointer) then
						-- Routing request to Switch Control
						h<='1';
						-- consume de 1st flit - target address
						read_pointer <= read_pointer + 1;
						EA <= S_HEADER;
					end if;

				when S_HEADER =>
					-- When the Switch Control confirm the routing
					if ack_h='1' then					
						h              <= '0';   -- Disable the routing request 
						sender         <= '1';   -- Enable wrapper signal to packet transmission
						data_available <= '1'; 
						EA             <= S_SENDHEADER ;
					end if;

				when S_SENDHEADER  =>
					-- If the data available is read or was read 
					if data_ack = '1' or data_available = '0' then
						-- If fifo isn`t empty 
						if (read_pointer + 1 /= write_pointer) then
							data_available   <= '1';
							read_pointer   <= read_pointer + 1;     -- consumes de second flit (payload size)
							EA <= S_PAYLOAD;
						-- If fifo is empty (protection clause)
						else
							data_available <= '0';
						end if;
					end if;

				when S_PAYLOAD =>
					-- If the data available is read or was read 
					if data_ack = '1' or data_available = '0' then

						-- If fifo isn`t empty or is tail
						if (read_pointer + 1 /= write_pointer) or counter_flit = x"1" then
							-- If the second flit, memorize the packet size
							if counter_flit = x"0"   then   
								counter_flit <=  buf(CONV_INTEGER(read_pointer));
							elsif counter_flit /= x"1" then 
								counter_flit <=  counter_flit - 1;
							end if;

							-- If the tail flit
							if counter_flit = x"1" then
								-- If tail is send
								if data_ack = '1' then
									data_available <= '0';
									sender <= '0';
									EA <= S_INIT;
								else
									EA <= S_END;
								end if;
							-- Else read the next position
							else
								data_available <= '1';
								read_pointer <= read_pointer + 1;
							end if;
						-- If fifo is empty (protection clause)
						else
							data_available <= '0';
						end if;
					end if;

				when S_END =>
					-- When tail is send
					if data_ack = '1' then
						data_available <= '0';
						sender <= '0';
						EA <= S_INIT;
					end if;
			end case;
		end if;
	end process;
	
	data_av <= data_available;

end Hermes_buffer;
