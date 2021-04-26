-------------------------------------------
-- Block code:  uart_controller_fsm.vhd
-- History:     15.Jan.2017 - 1st version (dqtm)
--              19.Jan.2017 - further reduction for SEP HS17
--                 <date> - <changes>  (<author>)
-- Function: fsm and registers for UART-RX in DTP1 Mini-project alternative implementation.
--                      This block is the central piece of the UART-RX, coordinating byte reception and storage of 1 byte.
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity Declaration 
-------------------------------------------
entity uart_controller_fsm is
GENERIC (width : positive := 10);
  port(clk      : in  std_logic;
       reset_n  : in  std_logic;
		 falling_pulse : in std_logic;
		 baud_tick : in std_logic;
		 bit_count : in std_logic_vector(3 downto 0);
		 parallel_data : in std_logic_vector(width-1 downto 0);
		 shift_enable : out std_logic;
		 start_bit : out std_logic;
		 data_valid : out std_logic	 
       );
end uart_controller_fsm;

-- Architecture Declaration
-------------------------------------------
architecture rtl of uart_controller_fsm is
-- Signals & Constants Declaration
-------------------------------------------
  type fsm_type is (st_idle, st_start_bit, st_wait_rx_byte, st_check_rx);  -- st_check_rx is also used for storage
  signal fsm_state, next_fsm_state : fsm_type;

  -- shifted into shift register

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      fsm_state <= st_idle;

    elsif rising_edge(clk) then
      fsm_state <= next_fsm_state;

    end if;
  end process flip_flops;


  --------------------------------------------------
  -- PROCESS FOR INPUT-COMB-LOGIC fsm_n_counter
  --------------------------------------------------
  state_logic : process (all)
  begin
    -- default statements (hold current value)
    next_fsm_state <= fsm_state;

    case fsm_state is
	 
      when st_idle => 
			if(falling_pulse = '1') then
			next_fsm_state <= st_start_bit;
			else
			next_fsm_state <= st_idle;
			end if;
       
      when st_start_bit => 
			next_fsm_state <= st_wait_rx_byte;
          
      when st_wait_rx_byte => 
			if (bit_count = "0000" and baud_tick  = '1') then
			next_fsm_state <= st_check_rx;
			else
			next_fsm_state <= st_wait_rx_byte;
			end if;
		
      when st_check_rx => 
			next_fsm_state <= st_idle;
        
      when others =>
			next_fsm_state <= fsm_state;

    end case;

  end process state_logic;

  
  --------------------------------------------------
  -- PROCESS FOR OUTPUT-COMB-LOGIC 
  --------------------------------------------------
  fsm_out_logic : process (all)
  begin
    -- default statements
	 start_bit <= '0';
	 shift_enable <= '0';
	 data_valid <= '0';

    case fsm_state is
      when st_start_bit => start_bit <= '1';
        
      when st_wait_rx_byte =>
			if(baud_tick = '1') then
			shift_enable <= '1';
			else
			shift_enable <= '0';
			end if;
		
		when st_check_rx =>
		if(parallel_data(0) = '0' and parallel_data(9) = '1') then
		data_valid <= '1';
		else
		data_valid <= '0';
		end if;
       
      when others => null;
                     
    end case;

  end process fsm_out_logic;


-- End Architecture 
------------------------------------------- 
end rtl;

