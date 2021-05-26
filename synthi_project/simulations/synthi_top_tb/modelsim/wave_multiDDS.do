onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/attenu_i
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/attenu_sig
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/attenu_array_sig
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/attenu_array
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/attenu_1/tone_on_i
add wave -noupdate -format Analog-Step -height 74 -max 12865.999999999998 -min -11127.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/dds_l_o
add wave -noupdate -format Analog-Step -height 74 -max 3963.0000000000009 -min -3968.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 3581.0000000000005 -min -3584.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(1)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 3070.0 -min -3072.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(2)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 3070.0 -min -3072.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(3)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 2685.0 -min -2688.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(4)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 1645.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(5)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 2047.0 -min -996.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(6)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 2046.9999999999995 -min -2048.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(7)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 1405.0 -min -1408.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(8)/inst_fm_dds/fm_dds_o
add wave -noupdate -format Analog-Step -height 74 -max 1405.0 -min -1408.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(9)/inst_fm_dds/fm_dds_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {128840550 ns} 0}
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
WaveRestoreZoom {0 ns} {139984593 ns}
