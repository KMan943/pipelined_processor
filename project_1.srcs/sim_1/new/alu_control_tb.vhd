-- alu_control_tb.vhdl: Testbench for ALU Control
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity alu_control_tb is
end entity alu_control_tb;

architecture Behavioral of alu_control_tb is
    signal ALUOp  : STD_LOGIC_VECTOR(1 downto 0);
    signal funct  : STD_LOGIC_VECTOR(5 downto 0);
    signal ALUCtl : STD_LOGIC_VECTOR(3 downto 0);

    component alu_control is
        Port (
            ALUOp  : in  STD_LOGIC_VECTOR(1 downto 0);
            funct  : in  STD_LOGIC_VECTOR(5 downto 0);
            ALUCtl : out STD_LOGIC_VECTOR(3 downto 0)
        );
    end component;
begin
    uut: alu_control port map(
        ALUOp  => ALUOp,
        funct  => funct,
        ALUCtl => ALUCtl
    );

    stim_proc: process
    begin
        -- Test lw/sw (ALUOp=00)
        ALUOp <= "00"; funct <= "000000"; wait for 10 ns;
        assert ALUCtl = "0010" report "ALUOp=00 should yield ADD" severity error;

        -- Test beq (ALUOp=01)
        ALUOp <= "01"; funct <= "000000"; wait for 10 ns;
        assert ALUCtl = "0110" report "ALUOp=01 should yield SUB" severity error;

        -- Test default imm (ALUOp=11)
        ALUOp <= "11"; funct <= "000000"; wait for 10 ns;
        assert ALUCtl = "0010" report "ALUOp=11 should default to ADD" severity error;

        -- R-type ADD
        ALUOp <= "10"; funct <= "100000"; wait for 10 ns;
        assert ALUCtl = "0010" report "funct=100000 ADD mismatch" severity error;

        -- R-type SUB
        ALUOp <= "10"; funct <= "100010"; wait for 10 ns;
        assert ALUCtl = "0110" report "funct=100010 SUB mismatch" severity error;

        -- R-type AND
        ALUOp <= "10"; funct <= "100100"; wait for 10 ns;
        assert ALUCtl = "0000" report "funct=100100 AND mismatch" severity error;

        -- R-type OR
        ALUOp <= "10"; funct <= "100101"; wait for 10 ns;
        assert ALUCtl = "0001" report "funct=100101 OR mismatch" severity error;

        -- R-type XOR
        ALUOp <= "10"; funct <= "100110"; wait for 10 ns;
        assert ALUCtl = "0011" report "funct=100110 XOR mismatch" severity error;

        -- R-type SLT
        ALUOp <= "10"; funct <= "101010"; wait for 10 ns;
        assert ALUCtl = "0111" report "funct=101010 SLT mismatch" severity error;

        report "alu_control_tb completed";
        wait;
    end process;
end architecture Behavioral;
