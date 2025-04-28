-- if_id_tb.vhd: Corrected Testbench for IF/ID Pipeline Register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity if_id_tb is
end entity if_id_tb;

architecture Behavioral of if_id_tb is
    signal clk            : STD_LOGIC := '0';
    signal rst            : STD_LOGIC := '0';
    signal stall          : STD_LOGIC := '0';
    signal flush          : STD_LOGIC := '0';
    signal if_pc_plus4    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal if_instruction : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal id_pc_plus4    : STD_LOGIC_VECTOR(31 downto 0);
    signal id_instruction : STD_LOGIC_VECTOR(31 downto 0);

    component if_id is
        Port (
            clk            : in  STD_LOGIC;
            rst            : in  STD_LOGIC;
            stall          : in  STD_LOGIC;
            flush          : in  STD_LOGIC;
            if_pc_plus4    : in  STD_LOGIC_VECTOR(31 downto 0);
            if_instruction : in  STD_LOGIC_VECTOR(31 downto 0);
            id_pc_plus4    : out STD_LOGIC_VECTOR(31 downto 0);
            id_instruction : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
begin
    -- Instantiate the IF/ID register
    uut: if_id
        port map (
            clk            => clk,
            rst            => rst,
            stall          => stall,
            flush          => flush,
            if_pc_plus4    => if_pc_plus4,
            if_instruction => if_instruction,
            id_pc_plus4    => id_pc_plus4,
            id_instruction => id_instruction
        );

    -- Clock generation: 10 ns period
    clk_process: process
    begin
        while True loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset for two clock cycles
        rst <= '1';
        wait for 10 ns;  -- covers one rising edge at ~5ns and falling at ~10ns
        rst <= '0';
        wait for 10 ns;  -- allow pipeline registers to see rst inactive after reset

        -- Check reset behavior
        assert id_pc_plus4 = X"00000000" and id_instruction = X"00000000"
            report "Reset should clear registers" severity error;

        -- Normal update: apply new inputs
        if_pc_plus4 <= X"00000008";
        if_instruction <= X"FEEDFACE";
        wait for 10 ns;
        assert id_pc_plus4 = X"00000008" and id_instruction = X"FEEDFACE"
            report "Normal update failed" severity error;

        -- Stall: inputs change but outputs hold
        stall <= '1';
        if_pc_plus4 <= X"0000000C";
        if_instruction <= X"CAFEBABE";
        wait for 10 ns;
        assert id_pc_plus4 = X"00000008" and id_instruction = X"FEEDFACE"
            report "Stall did not hold registers" severity error;
        stall <= '0';

        -- Flush: clears on next edge
        flush <= '1';
        wait for 10 ns;
        assert id_pc_plus4 = X"00000000" and id_instruction = X"00000000"
            report "Flush did not clear registers" severity error;
        flush <= '0';

        report "if_id_tb completed" severity note;
        wait;
    end process;
end architecture Behavioral;
