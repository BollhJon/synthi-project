onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/KEY_0
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/i2s_frame_generator_1/rst_n
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/i2s_frame_generator_1/clk_6m
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/i2s_frame_generator_1/bckl
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/i2s_frame_generator_1/ws
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/i2s_frame_generator_1/load
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/i2s_frame_generator_1/shift_l
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/i2s_frame_generator_1/shift_r
add wave -noupdate -radix decimal /synthi_top_tb/DUT/i2s_master_1/i2s_frame_generator_1/count
add wave -noupdate -format Analog-Step -height 74 -max 65334.999999999993 -radix binary /synthi_top_tb/DUT/i2s_master_1/dacdat_pr_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_s_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/uni_shiftreg_1/ser_out
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/uni_shiftreg_2/ser_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {908822 ns} 0}
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
WaveRestoreZoom {906736 ns} {912780 ns}
