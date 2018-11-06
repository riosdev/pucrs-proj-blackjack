--------------------------------------------------------------------------------
-- Arquivo: blackjack.vhd
-- Autor:   Rafael Rios
-- E-mail:  rafael.rios@acad.pucrs.br
-- Data:    2018-10-30
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity controlador_de_cartas is
	port(
				clk : in STD_LOGIC;
				reset : in STD_LOGIC;
				request : out STD_LOGIC;
				card : in STD_LOGIC_VECTOR (3 downto 0);
				request_interno : in STD_LOGIC;
				ack : out STD_LOGIC;
				sel_jog : in STD_LOGIC;
				soma_player_vector : out STD_LOGIC_VECTOR (4 downto 0);
				soma_dealer_vector : out STD_LOGIC_VECTOR (4 downto 0);
				player_tem_as : out STD_LOGIC;
				dealer_tem_as : out STD_LOGIC
);
end controlador_de_cartas;

architecture controlador_de_cartas_arch of controlador_de_cartas is
	type estado is ( envia_request, envia_ack, limpa );
	signal entrada_mem, saida_mem  : STD_LOGIC_VECTOR (4 downto 0) := (others=>'0');
	signal mem_jogador, mem_dealer : STD_LOGIC_VECTOR (4 downto 0) := (others=>'0');
	signal jogador_as, dealer_as : STD_LOGIC := '0';
	signal carta : integer range 0 to 255;
begin
	player_tem_as <= jogador_as;
	dealer_tem_as <= dealer_as;
	carta <= 10 when (card >= x"B" and card <= x"D") else
				 to_integer(unsigned(card));
	entrada_mem <= card + saida_mem;
	saida_mem <= mem_jogador when (sel_jog = '1') else
							 mem_dealer when (sel_jog = '0') else (others=>'Z');
	soma_player_vector <= mem_jogador;
	soma_dealer_vector <= mem_dealer;
	mem : process(clk,request_interno)
		variable send_ack : integer := 0;
	begin
		if rising_edge(clk) then
			if (reset = '1') then
				mem_jogador <= (others=>'0');
				mem_dealer <= (others=>'0');
				request <= '0';
				send_ack := 0;
				ack <= '0';
				jogador_as <= '0';
				dealer_as <= '0';
			elsif (request_interno = '1') then
				if (send_ack = 0) then
					request <= '1'; 
					ack <= '0';
					send_ack := send_ack + 1;
				elsif (send_ack = 1) then
					if (carta > 0 and carta < 14) then
						ack <= '1';
						request <= '0';
						send_ack := 2;
						if (sel_jog = '1') then
							if (carta = 1) then 
								jogador_as <= '1'; 
								mem_jogador <= entrada_mem + 10;
							else
								mem_jogador <= entrada_mem;
							end if;
						elsif (sel_jog = '0') then
							if (carta = 1) then 
								dealer_as <= '1'; 
								mem_dealer <= entrada_mem + 10;
							else
								mem_dealer <= entrada_mem;
							end if;
						end	if;
					end if;
				else
					send_ack := 0;
					ack <= '0';
				end if;
			end if;
		end if;
	end process;
end controlador_de_cartas_arch;
--------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity blackjack is
	port(
				clk : in STD_LOGIC;
				reset : in STD_LOGIC;
				stay : in STD_LOGIC;
				hit : in STD_LOGIC;
				debug : in STD_LOGIC;
				show : in STD_LOGIC;
				request : out STD_LOGIC;
				card : in STD_LOGIC_VECTOR (3 downto 0);
				win : out STD_LOGIC;
				lose: out STD_LOGIC;
				tie: out STD_LOGIC;
				total: out STD_LOGIC_VECTOR (4 downto 0)
);
end blackjack;

architecture blackjack_arch of blackjack is
	-- define jogador
	type jogador is (player, dealer);
	signal j_atual : jogador;
	-- define estados da FSM
	type estado is (idle, inicializa, aguarda_acao, calc_acao_dealer,
	hit_player, stay_player, stay_dealer, win_player, win_dealer);
	signal e_atual : estado := idle;
	signal pega_nova_carta, recebe_nova_carta, seleciona_jogador : STD_LOGIC;
	signal soma_player_vector, soma_dealer_vector : STD_LOGIC_VECTOR (4 downto 0);
	signal soma_player, soma_dealer : integer ; 
	signal player_tem_as, dealer_tem_as : STD_LOGIC;
	signal ultrapassou : STD_LOGIC;
	signal result_soma : integer range -1 to 1;
	signal fim_de_jogo : STD_LOGIC;
