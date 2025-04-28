-- instruction_memory_tb.vhdl: Self-checking Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instruction_memory_tb is
end instruction_memory_tb;

architecture Behavioral of instruction_memory_tb is
    signal addr            : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal instruction_out : STD_LOGIC_VECTOR(31 downto 0);

    component instruction_memory is
        port (
            addr        : in  STD_LOGIC_VECTOR(31 downto 0);
            instruction : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
begin
    -- Instantiate ROM under test
    uut: instruction_memory
        port map (
            addr        => addr,
            instruction => instruction_out
        );

    stim_proc: process
    begin
        -- Test index 0
        addr <= X"00000000"; wait for 10 ns;
        assert instruction_out = X"20080005"
            report "IMEM[0] mismatch: expected 20080005" severity error;

        -- Test index 1
        addr <= X"00000004"; wait for 10 ns;
        assert instruction_out = X"20090003"
            report "IMEM[1] mismatch: expected 20090003" severity error;

        -- Test index 2
        addr <= X"00000008"; wait for 10 ns;
        assert instruction_out = X"01095020"
            report "IMEM[2] mismatch: expected 01095020" severity error;

        -- Test index 7
        addr <= X"0000001C"; wait for 10 ns;
        assert instruction_out = X"08000002"
            report "IMEM[7] mismatch: expected 08000002" severity error;

        -- Test out-of-range
        addr <= X"00000040"; wait for 10 ns;
        assert instruction_out = X"00000000"
            report "IMEM out-of-range mismatch: expected 00000000" severity error;

        report "instruction_memory_tb completed" severity note;
        wait;
    end process;
end Behavioral;