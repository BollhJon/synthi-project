-------------------------------------------------------------------------------
-- Title      : Testbench for design "uart_top"
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : uart_top_tb.vhd
-- Author     : gelk
-- Created    : 2018-02-08
-- Last update: 2019-11-08
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 -2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-02-08  1.0      gelk    Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use std.textio.all;
use work.simulation_pkg.all;
use work.standard_driver_pkg.all;
use work.user_driver_pkg.all;


-------------------------------------------------------------------------------

entity uart_top_tb is

end entity uart_top_tb;

-------------------------------------------------------------------------------

architecture struct of uart_top_tb is

  component uart_top is
    port (
      clock_50 : in  std_logic;
      ARDUINO_IO_11  : in  std_logic; --TX Data
      key_0    : in  std_logic;
      hex0     : out std_logic_vector(6 downto 0);
      hex1     : out std_logic_vector(6 downto 0);
      ledr_9   : out std_logic;
      ARDUINO_IO_10  : out std_logic; --RX Data
	  ARDUINO_IO_12 :  OUT  STD_LOGIC); --reset
  end component uart_top;

  -- component ports
  signal clock_50 : std_logic;
  signal ARDUINO_IO_11  : std_logic;
  signal ARDUINO_IO_12  : std_logic;
  signal key_0    : std_logic;
  signal hex0     : std_logic_vector(6 downto 0);
  signal hex1     : std_logic_vector(6 downto 0);
  signal ledr_9   : std_logic;

  constant clock_freq   : natural := 50_000_000;
  constant clock_period : time    := 1000 ms/clock_freq;

begin  -- architecture struct

  -- component instantiation
  DUT : uart_top
    port map (
      clock_50 => clock_50,
      ARDUINO_IO_11  => ARDUINO_IO_11,
	  ARDUINO_IO_12  => ARDUINO_IO_12,
      key_0    => key_0,
      hex0     => hex0,
      hex1     => hex1,
      ledr_9   => ledr_9);


  readcmd : process
    -- This process loops through a file and reads one line
    -- at a time, parsing the line to get the values and
    -- expected result.

    variable cmd          : string(1 to 7);  --stores test command
    variable line_in      : line;       --stores the to be processed line
    variable tv           : test_vect;  --stores arguments 1 to 4
    variable lincnt       : integer := 0;  --counts line number in testcase file
    variable fail_counter : integer := 0;  --counts failed tests



  begin

    -------------------------------------
    -- Open the Input and output files
    -------------------------------------
    FILE_OPEN(cmdfile, "../testcase.dat", read_mode);
    FILE_OPEN(outfile, "../results.dat", write_mode);

    -------------------------------------
    -- Start the loop
    -------------------------------------


    loop

      --------------------------------------------------------------------------
      -- Check for end of test file and print out results at the end
      --------------------------------------------------------------------------


      if endfile(cmdfile) then          -- Check EOF
        end_simulation(fail_counter);
        exit;
      end if;

      --------------------------------------------------------------------------
      -- Read all the argumnents and uar_chk if arguments are o.k.
      --------------------------------------------------------------------------

      readline(cmdfile, line_in);       -- Read a line from the file
      lincnt := lincnt + 1;


      next when line_in'length = 0;     -- Skip empty lines
      next when line_in.all(1) = '#';   -- Skip lines starting with #

      read_arguments(tv, line_in, cmd);  --
      tv.clock_period := clock_period;

      -------------------------------------
      -- Reset the circuit
      -------------------------------------

      if cmd = string'("rst_sim") then
        rst_sim(tv, key_0);

      elsif cmd = string'("run_sim") then
        run_sim(tv);

        -------------------------------------
        -- Generate Stimulus Signals
        -------------------------------------


      elsif cmd = string'("uar_stm") then
        uar_stm(tv, ARDUINO_IO_11);

      elsif cmd = string'("uar_ch0") then
        uar_chk(tv, hex0);

      elsif cmd = string'("uar_ch1") then
        uar_chk(tv, hex1);

      else
        assert false
          report "Unknown Command"
          severity failure;
      end if;

      if tv.fail_flag = true then
        fail_counter := fail_counter + 1;
      else fail_counter := fail_counter;
      end if;

    end loop;

    wait;

  end process;

  clkgen : process
  begin
    clock_50 <= '0';
    wait for 1*clock_period /2;
    clock_50 <= '1';
    wait for 1*clock_period /2;

  end process clkgen;



end architecture struct;

-------------------------------------------------------------------------------
