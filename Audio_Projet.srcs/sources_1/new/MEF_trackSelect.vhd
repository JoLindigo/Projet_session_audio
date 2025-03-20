library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_audio_select is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        state_input : in  STD_LOGIC_VECTOR(2 downto 0); -- 3 bits pour 8 pistes
        effect_bit  : in  STD_LOGIC; -- Effet sonore
        track_index : out INTEGER range 0 to 7; -- Piste sélectionnée
        effect_on   : out STD_LOGIC -- Active l'effet
    );
end fsm_audio_select;

architecture Behavioral of fsm_audio_select is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            track_index <= 0;
            effect_on <= '0';
        elsif rising_edge(clk) then
            track_index <= CONV_INTEGER(state_input);
            effect_on <= effect_bit;
        end if;
    end process;
end Behavioral;