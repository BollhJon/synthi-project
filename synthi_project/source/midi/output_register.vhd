-------------------------------------------------------------------------------
-- Title      : output register
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : output_register.vhd
-- Author     : Boehi Dominik
-- Company    : 
-- Created    : 2020-10-12
-- Last update: 2020-10-12
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: output register for the sevensegment display
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2020-10-12  1.0      Boehi Dominik	    Created
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
ENTITY output_register IS
GENERIC (width : positive := 10);
  PORT( clk,reset_n		: IN    std_logic;
  		data_valid			: IN    std_logic;
    	parallel_in     	: IN    std_logic_vector(width-1 downto 0);
		hex_lsb_out			: OUT	  std_logic_vector(3 downto 0);
		hex_msb_out			: OUT	  std_logic_vector(3 downto 0)
    	);
END output_register;


-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF output_register IS
-- Signals & Constants Declaration
-------------------------------------------
CONSTANT  	max_val: 			      unsigned(width-1 downto 0):= to_unsigned(4,width); -- convert integer value 4 to unsigned with 4bits
SIGNAL 		  count, next_count: 	unsigned(width-1 downto 0);	 


-- Begin Architecture
-------------------------------------------
BEGIN


  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic: PROCESS(all)
  BEGIN	
	-- store	
	IF (data_valid = '1') THEN
		next_count <= unsigned (parallel_in);
  	
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
  hex_msb_out <= std_logic_vector(count (8 downto 5));
  hex_lsb_out <= std_logic_vector(count (4 downto 1));
  
 -- End Architecture 
------------------------------------------- 
END rtl;

