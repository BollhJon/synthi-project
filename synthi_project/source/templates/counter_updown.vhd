-------------------------------------------------------------------------------
-- Title      : count up down template
-- Project    : 
-------------------------------------------------------------------------------
-- File       : counter_updown.vhd
-- Author     : gelk
-- Company    : 
-- Created    : 2019-09-24
-- Last update: 2019-09-24
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
-- Copyright (c) 2019 - 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  			Description
-- 2019-09-24  1.0      gelk    			Created
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration
-------------------------------------------
entity counter_updown is
  generic (
    width : positive := 4);  -- change this number for a larger counter
  port(clk     : in  std_logic;
       reset_n : in  std_logic;
		 SW_0		: in  std_logic;
		 SW_1		: in  std_logic;
       count_o : out std_logic_vector((width-1) downto 0)
       );
end counter_updown;


-- Architecture Declaration
-------------------------------------------
architecture rtl of counter_updown is
-- Signals & Constants Declaration
-------------------------------------------
  signal count, next_count : unsigned((width-1) downto 0);


-- Begin Architecture
-------------------------------------------
begin


  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic : process(all)
  begin
  
    if(not(SW_1) and SW_0) then
      next_count <= count + 1;          --count up
    elsif(SW_1 and not(SW_0)) then
      next_count <= count - 1;          --count_down
	 elsif(SW_0 and SW_1) then
	   next_count <= count + 2;          --count up 2
	 else
	   next_count <= count;          	 --stop count
    end if;

  end process comb_logic;




  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      count <= to_unsigned(0, width);  -- convert integer value 0 to unsigned with 4bits
    elsif rising_edge(clk) then
      count <= next_count;
    end if;
  end process flip_flops;


  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- convert count from unsigned to std_logic (output data-type)
  count_o <= std_logic_vector(count);


-- End Architecture 
------------------------------------------- 
end rtl;

