-------------------------------------------------------------------------------
-- Title      : evelop logic
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : envelope_logic.vhd
-- Author     : Mueller Pavel
-- Company    : 
-- Created    : 2021-05-06
-- Last update: 2021-05-06
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: -
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-05-06  1.0      Mueller Pavel	  Created
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.tone_gen_pkg.all;

entity envelope_logic is
  
  port (
    clk_6m       : in  std_logic;
    reset_n    : in  std_logic;
    tone_on_i  : in  std_logic;
    velocity_i : in  std_logic_vector(6 downto 0);
    lut_sel    : in  std_logic_vector(3 downto 0);
    attenu_o   : out std_logic_vector(3 downto 0)
    );
end envelope_logic;
   
architecture rtl of envelope_logic is  -- architecture rtl

  signal count,next_count : unsigned(N_CUM-1 downto 0) := to_unsigned(0, N_CUM);
  signal lut_addr, next_lut_addr : unsigned(7 downto 0) := to_unsigned(0,8);

begin
  
  counter_register: process (all) is
  begin  -- process counter_register
   if reset_n = '0' then
     count <= to_unsigned(0, N_CUM);
     lut_addr <= to_unsigned(0, 8);
    elsif rising_edge(clk_6m) then
      count <= next_count;
      lut_addr <= next_lut_addr;
    end if;
  end process counter_register;

  counter_logic: process (all) is
  begin  -- process counter_logic
    next_count <= count;
    next_lut_addr <= lut_addr;

    if tone_on_i = '1' then
      next_count <= count + to_unsigned(1,N_CUM);
    else
      next_count <= to_unsigned(0,N_CUM);
      next_lut_addr <= to_unsigned(0, 8);
    end if;

    if count > to_unsigned(117188, N_CUM) then --
      case to_integer(unsigned(lut_sel)) is
        when 1|3 =>
          if lut_addr < 255 then
            next_lut_addr <= lut_addr + to_unsigned(1,8);
          end if;
        when 2 =>
            if lut_addr < 255 then
              next_lut_addr <= lut_addr + to_unsigned(1,8);
            else
              next_lut_addr <= to_unsigned(1,8);
				 end if;
        when others => null;
      end case;
      next_count <= to_unsigned(0,N_CUM);
    end if;
  end process counter_logic;


  output_logic: process (all) is
  begin  -- process output_logic

    case to_integer(unsigned(lut_sel)) is
      when 1 => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_klavier(to_integer(lut_addr)),4));
      --when 2 => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_orgel(lut_addr),4));
      --when 3 => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_guitar(lut_addr),4));
      when others => attenu_o  <= std_logic_vector(to_unsigned(15, 4));
    end case;
  end process output_logic;
      

end architecture rtl;
