library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity square_wave is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           freq_div : in INTEGER;
           wave_out : out STD_LOGIC);
end square_wave;

architecture Behavioral of square_wave is
    signal counter : INTEGER := 0;
    signal state : STD_LOGIC := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            state <= '0';
        elsif rising_edge(clk) then
            if counter >= freq_div then
                state <= NOT state;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    wave_out <= state;
end Behavioral;
