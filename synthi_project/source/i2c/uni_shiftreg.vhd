-------------------------------------------------------------------------------
-- Title      : uni_shiftreg
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : uni_shiftreg.vhd
-- Author     : Müller Pavel
-- Created    : 2021-03-22
-- Last update: 2021-05-12
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Universal shift register for i2s master
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-03-22  1.0      muellpav	      Created
-- 2021-05-12  1.1      Müller Pavel    Bugfix
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity uni_shiftreg is

  generic (
    width : positive := 16
    );

  port (
    par_in      : in std_logic_vector(width-1 downto 0);
	  ser_in		  : in std_logic;
    load        : in std_logic;
    enable      : in std_logic;
    rst_n       : in std_logic;
    clk_6m      : in std_logic;
    par_out     : out std_logic_vector(width-1 downto 0);
    ser_out     : out std_logic
    );

end entity uni_shiftreg;

-------------------------------------------------------------------------------

architecture str of uni_shiftreg is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal shiftreg : std_logic_vector(width-1 downto 0);
  signal next_shiftreg : std_logic_vector(width-1 downto 0);

  begin  -- architecture str


 --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  -------------------------------------------------
  shift_comb: process (all) is
  begin  -- process shift_comb
    if load = '1' then
      next_shiftreg <= par_in;
    elsif enable = '1' then
      next_shiftreg <= shiftreg(width-2 downto 0) & ser_in; --ser_in & shiftreg(width-1 downto 1);
    else
      next_shiftreg <= shiftreg;
    end if;
  end process shift_comb;

  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  shift_dffs: process (all) is
  begin  -- process shift_dffs
    if rst_n = '0' then                 -- asynchronous reset (active low)
      shiftreg <= (others => '0');
    elsif rising_edge(clk_6m) then  -- rising clock edge
      shiftreg <= next_shiftreg;
    end if;
  end process shift_dffs;
  
--------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- take LSB of shiftreg as serial output
  par_out <= shiftreg;
  ser_out <= shiftreg(15);

end architecture str;

-------------------------------------------------------------------------------
