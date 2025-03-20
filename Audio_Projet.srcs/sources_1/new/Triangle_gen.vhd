library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity triangle_wave is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           freq_div : in INTEGER;
           wave_out : out INTEGER);
end triangle_wave;

architecture Behavioral of triangle_wave is
    signal counter : INTEGER := 0;
    signal direction : STD_LOGIC := '1';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            direction <= '1';
        elsif rising_edge(clk) then
            if direction = '1' then
                counter <= counter + 1;
                if counter >= freq_div then
                    direction <= '0';
                end if;
            else
                counter <= counter - 1;
                if counter <= 0 then
                    direction <= '1';
                end if;
            end if;
        end if;
    end process;
    wave_out <= counter;
end Behavioral;
