-------------------------------------------------------------------------------
-- Title      : shift register uart
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : shiftreg_uart.vhd
-- Author     : Boehi Dominik
-- Created    : 2013-11-12
-- Last update: 2020-11-23
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: shift-register working as a serial to parallel converter.
--              The block has a shift_enable( or freeze_n) control input, plus 
--              a serial data input. If shift_enable is high the data is 
--              shifted, the serial data is taken in the MSB, and the further 
--              bits are shifted towards the LSB. The parallel output contains 
--              the 4 q-outputs of the D-FFs in the shiftregister. Can be used 
--              as S2P in a serial interface, but need extra signal to identify 
--              when shifting is done (data_ready).
-------------------------------------------------------------------------------
-- Copyright (c) 2013 - 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2013-11-12  1.0      dqtm        	    Created
-- 2020-11-23  1.1      Boehi Dominik     adapted for lab 09
-- 2020-11-24  1.2      Boehi Dominik     adapted for lab 10
-- 2020-12-07  1.3      Boehi Dominik     adapted for miniprojekt
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;


-- Entity Declaration 
-------------------------------------------
entity shiftreg_uart is
  generic (
    width : positive := 10);
  port( clk, reset_n, load_in : in  std_logic;  -- Attention, this block has a set_n input for initialisation!!
		    serial_out   : out std_logic;
		    serial_in    : in std_logic;
		    shift_enable : in std_logic;
        parallel_in  : in  std_logic_vector(width-1 downto 0);
		    parallel_out : out std_logic_vector(width-1 downto 0)
       );
end shiftreg_uart;


-- Architecture Declaration
-------------------------------------------
architecture rtl of shiftreg_uart is
-- Signals & Constants Declaration
-------------------------------------------
  signal shiftreg, next_shiftreg : std_logic_vector(width-1 downto 0);  -- add one bit for walk-1 detection
-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  shift_comb : process(all)
  begin
	 if load_in = '1' then
		next_shiftreg <= parallel_in;
	 elsif shift_enable = '1' then
      next_shiftreg <= serial_in & shiftreg(width-1 downto 1);  -- shift direction towards LSB
	 else
		next_shiftreg <= Shiftreg;
    end if;
  end process shift_comb;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  shift_dffs : process(all)
  begin
    if reset_n = '0' then
      shiftreg <= (others => '0');
    elsif rising_edge(clk) then
      shiftreg <= next_shiftreg;
    end if;
  end process shift_dffs;

  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  
  parallel_out <= shiftreg;
  serial_out <= shiftreg(0);-- take LSB of shiftreg as serial output

-- End Architecture 
------------------------------------------- 
end rtl;

