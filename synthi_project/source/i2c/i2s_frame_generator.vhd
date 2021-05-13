-------------------------------------------------------------------------------
-- Title      : i2s_frame_generator
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : i2s_frame_generator.vhd
-- Author     : muellpav
-- Company    : 
-- Created    : 2021-03-22
-- Last update: 2021-03-22
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Generates the frames for i2s master
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author          Description
-- 2021-03-22  1.0      muellpav	      Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity i2s_frame_generator is

  port (
    clk_6m      : in std_logic;
    rst_n       : in std_logic;
    load        : out std_logic;
    shift_l     : out std_logic;
    shift_r     : out std_logic;
    ws          : out std_logic
    );

end entity i2s_frame_generator;

-------------------------------------------------------------------------------

architecture str of i2s_frame_generator is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal count : natural;
  signal next_count : natural;
  signal bckl : std_logic;                       -- inverted clk_6m

begin  -- architecture str

  bckl <= not clk_6m;
  
-- purpose: Process for registers
-- type   : sequential
-- inputs : clk_6m, rst_n
-- signals: next_count
-- outputs: count
  
  flip_flops: process (all) is
  begin  -- process flip_flops
    if rst_n = '0' then                   -- asynchronous reset (active low)
      count <= natural(0);				-- convert integer value 0 to unsigned
														-- with 4 bits
    elsif falling_edge(bckl) then         -- falling inverted clock edge
      count <= next_count;
    end if;
  end process flip_flops;


-- purpose: Increases the value of next_count
-- type   : combinational
-- inputs : all
-- outputs: next_count

  counter: process (all) is
  begin  -- process counter
    if count < 127 then
      next_count <= count +1;
    else
      next_count <= natural(0);            
    end if;
  end process counter;


-- purpose: decoder for the values of the counter
-- type   : combinational
-- inputs : all
-- outputs: load, shift_l, shift_r, ws

  i2s_decoder: process (all) is
  begin  -- process i2s_decoder

    -- decoder for output ws
    if count >= 64 and count <=127 then
      ws <= '1';
    else
      ws <= '0';
    end if;

	 
    load <= '0';
    shift_l <= '0';
    shift_r <= '0';
    -- decoder for load, shift_l, shift_r
    
    case count is
      when 0 =>
        load    <= '1';
      when 1 to 16 =>
        shift_l <= '1';
      when 65 to 80 =>
        shift_r <= '1';
		when others =>
		  shift_r <= '0';
		  shift_l <= '0';
		  load	 <= '0';
    end case;


   -- Wurde durch das case Statement oben ersetzt 
   -- if count = 0 then
   --   load <= '1';
   -- elsif count >= 1 and count <= 16 then
   --   shift_l <= '1';
   -- elsif count >=65 and count <= 80 then
   --   shift_r <= '1';
   -- end if;
	 
  
  end process i2s_decoder;



end architecture str;

-------------------------------------------------------------------------------
