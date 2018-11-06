--------------------------------------------------------------------------------
-- Arquivo: blackjack_tb.vhd
-- Autor:   Rafael Rios
-- E-mail:  rafael.rios@acad.pucrs.br
-- Data:    2018-10-30
--------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity blackjack_tb is
	end blackjack_tb;

architecture blackjack_tb_arch of blackjack_tb is
	subtype carta is STD_LOGIC_VECTOR (3 downto 0); 
	type deck is array (integer range<>) of carta;
	type estado is (t_win, t_win_of, t_lose, t_lose_of, t_tie, t_hit, t_invalido, t_as, t_as_dealer);
	signal e_atual : estado := t_win;
	signal clk, reset, stay, hit, debug, show, win, lose, tie, request : STD_LOGIC := '0';
	signal card : STD_LOGIC_VECTOR (3 downto 0) := x"0";
	signal total : STD_LOGIC_VECTOR (4 downto 0);
	signal test_deck : deck (0 to 7) := (others=>x"0");
begin
	clk <= not clk after 2500 ps;
	bjack: entity work.blackjack port map(
																 clk => clk, reset => reset, stay => stay, hit => hit, debug => debug,
																 show => show, win => win, lose => lose, tie => tie, total => total,
																 request => request, card => card
															 );  
	deckgen : process
		variable index : integer := 0;
	begin
		wait until (clk = '1');
		if (reset = '1') then 
			index := 0;
			card <= x"0"; --test_deck(0);
		else
			card <= test_deck(index);
			if (index >= 7) then 
				index := 0;
			else 
				index := index + 1; 
			end if; 
			wait for 18 ns;
		end if;
	end process;
	fsm : process
		variable cont : integer := 0;
	begin
		wait until rising_edge(clk);
		case e_atual is
			when t_win =>
				reset <= '1';
				wait for 100 ns;
				reset <= '0';
				test_deck <= (x"A",x"3",x"A",x"5",others=>x"A");
				wait for 200 ns;
				stay <= '1';
				wait for 100 ns;
				stay <= '0';
				reset <= '1';
				wait for 20 ns;
				e_atual <= t_win_of;
			when t_win_of =>
				reset <= '0';
				test_deck <= (x"3",x"C",x"8",x"C",others=>x"0");
				wait for 200 ns;
				stay <= '1';
				wait for 100 ns;
				stay <= '0';
				reset <= '1';
				wait for 20 ns;
		 		e_atual <= t_lose;		 
			when t_lose =>
				reset <= '0';
				debug <= '1';
				test_deck <= (x"3",x"A",x"8",x"4",others=>x"2");
				wait for 100 ns;
				stay <= '1';
				wait for 100 ns;
				stay <= '0';
				reset <= '1';
				wait for 20 ns;
		 		e_atual <= t_lose_of;		 
			when t_lose_of =>
				reset <= '0';
				show <= '1';
				test_deck <= (x"C",x"A",x"C",x"A",others=>x"0");
				wait for 200 ns;
				stay <= '1';
				wait for 100 ns;
				stay <= '0';
				reset <= '1';
				debug <= '0';
				wait for 20 ns;
		 		e_atual <= t_tie;		 
			when t_tie =>
				reset <= '0';
				test_deck <= (x"C",x"C",x"6",x"6",others=>x"0");
				wait for 200 ns;
				stay <= '1';
				wait for 100 ns;
				stay <= '0';
				reset <= '1';
				show <= '0';
				wait for 20 ns;
				e_atual <= t_hit;
			when t_hit =>
				reset <= '0';
				test_deck <= (x"C",x"C",x"4",x"4",others=>x"2");
				wait for 200 ns;
				hit <= '1';
				stay <= '1';
				wait for 30 ns;
				hit <= '0';
				wait for 50 ns;
				stay <= '0';
				reset <= '1';
				wait for 20 ns;
				e_atual <= t_as;
			when t_invalido =>
				reset <= '0';
				test_deck <= (x"9",x"F",x"C",x"3",others=>x"9");
				wait for 200 ns;
				stay <= '1';
				wait for 100 ns;
				stay <= '0';
				wait;
			when t_as =>
				reset <= '0';
				test_deck <= (x"A",x"C",x"A",x"7",others=>x"1");
				wait for 110 ns;
				hit <= '1';
				wait for 50 ns;
				hit <= '0';
				stay <= '1';
				wait for 50 ns;
				stay <= '0';
				reset <= '1';
				wait for 20 ns;
				e_atual <= t_as_dealer;
			when t_as_dealer =>
				reset <= '0';
				test_deck <= (x"C",x"A",x"2",x"6",others=>x"1");
				wait for 110 ns;
				stay <= '1';
				wait for 50 ns;
				stay <= '0';
				reset <= '1';
				wait for 20 ns;
				e_atual <= t_invalido;
		end case;
	end process;
end blackjack_tb_arch;

