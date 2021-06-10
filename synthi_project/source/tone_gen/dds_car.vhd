-------------------------------------------------------------------------------
-- Title      : dds carrier
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : dds_car.vhd
-- Author     : Bollhalder Jonas
-- Created    : 2021-03-31
-- Last update: 2021-05-23
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: dds_car for Synthi-Project
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
-- 2021-05-17  1.4      Mueller Pavel         added LUT for sawtooth, triangle and rectangle
-- 2021-05-17  1.5      Mueller Pavel         logic elements reduced
-- 2021-05-19  1.6      Mueller Pavel         attenu extendet to 32 values
-- 2021-05-23  1.7      Mueller Pavel         modified for fm carrier
-- 2021-06-08  1.7      Mueller Pavel         improvements for preventing cracking sounds
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
entity dds_car is
  port(clk_6m            : in  std_logic;
       reset_n           : in  std_logic;
       phi_incr_i        : in std_logic_vector(N_CUM-1 downto 0);
       step_i            : in std_logic;
       tone_on_i         : in std_logic;
       attenu_i          : in std_logic_vector(4 downto 0);
       lut_sel	         : in std_logic_vector(3 downto 0);
       dds_o             : out std_logic_vector(N_AUDIO-1 downto 0);
       dds_used_o        : out std_logic	 
       );
end dds_car;

-- Architecture Declaration
-------------------------------------------
architecture rtl of dds_car is
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
    dds_used_o <= '0';   

    -- check if the tone on is high
    if (tone_on_i = '1') then
      dds_used_o <= '1'; -- signal that the DDS is curently in use
      -- when the step sinal is high the cou
      if step_i = '1' then
        next_count <= count + unsigned(phi_incr_i);
      end if;
    -- when tone on signal is low and the counter is more than zero, the counter will count until end of the wave.
    elsif (tone_on_i = '0') and (count > 0) then
      -- check if wave is finished
      if (count + unsigned(phi_incr_i)) < count then
        next_count <= to_unsigned(0, N_CUM); -- wave is finished so it is set to zero
      -- else the wave will be finished
      else
        dds_used_o <= '1'; -- signal that the DDS is still in use to finish the note
        if step_i = '1' then
          next_count <= count + unsigned(phi_incr_i); -- wave is not finished so it continues with the wave
        end if;
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
	 
    -- selects the different LUTs
    case to_integer(unsigned(lut_sel)) is
      when 1 => lut_val  <= to_signed(LUT_sawtooth_falling(lut_addr), N_AUDIO);   -- sawtooth wave with falling shape
      when 2 => lut_val  <= to_signed(LUT_sawtooth_rising(lut_addr), N_AUDIO);    -- sawtooth wave with rising shape
      when 3 => lut_val  <= to_signed(LUT_triangle(lut_addr), N_AUDIO);           -- triangle wave
      when 4 => lut_val  <= to_signed(LUT_rectangle(lut_addr), N_AUDIO);          -- rectangle wave
      when 8 => lut_val  <= to_signed(LUT_klavier(lut_addr), N_AUDIO);            -- piano 1 wave
      when 9 => lut_val  <= to_signed(LUT_orgel(lut_addr), N_AUDIO);              -- organ wave
      when 10 => lut_val <= to_signed(LUT_guitar(lut_addr), N_AUDIO);             -- guitar wave
      when 11 => lut_val <= to_signed(LUT_klavier2(lut_addr), N_AUDIO);           -- piano 2 wave
      when others => lut_val  <= to_signed(LUT(lut_addr), N_AUDIO);               -- standart sine wave
    end case;
        
    
  end process lut_logic;

  --------------------------------------------------
  -- PROCESS for Attenuator Logic
  --------------------------------------------------
  attenuator: process (all)
    variable shift_var : signed(N_AUDIO-1 downto 0);
    -- generates an attenuator from 0 to 32/32 in steps of 1/32
    begin
      shift_var := (others => '0');  
      for i in 0 to 4 loop
        if attenu_i(i) = '1' then
          -- shifts the value from the lut i times right
          shift_var := shift_var + shift_right(lut_val,(5-i));
        end if;
      end loop ; 
      -- write the variable to the output
      dds_o <= std_logic_vector(shift_var);

  end process attenuator;


-- End Architecture 
------------------------------------------- 
end rtl;

