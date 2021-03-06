-------------------------------------------------------------------------------
-- Title      : reg_table_pkg
-- Project    : synthi Project
-------------------------------------------------------------------------------
-- File       : reg_table_pkg.vhd
-- Author     : dqtm
-- Created    : 2013-02-26
-- Last update: 2021-05-24
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Include in Design of Block codec_control.vhd :
--              use work.reg_table_pkg.all;
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2013-02-26  1.0      dqtm	          file created for DTP2 Lab3
-- 2015-02-24  1.1      dqtm            simplified names of register indexes
-- 2015-03-03  1.2      gelk            adapted sampling rate to 48 khz
-- 2015-03-04  1.3      gelk            also analog loop with 48 khz sampling rate
-- 2021-05-17  1.4      Müller Pavel    implemented volume control
-- 2021-05-24  1.4      Müller Pavel    changed values of volume
-------------------------------------------------------------------------------

-- Package  Declaration
-------------------------------------------------------------------------------
-- Include in Design of Block codec_control.vhd :
--   use work.reg_table_pkg.all;
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package reg_table_pkg is

-------------------------------------------------------------------------------
-- Type Declaration
-------------------------------------------------------------------------------
  type t_codec_register_array is array(0 to 9) of std_logic_vector(8 downto 0);

  type t_codec_volume_array is array(0 to 15) of std_logic_vector(8 downto 0);

  type i2c_data is record
    reg0, reg1, reg2, reg3, reg4 : std_logic_vector(8 downto 0);
    reg5, reg6, reg7, reg8, reg9 : std_logic_vector(8 downto 0);
  end record i2c_data;

  -------------------------------------------------------------------------------
-- Constant Declaration
-------------------------------------------------------------------------------
-- FOR REFERENCE:                       Registers R0 till R9
-- --------------------         --------------------------------------
-- R0  LEFT_LINE_IN:            Left line input channel volume control
-- R1  RIGHT_LINE_IN:           Right line input channel volume control
-- R2  LEFT_HP_OUT:             Left channel headphone volume control
-- R3  RIGHT_HP_OUT:            Right channel headphone volume control
-- R4  ANALOG_AP:                       Analog audio path control
-- R5  DIGITAL_AP:                      Digital audio path control
-- R6  POWER_DOWN               Power down control
-- R7  DIGITAL_AI:                      Digital audio interface format
-- R8  SAMPLING:                Sample rate control
-- R9  DIGITAL_ACTIVATE:        Digital interface activation

-- Fields in Registers
-- C_ADDR_LEFT/RIGHT_LINE_IN
  constant C_LINE_IN_LINVOL_P12DB : std_logic_vector(8 downto 0) := "000011111";  -- Line input volume +12 dB
  constant C_LINE_IN_LINVOL_0DB   : std_logic_vector(8 downto 0) := "000010111";  -- Line input volume 0 dB
  constant C_LINE_IN_LINVOL_M12DB : std_logic_vector(8 downto 0) := "000001111";  -- Line input volume -12 dB

