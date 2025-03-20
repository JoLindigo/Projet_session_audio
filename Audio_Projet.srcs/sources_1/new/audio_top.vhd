library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity zybo_audio_top is
    Port (
        clk         : in  STD_LOGIC;  -- Horloge 100MHz
        reset       : in  STD_LOGIC;
        
        -- Entrées de sélection de piste et d'effet
        track_select : in  STD_LOGIC_VECTOR(2 downto 0);
        effect_enable : in  STD_LOGIC;

        -- Sortie I2S
        i2s_bclk    : out STD_LOGIC;
        i2s_lrclk   : out STD_LOGIC;
        i2s_data    : out STD_LOGIC;
        i2s_mclk    : out STD_LOGIC;  -- Si nécessaire

        -- LEDs pour Debug (optionnel)
        led_debug   : out STD_LOGIC_VECTOR(3 downto 0)
    );
end zybo_audio_top;

architecture Behavioral of zybo_audio_top is

    -- Signaux internes
    signal track_id : INTEGER range 0 to 7;
    signal effect_active : STD_LOGIC;
    
    -- Signaux audio
    signal wave_sq1, wave_sq2, wave_tri, wave_noise : INTEGER := 0;
    signal mixed_audio : INTEGER := 0;
    signal audio_data : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal freq_sq1 : INTEGER;
    signal freq_sq2 : INTEGER;
    signal freq_tri : INTEGER;
    signal mclk_signal : STD_LOGIC;

    -- Génération des ondes
    component square_wave is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               freq_div : in INTEGER;
               wave_out : out INTEGER);
    end component;

    component triangle_wave is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               freq_div : in INTEGER;
               wave_out : out INTEGER);
    end component;

    component noise_generator is
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               noise_out : out INTEGER);
    end component;
    
    component mclk_generator is
        Port (
            clk_in    : in  STD_LOGIC;
            reset     : in  STD_LOGIC;
            mclk_out  : out STD_LOGIC
        );
    end component;


    component fsm_audio_select is
        Port (
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            state_input : in  STD_LOGIC_VECTOR(2 downto 0); -- 3 bits pour 8 pistes
            effect_bit  : in  STD_LOGIC; -- Effet sonore
            track_index : out INTEGER range 0 to 7; -- Piste sélectionnée
            effect_on   : out STD_LOGIC -- Active l'effet
        );
    end component;

    component audio_mixer is
        Port (
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            wave_sq1    : in  INTEGER;
            wave_sq2    : in  INTEGER;
            wave_tri    : in  INTEGER;
            wave_noise  : in  INTEGER;
            audio_out   : out INTEGER
        );
    end component;

    component i2s_audio is
        Port (
            clk         : in  STD_LOGIC;
            reset       : in  STD_LOGIC;
            audio_data  : in  STD_LOGIC_VECTOR(15 downto 0);
            bclk        : out STD_LOGIC;
            lrclk       : out STD_LOGIC;
            data_out    : out STD_LOGIC
        );
    end component;

begin
    
    -- Instantiate MCLK generator
    mclk_inst : mclk_generator
        Port Map (
            clk_in  => clk,
            reset   => reset,
            mclk_out => mclk_signal
        );
    
    -- FSM de sélection de la piste et activation des effets
    fsm_inst : fsm_audio_select
        Port Map (
            clk         => clk,
            reset       => reset,
            state_input => track_select,
            effect_bit  => effect_enable,
            track_index => track_id,
            effect_on   => effect_active
        );

    -- Génération des ondes
    process(clk)
    begin
        if rising_edge(clk) then
            freq_sq1 <= track_id * 100;
            freq_sq2 <= track_id * 120;
            freq_tri <= track_id * 150;
         end if;
    end process;
    
    square1_inst : square_wave
        Port Map (clk => clk, reset => reset, freq_div => freq_sq1, wave_out => wave_sq1);

    square2_inst : square_wave
        Port Map (clk => clk, reset => reset, freq_div => freq_sq2, wave_out => wave_sq2);

    triangle_inst : triangle_wave
        Port Map (clk => clk, reset => reset, freq_div => freq_tri, wave_out => wave_tri);

    noise_inst : noise_generator
        Port Map (clk => clk, reset => reset, noise_out => wave_noise);

    -- Mixage des ondes
    mixer_inst : audio_mixer
        Port Map (
            clk => clk,
            reset => reset,
            wave_sq1 => wave_sq1,
            wave_sq2 => wave_sq2,
            wave_tri => wave_tri,
            wave_noise => wave_noise,
            audio_out => mixed_audio
        );

    -- Conversion en 16 bits
    process(clk)
    begin
        if rising_edge(clk) then
            -- Ensure mixed_audio stays within signed 16-bit limits (-32768 to 32767)
            if mixed_audio < -32768 then
                audio_data <= CONV_STD_LOGIC_VECTOR(-32768, 16);
            elsif mixed_audio > 32767 then
                audio_data <= CONV_STD_LOGIC_VECTOR(32767, 16);
            else
                audio_data <= CONV_STD_LOGIC_VECTOR(mixed_audio, 16);  
            end if;
        end if;
    end process;

    -- Encodage I2S
    i2s_inst : i2s_audio
        Port Map (
            clk => clk,
            reset => reset,
            audio_data => audio_data,
            bclk => i2s_bclk,
            lrclk => i2s_lrclk,
            data_out => i2s_data
        );
    -- Assign MCLK to output
    i2s_mclk <= mclk_signal;
    -- Debug LEDS (affiche l'index de la piste sélectionnée)
    led_debug <= CONV_STD_LOGIC_VECTOR(track_id, 4);

end Behavioral;
