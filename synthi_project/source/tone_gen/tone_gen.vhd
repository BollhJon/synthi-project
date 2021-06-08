-------------------------------------------------------------------------------
-- Title      : tone generator
-- Project    : Synthi-Project
-------------------------------------------------------------------------------
-- File       : tone_gen.vhd
-- Author     : Bollhalder Jonas
-- Created    : 2021-03-31
-- Last update: 2021-05-06
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: generates the tone for Synthi-Project
-------------------------------------------------------------------------------
-- Copyright (c) 2021 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date         Version Author            Description
-- 2021-03-31   1.0     Bollhalder Jonas  Created
-- 2021-04-26   1.1     Müller Pavel      MS4-Integration
-- 2021-04-26   1.2     Müller Pavel      Upgraded to mutli DDS
-- 2021-05-03   1.3     Müller Pavel      implemented fm synthesis
-- 2021-05-04   1.4     Bollhalder Jonas  implemented simple attenu logic
-- 2021-05-05   1.5     Müller Pavel      added custom LUT selector
-- 2021-05-06   1.6     Müller Pavel      added envelope logic
-- 2021-05-17   1.7     Müller Pavel      added selector for envelope, modulator and carrier
-- 2021-05-19   1.8     Müller Pavel      upgraded attenuator to 5 Bits
-- 2021-05-24   1.9     Müller Pavel      reduced selector for modulator to 3 Bit
-- 2021-05-24   1.10    Müller Pavel      upgraded fm ratio to 5 Bits
-- 2021-05-25   1.11    Müller Pavel      updated attenuator logic
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.tone_gen_pkg.all;

-- Entity Declaration 
-------------------------------------------
entity tone_gen is
  port(clk_6m            : in  std_logic;
       reset_n           : in  std_logic;
       tone_on_i         : in std_logic_vector(9 downto 0);
       note_i            : in t_tone_array;
       step_i            : in std_logic;
       velocity_i        : in t_tone_array;
       fm_ratio          : in  std_logic_vector(4 downto 0);
       fm_depth          : in  std_logic_vector(3 downto 0);
       lut_sel_car       : in  std_logic_vector(3 downto 0);
       lut_sel_mod       : in  std_logic_vector(2 downto 0);
       lut_sel_env       : in  std_logic_vector(3 downto 0);
       dds_l_o           : out std_logic_vector(15 downto 0);
       dds_r_o           : out std_logic_vector(15 downto 0)
       );
end tone_gen;

-- Architecture Declaration
-------------------------------------------
architecture rtl of tone_gen is
-- Signals & Constants Declaration
-------------------------------------------
  type t_dds_o_array is array (0 to 9) of std_logic_vector(N_AUDIO-1 downto 0);
  type t_attenu_array is array (0 to 9) of std_logic_vector(4 downto 0);
  signal dds_o_array : t_dds_o_array;
  signal sum_reg : signed(N_AUDIO-1 downto 0);
  signal next_sum_reg : signed(N_AUDIO-1 downto 0);
  signal attenu_array : t_attenu_array;
  signal lut_sel_env_sig : std_logic_vector(3 downto 0) := "0000";
  signal attenu_array_sig : t_attenu_array;
  signal attenu_sig : std_logic_vector(4 downto 0);


-- Begin Architecture
-------------------------------------------

  component fm_dds is
    port (
      clk_6m        : in  std_logic;
      reset_n       : in  std_logic;
      phi_incr_fsig : in  std_logic_vector(N_CUM-1 downto 0);
      tone_on_i     : in  std_logic;
      fm_ratio      : in  std_logic_vector(4 downto 0);
      fm_depth      : in  std_logic_vector(3 downto 0);
      step_i        : in  std_logic;
      attenu_i      : in  std_logic_vector(4 downto 0);
		  lut_sel_car   : in  std_logic_vector(3 downto 0);
		  lut_sel_mod   : in  std_logic_vector(2 downto 0);
      fm_dds_o      : out std_logic_vector(N_AUDIO -1 downto 0));
  end component fm_dds;

  component envelope_logic is
    port (
      clk_6m      : in  std_logic;
      reset_n     : in  std_logic;
      tone_on_i   : in  std_logic;
      --velocity_i  : in  std_logic_vector(6 downto 0);
      lut_sel 		: in  std_logic_vector(3 downto 0);
      attenu_o    : out std_logic_vector(4 downto 0));
  end component envelope_logic;

  component attenu is
    port (
      clk_6m    : in  std_logic;
      reset_n   : in  std_logic;
      tone_on_i : in  std_logic_vector(9 downto 0);
      attenu_o  : out std_logic_vector(4 downto 0));
  end component attenu;

