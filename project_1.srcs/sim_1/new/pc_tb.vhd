-- pc_tb.vhdl: Testbench for Program Counter
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pc_tb is
end entity pc_tb;

architecture Behavioral of pc_tb is
    -- Signals to drive the PC
    signal clk    : STD_LOGIC := '0';
    signal rst    : STD_LOGIC := '0';
    signal pc_in  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal pc_out : STD_LOGIC_VECTOR(31 downto 0);

    -- Component declaration
    component pc
        Port (
            clk    : in  STD_LOGIC;
            rst    : in  STD_LOGIC;
            pc_in  : in  STD_LOGIC_VECTOR(31 downto 0);
            pc_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
begin
    -- Instantiate the Unit Under Test (UUT)
    uut: pc
        port map (
            clk    => clk,
            rst    => rst,
            pc_in  => pc_in,
            pc_out => pc_out
        );

    -- Clock generation: 10 ns period
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Apply reset
        rst <= '1';
        wait for 15 ns;
        rst <= '0';

        -- Provide a few PC inputs
        pc_in <= X"00000004";
        wait for 10 ns;
        assert pc_out = X"00000000" report "PC should still be 0 on first cycle after reset" severity note;

        wait for 10 ns;
        assert pc_out = X"00000004" report "PC should update to 1st input value" severity note;

        pc_in <= X"00000008";
        wait for 10 ns;
        assert pc_out = X"00000008" report "PC should update to 2nd input value" severity note;

        -- End simulation
        wait for 20 ns;
        report "pc_tb completed";
        wait;
    end process;
end architecture Behavioral;
