onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/clk_6m
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_car_1/tone_on_i
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/fm_ratio
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/phi_incr_fsig
add wave -noupdate -radix unsigned /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/phi_incr_mod_sig
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1749662 ns} 0}
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
WaveRestoreZoom {3732339 ns} {6558425 ns}
