-------------------------------------------------------------------------------
-- Title      : baud tick generator
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : baud_tick.vhd
-- Author     : Boehi Dominik
-- Created    : 2020-11-12
-- Last update: 2021-04-06
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Generates the baud tick signal out of the 6.25kHz signal.
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2020-11-12  1.0      Boehi Dominik	    Created
-- 2021-04-26  1.1      Müller Pavel      Reduced clk speed to 6.25 MHz
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
ENTITY baud_tick IS
GENERIC (width : positive := 10);
  PORT( clk,reset_n		: IN    std_logic;
  		start_bit			: IN    std_logic;
    	baud_tick     		: OUT   std_logic --std_logic_vector(width-1 downto 0)
    	);
END baud_tick;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF baud_tick IS
-- Signals & Constants Declaration
-------------------------------------------
CONSTANT max_val: 			unsigned(width-1 downto 0):= to_unsigned(4,width); -- convert integer value 4 to unsigned with 4bits
CONSTANT clock_freq		: positive := 6_250_000; -- Clock/Hz
CONSTANT	baud_rate		: positive := 115_200; -- Baude Rate/Hz
CONSTANT	count_width		: positive := 10; -- FreqClock/FreqBaudRate=50000000/115200 = 434 so need 10 bits
CONSTANT	one_period		: unsigned(count_width - 1 downto 0) := to_unsigned(clock_freq / baud_rate, count_width);
CONSTANT half_period		: unsigned(count_width - 1 downto 0) := to_unsigned(clock_freq / baud_rate / 2, count_width);	
SIGNAL 		count, next_count: 	unsigned(width - 1 downto 0);	 

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
		next_count <= half_period;
	
  	-- freezes
	ELSIF (count = 0) THEN
		next_count <= one_period;
	
	-- decrement
  	ELSE
		next_count <= count - 1;
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
		  count <= next_count;
	  END IF;
  END PROCESS flip_flops;		
  
   --------------------------------------------------
  -- PROCESS FOR DECODER
  --------------------------------------------------
  decoder : PROCESS(all)
  BEGIN
  	baud_tick <= '0'; 
	  IF (count = 0) THEN
		  baud_tick <= '1';
	  END IF;
  END PROCESS decoder;	
  
 -- End Architecture 
------------------------------------------- 
END rtl;

