onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/clk_6m
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/reset_n
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/rx_data
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/rx_data_rdy
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/midi_state
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/data_flag
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/new_data_flag
add wave -noupdate -expand /synthi_top_tb/DUT/midi_controller_fsm_1/note_on
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/note_o
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/velocity
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/status_reg
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/data1_reg
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/data2_reg
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/reg_note_on
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/reg_note
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/reg_velocity
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
WaveRestoreZoom {0 ns} {2486904 ns}
