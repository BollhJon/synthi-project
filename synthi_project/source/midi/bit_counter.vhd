-------------------------------------------------------------------------------
-- Title      : Bit counter
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : bit_counter.vhd
-- Author     : Boehi Dominik
-- Company    : 
-- Created    : 2020-11-12
-- Last update: 2020-11-12
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: down-counter, with start input and count output. 
-- 			        The input start should be a pulse which causes the 
--			        counter to load its max-value. When start is off,
--			        the counter decrements by one every clock cycle till 
--			        count_o equals 0. Once the count_o reachs 0, the counter
--			        freezes and wait till next start pulse. 
--			        Can be used as enable for other blocks where need to 
--			        count number of iterations.
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2020-11-12  1.0      Boehi Dominik	    Created
-------------------------------------------------------------------------------


-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
ENTITY bit_counter IS
GENERIC (width : positive := 4);
  PORT( clk,reset_n		: IN    std_logic;
  		start_bit			: IN    std_logic;
		baud_tick			: IN    std_logic;
    	bit_count     	: OUT   std_logic_vector(width-1 downto 0)
    	);
END bit_counter;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF bit_counter IS
-- Signals & Constants Declaration
-------------------------------------------
CONSTANT  	max_val: 			unsigned(width-1 downto 0):= to_unsigned(4,width); -- convert integer value 4 to unsigned with 4bits
SIGNAL 		count, next_count: 	unsigned(width-1 downto 0);	 


-- Begin Architecture
-------------------------------------------
BEGIN


  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(all)
  BEGIN	
	-- load	
	IF (start_bit = '1') THEN
		next_count <= "1001";
	
  	-- decrement
  	ELSIF (count > 0 and baud_tick = '1')  THEN
  		next_count <= count - 1;
  
  	-- freezes
  	ELSE
  		next_count <= count;
  	END IF;
	
  END PROCESS comb_logic;   
  
  
  
  
  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : PROCESS(all)
  BEGIN	
  	IF reset_n = '0' THEN
		count <= to_unsigned(0,width); -- convert integer value 0 to unsigned with 4bits
    ELSIF rising_edge(clk) THEN
		count <= next_count ;
    END IF;
  END PROCESS flip_flops;		
  
  
  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- convert count from unsigned to std_logic (output data-type)
  bit_count <= std_logic_vector(count);
  
  
 -- End Architecture 
------------------------------------------- 
END rtl;

