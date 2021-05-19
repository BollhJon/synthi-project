-------------------------------------------------------------------------------
-- Title      : dds
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : dds.vhd
-- Author     : Bollhalder Jonas
-- Company    : 
-- Created    : 2021-03-31
-- Last update: 2021-05-04
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: dds for Synthi-Project
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author                Description
-- 2021-03-31  1.0      Bollhalder Jonas      Created
-- 2021-05-04  1.1      Mueller Pavel         modifications for custom LUT
-- 2021-05-05  1.2      Mueller Pavel         added LUT for Piano and Orgel
-- 2021-05-05  1.3      Mueller Pavel         added LUT for guitar
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.tone_gen_pkg.all;

-- Entity Declaration 
-------------------------------------------
entity dds is
  port(clk_6m            : in  std_logic;
       reset_n           : in  std_logic;
       phi_incr_i        : in std_logic_vector(N_CUM-1 downto 0);
       step_i            : in std_logic;
       tone_on_i         : in std_logic;
       attenu_i          : in std_logic_vector(4 downto 0);
       lut_sel	         : in std_logic_vector(3 downto 0);
       dds_o             : out std_logic_vector(N_AUDIO-1 downto 0)	 
       );
end dds;

-- Architecture Declaration
-------------------------------------------
architecture rtl of dds is
-- Signals & Constants Declaration
-------------------------------------------

  signal count : unsigned(N_CUM-1 downto 0);
  signal next_count : unsigned(N_CUM-1 downto 0);
  signal lut_val : signed(N_AUDIO-1 downto 0);
  
-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR Counter Register
  --------------------------------------------------
  counter_register : process(all)
  begin
    if reset_n = '0' then
      count <= to_unsigned(0, N_CUM);
    elsif rising_edge(clk_6m) then
      count <= next_count;
    end if;
  end process counter_register;


  --------------------------------------------------
  -- PROCESS FOR Counter Logic
  --------------------------------------------------
  counter_logic : process (all)
  begin
    -- default statements (hold current value)
    next_count <= count;   

    if (tone_on_i = '1') and (step_i = '1') then
      next_count <= count + unsigned(phi_incr_i);
    elsif (tone_on_i = '0') and (step_i = '1') and (count > 0) then
      if (count + unsigned(phi_incr_i)) < count then
        next_count <= to_unsigned(0, N_CUM);
      else
        next_count <= count + unsigned(phi_incr_i);
      end if;
    end if;
   
  end process counter_logic;

  
  --------------------------------------------------
  -- PROCESS FOR LUT Logic
  --------------------------------------------------
  lut_logic : process (all)
  variable lut_addr : integer range 0 to L-1;

  begin
    lut_addr := to_integer(count(N_CUM-1 downto N_CUM - N_LUT));
	 
    case to_integer(unsigned(lut_sel)) is
      --when 0 => lut_val  <= to_signed(LUT(lut_addr), N_AUDIO);
      when 1 => lut_val  <= to_signed(LUT_sawtooth_falling(lut_addr), N_AUDIO);
      when 3 => lut_val  <= to_signed(LUT_triangle(lut_addr), N_AUDIO);
      when 8 => lut_val  <= to_signed(LUT_klavier(lut_addr), N_AUDIO);
      when 9 => lut_val  <= to_signed(LUT_orgel(lut_addr), N_AUDIO);
      when 10 => lut_val  <= to_signed(LUT_guitar(lut_addr), N_AUDIO);
      when others => lut_val  <= to_signed(LUT(lut_addr), N_AUDIO);
    end case;
        
    
  end process lut_logic;

  --------------------------------------------------
  -- PROCESS for Attenuator Logic
  --------------------------------------------------
  attenuator: process (all)
    variable shift_var : signed(N_AUDIO-1 downto 0);
    
    begin
      shift_var := (others => '0');  
      for i in 0 to 4 loop
        if attenu_i(i) = '1' then
          shift_var := shift_var + shift_right(lut_val,(5-i));
        end if;
      end loop ; 

      dds_o <= std_logic_vector(shift_var);
      

    --case to_integer(unsigned(attenu_i)) is
    --  -- when 0 => dds_o <= (others => '0');                                                                                                 -- 0
    --  when 1 => dds_o <= std_logic_vector(shift_right(lut_val,3));                                                                        -- 2/16
    --  when 2 => dds_o <= std_logic_vector(shift_right(lut_val,3)+shift_right(lut_val,4));                                                 -- 3/16
    --  when 3 => dds_o <= std_logic_vector(shift_right(lut_val,2));                                                                        -- 4/16
    --  when 4 => dds_o <= std_logic_vector(shift_right(lut_val,2)+shift_right(lut_val,4));                                                 -- 5/16
    --  when 5 => dds_o <= std_logic_vector(shift_right(lut_val,2)+shift_right(lut_val,3));                                                 -- 6/16
    --  when 6 => dds_o <= std_logic_vector(shift_right(lut_val,2)+shift_right(lut_val,3)+shift_right(lut_val,4));                          -- 7/16
    --  when 7 => dds_o <= std_logic_vector(shift_right(lut_val,1));                                                                        -- 8/16
    --  when 8 => dds_o <= std_logic_vector(shift_right(lut_val,1)+shift_right(lut_val,4));                                                 -- 9/16
    --  when 9 => dds_o <= std_logic_vector(shift_right(lut_val,1)+shift_right(lut_val,3));                                                 -- 10/16
    --  when 10 => dds_o <= std_logic_vector(shift_right(lut_val,1)+shift_right(lut_val,3)+shift_right(lut_val,4));                         -- 11/16
    --  when 11 => dds_o <= std_logic_vector(shift_right(lut_val,1)+shift_right(lut_val,2));                                                -- 12/16
    --  when 12 => dds_o <= std_logic_vector(shift_right(lut_val,1)+shift_right(lut_val,2)+shift_right(lut_val,4));                         -- 13/16
    --  when 13 => dds_o <= std_logic_vector(shift_right(lut_val,1)+shift_right(lut_val,2)+shift_right(lut_val,3));                         -- 14/16
    --  when 14 => dds_o <= std_logic_vector(shift_right(lut_val,1)+shift_right(lut_val,2)+shift_right(lut_val,3)+shift_right(lut_val,4));  -- 15/16
    --  when 15 => dds_o <= std_logic_vector(lut_val);                                                                                      -- 16/16
    --  when others => dds_o <= (others => '0');
    --end case;

  end process attenuator;


-- End Architecture 
------------------------------------------- 
end rtl;

