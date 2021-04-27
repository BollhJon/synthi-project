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
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/new_data_flag
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/midi_reg/note_available
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/midi_reg/note_written
add wave -noupdate -expand /synthi_top_tb/DUT/midi_controller_fsm_1/reg_note_on
add wave -noupdate /synthi_top_tb/DUT/midi_controller_fsm_1/next_reg_note_on
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1208657 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 367
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
WaveRestoreZoom {0 ns} {2446920 ns}
