-------------------------------------------------------------------------------
-- Title      : path_control
-- Project    : synthi Project
-------------------------------------------------------------------------------
-- File       : path_control.vhd
-- Author     : muellpav
-- Created    : 2021-03-22
-- Last update: 2021-03-22
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Controll of the audio Path
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-03-22  1.0      muellpav	      Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity path_control is

  port (
    dds_l_i     : in std_logic_vector(15 downto 0);
    dds_r_i     : in std_logic_vector(15 downto 0);
    adcdat_pl_i : in std_logic_vector(15 downto 0);
    adcdat_pr_i : in std_logic_vector(15 downto 0);
    dacdat_pl_o : out std_logic_vector(15 downto 0);
    dacdat_pr_o : out std_logic_vector(15 downto 0);
    sw          : in std_logic
    );

end entity path_control;

-------------------------------------------------------------------------------

architecture str of path_control is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  switch: process (all) is
  begin
    if sw = '1' then
      dacdat_pl_o <= adcdat_pl_i;
      dacdat_pr_o <= adcdat_pr_i;
    else
      dacdat_pl_o <= dds_l_i;
      dacdat_pr_o <= dds_r_i;
    end if;
    
  end process switch;
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

end architecture str;

-------------------------------------------------------------------------------
