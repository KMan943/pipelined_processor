-- control_unit_tb.vhdl: Self-checking Testbench
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit_tb is
end entity control_unit_tb;

architecture Behavioral of control_unit_tb is
    -- Inputs
    signal opcode    : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    -- Outputs
    signal RegDst, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite : STD_LOGIC;
    signal BranchEq, BranchNE, Jump : STD_LOGIC;
    signal ALUOp : STD_LOGIC_VECTOR(1 downto 0);

    component control_unit is
        Port (
            opcode    : in  STD_LOGIC_VECTOR(5 downto 0);
            RegDst    : out STD_LOGIC;
            ALUSrc    : out STD_LOGIC;
            MemtoReg  : out STD_LOGIC;
            RegWrite  : out STD_LOGIC;
            MemRead   : out STD_LOGIC;
            MemWrite  : out STD_LOGIC;
            BranchEq  : out STD_LOGIC;
            BranchNE  : out STD_LOGIC;
            Jump      : out STD_LOGIC;
            ALUOp     : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;
begin
    uut: control_unit
        port map (
            opcode    => opcode,
            RegDst    => RegDst,
            ALUSrc    => ALUSrc,
            MemtoReg  => MemtoReg,
            RegWrite  => RegWrite,
            MemRead   => MemRead,
            MemWrite  => MemWrite,
            BranchEq  => BranchEq,
            BranchNE  => BranchNE,
            Jump      => Jump,
            ALUOp     => ALUOp
        );

    stim_proc: process
    begin
        -- Test R-type
        opcode <= "000000"; wait for 10 ns;
        assert RegDst = '1' and ALUSrc = '0' and RegWrite = '1' and ALUOp = "10"
            report "R-type control mismatch" severity error;

        -- Test lw
        opcode <= "100011"; wait for 10 ns;
        assert RegDst = '0' and ALUSrc = '1' and MemtoReg = '1'
               and RegWrite = '1' and MemRead = '1' and ALUOp = "00"
            report "lw control mismatch" severity error;

        -- Test sw
        opcode <= "101011"; wait for 10 ns;
        assert ALUSrc = '1' and MemWrite = '1' and RegWrite = '0' and ALUOp = "00"
            report "sw control mismatch" severity error;

        -- Test beq
        opcode <= "000100"; wait for 10 ns;
        assert BranchEq = '1' and ALUOp = "01" and RegWrite = '0'
            report "beq control mismatch" severity error;

        -- Test bne
        opcode <= "000101"; wait for 10 ns;
        assert BranchNE = '1' and ALUOp = "01" and RegWrite = '0'
            report "bne control mismatch" severity error;

        -- Test jump
        opcode <= "000010"; wait for 10 ns;
        assert Jump = '1' and RegWrite = '0'
            report "j control mismatch" severity error;

        -- Test addi
        opcode <= "001000"; wait for 10 ns;
        assert ALUSrc = '1' and RegWrite = '1' and ALUOp = "11"
            report "addi control mismatch" severity error;

        -- Test andi
        opcode <= "001100"; wait for 10 ns;
        assert ALUSrc = '1' and RegWrite = '1' and ALUOp = "11"
            report "andi control mismatch" severity error;

        report "control_unit_tb completed";
        wait;
    end process;
end architecture Behavioral;
