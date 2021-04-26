-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     :   <domin@DESKTOP-PQBL6RE>
-- Company    : 
-- Created    : 2021-03-01
-- Last update: 2021-04-19
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-03-01  1.0      domin	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.reg_table_pkg.all;
use work.tone_gen_pkg.all;

-------------------------------------------------------------------------------

entity synthi_top is

 -- generic (
 --    );

  port (
        CLOCK_50 : in std_logic;            -- DE2 clock from xtal 50MHz
        KEY_0    : in std_logic;            -- DE2 low_active input buttons
        KEY_1    : in std_logic;            -- DE2 low_active input buttons
        SW       : in std_logic_vector(9 downto 0);  -- DE2 input switches

        USB_RXD : in std_logic;             -- USB (midi) serial_input
        USB_TXD : in std_logic;             -- USB (midi) serial_output

        BT_RXD : in std_logic;             -- Bluetooth serial_input
        BT_TXD : in std_logic;             -- Bluetooth serial_output
        BT_RST_N : out std_logic;           -- Bluetooth reset_n

        AUD_XCK     : out std_logic;        -- master clock for Audio Codec
        AUD_DACDAT  : out std_logic;        -- audio serial data to Codec-DAC
        AUD_BCLK    : out std_logic;        -- bit clock for audio serial data
        AUD_DACLRCK : out std_logic;        -- left/right word select for Codec-DAC
        AUD_ADCLRCK : out std_logic;        -- left/right word select for Codec-ADC
        AUD_ADCDAT  : in  std_logic;        -- audio serial data from Codec-ADC

        AUD_SCLK : out   std_logic;         -- clock from I2C master block
        AUD_SDAT : inout std_logic;          -- data  from I2C master block

        HEX0 : out std_logic_vector(6 downto 0);  -- output for HEX 0 display
        HEX1 : out std_logic_vector(6 downto 0);  -- output for HEX 1 display
        HEX2 : out std_logic_vector(6 downto 0);  -- output for HEX 2 display
        HEX3 : out std_logic_vector(6 downto 0);  -- output for HEX 3 display
       -- HEX4 : out std_logic_vector(6 downto 0);  -- output for HEX 4 display
       -- HEX5 : out std_logic_vector(6 downto 0);  -- output for HEX 5 display
		  
        LEDR_0 : out std_logic;
        LEDR_1 : out std_logic;
        LEDR_2 : out std_logic;
        LEDR_3 : out std_logic;
        LEDR_4 : out std_logic;
        LEDR_5 : out std_logic;
        LEDR_6 : out std_logic;
        LEDR_7 : out std_logic;
        LEDR_8 : out std_logic;
        LEDR_9 : out std_logic
    );

end entity synthi_top;

-------------------------------------------------------------------------------

