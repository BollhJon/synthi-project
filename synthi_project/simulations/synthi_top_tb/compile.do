# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../support/simulation_pkg.vhd
vcom -2008 -explicit -work work ../../support/standard_driver_pkg.vhd
vcom -2008 -explicit -work work ../../support/user_driver_pkg.vhd

# vcom -2008 -explicit -work work ../../../source/file.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure/modulo_divider.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure/clock_sync.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure/signal_checker.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure/infrastructure.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure/vector_check.vhd
vcom -2008 -explicit -work work ../../../source/midi/baud_tick.vhd
vcom -2008 -explicit -work work ../../../source/midi/bit_counter.vhd
vcom -2008 -explicit -work work ../../../source/midi/vhdl_hex2sevseg.vhd
vcom -2008 -explicit -work work ../../../source/midi/count_down.vhd
vcom -2008 -explicit -work work ../../../source/midi/flanken_detekt_vhdl.vhd
vcom -2008 -explicit -work work ../../../source/midi/output_register.vhd
vcom -2008 -explicit -work work ../../../source/midi/shiftreg_uart.vhd
vcom -2008 -explicit -work work ../../../source/midi/uart_controller_fsm.vhd
vcom -2008 -explicit -work work ../../../source/midi/uart_top.vhd
vcom -2008 -explicit -work work ../../../source/reg_table_pkg.vhd
vcom -2008 -explicit -work work ../../../source/i2c/codec_controller.vhd
vcom -2008 -explicit -work work ../../../source/i2c/i2c_master.vhd
vcom -2008 -explicit -work work ../../../source/i2c/i2c_slave_bfm.vhd
vcom -2008 -explicit -work work ../../../source/i2c/i2s_master.vhd
vcom -2008 -explicit -work work ../../../source/i2c/i2s_frame_generator.vhd
vcom -2008 -explicit -work work ../../../source/i2c/path_control.vhd
vcom -2008 -explicit -work work ../../../source/i2c/uni_shiftreg.vhd
vcom -2008 -explicit -work work ../../../source/synthi_control/reg_controller.vhd
vcom -2008 -explicit -work work ../../../source/tone_gen/tone_gen_pkg.vhd
vcom -2008 -explicit -work work ../../../source/tone_gen/dds.vhd
vcom -2008 -explicit -work work ../../../source/tone_gen/tone_gen.vhd

vcom -2008 -explicit -work work ../../../source/synthi_top.vhd
vcom -2008 -explicit -work work ../../../source/synthi_top_tb.vhd

# run the simulation (Achten Sie darauf, dass work.file_top_tb keine
# .vhdl Datei ist, sondern der Name der Testbench Entity)
vsim -voptargs=+acc -t 1ns -lib work work.synthi_top_tb
do ./wave.do
run 50 ms
