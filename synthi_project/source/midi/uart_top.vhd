-------------------------------------------------------------------------------
-- Title      : uart_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : uart_top_tb.vhd
-- Author     : Boehi Dominik
-- Company    : 
-- Created    : 2021-03-01
-- Last update: 2021-03-01
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  		Description
-- 2021-03-01  1.0      Boehi Dominik   Created
-------------------------------------------------------------------------------
-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all; 
-------------------------------------------
-- Entity Declaration 
-------------------------------------------
ENTITY uart_top IS 
	PORT
	(
		clk 		:  IN  STD_LOGIC;
		reset_n 	:  IN  STD_LOGIC;
		ser_data_i 	:  IN  STD_LOGIC;
		rx_data_rdy :  OUT  STD_LOGIC;
		rx_data 	:  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
		seg0_o 		:  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		seg1_o 		:  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END uart_top;
-------------------------------------------
-- Architecture Declaration
-------------------------------------------
ARCHITECTURE bdf_type OF uart_top IS 
-------------------------------------------
-- Components Declaration
-------------------------------------------
COMPONENT baud_tick
GENERIC (width : INTEGER
			);
	PORT(clk 		: IN STD_LOGIC;
		 reset_n 	: IN STD_LOGIC;
		 start_bit 	: IN STD_LOGIC;
		 baud_tick 	: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT flanken_detekt_vhdl
	PORT(data_in 		: IN STD_LOGIC;
		 clk 			: IN STD_LOGIC;
		 reset_n 		: IN STD_LOGIC;
		 rising_pulse 	: OUT STD_LOGIC;
		 falling_pulse 	: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT vhdl_hex2sevseg
	PORT(data_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg_o 	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;


COMPONENT uart_controller_fsm
GENERIC (width : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 falling_pulse : IN STD_LOGIC;
		 baud_tick : IN STD_LOGIC;
		 bit_count : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 parallel_data : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 shift_enable : OUT STD_LOGIC;
		 start_bit : OUT STD_LOGIC;
		 data_valid : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT bit_counter
GENERIC (width : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 start_bit : IN STD_LOGIC;
		 baud_tick : IN STD_LOGIC;
		 bit_count : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT shiftreg_uart
GENERIC (width : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 load_in : IN STD_LOGIC;
		 serial_in : IN STD_LOGIC;
		 shift_enable : IN STD_LOGIC;
		 parallel_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 serial_out : OUT STD_LOGIC;
		 parallel_out : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

COMPONENT output_register
GENERIC (width : INTEGER
			);
	PORT(clk : IN STD_LOGIC;
		 reset_n : IN STD_LOGIC;
		 data_valid : IN STD_LOGIC;
		 parallel_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 hex_lsb_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 hex_msb_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;
-------------------------------------------
-- Signals & Constants Declaration
-------------------------------------------
SIGNAL	baud_tick_sig :  STD_LOGIC;
SIGNAL	bit_count_sig :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	data_valid_sig :  STD_LOGIC;
SIGNAL	falling_pulse_sig :  STD_LOGIC;
SIGNAL	hex_lsb_out_sig :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	hex_msb_out_sig :  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	parallel_data_sig :  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	shift_enable_sig :  STD_LOGIC;
SIGNAL	start_bit_sig :  STD_LOGIC;


BEGIN 

b2v_inst : baud_tick
GENERIC MAP(width => 10
			)
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 start_bit => start_bit_sig,
		 baud_tick => baud_tick_sig);


b2v_inst13 : flanken_detekt_vhdl
PORT MAP(data_in => ser_data_i,
		 clk => clk,
		 reset_n => reset_n,
		 falling_pulse => falling_pulse_sig);


b2v_inst14 : vhdl_hex2sevseg
PORT MAP(data_in => hex_lsb_out_sig,
		 seg_o => seg0_o);


b2v_inst17 : vhdl_hex2sevseg
PORT MAP(data_in => hex_msb_out_sig,
		 seg_o => seg1_o);


b2v_inst3 : uart_controller_fsm
GENERIC MAP(width => 10
			)
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 falling_pulse => falling_pulse_sig,
		 baud_tick => baud_tick_sig,
		 bit_count => bit_count_sig,
		 parallel_data => parallel_data_sig,
		 shift_enable => shift_enable_sig,
		 start_bit => start_bit_sig,
		 data_valid => data_valid_sig);


b2v_inst5 : bit_counter
GENERIC MAP(width => 4
			)
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 start_bit => start_bit_sig,
		 baud_tick => baud_tick_sig,
		 bit_count => bit_count_sig);


b2v_inst6 : shiftreg_uart
GENERIC MAP(width => 10
			)
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 load_in => '0',
		 serial_in => ser_data_i,
		 shift_enable => shift_enable_sig,
		 parallel_in => "0000000000",
		 parallel_out => parallel_data_sig);

b2v_inst7 : output_register
GENERIC MAP(width => 10
			)
PORT MAP(clk => clk,
		 reset_n => reset_n,
		 data_valid => data_valid_sig,
		 parallel_in => parallel_data_sig,
		 hex_lsb_out => hex_lsb_out_sig,
		 hex_msb_out => hex_msb_out_sig);


rx_data <= parallel_data_sig(8 downto 1);
rx_data_rdy <= data_valid_sig;

END bdf_type;