-- C_ADDR_LEFT/RIGHT_HP_OUT
  constant C_HP_OUT_HPVOL_P6DB  : std_logic_vector(8 downto 0) := "001111111";  -- Headphone volume +6dB (127)
  constant C_HP_OUT_HPVOL_P4DB  : std_logic_vector(8 downto 0) := "001111101";  -- Headphone volume +4dB
  constant C_HP_OUT_HPVOL_P3DB  : std_logic_vector(8 downto 0) := "001111100";  -- Headphone volume +3dB (124)
  constant C_HP_OUT_HPVOL_0DB   : std_logic_vector(8 downto 0) := "001111001";  -- Headphone volume +0dB (121)
  constant C_HP_OUT_HPVOL_M5DB  : std_logic_vector(8 downto 0) := "001110100";  -- Headphone volume -5dB (116)
  constant C_HP_OUT_HPVOL_M10DB : std_logic_vector(8 downto 0) := "001101111";  -- Headphone volume -10dB(111)
  constant C_HP_OUT_HPVOL_M15DB : std_logic_vector(8 downto 0) := "001101010";  -- Headphone volume -15dB(106)
  constant C_HP_OUT_HPVOL_M20DB : std_logic_vector(8 downto 0) := "001100101";  -- Headphone volume -20dB(101)
  constant C_HP_OUT_HPVOL_M25DB : std_logic_vector(8 downto 0) := "001100000";  -- Headphone volume -25dB (96)
  constant C_HP_OUT_HPVOL_M30DB : std_logic_vector(8 downto 0) := "001011011";  -- Headphone volume -30dB (91)
  constant C_HP_OUT_HPVOL_M35DB : std_logic_vector(8 downto 0) := "001010110";  -- Headphone volume -35dB (86)
  constant C_HP_OUT_HPVOL_M40DB : std_logic_vector(8 downto 0) := "001010001";  -- Headphone volume -40db (81)
  constant C_HP_OUT_HPVOL_M45DB : std_logic_vector(8 downto 0) := "001001100";  -- Headphone volume -45dB (76)
  constant C_HP_OUT_HPVOL_M50DB : std_logic_vector(8 downto 0) := "001000111";  -- Headphone volume -50dB (71)
  constant C_HP_OUT_HPVOL_M55DB : std_logic_vector(8 downto 0) := "001000010";  -- Headphone volume -55dB (66)
  constant C_HP_OUT_HPVOL_M60DB : std_logic_vector(8 downto 0) := "000111101";  -- Headphone volume -60dB (61)
  constant C_HP_OUT_HPVOL_MUTE  : std_logic_vector(8 downto 0) := "000000000";  -- Headphone volume MUTE   (0)

--  C_ADDR_ANALOG_AP
  constant C_ANALOG_AP_DACSEL  : std_logic_vector(8 downto 0) := (4 => '1', others => '0');  -- Add DAC signal to output
  constant C_ANALOG_AP_BYPASS  : std_logic_vector(8 downto 0) := (3 => '1', others => '0');  -- Bypass switch (loop line in to line out)
  constant C_ANALOG_AP_MUTEMIC : std_logic_vector(8 downto 0) := (1 => '1', others => '0');  -- Microphone mute.

-- C_ADDR_DIGITAL_AP - Digital Audio Path Control
  constant C_DIGITAL_AP_DACMU     : std_logic_vector(8 downto 0) := (3      => '1', others => '0');  -- DAC soft mute
  constant C_DIGITAL_AP_DEEMP_DIS : std_logic_vector(8 downto 0) := (others => '0');  -- De-emphasis Disabled

-- C_ADDR_POWER_DOWN - Power Down Control
  constant C_POWER_DOWN_NONE : std_logic_vector(8 downto 0) := (others => '0');  -- power all blocks

-- C_ADDR_DIGITAL_AI - Digital Audio Interface Format
  constant C_DIGITAL_AI_IWL_16     : std_logic_vector(8 downto 0) := (others => '0');  -- 16 bit data.
  constant C_DIGITAL_AI_FORMAT_I2S : std_logic_vector(8 downto 0) := (1      => '1', others => '0');  -- I2S format

-- C_ADDR_SAMPLING - Sample Rate Control
  constant C_SAMPLING_SR_1 : std_logic_vector(8 downto 0) := (3 => '1', others => '0');  -- sample rate control bit 1
  constant C_SAMPLING_SR_0 : std_logic_vector(8 downto 0) := (2 => '1', others => '0');  -- sample rate control bit 0

-- C_ADDR_DIGITAL_ACTIVATE - Digital Interface Activation
  constant C_DIGITAL_ACTIVATE_ACTIVE : std_logic_vector(8 downto 0) := (0 => '1', others => '0');  -- Activate interface (1=act)



-- Register Set for selected modes

