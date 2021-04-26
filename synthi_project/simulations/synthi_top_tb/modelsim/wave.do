onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/KEY_0
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/status_reg
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/data1_reg
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/data2_reg
add wave -noupdate -format Analog-Step -height 74 -max 32304.0 -min -29472.0 -radix decimal -childformat {{/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(15) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(14) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(13) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(12) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(11) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(10) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(9) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(8) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(7) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(6) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(5) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(4) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(3) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(2) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(1) -radix decimal} {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(0) -radix decimal}} -subitemconfig {/synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(15) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(14) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(13) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(12) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(11) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(10) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(9) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(8) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(7) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(6) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(5) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(4) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(3) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(2) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(1) {-height 15 -radix decimal} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o(0) {-height 15 -radix decimal}} /synthi_top_tb/DUT/tone_gen_1/dds_1/dds_o
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/dds_1/atte
add wave -noupdate /synthi_top_tb/DUT/tone_gen_1/dds_1/attenu_i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3308111 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 306
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ns} {6562504 ns}
