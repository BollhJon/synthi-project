-------------------------------------------------------------------------------
-- Title      : i2s_master
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : i2s_master.vhd
-- Author     : Müller Pavel
-- Created    : 2021-03-22
-- Last update: 2021-03-23
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Top level design for I2S
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2021-03-22  1.0      Müller Pavel      Created
-- 2021-03-23  1.1      Bollhalder Jonas  MS2 integration
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity i2s_master is

  port (
    dacdat_pr_i	: in std_logic_vector(15 downto 0);
    dacdat_pl_i	: in std_logic_vector(15 downto 0);
    adcdat_s_i	: in std_logic;
    clk_6m	: in std_logic;
    rst_n	: in std_logic;
    dacdat_s_o	: out std_logic;
    step_o	: out std_logic;
    ws_o	: out std_logic;
    adcdat_pl_o	: out std_logic_vector(15 downto 0);
    adcdat_pr_o	: out std_logic_vector(15 downto 0)
    );

end entity i2s_master;

-------------------------------------------------------------------------------

architecture str of i2s_master is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal load_sig       : std_logic;
  signal shift_l_sig    : std_logic;
  signal shift_r_sig    : std_logic;
  signal ws_sig         : std_logic;
  signal ser_out_l_sig : std_logic;
  signal ser_out_r_sig : std_logic;
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component i2s_frame_generator is
    port (
      clk_6m  : in  std_logic;
      rst_n   : in  std_logic;
      load    : out std_logic;
      shift_l : out std_logic;
      shift_r : out std_logic;
      ws      : out std_logic);
  end component i2s_frame_generator;

  component uni_shiftreg is
    generic (
      width : positive);
    port (
      par_in  : in  std_logic_vector(width-1 downto 0);
      ser_in  : in  std_logic;
      load    : in  std_logic;
      enable  : in  std_logic;
      rst_n   : in  std_logic;
      clk_6m  : in  std_logic;
      par_out : out std_logic_vector(width-1 downto 0);
      ser_out : out std_logic);
  end component uni_shiftreg;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "i2s_frame_generator_1"
  i2s_frame_generator_1: i2s_frame_generator
    port map (
      clk_6m  => clk_6m,
      rst_n   => rst_n,
      load    => load_sig,
      shift_l => shift_l_sig,
      shift_r => shift_r_sig,
      ws      => ws_sig);

  -- instance "Left pl to s uni_shiftreg_1"
  uni_shiftreg_1: uni_shiftreg
    generic map (
      width => 16)
    port map (
      par_in  => dacdat_pl_i,
      ser_in  => '0',
      load    => load_sig,
      enable  => shift_l_sig,
      rst_n   => rst_n,
      clk_6m  => clk_6m,
      par_out => open,
      ser_out => ser_out_l_sig);

  -- instance "Right pl to s uni_shiftreg_2"
  uni_shiftreg_2: uni_shiftreg
    generic map (
      width => 16)
    port map (
      par_in  => dacdat_pr_i,
      ser_in  => '0',
      load    => load_sig,
      enable  => shift_r_sig,
      rst_n   => rst_n,
      clk_6m  => clk_6m,
      par_out => open,
      ser_out => ser_out_r_sig); 

  -- instance "Left s to pl uni_shiftreg_3"
  uni_shiftreg_3: uni_shiftreg
    generic map (
      width => 16)
    port map (
      par_in  => (others => '0'),
      ser_in  => adcdat_s_i,
      load    => '0',
      enable  => shift_l_sig,
      rst_n   => rst_n,
      clk_6m  => clk_6m,
      par_out => adcdat_pl_o,
      ser_out => open);

  -- instance "Right s to pl uni_shiftreg_4"
  uni_shiftreg_4: uni_shiftreg
    generic map (
      width => 16)
    port map (
      par_in  => (others => '0'),
      ser_in  => adcdat_s_i,
      load    => '0',
      enable  => shift_r_sig,
      rst_n   => rst_n,
      clk_6m  => clk_6m,
      par_out => adcdat_pr_o,
      ser_out => open);

  -- purpose: multiplex serial out
  -- type   : combinational
  multiplexer: process (all) is
  begin  -- process multiplexer
    if ws_sig = '1' then
      --right
      dacdat_s_o <= ser_out_r_sig;
    else
     --left
      dacdat_s_o <= ser_out_l_sig;      
    end if;
  end process multiplexer;

  step_o <= load_sig;
  ws_o   <= ws_sig;

end architecture str;

-------------------------------------------------------------------------------
