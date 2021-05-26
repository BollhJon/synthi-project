-------------------------------------------------------------------------------
-- Title      : vector check
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : vector_check.vhd
-- Author     : Bollhalder Jonas
-- Created    : 2021-04-15
-- Last update: 2021-04-15
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Der Baustein speichert den vorherigen Vektorzustand und
--              wenn sich der Wert des Vektors veraendert, wird ein
--              Signal aus gegeben.
-------------------------------------------------------------------------------
-- Copyright (c) 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author              Description
-- 2021-04-15  1.0      Bollhalder Jonas    Created
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity vector_check is
  generic (
    width : positive := 3);
  port (
    vector_i : in std_logic_vector(width-1 downto 0);
    clk_i    : in std_logic;
    signal_o : out std_logic);

end entity vector_check;

-- Architecture Declaration
-------------------------------------------
architecture rtl of vector_check is
-- Signals & Constants Declaration
-------------------------------------------
  signal last_vector : std_logic_vector(width-1 downto 0);
  signal signal_int : std_logic;

  component clock_sync is
    port (
      data_in  : in  std_logic;
      clk      : in  std_logic;
      sync_out : out std_logic);
  end component clock_sync;
  
begin  -- architecture rtl

  -- purpose: buffer vector into signal
  -- type   : combinational
  -- inputs : all
  -- outputs: --
  buffer_vector: process (all) is
  begin
    if rising_edge(clk_i) then
      last_vector <= vector_i;
    end if;
  end process buffer_vector;

  -- purpose: check buffer with input
  -- type   : combinational
  -- inputs : all
  -- outputs: signal_o
  check_process: process (all) is
  begin  -- process check_process
    signal_int <= '0';
    if vector_i /= last_vector then
      signal_int <= '1';
    end if;
  end process check_process;

  -- instance "clock_sync_1"
  clock_sync_1: clock_sync
    port map (
      data_in  => signal_int,
      clk      => clk_i,
      sync_out => signal_o);
end architecture rtl;





