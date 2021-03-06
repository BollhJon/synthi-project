-------------------------------------------------------------------------------
-- Title      : codec controller
-- Project    : Synthi Project
-------------------------------------------------------------------------------
-- File       : codec_controller.vhd
-- Author     : gelk
-- Created    : 2019-03-06
-- Last update: 2021-05-30
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Der Baustein wartet bis das reset_n signal inaktiv wird oder
--              eines der Konfigurations signale sich ändert.
--              Danach sendet dieser Codec Konfigurierungsdaten an
--              den Baustein i2c_Master
-------------------------------------------------------------------------------
-- Copyright (c) 2021
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  			    Description
-- 2019-03-06  1.0      gelk    			    Created
-- 2021-03-14  1.1		  Bollhalder Jonas	changes for Synthi Project
-- 2021-03-26  1.2      Bollhalder Jonas  rearranged
-- 2021-05-17  1.3      Müller Pavel      added volume control
-- 2021-05-30  1.4      Müller Pavel      bugfix
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.reg_table_pkg.all;


entity codec_controller is

  port (
    mode         : in  std_logic_vector(2 downto 0);  -- Inputs to choose Audio_MODE
    write_done_i : in  std_logic;       -- Input from i2c register write_done
    ack_error_i  : in  std_logic;       -- Inputs to check the transmission
    clk          : in  std_logic;
    reset_n      : in  std_logic;
    ctr_i        : in  std_logic;
    volume_i     : in  std_logic_vector(3 downto 0);
	emphasis_i   : in  std_logic_vector(1 downto 0);
    write_o      : out std_logic;       -- Output to i2c to start transmission 
    write_data_o : out std_logic_vector(15 downto 0)  -- Data_Output
    
    );
end codec_controller;

-- Architecture Declaration
-------------------------------------------
architecture rtl of codec_controller is
-- Signals & Constants Declaration
-------------------------------------------

type State_type is (idle, wait_write, state_end);
signal State, next_State : State_type;

signal count, next_count : unsigned(6 downto 0) := (others =>'0');
signal mode_change, volume_change : std_logic;
-- Begin Architecture
-------------------------------------------

  component vector_check is
    generic (
      width : positive);
    port (
      vector_i : in  std_logic_vector(width-1 downto 0);
      clk_i    : in  std_logic;
      signal_o : out std_logic);
  end component vector_check;

begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0'or mode_change = '1' or volume_change = '1'  then
      State <= idle;
      count <= (others =>'0');
    elsif rising_edge(clk) then
      State <= next_State;
      count <= next_count;
    end if;
  end process flip_flops;

----(codec control automat block)----

codec_control_automat : PROCESS(all)
begin
	
-- default statements	
		next_State <= State;
		next_count <= count;
		write_o <= '0'; 
		
		case State is -- State Machine
		
			when idle =>				-- State: idle
				next_State <= wait_write;
				
			when wait_write =>		-- State: wait_write
				write_o <=  '1';
				if(ack_error_i = '1') then
					next_State <= state_end;
				elsif(write_done_i = '1') then						
					if(count >= 9)then
						next_State <= state_end;
					else
						next_count <= count + 1;
						next_State <= idle;
					end if;	
				else
					next_State <= wait_write;
				end if;
				
			when state_end =>			-- State: state_end
				next_count <= (others =>'0');
				write_o <= '0';
				next_State <= state_end;
			
				
			when others => -- default statements	
				write_o <= '0'; 
				next_State <= idle;
				next_count <= (others =>'0');
				
		end case;
		
	end PROCESS codec_control_automat;

write_data_o (15 downto 9) <= std_logic_vector(count);

-- --(mode mux logic)----

	mode_mux_logic : PROCESS(all) --evtl besserer name?
	begin
		
		write_data_o(8 downto 0) <= "000000000"; -- tbd: default

		if(mode(0) = '0') then
       write_data_o(8 downto 0) <= C_W8731_ADC_DAC_0DB_48K(to_integer(count)); --tbd: array_pointer
		elsif(mode(1) = '0' and mode(2) = '0') then
      write_data_o(8 downto 0) <= C_W8731_ANALOG_BYPASS(to_integer(count)); --tbd: array_pointer
		elsif(mode(1) = '0' and mode(2) = '1') then
       write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_LEFT(to_integer(count)); --tbd: array_pointer
		elsif(mode(1) = '1' and mode(2) = '0') then
       write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_RIGHT(to_integer(count)); --tbd: array_pointer
		elsif(mode(1) = '1' and mode(2) = '1') then
       write_data_o(8 downto 0) <= C_W8731_ANALOG_MUTE_BOTH(to_integer(count)); --tbd: array_pointer
		end if;

    if (ctr_i = '1') then
       if ((mode(0)='0') and (count = 2 or count = 3)) then
         write_data_o(8 downto 0) <= C_W8731_VOLUME(to_integer(unsigned(volume_i)));
       elsif (count = 5) then
         write_data_o(8 downto 0) <= "000000" & emphasis_i & "1";
       end if;
    end if;                 
		
	end PROCESS mode_mux_logic;
	
	
-- End Architecture 
-------------------------------------------

  -- instance "vector_check_1"
  vector_check_1: vector_check
     generic map (
        width => 3)
     port map (
        vector_i => mode,
        clk_i    => clk,
        signal_o => mode_change
        );

  -- instance "vector_check_2"
  vector_check_2: vector_check
     generic map (
        width => 7)
     port map (
        vector_i => volume_i & ctr_i & emphasis_i,
        clk_i    => clk,
        signal_o => volume_change
        );


                
end rtl;
