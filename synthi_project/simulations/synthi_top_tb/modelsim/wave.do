onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/clk
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/write_i
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/write_data_i
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/write_done_o
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/fsm_state
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/data
add wave -noupdate /synthi_top_tb/DUT/i2c_master_1/bit_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {96234400 ns} 0}
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
WaveRestoreZoom {0 ns} {57932948 ns}
