-------------------------------------------------------------------------------
-- Title      : evelop logic
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : envelope_logic.vhd
-- Author     : Mueller Pavel
-- Company    : 
-- Created    : 2021-05-06
-- Last update: 2021-05-19
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
-- 2021-05-19  1.1      Mueller Pavel   Attenu extendet   
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
    -- velocity_i : in  std_logic_vector(6 downto 0); wurde noch nicht implementiert
    lut_sel    : in  std_logic_vector(3 downto 0);
    attenu_o   : out std_logic_vector(4 downto 0)
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

    if count > to_unsigned(100000, N_CUM) then --
      case to_integer(unsigned(lut_sel)) is
        when 8|10 =>
          if lut_addr < 255 then
            next_lut_addr <= lut_addr + to_unsigned(1,8);
          end if;
        when 9 =>
            if lut_addr < 255 then
              next_lut_addr <= lut_addr + to_unsigned(1,8);
            else
              next_lut_addr <= to_unsigned(40,8);
				 end if;
        when others => null;
      end case;
      next_count <= to_unsigned(0,N_CUM);
    end if;
  end process counter_logic;


  output_logic: process (all) is
  begin  -- process output_logic

    case to_integer(unsigned(lut_sel)) is
      when 8  => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_klavier(to_integer(lut_addr)),5));
      when 9  => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_orgel(to_integer(lut_addr)),5));
      when 10 => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_guitar(to_integer(lut_addr)),5));
      when others => attenu_o  <= std_logic_vector(to_unsigned(31, 5));
    end case;
  end process output_logic;
      

end architecture rtl;
