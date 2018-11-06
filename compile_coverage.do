vcom -cover sbcexf blackjack.vhd blackjack_tb.vhd
vsim -coverage -wlfdeleteonquit -novopt work.blackjack_tb
do wave.do
run 3 us
