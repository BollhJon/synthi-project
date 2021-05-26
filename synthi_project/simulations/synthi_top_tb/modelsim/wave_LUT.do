onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/clk_6m
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/lut_sel_car
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/tone_on_i(0)
add wave -noupdate -format Analog-Step -height 150 -max 4200.0 -min -4200.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/dds_o_array(0)
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/phi_incr_i
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/step_i
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/tone_on_i
add wave -noupdate -max 1.0 -min -1.0 /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/attenu_i
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/lut_sel
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/dds_o
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {42852350 ns} 0}
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
WaveRestoreZoom {134032 ns} {56430672 ns}
