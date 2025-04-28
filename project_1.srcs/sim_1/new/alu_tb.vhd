-- alu_tb.vhdl: Testbench for ALU
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_tb is
end entity alu_tb;

architecture Behavioral of alu_tb is
    signal A, B    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ALUCtl  : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    signal Result  : STD_LOGIC_VECTOR(31 downto 0);
    signal Zero    : STD_LOGIC;

    component alu is
        Port (
            A       : in  STD_LOGIC_VECTOR(31 downto 0);
            B       : in  STD_LOGIC_VECTOR(31 downto 0);
            ALUCtl  : in  STD_LOGIC_VECTOR(3 downto 0);
            Result  : out STD_LOGIC_VECTOR(31 downto 0);
            Zero    : out STD_LOGIC
        );
    end component;
begin
    uut: alu
        port map (
            A      => A,
            B      => B,
            ALUCtl => ALUCtl,
            Result => Result,
            Zero   => Zero
        );

    stim_proc: process
    begin
        -- ADD: 5 + 3 = 8
        A <= X"00000005"; B <= X"00000003"; ALUCtl <= "0010"; wait for 10 ns;
        assert Result = X"00000008" report "ADD failed" severity error;
        assert Zero = '0' report "Zero wrong for ADD" severity error;

        -- SUB: 5 - 5 = 0
        A <= X"00000005"; B <= X"00000005"; ALUCtl <= "0110"; wait for 10 ns;
        assert Result = X"00000000" report "SUB failed" severity error;
        assert Zero = '1' report "Zero wrong for zero result" severity error;

        -- AND: F0F0 & 0FF0 = 00F0
        A <= X"F0F0F0F0"; B <= X"0FF00FF0"; ALUCtl <= "0000"; wait for 10 ns;
        assert Result = X"00F000F0" report "AND failed" severity error;

        -- OR: 0F0F | F00F = FF0F
        A <= X"0F0F0F0F"; B <= X"F00FF00F"; ALUCtl <= "0001"; wait for 10 ns;
        assert Result = X"FF0FFF0F" report "OR failed" severity error;

        -- XOR: AAAA ^ 5555 = FFFF
        A <= X"AAAA0000"; B <= X"55550000"; ALUCtl <= "0011"; wait for 10 ns;
        assert Result = X"FFFF0000" report "XOR failed" severity error;

        -- SLT: 3 < 5 = 1
        A <= X"00000003"; B <= X"00000005"; ALUCtl <= "0111"; wait for 10 ns;
        assert Result = X"00000001" report "SLT true failed" severity error;

        -- SLT: 5 < 3 = 0
        A <= X"00000005"; B <= X"00000003"; ALUCtl <= "0111"; wait for 10 ns;
        assert Result = X"00000000" report "SLT false failed" severity error;

        report "alu_tb completed";
        wait;
    end process;
end architecture Behavioral;