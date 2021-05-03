-------------------------------------------------------------------------------
-- Title      : fm-dds
-- Project    : 
-------------------------------------------------------------------------------
-- File       : fm_dds.vhd
-- Author     : muellpav
-- Company    : 
-- Created    : 2021-05-03
-- Last update: 2021-05-03
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: fm-dds
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-05-03  1.0      muellpav	Created
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.tone_gen_pkg.all;

entity fm_dds is
  
  port (
    clk_6m : in std_logic;
    reset_n : in std_logic;
    phi_incr_fsig : in std_logic_vector(N_CUM-1 downto 0);
    tone_on_i : in std_logic;
    fm_ratio : in std_logic_vector(3 downto 0);
    fm_depth : in std_logic_vector(2 downto 0);
    step_i   : in std_logic;
    attenu_i : in std_logic_vector(2 downto 0);
    fm_dds_o : out std_logic_vector(N_AUDIO -1 downto 0)
    );
end fm_dds;

architecture rtl of fm_dds is

  signal phi_incr_car_sig : unsigned(N_CUM-1 downto 0);
  signal phi_incr_mod_sig : unsigned(N_CUM-1 downto 0);
  signal dds_o_mod_sig : std_logic_vector(N_AUDIO -1 downto 0);

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

begin  -- architecture rtl

  -- instance "dds_1"
  dds_mod: dds
    port map (
      clk_6m     => clk_6m,
      reset_n    => reset_n,
      phi_incr_i => std_logic_vector(phi_incr_mod_sig),
      step_i     => step_i,
      tone_on_i  => tone_on_i,
      attenu_i   => fm_depth,
      dds_o      => dds_o_mod_sig
      );

  -- instance "dds_2"
  dds_car: dds
    port map (
      clk_6m     => clk_6m,
      reset_n    => reset_n,
      phi_incr_i => std_logic_vector(phi_incr_car_sig),
      step_i     => step_i,
      tone_on_i  => tone_on_i,
      attenu_i   => attenu_i,
      dds_o      => fm_dds_o
      );


-- purpose: adjusts the fm ratio
-- type   : combinational

ratio: process (all) is
begin  -- process fm_ratio

  case to_integer(unsigned(fm_ratio)) is
    when 0 => phi_incr_mod_sig <= to_unsigned(0,N_CUM) ;
    when 1 => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),3); 
    when 2 => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),2);
    when 3 => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),1);
    when 4 => phi_incr_mod_sig <= unsigned(phi_incr_fsig);
    when 5 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),1);
    when 6 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),2);
    when 7 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),3);
    when others => phi_incr_mod_sig <= to_unsigned(0,N_CUM);
  end case;
  
end process ratio;


phi_add: process (all) is
begin  -- process phi_add

  phi_incr_car_sig <= unsigned(dds_o_mod_sig)+unsigned(phi_incr_fsig);
  
end process phi_add;
  

end architecture rtl;
