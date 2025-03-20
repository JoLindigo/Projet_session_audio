library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity i2s_audio is
    Port (
        clk         : in  STD_LOGIC;  -- Horloge principale
        reset       : in  STD_LOGIC;
        audio_data  : in  STD_LOGIC_VECTOR(15 downto 0);  -- Données audio 16 bits
        bclk        : out STD_LOGIC;  -- Bit Clock
        lrclk       : out STD_LOGIC;  -- Left/Right Clock
        data_out    : out STD_LOGIC   -- Ligne de données I2S
    );
end i2s_audio;

architecture Behavioral of i2s_audio is
    signal bit_counter : INTEGER := 0;
    signal shift_reg   : STD_LOGIC_VECTOR(15 downto 0);
    signal bclk_int    : STD_LOGIC := '0';  -- Internal BCLK signal
    signal lrclk_int   : STD_LOGIC := '0';  -- Internal LRCLK signal
begin
    process(clk, reset)
    begin
        if reset = '1' then
            bit_counter <= 0;
            bclk_int <= '0';
            lrclk_int <= '0';
            data_out <= '0';
        elsif rising_edge(clk) then
            -- Génération du Bit Clock (BCLK)
            bclk_int <= NOT bclk_int;

            -- Génération de LRCLK (Left/Right)
            if bit_counter = 0 then
                lrclk_int <= NOT lrclk_int;
            end if;

            -- Transmission des données audio
            if bit_counter < 16 then
                data_out <= shift_reg(15);
                shift_reg <= shift_reg(14 downto 0) & '0';
            end if;

            bit_counter <= bit_counter + 1;
            if bit_counter = 32 then
                bit_counter <= 0;
                shift_reg <= audio_data; -- Charger la nouvelle valeur audio
            end if;
        end if;
    end process;

    -- Assign internal signals to output ports
    bclk  <= bclk_int;
    lrclk <= lrclk_int;

end Behavioral;
