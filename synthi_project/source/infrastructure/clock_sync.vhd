-------------------------------------------------------------------------------
-- Title      : clock_sync.vhd
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : clock_sync.vhd
-- Author     : gelk
-- Created    : 2019-09-04
-- Last update: 2020-11-23
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 -2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author        Description
-- 2019-09-04  1.0      gelk          Created
-- 2020-11-23  1.1      Boehi Dominik small changes
-------------------------------------------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
entity clock_sync is
  port(data_in  : in  std_logic;
       clk      : in  std_logic;
       sync_out : out std_logic
       );
end clock_sync;


-- Architecture Declaration¬†
architecture rtl of clock_sync is

  -- Signals & Constants Declaration¬†
  signal q_0, q_1 : std_logic := '0';


-- Begin Architecture
begin

  -------------------------------------------
  -- Process for registers (flip-flops)
  -------------------------------------------
  reg_proc : process(all)
  begin
    if rising_edge(clk) then
      q_0 <= data_in;
      q_1 <= q_0;
    end if;

  end process reg_proc;

  -------------------------------------------
  -- Concurrent Assignments  
  -------------------------------------------
  sync_out <= q_1;


end rtl;
