onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/KEY_0
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/status_reg
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/data1_reg
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/data2_reg
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/midi_state
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/next_midi_state
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/data_flag
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/midi_reg/note_available
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/midi_reg/note_written
add wave -noupdate -expand /synthi_top_tb/DUT/midi_controller_fsm_1/reg_note_on
add wave -noupdate -format Analog-Step -height 74 -max 4095.0 -min -4096.0 -radix decimal /synthi_top_tb/DUT/tone_gen_1/dds_l_o
add wave -noupdate /synthi_top_tb/SW
add wave -noupdate -radix decimal /synthi_top_tb/DUT/tone_gen_1/fm_dds_inst_gen(0)/inst_fm_dds/dds_mod/lut_sel
add wave -noupdate -childformat {{/synthi_top_tb/DUT/reg_controller_1/config_o(0) -radix decimal} {/synthi_top_tb/DUT/reg_controller_1/config_o(1) -radix decimal} {/synthi_top_tb/DUT/reg_controller_1/config_o(2) -radix decimal} {/synthi_top_tb/DUT/reg_controller_1/config_o(3) -radix decimal} {/synthi_top_tb/DUT/reg_controller_1/config_o(4) -radix decimal} {/synthi_top_tb/DUT/reg_controller_1/config_o(5) -radix decimal}} -expand -subitemconfig {/synthi_top_tb/DUT/reg_controller_1/config_o(0) {-radix decimal} /synthi_top_tb/DUT/reg_controller_1/config_o(1) {-radix decimal} /synthi_top_tb/DUT/reg_controller_1/config_o(2) {-radix decimal} /synthi_top_tb/DUT/reg_controller_1/config_o(3) {-radix decimal} /synthi_top_tb/DUT/reg_controller_1/config_o(4) {-radix decimal} /synthi_top_tb/DUT/reg_controller_1/config_o(5) {-radix decimal}} /synthi_top_tb/DUT/reg_controller_1/config_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28182240 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 472
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
WaveRestoreZoom {21025457 ns} {43678745 ns}
