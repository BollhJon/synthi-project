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
-- 2021-06-04  1.2      Mueller Pavel   Integrated std envelope
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
    clk_6m     : in  std_logic;
    reset_n    : in  std_logic;
    -- tone_on_i  : in  std_logic;
    -- velocity_i : in  std_logic_vector(6 downto 0); not implemented
    lut_sel    : in  std_logic_vector(3 downto 0);
    dds_used_i : in  std_logic;
    attenu_o   : out std_logic_vector(4 downto 0)
    );
end envelope_logic;
   
architecture rtl of envelope_logic is  -- architecture rtl

  signal count,next_count : unsigned(N_CUM-1 downto 0) := to_unsigned(0, N_CUM);
  signal lut_addr, next_lut_addr : unsigned(7 downto 0) := to_unsigned(0,8);

begin
  
  -- flip flop
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

  -- process for counter logic
  counter_logic: process (all) is
  begin  -- process counter_logic
    next_count <= count;
    next_lut_addr <= lut_addr;

    -- increases count on every rising edge of clk_6m
    if dds_used_i = '1' then
      next_count <= count + to_unsigned(1,N_CUM);
    -- set both signals to zero when tone on = 0
    else
      next_count <= to_unsigned(0,N_CUM);
      next_lut_addr <= to_unsigned(0, 8);
    end if;

    -- limitation for the counters
    if count > to_unsigned(80000, N_CUM) then --compare to 100000
      case to_integer(unsigned(lut_sel)) is
        when 2|3|8|10|11 => -- when envelope mode is std, piano or guitar the counter will count to 255
          if lut_addr < 255 then
            next_lut_addr <= lut_addr + to_unsigned(1,8);
          end if;
        when 9 => -- when evelope mode is organ, the counter will count to 255 and then return to value #40 until key is released
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


  -- process for the output logic
  output_logic: process (all) is
  begin  -- process output_logic

    -- select envelope LUT
    case to_integer(unsigned(lut_sel)) is
      when 2    => attenu_o  <= std_logic_vector(to_unsigned(LUT_h(to_integer(lut_addr)),5));           -- std envelope
      when 3    => attenu_o  <= std_logic_vector(to_unsigned(LUT_h2(to_integer(lut_addr)),5));          -- std envelope 2
      when 8|11 => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_klavier(to_integer(lut_addr)),5));   -- piano envelope
      when 9    => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_orgel(to_integer(lut_addr)),5));     -- organ envelope
      when 10   => attenu_o  <= std_logic_vector(to_unsigned(LUT_h_guitar(to_integer(lut_addr)),5));    -- guitar envelope
      when others => attenu_o  <= std_logic_vector(to_unsigned(31, 5));
    end case;
  end process output_logic;
      

end architecture rtl;
