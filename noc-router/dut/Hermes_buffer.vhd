------------------------------------------------------------------------------------------------
--
--  DISTRIBUTED HEMPS  - version 5.0
--
--  Research group: GAPH-PUCRS    -    contact   fernando.moraes@pucrs.br
--
--  Distribution:  September 2013
--
--  Source name:  Hermes_buffer.vhd
--
--  Brief description: Description of queues of flits
--
---------------------------------------------------------------------------------------
--                                      BUFFER
--                         --------------
--                   RX ->|             |-> H
--              DATA_IN ->|             |<- ACK_H
--             CLOCK_RX ->|             |
--             CREDIT_O <-|             |-> DATA_AV
--                        |             |-> DATA
--                        |             |<- DATA_ACK
--                        |             |
--                        |             |   SENDER
--                        |             |=> de todas
--                        |             |   as portas
--                         --------------
--
--  Quando o algoritmo de chaveamento resulta no bloqueio dos flits de um pacote,
--  ocorre uma perda de desempenho em toda rede de interconexão, porque os flits são
--  bloqueados não somente na chave atual, mas em todas as intermediárias.
--  Para diminuir a perda de desempenho foi adicionada uma fila em cada porta de
--  entrada da chave, reduzindo as chaves afetadas com o bloqueio dos flits de um
--  pacote. É importante observar que quanto maior for o tamanho da fila menor será o
--  número de chaves intermediárias afetadas.
--  As filas usadas contêm dimensão e largura de flit parametrizáveis, para alterá-las
--  modifique as constantes TAM_BUFFER e TAM_FLIT no arquivo "packet.vhd".
--  As filas funcionam como FIFOs circulares. Cada fila possui dois ponteiros: first e
--  last. First aponta para a posição da fila onde se encontra o flit a ser consumido.
--  Last aponta para a posição onde deve ser inserido o próximo flit.
---------------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.HeMPS_defaults.all;
use work.HemPS_PKG.all;

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

type fila_out is (S_INIT, S_PAYLOAD, S_SENDHEADER, S_HEADER, S_END, S_END2);
signal EA : fila_out;

signal buf: buff := (others=>(others=>'0'));
signal first,last: pointer := (others=>'0');
signal tem_espaco: std_logic := '0';
signal counter_flit: regflit := (others=>'0');

begin

        -------------------------------------------------------------------------------------------
        -- ENTRADA DE DADOS NA FILA
        -------------------------------------------------------------------------------------------

        -- Verifica se existe espaço na fila para armazenamento de flits.
        -- Se existe espaço na fila o sinal tem_espaco_na_fila é igual 1.
        process(reset, clock_rx)
        begin
                if reset='1' then
                        tem_espaco <= '1';
                elsif clock_rx'event and clock_rx='1' then
                        if not((first=x"0" and last=TAM_BUFFER - 1) or (first=last+1)) then
                                tem_espaco <= '1';