-- C_W8731_ANALOG_BYPASS =====================================================
-- analog bypass (loop line in  -> line out via FPGA)
-- input gain -12dB / 0dB / +6dB
-- output gain -12dB / 0dB / +6dB
-- dac muted, no sidetone
-- adc sampling 48kHz
-- interface in I2S mode, 16 bit quantisation
  constant C_W8731_ANALOG_BYPASS : t_codec_register_array := (
    0 => "000000000" or C_LINE_IN_LINVOL_0DB,
    1 => "000000000" or C_LINE_IN_LINVOL_0DB,
    2 => "000000000" or C_HP_OUT_HPVOL_P4DB,
    3 => "000000000" or C_HP_OUT_HPVOL_P4DB,
    4 => "000000000" or C_ANALOG_AP_MUTEMIC or C_ANALOG_AP_BYPASS,
    5 => "000000000" or C_DIGITAL_AP_DACMU or C_DIGITAL_AP_DEEMP_DIS,
    6 => "000000000" or C_POWER_DOWN_NONE,
    7 => "000000000" or C_DIGITAL_AI_IWL_16 or C_DIGITAL_AI_FORMAT_I2S,
    8 => "000000000",                   -- 48kHz with mclk=12.288MHz
    9 => "000000000" or C_DIGITAL_ACTIVATE_ACTIVE);

-- C_W8731_ANALOG_MUTE_LEFT =====================================================
-- analog bypass (loop line in  -> line out via FPGA)
-- input gain -12dB / 0dB / +6dB
-- output gain -12dB / 0dB / +6dB
-- dac muted, no sidetone
-- adc sampling 48kHz
-- interface in I2S mode, 16 bit quantisation
  constant C_W8731_ANALOG_MUTE_LEFT : t_codec_register_array := (
    0 => "000000000" or C_LINE_IN_LINVOL_M12DB,
    1 => "000000000" or C_LINE_IN_LINVOL_M12DB,
    2 => "000000000" or C_HP_OUT_HPVOL_MUTE,  -- Mute   left
    3 => "000000000" or C_HP_OUT_HPVOL_0DB,   -- louder  right
    4 => "000000000" or C_ANALOG_AP_MUTEMIC or C_ANALOG_AP_BYPASS,
    5 => "000000000" or C_DIGITAL_AP_DACMU or C_DIGITAL_AP_DEEMP_DIS,
    6 => "000000000" or C_POWER_DOWN_NONE,
    7 => "000000000" or C_DIGITAL_AI_IWL_16 or C_DIGITAL_AI_FORMAT_I2S,
    8 => "000000000",                         -- 48kHz with mclk=12.288MHz
    9 => "000000000" or C_DIGITAL_ACTIVATE_ACTIVE);

-- C_W8731_ANALOG_MUTE_RIGHT =====================================================
-- analog bypass (loop line in  -> line out via FPGA)
-- input gain -12dB / 0dB / +6dB
-- output gain -12dB / 0dB / +6dB
-- dac muted, no sidetone
-- adc sampling 48kHz
-- interface in I2S mode, 16 bit quantisation
  constant C_W8731_ANALOG_MUTE_RIGHT : t_codec_register_array := (
    0 => "000000000" or C_LINE_IN_LINVOL_M12DB,
    1 => "000000000" or C_LINE_IN_LINVOL_M12DB,
    2 => "000000000" or C_HP_OUT_HPVOL_0DB,   -- louder  left
    3 => "000000000" or C_HP_OUT_HPVOL_MUTE,  -- Mute   right
    4 => "000000000" or C_ANALOG_AP_MUTEMIC or C_ANALOG_AP_BYPASS,
    5 => "000000000" or C_DIGITAL_AP_DACMU or C_DIGITAL_AP_DEEMP_DIS,
    6 => "000000000" or C_POWER_DOWN_NONE,
    7 => "000000000" or C_DIGITAL_AI_IWL_16 or C_DIGITAL_AI_FORMAT_I2S,
    8 => "000000000",                         -- 48kHz with mclk=12.288MHz
    9 => "000000000" or C_DIGITAL_ACTIVATE_ACTIVE);