architecture str of synthi_top is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal usb_data_rdy_sig : std_logic;
  signal usb_data_sig     : std_logic_vector(7 DOWNTO 0);
  signal bt_data_rdy_sig  : std_logic;
  signal bt_data_sig      : std_logic_vector(7 DOWNTO 0);
  signal clk_12m_sig      : std_logic;
  signal clk_6m_sig       : std_logic;
  signal reset_n_sig      : std_logic;
  signal reset_bt_n_sig   : std_logic;
  signal usb_txd_sync_sig : std_logic;
  signal bt_txd_sync_sig  : std_logic;
  signal write_done_sig	  : std_logic;
  signal ack_error_sig	  : std_logic;
  signal write_sig	  : std_logic;
  signal write_data_sig	  : std_logic_vector(15 downto 0);
  signal dds_l_i_sig      : std_logic_vector(15 downto 0);
  signal dds_r_i_sig      : std_logic_vector(15 downto 0);
  signal adcdat_pl_i_sig  : std_logic_vector(15 downto 0);
  signal adcdat_pr_i_sig  : std_logic_vector(15 downto 0);
  signal dacdat_pl_o_sig  : std_logic_vector(15 downto 0);
  signal dacdat_pr_o_sig  : std_logic_vector(15 downto 0);
  signal step_o_sig       : std_logic;
  signal ws_o_sig         : std_logic;
  signal note_sig         : std_logic_vector(6 downto 0);
  signal velocity_sig     : std_logic_vector(7 downto 0);
  signal config_sig       : std_logic_vector(23 downto 0);
  
 -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component uart_top is
    port (
      clk         : IN  STD_LOGIC;
      reset_n     : IN  STD_LOGIC;
      ser_data_i  : IN  STD_LOGIC;
      rx_data_rdy : OUT STD_LOGIC;
      rx_data     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
      seg0_o      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      seg1_o      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
  end component uart_top;

    component infrastructure is
    port (
      clock_50     : in  std_logic;
      key_0        : in  std_logic;
      key_1        : in  std_logic;
      usb_txd      : in  std_logic;
      bt_txd       : in  std_logic;
      clk_6m       : out std_logic;
      clk_12m      : out std_logic;
      key_0_sync   : out std_logic;
      key_1_sync   : out std_logic;
      usb_txd_sync : out std_logic;
      bt_txd_sync  : out std_logic;
      ledr_0       : out std_logic;
      ledr_1       : out std_logic);
  end component infrastructure;

  component codec_controller is
    port (
      mode         : in  std_logic_vector(2 downto 0);
      write_done_i : in  std_logic;
      ack_error_i  : in  std_logic;
      clk          : in  std_logic;
      reset_n      : in  std_logic;
      write_o      : out std_logic;
      write_data_o : out std_logic_vector(15 downto 0));
  end component codec_controller;

  component i2c_master is
    port (
      clk          : in    std_logic;
      reset_n      : in    std_logic;
      write_i      : in    std_logic;
      write_data_i : in    std_logic_vector(15 downto 0);
      sda_io       : inout std_logic;
      scl_o        : out   std_logic;
      write_done_o : out   std_logic;
      ack_error_o  : out   std_logic);
  end component i2c_master;

  component i2s_master is
    port (
      dacdat_pr_i : in  std_logic_vector(15 downto 0);
      dacdat_pl_i : in  std_logic_vector(15 downto 0);
      adcdat_s_i  : in  std_logic;
      clk_6m      : in  std_logic;
      rst_n       : in  std_logic;
      dacdat_s_o  : out std_logic;
      step_o      : out std_logic;
      ws_o        : out std_logic;
      adcdat_pl_o : out std_logic_vector(15 downto 0);
      adcdat_pr_o : out std_logic_vector(15 downto 0));
  end component i2s_master;

  component path_control is
    port (
      dds_l_i     : in  std_logic_vector(15 downto 0);
      dds_r_i     : in  std_logic_vector(15 downto 0);
      adcdat_pl_i : in  std_logic_vector(15 downto 0);
      adcdat_pr_i : in  std_logic_vector(15 downto 0);
      dacdat_pl_o : out std_logic_vector(15 downto 0);
      dacdat_pr_o : out std_logic_vector(15 downto 0);
      sw          : in  std_logic);
  end component path_control;
  
  component tone_gen is
    port(
      clk_6m            : in  std_logic;
      reset_n           : in  std_logic;
      tone_on_i         : in std_logic;
      note_i            : in std_logic_vector(6 downto 0);
      step_i            : in std_logic;
      velocity_i        : in std_logic_vector(7 downto 0);
      dds_l_o           : out std_logic_vector(15 downto 0);
      dds_r_o           : out std_logic_vector(15 downto 0));
  end component tone_gen;

  component reg_controller is
    port (
      rst_n    : in  std_logic;
      data_i   : in  std_logic_vector(7 downto 0);
      data_rdy : in  std_logic;
      config_i : in  std_logic_vector(23 downto 0);
      config_o : out std_logic_vector(23 downto 0));
  end component reg_controller;


  
begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "uart_top_1"
  uart_top_1: uart_top
    port map (
      clk         => clk_6m_sig,
      reset_n     => reset_n_sig,
      ser_data_i  => usb_txd_sync_sig,
      rx_data_rdy => usb_data_rdy_sig,
      rx_data     => usb_data_sig,
      seg0_o      => HEX0,
      seg1_o      => HEX1);

  -- instance "uart_top_2"
  uart_top_2: uart_top
    port map (
      clk         => clk_12m_sig,
      reset_n     => reset_n_sig,
      ser_data_i  => bt_txd_sync_sig,
      rx_data_rdy => bt_data_rdy_sig,
      rx_data     => bt_data_sig,
      seg0_o      => HEX2,
      seg1_o      => HEX3);

  BT_RST_N  <= reset_bt_n_sig;
   

  -- instance "infrastructure_1"
  infrastructure_1: infrastructure
    port map (
      clock_50     => CLOCK_50,
      key_0        => KEY_0,
      key_1        => KEY_1,
      usb_txd      => USB_TXD,
      bt_txd       => BT_TXD,
      clk_6m       => clk_6m_sig,
      clk_12m      => clk_12m_sig,
      key_0_sync   => reset_n_sig,
      key_1_sync   => reset_bt_n_sig,
      usb_txd_sync => usb_txd_sync_sig,
      bt_txd_sync  => bt_txd_sync_sig,
      ledr_0       => LEDR_0,
      ledr_1       => LEDR_1);

  -- instance "codec_controller_1"
  codec_controller_1: codec_controller
    port map (
      mode         => config_sig(6 downto 4),
      write_done_i => write_done_sig,
      ack_error_i  => ack_error_sig,
      clk          => clk_6m_sig,
      reset_n      => reset_n_sig,
      write_o      => write_sig,
      write_data_o => write_data_sig);

  -- instance "i2c_master_1"
  i2c_master_1: i2c_master
    port map (
      clk          => clk_6m_sig,
      reset_n      => reset_n_sig,
      write_i      => write_sig,
      write_data_i => write_data_sig,
      sda_io       => AUD_SDAT,
      scl_o        => AUD_SCLK,
      write_done_o => write_done_sig,
      ack_error_o  => ack_error_sig);

  -- instance "i2s_master_1"
  i2s_master_1: i2s_master
    port map (
      dacdat_pr_i => dacdat_pr_o_sig,
      dacdat_pl_i => dacdat_pl_o_sig,
      adcdat_s_i  => AUD_ADCDAT,
      clk_6m      => clk_6m_sig,
      rst_n       => reset_n_sig,
      dacdat_s_o  => AUD_DACDAT,
      step_o      => step_o_sig,
      ws_o        => ws_o_sig,
      adcdat_pl_o => adcdat_pl_i_sig,
      adcdat_pr_o => adcdat_pr_i_sig);

  -- instance "path_control_1"
  path_control_1: path_control
    port map (
      dds_l_i     => dds_l_i_sig,
      dds_r_i     => dds_r_i_sig,
      adcdat_pl_i => adcdat_pl_i_sig,
      adcdat_pr_i => adcdat_pr_i_sig,
      dacdat_pl_o => dacdat_pl_o_sig,
      dacdat_pr_o => dacdat_pr_o_sig,
      sw          => config_sig(7));

  AUD_XCK <= clk_12m_sig;
  AUD_BCLK <= not clk_6m_sig;
  AUD_DACLRCK <= ws_o_sig;
  AUD_ADCLRCK <= ws_o_sig;
  
  -- instance "tone_gen_1
  
  tone_gen_1: tone_gen
    port map (
      clk_6m    => clk_6m_sig,
      reset_n   => reset_n_sig,
      step_i	=> step_o_sig,
      note_i	=> note_sig,
      velocity_i=> velocity_sig,
      tone_on_i	=> config_sig(8),
      dds_l_o	=> dds_l_i_sig,
      dds_r_o	=> dds_r_i_sig);
	
  note_sig <= config_sig(13 downto 12) & "00000";
  velocity_sig <= config_sig(11 downto 9) & "00000";

  -- instance "reg_controller_1"
  reg_controller_1: reg_controller
    port map (
      rst_n    => reset_n_sig,
      data_i   => bt_data_sig,
      data_rdy => bt_data_rdy_sig,
      config_i => "0000"&"0000"&("00"&SW(9 downto 8))&SW(7 downto 4)&SW(3 downto 0)&"0000",
      config_o => config_sig);
  
  LEDR_9 <= config_sig(0);
  
end architecture str;

-------------------------------------------------------------------------------
