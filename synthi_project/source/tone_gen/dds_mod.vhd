-------------------------------------------------------------------------------
-- Title      : dds modulator
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : dds_mod.vhd
-- Author     : Bollhalder Jonas
-- Created    : 2021-03-31
-- Last update: 2021-05-23
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: dds_mod for Synthi-Project
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author                Description
-- 2021-03-31  1.0      Bollhalder Jonas      Created
-- 2021-04-12  1.1      Bollhalder Jonas      Bugfixes
-- 2021-05-04  1.1      Mueller Pavel         modifications for custom LUT
-- 2021-05-05  1.2      Mueller Pavel         added LUT for Piano, Orgel and guitar
-- 2021-05-15  1.3      Mueller Pavel         attenu extendet to 16 values
-- 2021-05-17  1.4      Mueller Pavel         logic elements reduced
-- 2021-05-19  1.5      Mueller Pavel         attenu extendet to 32 values
-- 2021-05-23  1.6      Mueller Pavel         modified for fm carrier
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
entity dds_mod is
  port(clk_6m            : in  std_logic;
       reset_n           : in  std_logic;
       phi_incr_i        : in std_logic_vector(N_CUM-1 downto 0);
       step_i            : in std_logic;
       tone_on_i         : in std_logic;
       attenu_i          : in std_logic_vector(3 downto 0);
       lut_sel	         : in std_logic_vector(2 downto 0);
       dds_o             : out std_logic_vector(N_AUDIO-1 downto 0)
       );
end dds_mod;

-- Architecture Declaration
-------------------------------------------
architecture rtl of dds_mod is
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
      when 1 => lut_val  <= to_signed(LUT_sawtooth_falling(lut_addr), N_AUDIO);   -- sawtooth wave with falling edge
      when 2 => lut_val  <= to_signed(LUT_sawtooth_rising(lut_addr), N_AUDIO);    -- sawtooth wave with rising edge
      when 3 => lut_val  <= to_signed(LUT_triangle(lut_addr), N_AUDIO);           -- triangle wave
      when 4 => lut_val  <= to_signed(LUT_rectangle(lut_addr), N_AUDIO);          -- rectangle wave
      when others => lut_val  <= to_signed(LUT(lut_addr), N_AUDIO);               -- standart wave -> sinus
    end case;
        
    
  end process lut_logic;

  --------------------------------------------------
  -- PROCESS for Attenuator Logic
  --------------------------------------------------
  attenuator: process (all)
    variable shift_var : signed(N_AUDIO-1 downto 0);
    -- generates an attenuator from 0 to 16/16 in steps of 1/16
    begin
      shift_var := (others => '0');
      -- when the phi increment singnal is more that zero the attenuator logic will be activated
      if unsigned(phi_incr_i) > 0 then   
        for i in 0 to 3 loop
          if attenu_i(i) = '1' then
            -- shifts the value from the lut i times right
            shift_var := shift_var + shift_right(lut_val,(4-i));
          end if;
        end loop;
      else
        shift_var := to_signed(0,N_AUDIO);
      end if; 
      -- write the variable to the output
      dds_o <= std_logic_vector(shift_var);

  end process attenuator;


-- End Architecture 
------------------------------------------- 
end rtl;

