-------------------------------------------------------------------------------
-- Title      : fm-dds
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : fm_dds.vhd
-- Author     : Mueller Pavel
-- Company    : 
-- Created    : 2021-05-03
-- Last update: 2021-05-25
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: fm-dds
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-05-03  1.0      Mueller Pavel	  Created
-- 2021-05-03  1.1      Mueller Pavel   added selector for custom LUT
-- 2021-05-06  1.2      Mueller Pavel   added envelope logic
-- 2021-05-15  1.3      Mueller Pavel   extended fm-ratio
-- 2021-05-17  1.4      Mueller Pavel   logic elements reduced
-- 2021-05-19  1.5      Mueller Pavel   attenu extended
-- 2021-05-24  1.6      Mueller Pavel   DDS splitted to dds carrier and modulator
-- 2021-05-24  1.7      Mueller Pavel   extended fm-ratio to 5 bit
-- 2021-05-25  1.8      Mueller Pavel   implemented atenu logic
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
    clk_6m        : in std_logic;
    reset_n       : in std_logic;
    phi_incr_fsig : in std_logic_vector(N_CUM-1 downto 0);
    tone_on_i     : in std_logic;
    fm_ratio      : in std_logic_vector(4 downto 0);
    fm_depth      : in std_logic_vector(3 downto 0);
    step_i        : in std_logic;
    attenu_i      : in std_logic_vector(4 downto 0);
	  lut_sel_car   : in std_logic_vector(3 downto 0);
    lut_sel_mod   : in std_logic_vector(2 downto 0);
    fm_dds_o      : out std_logic_vector(N_AUDIO -1 downto 0)
    );
end fm_dds;

architecture rtl of fm_dds is

  signal phi_incr_car_sig : unsigned(N_CUM-1 downto 0);
  signal phi_incr_mod_sig : unsigned(N_CUM-1 downto 0);
  signal dds_o_mod_sig : std_logic_vector(N_AUDIO -1 downto 0);

  component dds_mod is
    port (
      clk_6m     : in  std_logic;
      reset_n    : in  std_logic;
      phi_incr_i : in  std_logic_vector(N_CUM-1 downto 0);
      step_i     : in  std_logic;
      tone_on_i  : in  std_logic;
      attenu_i   : in  std_logic_vector(3 downto 0);
		  lut_sel	   : in  std_logic_vector(2 downto 0);
      dds_o      : out std_logic_vector(N_AUDIO-1 downto 0));
  end component dds_mod;

  component dds_car is
    port (
      clk_6m     : in  std_logic;
      reset_n    : in  std_logic;
      phi_incr_i : in  std_logic_vector(N_CUM-1 downto 0);
      step_i     : in  std_logic;
      tone_on_i  : in  std_logic;
      attenu_i   : in  std_logic_vector(4 downto 0);
		  lut_sel	   : in  std_logic_vector(3 downto 0);
      dds_o      : out std_logic_vector(N_AUDIO-1 downto 0));
  end component dds_car;

begin  -- architecture rtl

  -- instance "dds_mod"
  dds_mod_1: dds_mod
    port map (
      clk_6m     => clk_6m,
      reset_n    => reset_n,
      phi_incr_i => std_logic_vector(phi_incr_mod_sig),
      step_i     => step_i,
      tone_on_i  => tone_on_i,
      attenu_i   => fm_depth,
		  lut_sel	   => lut_sel_mod,
      dds_o      => dds_o_mod_sig
      );

  -- instance "dds_car"
  dds_car_1: dds_car
    port map (
      clk_6m     => clk_6m,
      reset_n    => reset_n,
      phi_incr_i => std_logic_vector(phi_incr_car_sig),
      step_i     => step_i,
      tone_on_i  => tone_on_i,
      attenu_i   => attenu_i,
		  lut_sel	   => lut_sel_car,
      dds_o      => fm_dds_o
      );


-- purpose: adjusts the fm ratio
-- type   : combinational

ratio: process (all) is
  variable shift_var : unsigned(N_CUM-1 downto 0);
  variable fm_ratio_var : unsigned(4 downto 0);
  variable phi_incr_var : unsigned(N_CUM-1 downto 0);

begin  -- process fm_ratio
  shift_var := (others => '0');
  fm_ratio_var := unsigned(fm_ratio)-1;
  phi_incr_var := unsigned(phi_incr_fsig);

  if fm_ratio = "00000" then
    shift_var := (others => '0');
  elsif fm_ratio = "10000" then
    shift_var := phi_incr_var; 
  elsif fm_ratio(4) = '1' then
    for i in 0 to 3 loop
      if fm_ratio(i) = '1' then
        shift_var := shift_var + shift_right(phi_incr_var,(4-i));
      end if;
    end loop ;
  else
    for i in 0 to 3 loop
      if fm_ratio_var(i) = '0' then
        shift_var := shift_var + shift_left(phi_incr_var,(4-i));
      end if;
    end loop;
  end if; 

  phi_incr_mod_sig <= shift_var;

--  case to_integer(unsigned(fm_ratio)) is
--    when 0  => phi_incr_mod_sig <= to_unsigned(0,N_CUM) ;                                                                                                     -- 0
--    when 1  => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),3);                                                                                    -- 1/8
--    when 2  => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),2);                                                                                    -- 2/8 = 1/4
--    when 3  => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),2) + shift_right(unsigned(phi_incr_fsig),3);                                           -- 3/8
--    when 4  => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),1);                                                                                    -- 4/8 = 1/2
--    when 5  => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),1) + shift_right(unsigned(phi_incr_fsig),3);                                           -- 5/8
--    when 6  => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),1) + shift_right(unsigned(phi_incr_fsig),2);                                           -- 6/8 = 3/4
--    when 7  => phi_incr_mod_sig <= shift_right(unsigned(phi_incr_fsig),1) + shift_right(unsigned(phi_incr_fsig),2) + shift_right(unsigned(phi_incr_fsig),3);  -- 7/8 
--    when 8  => phi_incr_mod_sig <= unsigned(phi_incr_fsig);                                                                                                   -- 8/8 = 1/1
--    when 9  => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),1) + shift_left(unsigned(phi_incr_fsig),2) + shift_left(unsigned(phi_incr_fsig),3);     -- 8/7
--    when 10 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),1) + shift_left(unsigned(phi_incr_fsig),2);                                             -- 8/6 = 4/3
--    when 11 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),1) + shift_left(unsigned(phi_incr_fsig),3);                                             -- 8/5
--    when 12 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),1);                                                                                     -- 8/4 = 2/1
--    when 13 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),2) + shift_left(unsigned(phi_incr_fsig),3);                                             -- 8/3
--    when 14 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),2);                                                                                     -- 8/2 = 4/1
--    when 15 => phi_incr_mod_sig <= shift_left(unsigned(phi_incr_fsig),3);                                                                                     -- 8/1
--    when others => phi_incr_mod_sig <= to_unsigned(0,N_CUM);                                                                                                  -- 0
--  end case;
  
end process ratio;


phi_add: process (all) is
begin  -- process phi_add

  phi_incr_car_sig <= to_unsigned((to_integer(signed(dds_o_mod_sig)) + to_integer(unsigned(phi_incr_fsig))),N_CUM);
  
end process phi_add;
  
end architecture rtl;