begin



  -- instance "fm_dds_1"
  fm_dds_inst_gen: for i in 0 to 9 generate
    inst_fm_dds: fm_dds
    port map (
      clk_6m        => clk_6m,
      reset_n       => reset_n,
      phi_incr_fsig => LUT_midi2dds(to_integer(unsigned(note_i(i)))),
      tone_on_i     => tone_on_i(i),
      fm_ratio      => fm_ratio,
      fm_depth      => fm_depth,
      step_i        => step_i,
      attenu_i      => attenu_array(i),
      lut_sel_car	  => lut_sel_car,
      lut_sel_mod	  => lut_sel_mod,
      fm_dds_o      => dds_o_array(i)
      );
  end generate fm_dds_inst_gen;

  -- instance "envelope_logic_1"
  envelope_logic_inst_gen: for i in 0 to 9 generate
    inst_envelope_logic: envelope_logic
      port map (
        clk_6m     => clk_6m,
        reset_n    => reset_n,
        tone_on_i  => tone_on_i(i),
        --velocity_i => velocity_i(i), wurde nicht implementiert
        lut_sel    => lut_sel_env_sig,
        attenu_o   => attenu_array_sig(i)
        );
  end generate envelope_logic_inst_gen;

  attenu_1: attenu
    port map(
      clk_6m    => clk_6m,
      reset_n   => reset_n,
      tone_on_i => tone_on_i,
      attenu_o  => attenu_sig
      );

  
  comb_sum_output : process(all)
    variable var_sum : signed(N_AUDIO-1 downto 0);
  begin
    var_sum := (others => '0');
    if step_i = '1' then
      dds_sum_loop : for i in 0 to 9 loop
      var_sum := var_sum + signed(dds_o_array(i));
      end loop dds_sum_loop;
      next_sum_reg <= var_sum;
    else
      next_sum_reg <= sum_reg;
    end if;
  end process comb_sum_output;
  
  -- flip flop
  reg_sum_output : process(all)
  begin
    if reset_n = '0' then
      sum_reg <= (others => '0');
    elsif rising_edge(clk_6m) then
      sum_reg <= next_sum_reg;
    end if;
  end process reg_sum_output;

  -- write singnal sum_reg to output
  dds_l_o <= std_logic_vector(sum_reg);
  dds_r_o <= std_logic_vector(sum_reg);

  -- logic for automatic, manual or no envelope
  lut_sel_env_logic : process(all)
  begin	
    case to_integer(unsigned(lut_sel_env)) is
      when 0 => lut_sel_env_sig <= lut_sel_car;       -- automatic envelope
      when 1 => lut_sel_env_sig <= "0000";            -- no envelope
      when others => lut_sel_env_sig <= lut_sel_env;  -- manual envelope
    end case ;
  end process lut_sel_env_logic;
  
  -- logic for attenuator
  attenu_logic: process (all) is
    variable attenu_sig_var : unsigned(4 downto 0);
  begin
    attenu_sig_var := unsigned(attenu_sig);
    -- removes the attenuator value from attenu.vhd from the attenuator signal for all 10 DDS
    for i in 0 to 9 loop
      -- if the value from attenu.vhd is lager than the attenuator signal, then it will bi removed from the attenuator signal
      if unsigned(attenu_array_sig(i)) > attenu_sig_var then
        attenu_array(i) <= std_logic_vector(unsigned(attenu_array_sig(i)) - attenu_sig_var);
      -- if the value is smaller, the signal will be directly assigned to the attenuator array
        else
        attenu_array(i) <= attenu_array_sig(i);
      end if;
    end loop;
  end process attenu_logic;
-- End Architecture 
-------------------------------------------
end rtl;