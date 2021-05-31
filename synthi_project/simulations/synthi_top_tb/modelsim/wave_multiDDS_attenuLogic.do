onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/clk_6m
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/reset_n
add wave -noupdate -expand /synthi_top_tb/DUT/tone_gen_1/tone_on_i
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/attenu_sig
add wave -noupdate -format Analog-Step -height 250 -max 12000.0 -min -12000.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/sum_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {53228390 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 507
configure wave -valuecolwidth 258
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {139968528 ns}
