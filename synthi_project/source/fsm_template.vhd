-------------------------------------------
-- Block code:  fsm_template.vhd
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
entity fsm_template is

  port(clk      : in  std_logic;
       reset_n  : in  std_logic
       );
end fsm_template;

-- Architecture Declaration
-------------------------------------------
architecture rtl of fsm_template is
-- Signals & Constants Declaration�
-------------------------------------------
  type fsm_type is (st_idle, st_state1, st_state2, st_state3);  -- st_check_rx is also used for storage
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
       

      when st_state1 =>
          

      when st_state2 =>
       

      when st_state3 =>
        

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
    default_signal1 <= '0';
    default_signal2 <= '0';

    case fsm_state is
      when st_state1 =>
        
      when st_state2 =>
       
      when others => null;
                     
    end case;

  end process fsm_out_logic;


-- End Architecture 
------------------------------------------- 
end rtl;

