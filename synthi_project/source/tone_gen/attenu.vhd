-------------------------------------------------------------------------------
-- Title      : attenu logic
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : attenu.vhd
-- Author     : Bollhalder Jonas
-- Created    : 2021-05-04
-- Last update: 2021-05-25
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: control the attenu by the tone_on vector
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2021-05-04  1.0      Bollhalder Jonas	Created
-- 2021-05-24  1.1      Müller Pavel      Changed attenu logic
-- 2021-05-25  1.2      Müller Pavel      Changed values in case statement
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
    dds_used_i: in  std_logic_vector(9 downto 0);
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
  -- default statement
  count := (others => '0');
  -- count how many dds are in use
  for i in 0 to 9 loop
    if dds_used_i(i) ='1' then
      count := count + 1;
    end if;
  end loop;  -- i

  -- depending on counter set attenu signal
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