begin
	soma_player <= to_integer(unsigned(soma_player_vector));
	soma_dealer <= to_integer(unsigned(soma_dealer_vector));
	-- instancia controlador de cartas
	cc: entity work.controlador_de_cartas port map(
		clk=>clk, reset=>reset, request=>request, card=>card, 
		request_interno => pega_nova_carta, ack => recebe_nova_carta,
		sel_jog => seleciona_jogador, soma_player_vector => soma_player_vector,
		soma_dealer_vector => soma_dealer_vector, player_tem_as => player_tem_as,
		dealer_tem_as => dealer_tem_as);
	seleciona_jogador <= '1' when (j_atual = player) else
											 '0' when (j_atual = dealer) else
											 'Z';
	-- maquina de estados
	fsm: process(e_atual, clk)
		variable libera_hit : boolean := false;
		variable conta_cartas_inicias : integer range 0 to 5;
	begin
		if (rising_edge(clk)) then
			if(reset = '1') then
				libera_hit := false;
				e_atual <= idle;
				pega_nova_carta <= '0';
				fim_de_jogo <= '0';
				conta_cartas_inicias := 0;
			else
				case e_atual is
					when idle =>
						e_atual <= inicializa;
						win <= 'Z';
						tie <= 'Z';
						lose <= 'Z';
					when inicializa =>
						case conta_cartas_inicias is
							when 0 =>
								j_atual <= player;
								if (recebe_nova_carta /= '1') then
									pega_nova_carta <= '1';
								elsif (recebe_nova_carta = '1') then
									pega_nova_carta <= '0';
									conta_cartas_inicias := 1;
								end if;
							when 1 =>
								j_atual <= dealer;
								if (recebe_nova_carta /= '1') then
									pega_nova_carta <= '1';
								elsif (recebe_nova_carta = '1') then
									pega_nova_carta <= '0';
									conta_cartas_inicias := 2;
								end if;
							when 2 =>
								j_atual <= player;
								if (recebe_nova_carta /= '1') then
									pega_nova_carta <= '1';
								elsif (recebe_nova_carta = '1') then
									pega_nova_carta <= '0';
									conta_cartas_inicias := 3;
								end if;
							when 3 =>
								j_atual <= dealer;
								if (recebe_nova_carta /= '1') then
									pega_nova_carta <= '1';
								elsif (recebe_nova_carta = '1') then
									pega_nova_carta <= '0';
									conta_cartas_inicias := 4;
								end if;
							when 4 =>
								if (ultrapassou = '1') then e_atual <= win_player;
								else 
									conta_cartas_inicias := 5;
									j_atual <= player;
								end if;
							when 5 =>
								if(ultrapassou = '1') then e_atual <= win_dealer;
								else e_atual <= aguarda_acao; conta_cartas_inicias := 5;
								end if;
						end case;
					when aguarda_acao =>
						if (hit xnor stay) = '1' then
							e_atual <= aguarda_acao;
						elsif (hit = '1') then
							e_atual <= hit_player;
						elsif (stay = '1') then
							e_atual <= calc_acao_dealer;
						end if;
					when hit_player =>
						j_atual <= player;
						if (libera_hit = false and recebe_nova_carta /= '1') then
							pega_nova_carta <= '1';
						elsif (recebe_nova_carta = '1') then
							pega_nova_carta <= '0';
							if (ultrapassou = '1') then e_atual <= win_dealer;
							elsif (hit = '0') then e_atual <= aguarda_acao; 
							else libera_hit := true;
							end if;
						elsif (libera_hit = true and hit = '0') then
							e_atual <= aguarda_acao;
							libera_hit := false;
						end if;
					when stay_player =>
						j_atual <= dealer;
						if (recebe_nova_carta /= '1') then
							pega_nova_carta <= '1';
						elsif (recebe_nova_carta = '1') then
							pega_nova_carta <= '0';
							if (ultrapassou = '1') then e_atual <= win_player;
							else e_atual <= calc_acao_dealer; end if;
						end if;
					when calc_acao_dealer =>
						if (soma_dealer <= 16) then e_atual <= stay_player;
					else e_atual <= stay_dealer; end if;
					when stay_dealer =>
						fim_de_jogo <= '1';
						case result_soma is
							when 1 =>
								win <= '1';
								tie <= '0';
								lose <= '0';
							when 0 =>
								win <= '0';
								tie <= '1';
								lose <= '0';
							when -1 =>
								win <= '0';
								tie <= '0';
								lose <= '1';
						end case;
					when win_player =>
						fim_de_jogo <= '1';
						win <= '1';
						tie <= '0';
						lose <= '0';
					when win_dealer =>
						fim_de_jogo <= '1';
						win <= '0';
						tie <= '0';
						lose <= '1';
				end case;
			end if;
		end if;
	end process;
	-- mostra total
	t: process(fim_de_jogo, soma_player, soma_dealer, show, debug)
	begin
		if (fim_de_jogo = '0') then
			if(debug = '1') then
				if (show = '1') then
					total <= std_logic_vector(to_unsigned(soma_dealer, 5)); 
				 else 
					total <=  std_logic_vector(to_unsigned(soma_player, 5));
				end if;
			else
				total <= std_logic_vector(to_unsigned(soma_player, 5));
			end if;
		else
			if (show = '1') then
				total <= std_logic_vector(to_unsigned(soma_dealer, 5)); 
			else 
				total <= std_logic_vector(to_unsigned(soma_player, 5));
			end if;
		end if;
	end process;
	-- verifica somatorio
	vs: process(clk)
		variable tem_as : STD_LOGIC;
		variable soma : integer;
	begin
		if (j_atual = player) then 
			soma := soma_player;
			tem_as := player_tem_as;
		else
			soma := soma_dealer;
			tem_as := dealer_tem_as;
		end if;
		if (tem_as = '0' and soma > 21) then
			ultrapassou <= '1';
		else
			ultrapassou <= '0';
		end if;
	end process;
	-- compara somatorio
	result_soma <= -1 when (soma_player < soma_dealer) else
								 1 when (soma_player > soma_dealer) else
								 0;
end blackjack_arch;