--			elsif (((last - first)=x"2") or ((first - last)=TAM_BUFFER - 2)) then
                        else
                                tem_espaco <= '0';
                        end if;
                end if;
        end process;

        credit_o <= tem_espaco;

        -- O ponteiro last é inicializado com o valor zero quando o reset é ativado.
        -- Quando o sinal rx é ativado indicando que existe um flit na porta de entrada é
        -- verificado se existe espaço na fila para armazená-lo. Se existir espaço na fila o
        -- flit recebido é armazenado na posição apontada pelo ponteiro last e o mesmo é
        -- incrementado. Quando last atingir o tamanho da fila, ele recebe zero.
        process(reset, clock_rx)
        begin
                if reset='1' then
                        last <= (others=>'0');
                elsif clock_rx'event and clock_rx='0' then
                        if tem_espaco='1' and rx='1' then
                                buf(CONV_INTEGER(last)) <= data_in;
                                --incrementa o last
                                if(last = TAM_BUFFER - 1) then last <= (others=>'0');
                                else last <= last + 1;
                                end if;
                        end if;
                end if;
        end process;

        -------------------------------------------------------------------------------------------
        -- SAÍDA DE DADOS NA FILA
        -------------------------------------------------------------------------------------------

        -- disponibiliza o dado para transmissão.
        data <= buf(CONV_INTEGER(first));

        -- Quando sinal reset é ativado a máquina de estados avança para o estado S_INIT.
        -- No estado S_INIT os sinais counter_flit (contador de flits do corpo do pacote), h (que
        -- indica requisição de chaveamento) e data_av (que indica a existência de flit a ser
        -- transmitido) são inicializados com zero. Se existir algum flit na fila, ou seja, os
        -- ponteiros first e last apontarem para posições diferentes, a máquina de estados avança
        -- para o estado S_HEADER.
        -- No estado S_HEADER é requisitado o chaveamento (h='1'), porque o flit na posição
        -- apontada pelo ponteiro first, quando a máquina encontra-se nesse estado, é sempre o
        -- header do pacote. A máquina permanece neste estado até que receba a confirmação do
        -- chaveamento (ack_h='1') então o sinal h recebe o valor zero e a máquina avança para
        -- S_SENDHEADER.
        -- Em S_SENDHEADER é indicado que existe um flit a ser transmitido (data_av='1'). A máquina de
        -- estados permanece em S_SENDHEADER até receber a confirmação da transmissão (data_ack='1')
        -- então o ponteiro first aponta para o segundo flit do pacote e avança para o estado S_PAYLOAD.
        -- No estado S_PAYLOAD é indicado que existe um flit a ser transmitido (data_av='1') quando
        -- é recebida a confirmação da transmissão (data_ack='1') é verificado qual o valor do sinal
        -- counter_flit. Se counter_flit é igual a um, a máquina avança para o estado S_INIT. Caso
        -- counter_flit seja igual a zero, o sinal counter_flit é inicializado com o valor do flit, pois
        -- este ao número de flits do corpo do pacote. Caso counter_flit seja diferente de um e de zero
        -- o mesmo é decrementado e a máquina de estados permanece em S_PAYLOAD enviando o próximo flit
        -- do pacote.
        process(reset, clock)
        begin
                if reset='1' then
                        counter_flit <= (others=>'0');
                        h <= '0';
                        data_av <= '0';
                        sender <=  '0';
                        first <= (others=>'0');
                        EA <= S_INIT;
                elsif clock'event and clock='1' then
                        case EA is
                                when S_INIT =>
                                        counter_flit <= (others=>'0');
                                        h<='0';
                                        data_av <= '0';
                                        if first /= last then -- detectou dado na fila
                                                h<='1';           -- pede roteamento
                                                EA <= S_HEADER;
                                        else
                                                EA<= S_INIT;
                                        end if;
                                when S_HEADER =>
                                        if ack_h='1' then -- confirmação de roteamento
                                                EA <= S_SENDHEADER ;
                                                h<='0';
                                                data_av <= '1';
                                                sender <=  '1';
                                        else
                                                EA <= S_HEADER;
                                        end if;
                                when S_SENDHEADER  =>
                                        if data_ack = '1' then  -- confirmação do envio do header
                                                -- retira o header do buffer e se tem dado no buffer pede envio do mesmo
                                                if (first = TAM_BUFFER -1) then
                                                        first <= (others=>'0');
                                                        if last /= 0 then data_av <= '1';
                                                        else data_av <= '0';
                                                        end if;
                                                else
                                                        first <= first+1;
                                                        if first+1 /= last then data_av <= '1';
                                                        else data_av <= '0';
                                                        end if;
                                                end if;
                                                EA <= S_PAYLOAD;
                                        else
                                                EA <= S_SENDHEADER;
                                        end if;
                                when S_PAYLOAD =>
                                        if data_ack = '1' and counter_flit /= x"1" then -- confirmação do envio de um dado que não é o tail
                                                -- se counter_flit é zero indica recepção do size do payload
                                                if counter_flit = x"0" then    counter_flit <=  buf(CONV_INTEGER(first));
                                                else counter_flit <= counter_flit - 1;
                                                end if;

                                                -- retira um dado do buffer e se tem dado no buffer pede envio do mesmo
                                                if (first = TAM_BUFFER -1) then
                                                        first <= (others=>'0');
                                                        if last /= 0 then data_av <= '1';
                                                        else data_av <= '0';
                                                        end if;
                                                else
                                                        first <= first+1;
                                                        if first+1 /= last then data_av <= '1';
                                                        else data_av <= '0';
                                                        end if;
                                                end if;
                                                EA <= S_PAYLOAD;
                                        elsif data_ack = '1' and counter_flit = x"1" then -- confirmação do envio do tail
                                                -- retira um dado do buffer
                                                if (first = TAM_BUFFER -1) then    first <= (others=>'0');
                                                else first <= first+1;
                                                end if;
                                                data_av <= '0';
                                                sender <=  '0';
                                                EA <= S_END;
                                        elsif first /= last then -- se tem dado a ser enviado faz a requisição
                                                data_av <= '1';
                                                EA <= S_PAYLOAD;
                                        else
                                                EA <= S_PAYLOAD;
                                        end if;
                                when S_END =>
                                        data_av <= '0';
                                        EA <= S_END2;
                                when S_END2 => -- estado necessario para permitir a liberação da porta antes da solicitação de novo envio
                                        data_av <= '0';
                                        EA <= S_INIT;
                        end case;
                end if;
        end process;

end Hermes_buffer;
