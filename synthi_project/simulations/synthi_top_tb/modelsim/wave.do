onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/KEY_0
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/mode
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_done_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/ack_error_i
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/clk
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_o
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/write_data_o
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/State
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/next_State
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/count
add wave -noupdate /synthi_top_tb/DUT/codec_controller_1/next_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2356070 ns} 0}
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
WaveRestoreZoom {0 ns} {105 ms}
