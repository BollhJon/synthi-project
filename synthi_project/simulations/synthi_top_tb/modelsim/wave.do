onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/KEY_0
add wave -noupdate -format Analog-Step -height 74 -max 8628.0000000000018 -min 44.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/phi_incr_car_sig
add wave -noupdate -format Analog-Step -height 74 -max 4092.0 -min -4096.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_o_mod_sig
add wave -noupdate -format Analog-Step -height 74 -max 3963.0000000000009 -min -3968.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/dds_o
add wave -noupdate -format Analog-Step -height 74 -max 4536.0 -min 44.0 -radix unsigned /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/phi_incr_fsig
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/codec_controller_1/volume_i
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/codec_controller_1/emphasis_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_data_o
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/State
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/next_State
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/codec_controller_1/count
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/mode_change
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/volume_change
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/fm_ratio
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/fm_depth
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/attenu_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {9233150 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 507
configure wave -valuecolwidth 125
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
WaveRestoreZoom {0 ns} {64052848 ns}
