-------------------------------------------------------------------------------
-- Title      : register controller
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : reg_controller.vhd
-- Author     : Bollhalder Jonas
-- Created    : 2021-04-15
-- Last update: 2021-04-15
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: The received byte messages are evaluated and stored in the 
--              corresponding registers. According to the settings in the 
--              registers the switches are overwritten.
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2021-04-15  1.0      Bollhalder Jonas  Created
-- 2021-05-03  1.1      Bollhalder Jonas  Optimized
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.reg_controller_pkg.all;

entity reg_controller is
  
  port (
    clk_6m : in std_logic;
    rst_n : in std_logic;
    data_i : in std_logic_vector(7 downto 0);
    data_rdy : in std_logic;
    config_i : in t_reg_array;
    config_o : out t_reg_array);

end entity reg_controller;

-- Architecture Declaration
-------------------------------------------
architecture rtl of reg_controller is
-- Signals & Constants Declaration
-------------------------------------------
  signal reg, next_reg : t_reg_array;
  
begin  -- architecture rtl

  -- purpose: manage register
  -- type   : combinational
  -- inputs : all
  -- outputs: --
  manage_register: process (all) is
  begin  -- process register
    if rst_n = '0' then
      reg <= (others=>(others=>'0'));
    elsif rising_edge(clk_6m) then
      reg <= next_reg;
    end if;
  end process manage_register;

  -- purpose: read input and maipulate next_register
  -- type   : combinational
  -- inputs : all
  -- outputs: --
  input_register: process (all) is
    begin  -- process input_register
      next_reg <= reg;
      if data_rdy = '1' then
        next_reg(to_integer(unsigned(data_i(7 downto 4))))<= data_i(3 downto 0);
      end if;
    end process input_register;
  
  -- purpose: mux input config with regs
  -- type   : combinational
  -- inputs : all
  -- outputs: --
  config_mux: process (all) is
  begin  -- process config_mux
    if reg(0)(0) = '1' then
      config_o <= reg;
    else
      config_o <= config_i;
    end if;
  
  end process config_mux;

end architecture rtl;
