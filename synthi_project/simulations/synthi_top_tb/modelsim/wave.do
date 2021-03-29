onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/KEY_0
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_pr_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_pl_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/adcdat_s_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/clk_6m
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/rst_n
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_s_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/step_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ws_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/adcdat_pl_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/adcdat_pr_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/load_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_l_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_r_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ws_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ser_out_l_sig
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ser_out_r_sig
add wave -noupdate /synthi_top_tb/DUT/path_control_1/dds_l_i
add wave -noupdate /synthi_top_tb/DUT/path_control_1/dds_r_i
add wave -noupdate /synthi_top_tb/DUT/path_control_1/adcdat_pl_i
add wave -noupdate /synthi_top_tb/DUT/path_control_1/adcdat_pr_i
add wave -noupdate /synthi_top_tb/DUT/path_control_1/dacdat_pl_o
add wave -noupdate /synthi_top_tb/DUT/path_control_1/dacdat_pr_o
add wave -noupdate /synthi_top_tb/DUT/path_control_1/sw
TreeUpdate [SetDefaultTree]
WaveRestoreCursors
quietly wave cursor active 0
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
WaveRestoreZoom {0 ns} {50696 ns}
