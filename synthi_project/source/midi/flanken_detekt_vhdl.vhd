-------------------------------------------
-- Block code:  flankenDetekt_v2.vhd
-- History: 	14.Oct.2013 - 1st version (dqtm)
--                 <date> - <changes>  (<author>)
-- Function: template to be edited by students in order 
--           to describe edge detector with rise & fall outputs. 
--             
-------------------------------------------

-- Library & Use Statements
LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Entity Declaration 
ENTITY flanken_detekt_vhdl IS
  PORT( data_in 	: IN    std_logic;
			clk		: IN    std_logic;
			reset_n	: IN    std_logic;
    	   rising_pulse    : OUT   std_logic;
			falling_pulse     : OUT   std_logic
    	);
END flanken_detekt_vhdl;


-- Architecture Declaration 
ARCHITECTURE rtl OF flanken_detekt_vhdl IS

	-- Signals & Constants Declaration 
	SIGNAL q_0: std_logic;
	SIGNAL q_1: std_logic;
	
-- Begin Architecture
BEGIN 
    -------------------------------------------
    -- Process for combinatorial logic
    ------------------------------------------- 
	 -- not needed in this file, using concurrent logic
	 
	 -------------------------------------------
    -- Process for registers (flip-flops)
    -------------------------------------------
	flip_flops : PROCESS(all)
	BEGIN	
		IF reset_n = '0' THEN
			q_0 <= '0';
			q_1 <= '0';
		ELSIF (rising_edge(clk)) THEN
			q_0 <= data_in;
			q_1 <= q_0;			
		END IF;
	END PROCESS flip_flops;	
	 
	 -------------------------------------------
    -- Concurrent Assignments  
    -------------------------------------------
	 flanken_detect: process(ALL)
	 BEGIN
		rising_pulse <= q_0 and not q_1;
		falling_pulse <= not q_0 and q_1;
	end process flanken_detect;
	
END rtl;	