-- C_W8731_ANALOG_MUTE_BOTH =====================================================
-- analog bypass (loop line in  -> line out via FPGA)
-- input gain -12dB / 0dB / +6dB
-- output gain -12dB / 0dB / +6dB
-- dac muted, no sidetone
-- adc sampling 48kHz
-- interface in I2S mode, 16 bit quantisation
  constant C_W8731_ANALOG_MUTE_BOTH : t_codec_register_array := (
    0 => "000000000" or C_LINE_IN_LINVOL_M12DB,
    1 => "000000000" or C_LINE_IN_LINVOL_M12DB,
    2 => "000000000" or C_HP_OUT_HPVOL_MUTE,  -- Mute   left
    3 => "000000000" or C_HP_OUT_HPVOL_MUTE,  -- Mute   right
    4 => "000000000" or C_ANALOG_AP_MUTEMIC or C_ANALOG_AP_BYPASS,
    5 => "000000000" or C_DIGITAL_AP_DACMU or C_DIGITAL_AP_DEEMP_DIS,
    6 => "000000000" or C_POWER_DOWN_NONE,
    7 => "000000000" or C_DIGITAL_AI_IWL_16 or C_DIGITAL_AI_FORMAT_I2S,
    8 => "000000000",                         -- 48kHz with mclk=12.288MHz
    9 => "000000000" or C_DIGITAL_ACTIVATE_ACTIVE);



-- C_W8731_ADC_DAC_0DB_48K =====================================================
-- input gain -12dB / 0dB / +6dB
-- output gain -12dB / 0dB / +6dB
-- dac enabled, no sidetone
-- adc/dac sampling 48kHz
-- interface in I2S mode, 16 bit quantisation
  constant C_W8731_ADC_DAC_0DB_48K : t_codec_register_array := (
    0 => "000000000" or C_LINE_IN_LINVOL_0DB,
    1 => "000000000" or C_LINE_IN_LINVOL_0DB,
    2 => "000000000" or C_HP_OUT_HPVOL_0DB,
    3 => "000000000" or C_HP_OUT_HPVOL_0DB,
    4 => "000000000" or C_ANALOG_AP_MUTEMIC or C_ANALOG_AP_DACSEL,
    5 => "000000000" or C_DIGITAL_AP_DEEMP_DIS,
    6 => "000000000" or C_POWER_DOWN_NONE,
    7 => "000000000" or C_DIGITAL_AI_IWL_16 or C_DIGITAL_AI_FORMAT_I2S,
    8 => "000000000",                   -- 48kHz with mclk=12.288MHz
    9 => "000000000" or C_DIGITAL_ACTIVATE_ACTIVE);

-- C_W8731_VOLUME =====================================================
-- Volume Array for codec controller

    constant C_W8731_VOLUME : t_codec_volume_array := (
    0 => "000000000"  or C_HP_OUT_HPVOL_P6DB,
    1 => "000000000"  or C_HP_OUT_HPVOL_P3DB,
    2 => "000000000"  or C_HP_OUT_HPVOL_0DB,
    3 => "000000000"  or C_HP_OUT_HPVOL_M5DB,
    4 => "000000000"  or C_HP_OUT_HPVOL_M10DB,
    5 => "000000000"  or C_HP_OUT_HPVOL_M15DB,
    6 => "000000000"  or C_HP_OUT_HPVOL_M20DB,
    7 => "000000000"  or C_HP_OUT_HPVOL_M25DB,
    8 => "000000000"  or C_HP_OUT_HPVOL_M30DB,               
    9 => "000000000"  or C_HP_OUT_HPVOL_M35DB,
    10 => "000000000" or C_HP_OUT_HPVOL_M40DB,
    11 => "000000000" or C_HP_OUT_HPVOL_M45DB,
    12 => "000000000" or C_HP_OUT_HPVOL_M50DB,
    13 => "000000000" or C_HP_OUT_HPVOL_M55DB,
    14 => "000000000" or C_HP_OUT_HPVOL_M60DB,
    15 => "000000000" or C_HP_OUT_HPVOL_MUTE);
end package;
