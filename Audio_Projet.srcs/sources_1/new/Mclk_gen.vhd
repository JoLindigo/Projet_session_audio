library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mclk_generator is
    Port (
        clk_in    : in  STD_LOGIC;  -- 100MHz system clock
        reset     : in  STD_LOGIC;
        mclk_out  : out STD_LOGIC   -- Master Clock (MCLK)
    );
end mclk_generator;

architecture Behavioral of mclk_generator is
    constant DIVIDER : INTEGER := 100_000_000 / 12_288_000 / 2; -- Divider factor
    signal counter : INTEGER range 0 to DIVIDER := 0;
    signal mclk    : STD_LOGIC := '0';
begin
    process (clk_in, reset)
    begin
        if reset = '1' then
            counter <= 0;
            mclk <= '0';
        elsif rising_edge(clk_in) then
            if counter = DIVIDER then
                mclk <= NOT mclk;
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    mclk_out <= mclk;
end Behavioral;
