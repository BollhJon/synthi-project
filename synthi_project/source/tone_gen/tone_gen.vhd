-------------------------------------------------------------------------------
-- Title      : tone generator
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : tone_gen.vhd
-- Author     : Bollhalder Jonas
-- Company    : 
-- Created    : 2021-03-31
-- Last update: 2021-03-31
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: generates the tone for Synthi-Project
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author                Description
-- 2021-03-31  1.0      Bollhalder Jonas	    Created
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
entity tone_gen is
  port(clk_6m            : in  std_logic;
       reset_n           : in  std_logic;
       tone_on_i         : in std_logic;
       note_i            : in std_logic_vector(6 downto 0);
       step_i            : in std_logic;
       velocity_i        : in std_logic_vector(7 downto 0);
       dds_l_o           : out std_logic_vector(15 downto 0);
       dds_r_o           : out std_logic_vector(15 downto 0)
       );
end tone_gen;

-- Architecture Declaration
-------------------------------------------
architecture rtl of tone_gen is
-- Signals & Constants Declaration
-------------------------------------------
  signal dds_o_sig : std_logic_vector(15 downto 0);

-- Begin Architecture
-------------------------------------------

  component dds is
    port (
      clk_6m     : in  std_logic;
      reset_n    : in  std_logic;
      phi_incr_i : in  std_logic_vector(N_CUM-1 downto 0);
      step_i     : in  std_logic;
      tone_on_i  : in  std_logic;
      attenu_i   : in  std_logic_vector(2 downto 0);
      dds_o      : out std_logic_vector(N_AUDIO-1 downto 0));
  end component dds;
begin

-- End Architecture 
-------------------------------------------

  -- instance "dds_1"
  dds_1: dds
     port map (
        clk_6m     => clk_6m,
        reset_n    => reset_n,
        phi_incr_i => LUT_midi2dds(to_integer(unsigned(note_i))),
        step_i     => step_i,
        tone_on_i  => tone_on_i,
        attenu_i   => velocity_i(7 downto 5),
        dds_o      => dds_o_sig);

  dds_l_o <= dds_o_sig;
  dds_r_o <= dds_o_sig;
  
end rtl;

