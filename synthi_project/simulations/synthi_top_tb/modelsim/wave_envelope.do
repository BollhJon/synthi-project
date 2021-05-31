onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/envelope_logic_inst_gen(0)/inst_envelope_logic/clk_6m
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/envelope_logic_inst_gen(0)/inst_envelope_logic/reset_n
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/envelope_logic_inst_gen(0)/inst_envelope_logic/tone_on_i
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/envelope_logic_inst_gen(0)/inst_envelope_logic/lut_sel
add wave -noupdate -radix decimal /synthi_top_tb/DUT/tone_gen_1/envelope_logic_inst_gen(0)/inst_envelope_logic/count
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/envelope_logic_inst_gen(0)/inst_envelope_logic/lut_addr
add wave -noupdate -format Analog-Step -height 74 -max 101.0 -min 31.0 -radix unsigned /synthi_top_tb/DUT/tone_gen_1/envelope_logic_inst_gen(0)/inst_envelope_logic/attenu_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9256627 ns} 0}
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
WaveRestoreZoom {0 ns} {13342560 ns}
