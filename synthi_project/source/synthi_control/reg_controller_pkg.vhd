-------------------------------------------------------------------------------
-- Title      : register controller package
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : reg_controller_pkg.vhd
-- Author     : Bollhalder Jonas
-- Created    : 2021-05-03
-- Last update: 2021-05-13
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
-- 2021-05-03  1.0      Bollhalder Jonas  Created
-- 2021-05-13  1.1      Bollhalder Jonas  Upgraded to 16 registers
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package reg_controller_pkg is    

    type t_reg_array is array (0 to 15) of std_logic_vector(3 downto 0);

end package;
