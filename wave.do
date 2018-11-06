onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /blackjack_tb/e_atual
add wave -noupdate -expand -group tb /blackjack_tb/clk
add wave -noupdate -expand -group tb /blackjack_tb/reset
add wave -noupdate -expand -group tb -color Orange /blackjack_tb/stay
add wave -noupdate -expand -group tb -color Orange /blackjack_tb/hit
add wave -noupdate -expand -group tb /blackjack_tb/debug
add wave -noupdate -expand -group tb /blackjack_tb/show
add wave -noupdate -expand -group tb /blackjack_tb/win
add wave -noupdate -expand -group tb /blackjack_tb/lose
add wave -noupdate -expand -group tb /blackjack_tb/tie
add wave -noupdate -expand -group tb -color Coral /blackjack_tb/request
add wave -noupdate -expand -group tb -radix unsigned /blackjack_tb/card
add wave -noupdate -expand -group tb -radix unsigned /blackjack_tb/total
add wave -noupdate -expand -group tb -radix unsigned /blackjack_tb/test_deck
add wave -noupdate -expand -group ent /blackjack_tb/bjack/clk
add wave -noupdate -expand -group ent /blackjack_tb/bjack/reset
add wave -noupdate -expand -group ent -color Orange /blackjack_tb/bjack/stay
add wave -noupdate -expand -group ent -color Orange /blackjack_tb/bjack/hit
add wave -noupdate -expand -group ent /blackjack_tb/bjack/debug
add wave -noupdate -expand -group ent /blackjack_tb/bjack/show
add wave -noupdate -expand -group ent -color Coral /blackjack_tb/bjack/request
add wave -noupdate -expand -group ent -radix unsigned /blackjack_tb/bjack/card
add wave -noupdate -expand -group ent /blackjack_tb/bjack/win
add wave -noupdate -expand -group ent /blackjack_tb/bjack/lose
add wave -noupdate -expand -group ent /blackjack_tb/bjack/tie
add wave -noupdate -expand -group ent /blackjack_tb/bjack/fim_de_jogo
add wave -noupdate -expand -group ent -radix unsigned /blackjack_tb/bjack/total
add wave -noupdate -expand -group ent -radix decimal /blackjack_tb/bjack/result_soma
add wave -noupdate -expand -group ent /blackjack_tb/bjack/ultrapassou
add wave -noupdate -expand -group ent /blackjack_tb/bjack/e_atual
add wave -noupdate -expand -group ent -color Coral /blackjack_tb/bjack/pega_nova_carta
add wave -noupdate -expand -group ent -color Coral /blackjack_tb/bjack/recebe_nova_carta
add wave -noupdate -expand -group ent /blackjack_tb/bjack/j_atual
add wave -noupdate -expand -group ent /blackjack_tb/bjack/player_tem_as
add wave -noupdate -expand -group ent -radix unsigned /blackjack_tb/bjack/soma_player_vector
add wave -noupdate -expand -group ent -radix unsigned /blackjack_tb/bjack/soma_player
add wave -noupdate -expand -group ent /blackjack_tb/bjack/dealer_tem_as
add wave -noupdate -expand -group ent -radix unsigned /blackjack_tb/bjack/soma_dealer_vector
add wave -noupdate -expand -group ent -radix unsigned /blackjack_tb/bjack/soma_dealer
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2012500 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1963300 ps} {3073900 ps}
