--------------------------------------------------------------------
--
-- Project     : Synthi_Project
--
-- File Name   : reg_controller.vhd
-- Description : controller for Registers
--                                      
-- Features:    Die eingegangenen Byte-Nachrichten werden ausgewertet
--              und in die entsprechnenden Register gespeichert.
--              Gemäss den Einstellungen in den Registern werden die
--              Schalter überschrieben.
--                              
--------------------------------------------------------------------
-- Change History
-- Date       |Name      |Modification
--------------|----------|------------------------------------------
-- 15.04.2021 | bollhjon | created file
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_contoller is
  
  port (
    rst_n : in std_logic;
    data_i : in std_logic_vector(7 downto 0);
    data_rdy : in std_logic;
    config_i : in std_logic_vector(23 downto 0);
    config_o : out std_logic_vector(23 downto 0));

end entity reg_contoller;

-- Architecture Declaration
-------------------------------------------
architecture rtl of reg_contoller is
-- Signals & Constants Declaration
-------------------------------------------
  signal reg_0 : std_logic_vector(3 downto 0):= (others=>'0');
  signal reg_1 : std_logic_vector(3 downto 0):= (others=>'0');
  signal reg_2 : std_logic_vector(3 downto 0):= (others=>'0');
  signal reg_3 : std_logic_vector(3 downto 0):= (others=>'0');
  signal reg_4 : std_logic_vector(3 downto 0):= (others=>'0');
  signal reg_5 : std_logic_vector(3 downto 0):= (others=>'0');
  
begin  -- architecture rtl

  -- purpose: get input and write into register
  -- type   : combinational
  -- inputs : all
  -- outputs: --
  input_to_reg: process (all) is
  begin  -- process input_to_reg
    if rst_n = '0' then
      reg_0 <= (others=>'0');
      reg_1 <= (others=>'0');
      reg_2 <= (others=>'0');
      reg_3 <= (others=>'0');
      reg_4 <= (others=>'0');
      reg_5 <= (others=>'0');
    elsif rising_edge(data_rdy) then
      case data_i(7 downto 4) is
        when "0000" => reg_0 <= data_i(3 downto 0);
        when "0001" => reg_1 <= data_i(3 downto 0);
        when "0010" => reg_2 <= data_i(3 downto 0);
        when "0011" => reg_3 <= data_i(3 downto 0);
        when "0100" => reg_4 <= data_i(3 downto 0);
        when "0101" => reg_5 <= data_i(3 downto 0);                             
        when others => null;
      end case;
    end if;
  end process input_to_reg;

  -- purpose: mux input config with regs
  -- type   : combinational
  -- inputs : all
  -- outputs: --
  config_mux: process (all) is
  begin  -- process config_mux
    if reg_0(0) = '1' then
      config_o <= reg_5 & reg_4 & reg_3 & reg_2 & reg_1 & reg_0;
    else
      config_o <= config_i;
    end if;
  
  end process config_mux;
  
  

end architecture rtl;
