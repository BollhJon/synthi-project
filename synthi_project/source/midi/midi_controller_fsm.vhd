-------------------------------------------------------------------------------
-- Title      : midi_controller_fsm
-- Project    : 
-------------------------------------------------------------------------------
-- File       : midi_controller_fsm.vhd
-- Author     : 
-- Company    : 
-- Created    : 2021-04-19
-- Last update: 2021-04-26
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2021-04-19  1.0      boehidom   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;
-------------------------------------------------------------------------------

entity midi_controller_fsm is

  port(clk12_m          : in  std_logic;
       reset_n          : in  std_logic;
       rx_data          : in  std_logic_vector(7 downto 0);
       rx_data_rdy      : in  std_logic;
		 note_on				: out std_logic;
		 note_simple		: out std_logic_vector(6 downto 0);
		 velocity_simple	: out std_logic_vector(6 downto 0)
       );

end entity midi_controller_fsm;

-------------------------------------------------------------------------------

architecture str of midi_controller_fsm is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  --Signals & Constants
  type midi_type is (wait_status, wait_data1, wait_data2);
  signal midi_state, next_midi_state : midi_type;

    signal data_flag, new_data_flag    : std_logic;
    signal data1_reg, next_data1_reg   : std_logic_vector(6 downto 0);
    signal data2_reg, next_data2_reg   : std_logic_vector(6 downto 0);
	 signal status_reg, next_status_reg : std_logic_vector(6 downto 0);

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

begin  -- architecture str

  midi_fsm : process(all)
  begin
    --default
    next_midi_state <= midi_state;
    next_status_reg <= status_reg;
    new_data_flag   <= '0';
    next_data1_reg  <= data1_reg;
    next_data2_reg  <= data2_reg;


    case midi_state is

-------------------------------------------------------------------------------
      --wait state
-------------------------------------------------------------------------------
      when wait_status =>
        if rx_data_rdy = '1' then
          if rx_data(7) = '1' then
            next_status_reg <= rx_data(6 downto 0);
            next_midi_state <= wait_data1;
          else
            next_data1_reg  <= rx_data(6 downto 0);
            next_midi_state <= wait_data2;
          end if;
        end if;

-------------------------------------------------------------------------------
      --wait data one
-------------------------------------------------------------------------------
      when wait_data1 =>
        if rx_data_rdy = '1' then
          next_data1_reg  <= rx_data(6 downto 0);
          next_midi_state <= wait_data2;
        else
          next_midi_state <= wait_data1;
        end if;


------------------------------------------------------------------------------
      --wait data two
------------------------------------------------------------------------------
      when wait_data2 =>
        if rx_data_rdy = '1' then
          next_data2_reg  <= rx_data(6 downto 0);
          new_data_flag   <= '1';
          next_midi_state <= wait_status;
        else
          next_midi_state <= wait_data2;
        end if;
------------------------------------------------------------------------------
        --others
------------------------------------------------------------------------------

      when others => next_midi_state <= midi_state;
    end case;
  end process midi_fsm;

------------------------------------------------------------------------------

  midi_out : process(all)
  
	begin
		
		note_on <= status_reg(4);
		note_simple <= data1_reg; 
		velocity_simple <= data2_reg;
	  
  end process midi_out;

  --FF midi_state
  ff : process(all)
  begin
    if reset_n = '0' then
      midi_state   <= wait_status;
      status_reg   <= (others => '0');
      data_flag    <= '0';
      data1_reg    <= (others => '0');
      data2_reg    <= (others => '0');


    elsif rising_edge(clk12_m) then
      midi_state   <= next_midi_state;
      status_reg   <= next_status_reg;
      data_flag    <= new_data_flag;
      data1_reg    <= next_data1_reg;
      data2_reg    <= next_data2_reg;
    end if;
  end process ff;

  -- Internal signal assignments
-----------------------------------------------------------------------------


-------------------------------------------------------------------------------

end architecture str;


