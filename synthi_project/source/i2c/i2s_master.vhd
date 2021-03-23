-------------------------------------------------------------------------------
-- Title      : i2s_master
-- Project    : 
-------------------------------------------------------------------------------
-- File       : i2s_master.vhd
-- Author     : muellpav
-- Company    : 
-- Created    : 2021-03-22
-- Last update: 2021-03-22
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Top level design for I2S
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-03-22  1.0      muellpav	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity i2s_master is

  port (
    dacdat_pr_i	: in std_logic_vector(15 downto 0);
    dacdat_pl_i	: in std_logic_vector(15 downto 0);
    adcdat_s_i		: in std_logic;
    clk_6m			: in std_logic;
    rst_n			: in std_logic;
	 dacdat_s_o		: out std_logic;
	 step_o			: out std_logic;
	 ws_o				: out std_logic;
	 adcdat_pl_o	: out std_logic_vector(15 downto 0);
	 adcdat_pr_o	: out std_logic_vector(15 downto 0)
    );

end entity i2s_master;

-------------------------------------------------------------------------------

architecture str of i2s_master is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
