library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity noise_generator is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           noise_out : out STD_LOGIC_VECTOR(15 downto 0));
end noise_generator;

architecture Behavioral of noise_generator is
    signal lfsr : STD_LOGIC_VECTOR(15 downto 0) := "1010101010101010";
begin
    process(clk, reset)
    begin
        if reset = '1' then
            lfsr <= "1010101010101010";
        elsif rising_edge(clk) then
            lfsr <= lfsr(14 downto 0) & (lfsr(15) XOR lfsr(13) XOR lfsr(12) XOR lfsr(10));
        end if;
    end process;
    noise_out <= lfsr;
end Behavioral;
