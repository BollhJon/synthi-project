onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/clk
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/ctr_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/emphasis_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/volume_change
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_o
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_data_o
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/State
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {41760 ns} 0}
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
WaveRestoreZoom {0 ns} {21081984 ns}
