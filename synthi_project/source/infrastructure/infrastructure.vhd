-------------------------------------------------------------------------------
-- Title      : infrastructure
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : infrastructure.vhd
-- Author     : Boehi Dominik
-- Created    : 2021-03-01
-- Last update: 2021-04-15
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description:
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2021-03-01  1.0      Boehi Dominik	    Created
-- 2021-04-15  1.1      Bollhalder Jonas  implemented bluetooth
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity infrastructure is

  port (
    clock_50 : in std_logic;
    key_0    : in std_logic;
    key_1    : in std_logic;
    usb_txd  : in std_logic;
    bt_txd   : in std_logic;
    clk_6m   : out std_logic;
    clk_12m  : out std_logic;
    key_0_sync  : out std_logic;
    key_1_sync  : out std_logic;
    usb_txd_sync : out std_logic;
    bt_txd_sync  : out std_logic;
    ledr_0   : out std_logic;
    ledr_1   : out std_logic
    );

end entity infrastructure;

-------------------------------------------------------------------------------

architecture str of infrastructure is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  component modulo_divider is
    port (
      clk     : IN  std_logic;
      clk_12m : OUT std_logic;
      clk_6m  : OUT std_logic);
  end component modulo_divider;

  component clock_sync is
    port (
      data_in  : in  std_logic;
      clk      : in  std_logic;
      sync_out : out std_logic);
  end component clock_sync;

  component signal_checker is
    port (
      clk, reset_n : in  std_logic;
      data_in      : in  std_logic;
      led_blink    : out std_logic);
  end component signal_checker;

  signal clk_12m_sig : std_logic;
  signal clk_6m_sig : std_logic;
  

begin  -- architecture str

	clk_12m <= clk_12m_sig;
	clk_6m <= clk_6m_sig;
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "modulo_divider_1"
  modulo_divider_1: modulo_divider
    port map (
      clk     => clock_50,
      clk_6m  => clk_6m_sig,
      clk_12m => clk_12m_sig);

    -- instance "signal_checker_1"
  signal_checker_1: signal_checker
    port map (
      clk 	=> clock_50,
      reset_n   => key_0,
      data_in   => usb_txd,
      led_blink => ledr_0);

    -- instance "signal_checker_2"
  signal_checker_2: signal_checker      
    port map (
      clk 	=> clock_50,
      reset_n   => key_0,
      data_in   => bt_txd,
      led_blink => ledr_1);

  -- instance "clock_sync_1"
  clock_sync_1: clock_sync
    port map (
      data_in  => key_0,
      clk      => clk_6m_sig,
      sync_out => key_0_sync);

  -- instance "clock_sync_2"
  clock_sync_2: clock_sync
    port map (
      data_in  => key_1,
      clk      => clk_6m_sig,
      sync_out => key_1_sync);

  -- instance "clock_sync_3"
  clock_sync_3: clock_sync
    port map (
      data_in  => usb_txd,
      clk      => clk_6m_sig,
      sync_out => usb_txd_sync);

  -- instance "clock_sync_4"
  clock_sync_4: clock_sync
    port map (
      data_in  => bt_txd,
      clk      => clk_6m_sig,
      sync_out => bt_txd_sync);

end architecture str;

-------------------------------------------------------------------------------
