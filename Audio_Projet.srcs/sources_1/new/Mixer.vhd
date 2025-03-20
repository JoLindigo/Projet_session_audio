library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity audio_mixer is
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        wave_sq1    : in  INTEGER;
        wave_sq2    : in  INTEGER;
        wave_tri    : in  INTEGER;
        wave_noise  : in  INTEGER;
        audio_out   : out INTEGER
    );
end audio_mixer;

architecture Behavioral of audio_mixer is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            audio_out <= 0;
        elsif rising_edge(clk) then
            -- Mixage simple par addition des valeurs
            audio_out <= (wave_sq1 + wave_sq2 + wave_tri + wave_noise) / 4;
        end if;
    end process;
end Behavioral;
