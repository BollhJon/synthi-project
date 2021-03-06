-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     : Boehi Dominik
-- Created    : 2021-03-01
-- Last update: 2021-05-24
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Top level file for Synthi-Project
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2021-03-01  1.0      Boehi Dominik	    Created
-- 2021-03-23  1.1      Bollhalder Jonas  MS2-integration
-- 2021-04-12  1.2      Boehi Dominik     MS3-integration
-- 2021-04-15  1.3      Bollhalder Jonas  Implemented Bluetooth uart_top
-- 2021-04-16  1.4      Bollhalder Jonas  Implemented reg-controller
-- 2021-05-03  1.5      Bollhalder Jonas  Optimized reg-controller
-- 2021-05-03  1.6      Müller Pavel      Implemented FM-Synthesis
-- 2021-05-06  1.7      Müller Pavel      Implemented selector for waves
-- 2021-05-10  1.8      Müller Pavel      Implemented logic for envelopes
-- 2021-05-17  1.9      Bollhalder Jonas  Full capacity Upgrade for reg-controller
-- 2021-05-17  1.10     Müller Pavel      Rearranged registers in reg-controller
-- 2021-05-17  1.11     Müller Pavel      Wave selector for envelope, carrier and modulator added
-- 2021-05-24  1.12     Müller Pavel      DDS splitted for for modulator and carrier
-- 2021-05-24  1.13     Müller Pavel      Upgraded fm-Ratio to 5 Bit
-------------------------------------------------------------------------------
-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.reg_table_pkg.all;
use work.tone_gen_pkg.all;
use work.reg_controller_pkg.all;

-------------------------------------------------------------------------------
-- Entity Declaration 
-------------------------------------------
entity synthi_top is

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
-- Architecture Declaration
-------------------------------------------
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
  signal write_sig	      : std_logic;
  signal write_data_sig	  : std_logic_vector(15 downto 0);
  signal dds_l_i_sig      : std_logic_vector(15 downto 0);
  signal dds_r_i_sig      : std_logic_vector(15 downto 0);
  signal adcdat_pl_i_sig  : std_logic_vector(15 downto 0);
  signal adcdat_pr_i_sig  : std_logic_vector(15 downto 0);
  signal dacdat_pl_o_sig  : std_logic_vector(15 downto 0);
  signal dacdat_pr_o_sig  : std_logic_vector(15 downto 0);
  signal step_o_sig       : std_logic;
  signal ws_o_sig         : std_logic;
  signal config_sig       : t_reg_array;
  signal note_on_sig      : std_logic_vector(9 downto 0);   
  signal note_sig         : t_tone_array;
  signal velocity_sig     : t_tone_array;
  signal dds_used_sig     : std_logic_vector(9 downto 0);

  
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
      ctr_i        : in  std_logic;
      volume_i     : in  std_logic_vector(3 downto 0);
      emphasis_i   : in  std_logic_vector(1 downto 0);
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

  component reg_controller is
    port (
      clk_6m   : in  std_logic;
      rst_n    : in  std_logic;
      data_i   : in  std_logic_vector(7 downto 0);
      data_rdy : in  std_logic;
      config_i : in  t_reg_array;
      config_o : out t_reg_array);
  end component reg_controller;

  component midi_controller_fsm is
    port (
      clk_6m      : in  std_logic;
      reset_n     : in  std_logic;
      rx_data     : in  std_logic_vector(7 downto 0);
      rx_data_rdy : in  std_logic;
      dds_used_i  : in  std_logic_vector( 9 downto 0);
      note_on     : out std_logic_vector(9 downto 0);
      note_o      : out t_tone_array;
      velocity    : out t_tone_array);
  end component midi_controller_fsm;

  component tone_gen is
    port (
      clk_6m      : in  std_logic;
      reset_n     : in  std_logic;
      tone_on_i   : in  std_logic_vector(9 downto 0);
      note_i      : in  t_tone_array;
      step_i      : in  std_logic;
      velocity_i  : in  t_tone_array;
      fm_ratio    : in std_logic_vector(4 downto 0);
      fm_depth    : in std_logic_vector(3 downto 0);
      lut_sel_car : in  std_logic_vector(3 downto 0);
      lut_sel_mod : in  std_logic_vector(2 downto 0);
      lut_sel_env : in  std_logic_vector(3 downto 0);
      dds_l_o     : out std_logic_vector(15 downto 0);
      dds_r_o     : out std_logic_vector(15 downto 0);
      dds_used_o  : out std_logic_vector(9 downto 0));
  end component tone_gen;



  
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
      seg1_o      => HEX1
      );

  -- instance "uart_top_2"
  uart_top_2: uart_top
    port map (
      clk         => clk_6m_sig,
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
      mode         => config_sig(1)(2 downto 0),
      write_done_i => write_done_sig,
      ack_error_i  => ack_error_sig,
      clk          => clk_6m_sig,
      reset_n      => reset_n_sig,
      ctr_i        => config_sig(0)(0),
      volume_i     => config_sig(3),
      emphasis_i   => config_sig(2)(1 downto 0),
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
      sw          => config_sig(1)(3));

  AUD_XCK <= clk_12m_sig;
  AUD_BCLK <= not clk_6m_sig;
  AUD_DACLRCK <= ws_o_sig;
  AUD_ADCLRCK <= ws_o_sig;
  

  -- instance "reg_controller_1"
  reg_controller_1: reg_controller
    port map (
      clk_6m   => clk_6m_sig,
      rst_n    => reset_bt_n_sig,
      data_i   => bt_data_sig,
      data_rdy => bt_data_rdy_sig,
      config_i => ("0000",SW(3 downto 0),"0000",SW(7 downto 4),("00"&SW(9 downto 8)),"0000","0000","0000","0000","0000","0000","0000","0000","0000","0000","0000"),
      config_o => config_sig);
  
  LEDR_9 <= config_sig(0)(0);

  -- instance "midi_controller_fsm_1"
  midi_controller_fsm_1: midi_controller_fsm
    port map (
      clk_6m     => clk_6m_sig,
      reset_n     => reset_n_sig,
      rx_data     => usb_data_sig,
      rx_data_rdy => usb_data_rdy_sig,
      dds_used_i  => dds_used_sig,
      note_on     => note_on_sig,
      note_o      => note_sig,
      velocity    => velocity_sig
      );


  -- instance "tone_gen_1"
  tone_gen_1: tone_gen
    port map (
      clk_6m     => clk_6m_sig,
      reset_n    => reset_n_sig,
      tone_on_i  => note_on_sig,
      note_i     => note_sig,
      step_i     => step_o_sig,
      velocity_i => velocity_sig,
      fm_ratio   => config_sig(4) & config_sig(9)(0),
      fm_depth   => config_sig(5),
      lut_sel_car => config_sig(6),
      lut_sel_mod => config_sig(7)(2 downto 0),
      lut_sel_env => config_sig(8),
      dds_l_o    => dds_l_i_sig,
      dds_r_o    => dds_r_i_sig,
      dds_used_o => dds_used_sig
      );
end architecture str;

-------------------------------------------------------------------------------
