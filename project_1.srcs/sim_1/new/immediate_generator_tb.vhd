-- immediate_generator_tb.vhd: Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity immediate_generator_tb is
end immediate_generator_tb;

architecture Behavioral of immediate_generator_tb is
    signal instr   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal imm_out : STD_LOGIC_VECTOR(31 downto 0);

    component immediate_generator is
        port (
            instr   : in  STD_LOGIC_VECTOR(31 downto 0);
            imm_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
begin
    uut: immediate_generator
        port map (
            instr   => instr,
            imm_out => imm_out
        );

    stim_proc: process
    begin
        -- addi $t0, $zero, 5 => opcode = 001000, imm = 0000_0000_0000_0101
        instr <= X"20080005"; wait for 10 ns;
        assert imm_out = X"00000005"
            report "Failed addi immediate extraction" severity error;

        -- lw $t2, 4($t1) => opcode = 100011, imm = 0000_0000_0000_0100
        instr <= X"8D2A0004"; wait for 10 ns;
        assert imm_out = X"00000004"
            report "Failed lw immediate extraction" severity error;

        -- sw $t3, -8($t1) => opcode = 101011, imm = 1111_1111_1111_1000
        instr <= X"AD2BFFF8"; wait for 10 ns;
        assert imm_out = X"FFFFFFF8"
            report "Failed sw immediate extraction" severity error;

        -- beq $t0, $t1, -4 => opcode = 000100, imm = FFFC
        instr <= X"1109FFFC"; wait for 10 ns;
        assert imm_out = X"FFFFFFF0"
            report "Failed beq offset extraction" severity error;

        report "immediate_generator_tb completed" severity note;
        wait;
    end process;
end Behavioral;
