-------------------------------------------------------------------------------
-- Title      : attenu logic
-- Project    : 
-------------------------------------------------------------------------------
-- File       : attenu.vhd
-- Author     :   bollhjon
-- Company    : 
-- Created    : 2021-05-04
-- Last update: 2021-05-04
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: control the attenu by the tone_on vector
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-05-04  1.0      bollhjon	    Created
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
entity attenu is
  port (
    clk_6m    : in  std_logic;
    reset_n   : in  std_logic;
    tone_on_i : in  std_logic_vector(9 downto 0);
    attenu_o  : out std_logic_vector(4 downto 0));
end entity attenu;

-- Architecture Declaration
-------------------------------------------
architecture rtl of attenu is
-- Signals & Constants Declaration
-------------------------------------------
  signal attenu, next_attenu : std_logic_vector(4 downto 0);

-- Begin Architecture
-------------------------------------------  
begin  -- architecture rtl

attenu_ff: process (all) is
begin  -- process attenu_ff
  if reset_n = '0' then
   attenu <= (others => '0');
  elsif rising_edge(clk_6m) then
    attenu <= next_attenu;
  end if;
end process attenu_ff;

attenu_logic: process (all) is
  variable count : unsigned(3 downto 0);
begin  -- process attenu_logic
  count := (others => '0');
  for i in 0 to 9 loop
    if tone_on_i(i)='1' then
      count := count + 1;
    end if;
  end loop;  -- i

  case to_integer(count) is
    when 1       => next_attenu <= std_logic_vector(to_unsigned(0,5));
    when 2       => next_attenu <= std_logic_vector(to_unsigned(3,5));
    when 3 to 4  => next_attenu <= std_logic_vector(to_unsigned(7,5));
    when 5 to 6  => next_attenu <= std_logic_vector(to_unsigned(10,5));
    when 7 to 8  => next_attenu <= std_logic_vector(to_unsigned(15,5));
    when 9 to 10 => next_attenu <= std_logic_vector(to_unsigned(20,5));
    when others => next_attenu <= std_logic_vector(to_unsigned(30,5));
  end case;
end process attenu_logic;

attenu_out: process (all) is
begin  -- process attenu_out
  attenu_o <= attenu;
end process attenu_out;


end architecture rtl;

