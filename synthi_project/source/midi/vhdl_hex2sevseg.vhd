-------------------------------------------------------------------------------
-- Title      : vhdl hex to sevensegment
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : vhdl_hex2sevenseg.vhd
-- Author     : dqtm
-- Created    : 2014-10-15
-- Last update: 2020-10-14
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 - 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  		Description
-- 2014-10-15  1.0      dqtm    		Created
-- 2014-10-15  1.1      rosn    		small changes, comments
-- 2019-10-11  1.2		gelk			adapted for 2025
-- 2020-10-13  1.3		Boehi Dominik	adapted for sevensegment display
-------------------------------------------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;


--Entity Declaration
ENTITY vhdl_hex2sevseg IS
	PORT
	(
		data_in 	: IN std_logic_vector(3 downto 0);
		seg_o		: OUT std_logic_vector(6 downto 0)
	);
END vhdl_hex2sevseg;

-- Architecture Declaration
ARCHITECTURE comb  OF vhdl_hex2sevseg  IS

-- Signals & Constants Declaration
CONSTANT disp_0 : std_logic_vector(6 downto 0):= "0111111";
CONSTANT disp_1 : std_logic_vector(6 downto 0):= "0000110";
CONSTANT disp_2 : std_logic_vector(6 downto 0):= "1011011";
CONSTANT disp_3 : std_logic_vector(6 downto 0):= "1001111";
CONSTANT disp_4 : std_logic_vector(6 downto 0):= "1100110";
CONSTANT disp_5 : std_logic_vector(6 downto 0):= "1101101";
CONSTANT disp_6 : std_logic_vector(6 downto 0):= "1111101";
CONSTANT disp_7 : std_logic_vector(6 downto 0):= "0000111";
CONSTANT disp_8 : std_logic_vector(6 downto 0):= "1111111";
CONSTANT disp_9 : std_logic_vector(6 downto 0):= "1101111";
CONSTANT disp_A : std_logic_vector(6 downto 0):= "1110111";
CONSTANT disp_B : std_logic_vector(6 downto 0):= "1111100";
CONSTANT disp_C : std_logic_vector(6 downto 0):= "0111001";
CONSTANT disp_D : std_logic_vector(6 downto 0):= "1011110";
CONSTANT disp_E : std_logic_vector(6 downto 0):= "1111001";
CONSTANT disp_F : std_logic_vector(6 downto 0):= "1110001";
CONSTANT disp_None : std_logic_vector(6 downto 0):= "0000000";


BEGIN
hex2seven : PROCESS (all) IS
	BEGIN
		CASE data_in IS
		when x"0" => seg_o <= not(disp_0);
		when x"1" => seg_o <= not(disp_1);
		when x"2" => seg_o <= not(disp_2);
		when x"3" => seg_o <= not(disp_3);
		when x"4" => seg_o <= not(disp_4);
		when x"5" => seg_o <= not(disp_5);
		when x"6" => seg_o <= not(disp_6);
		when x"7" => seg_o <= not(disp_7);
		when x"8" => seg_o <= not(disp_8);
		when x"9" => seg_o <= not(disp_9);
		when x"A" => seg_o <= not(disp_A);
		when x"B" => seg_o <= not(disp_B);
		when x"C" => seg_o <= not(disp_C);
		when x"D" => seg_o <= not(disp_D);
		when x"E" => seg_o <= not(disp_E);
		when x"F" => seg_o <= not(disp_F);
		when others => seg_o <= not(disp_None);
		
		END CASE;
	END PROCESS hex2seven;
	
End comb;
		
	
	
	
