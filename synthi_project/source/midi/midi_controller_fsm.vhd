-------------------------------------------------------------------------------
-- Title      : midi_controller_fsm
-- Project    : 
-------------------------------------------------------------------------------
-- File       : midi_controller_fsm.vhd
-- Author     : Boehi Dominik
-- Created    : 2021-04-19
-- Last update: 2021-04-26
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author            Description
-- 2021-04-19  1.0      Böhi dominik      Created
-- 2021-04-27  1.1      Bollhalder Jonas  Edits for poly DDS
-- 2021-05-15  1.2      Müller Pavel      Bugfix for octave change on Piano
-- 2021-06-08  1.3      Müller Pavel      Integrated DDS used
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.tone_gen_pkg.all;
-------------------------------------------------------------------------------

entity midi_controller_fsm is
  port(clk_6m           : in  std_logic;
       reset_n          : in  std_logic;
       rx_data          : in  std_logic_vector(7 downto 0);
       rx_data_rdy      : in  std_logic;
       dds_used_i       : in  std_logic_vector(9 downto 0);
       note_on		      : out std_logic_vector(9 downto 0);
       note_o           : out t_tone_array;
       velocity         : out t_tone_array
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

  signal reg_note_on, next_reg_note_on : std_logic_vector(9 downto 0);
  signal reg_note, next_reg_note         : t_tone_array;
  signal reg_velocity, next_reg_velocity : t_tone_array;

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


-------------------------------------------------------------------------------
      --wait data two
-------------------------------------------------------------------------------
      when wait_data2 =>
        if rx_data_rdy = '1' then
          next_data2_reg  <= rx_data(6 downto 0);
          new_data_flag   <= '1';
          next_midi_state <= wait_status;
        else
          next_midi_state <= wait_data2;
        end if;
-------------------------------------------------------------------------------
        --others
-------------------------------------------------------------------------------

      when others => next_midi_state <= midi_state;
    end case;
  end process midi_fsm;

-------------------------------------------------------------------------------

  midi_reg : process(all)
    variable note_available : std_logic := '0';
    variable note_written : std_logic := '0';
  begin


    next_reg_note_on  <= reg_note_on;
    next_reg_note     <= reg_note;
    next_reg_velocity <= reg_velocity;
    note_available := '0';
    note_written := '0';  
    
    if data_flag = '1' then
      note_available := '0';
      note_written := '0';  
      -----------------------------------------------------
      -- CHECK IF NOTE IS ALREADY ENTERED IN MIDI ARRAY
      ------------------------------------------------------
      for i in 0 to 9 loop
        if reg_note(i) = data1_reg and reg_note_on(i) = '1' then -- Found a matching note
            if status_reg(6 downto 4) = "000" then -- note off
              next_reg_note_on(i) <= '0'; -- turn off note
              if dds_used_i(i) = '0' then
                note_available := '1'; -- as long as the DDS is used to finish its wave the note will not be available
              end if;
            elsif status_reg(6 downto 4) = "001" and data2_reg = "0000000" then
              next_reg_note_on(i) <= '0'; -- turn off note if velocity is 0
              if dds_used_i(i) = '0' then
                note_available := '1'; -- as long as the DDS is used to finish its wave the note will not be available
              end if;
            end if;
        end if;
      end loop;

      -----------------------------------------
      -- ENTER A NEW NOTE IF STILL EMPTY REGISTERS
      ------------------------------------------
      -- If the new note is not in the midi storage array yet, find a free space
      -- if the valid flag is cleared, the note can be overwritten, at the same time a flag is set to mark that
      -- the new note has found a place.
      if note_available = '0' then
        for i in 0 to 9 loop
          if note_written = '0' then -- if the note already written, ignore the remaining loop runs
            -- If a free space is found (reg_note_on(i) = '0') enter the note number and velocity
            -- or if until the end of the loop no space is found (i=9) overwrite last entry
            if (reg_note_on(i) = '0' or i = 9) and status_reg(6 downto 4) = "001" then --bit 7 is note_on bit 
              next_reg_note(i) <= data1_reg;
              next_reg_velocity(i) <= data2_reg;
              next_reg_note_on(i) <= '1'; -- And set the note_1_register to valid.
              note_written := '1'; -- flag that note is written to supress remaining loop runs
            end if;
          end if;
        end loop;
      end if;
    end if;
	  
  end process midi_reg;

  --FF midi_state
  ff : process(all)
  begin
    if reset_n = '0' then
      midi_state   <= wait_status;
      status_reg   <= (others => '0');
      data_flag    <= '0';
      data1_reg    <= (others => '0');
      data2_reg    <= (others => '0');
      reg_note_on  <= (others => '0');
      reg_note     <= (others => (others => '0'));
      reg_velocity <= (others => (others => '0'));

    elsif rising_edge(clk_6m) then
      midi_state   <= next_midi_state;
      status_reg   <= next_status_reg;
      data_flag    <= new_data_flag;
      data1_reg    <= next_data1_reg;
      data2_reg    <= next_data2_reg;
      reg_note_on  <= next_reg_note_on;
      reg_note     <= next_reg_note;
      reg_velocity <= next_reg_velocity;
    end if;
  end process ff;

  -- Internal signal assignments
-----------------------------------------------------------------------------
  note_on <= reg_note_on;
  note_o <= reg_note;
  velocity <= reg_velocity;

-------------------------------------------------------------------------------

end architecture str;


