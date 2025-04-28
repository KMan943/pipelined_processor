-- id_ex_tb.vhd: Full Testbench for ID/EX Pipeline Register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity id_ex_tb is
end entity id_ex_tb;

architecture Behavioral of id_ex_tb is
    -- Clock and control signals
    signal clk            : STD_LOGIC := '0';
    signal rst            : STD_LOGIC := '0';
    signal stall          : STD_LOGIC := '0';
    signal flush          : STD_LOGIC := '0';

    -- ID stage inputs
    signal id_pc_plus4_in    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal id_read_data1_in  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal id_read_data2_in  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal id_imm_in         : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal id_rs_in          : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal id_rt_in          : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal id_rd_in          : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal id_funct_in       : STD_LOGIC_VECTOR(5 downto 0) := (others => '0');
    signal id_RegDst_in      : STD_LOGIC := '0';
    signal id_ALUSrc_in      : STD_LOGIC := '0';
    signal id_MemtoReg_in    : STD_LOGIC := '0';
    signal id_RegWrite_in    : STD_LOGIC := '0';
    signal id_MemRead_in     : STD_LOGIC := '0';
    signal id_MemWrite_in    : STD_LOGIC := '0';
    signal id_BranchEq_in    : STD_LOGIC := '0';
    signal id_BranchNE_in    : STD_LOGIC := '0';
    signal id_Jump_in        : STD_LOGIC := '0';
    signal id_ALUOp_in       : STD_LOGIC_VECTOR(1 downto 0) := (others => '0');

    -- EX stage outputs
    signal ex_pc_plus4       : STD_LOGIC_VECTOR(31 downto 0);
    signal ex_read_data1     : STD_LOGIC_VECTOR(31 downto 0);
    signal ex_read_data2     : STD_LOGIC_VECTOR(31 downto 0);
    signal ex_imm            : STD_LOGIC_VECTOR(31 downto 0);
    signal ex_rs             : STD_LOGIC_VECTOR(4 downto 0);
    signal ex_rt             : STD_LOGIC_VECTOR(4 downto 0);
    signal ex_rd             : STD_LOGIC_VECTOR(4 downto 0);
    signal ex_funct          : STD_LOGIC_VECTOR(5 downto 0);
    signal ex_RegDst         : STD_LOGIC;
    signal ex_ALUSrc         : STD_LOGIC;
    signal ex_MemtoReg       : STD_LOGIC;
    signal ex_RegWrite       : STD_LOGIC;
    signal ex_MemRead        : STD_LOGIC;
    signal ex_MemWrite       : STD_LOGIC;
    signal ex_BranchEq       : STD_LOGIC;
    signal ex_BranchNE       : STD_LOGIC;
    signal ex_Jump           : STD_LOGIC;
    signal ex_ALUOp          : STD_LOGIC_VECTOR(1 downto 0);

    component id_ex is
        port (
            clk              : in  STD_LOGIC;
            rst              : in  STD_LOGIC;
            stall            : in  STD_LOGIC;
            flush            : in  STD_LOGIC;
            id_pc_plus4_in   : in  STD_LOGIC_VECTOR(31 downto 0);
            id_read_data1_in : in  STD_LOGIC_VECTOR(31 downto 0);
            id_read_data2_in : in  STD_LOGIC_VECTOR(31 downto 0);
            id_imm_in        : in  STD_LOGIC_VECTOR(31 downto 0);
            id_rs_in         : in  STD_LOGIC_VECTOR(4 downto 0);
            id_rt_in         : in  STD_LOGIC_VECTOR(4 downto 0);
            id_rd_in         : in  STD_LOGIC_VECTOR(4 downto 0);
            id_funct_in      : in  STD_LOGIC_VECTOR(5 downto 0);
            id_RegDst_in     : in  STD_LOGIC;
            id_ALUSrc_in     : in  STD_LOGIC;
            id_MemtoReg_in   : in  STD_LOGIC;
            id_RegWrite_in   : in  STD_LOGIC;
            id_MemRead_in    : in  STD_LOGIC;
            id_MemWrite_in   : in  STD_LOGIC;
            id_BranchEq_in   : in  STD_LOGIC;
            id_BranchNE_in   : in  STD_LOGIC;
            id_Jump_in       : in  STD_LOGIC;
            id_ALUOp_in      : in  STD_LOGIC_VECTOR(1 downto 0);
            ex_pc_plus4      : out STD_LOGIC_VECTOR(31 downto 0);
            ex_read_data1    : out STD_LOGIC_VECTOR(31 downto 0);
            ex_read_data2    : out STD_LOGIC_VECTOR(31 downto 0);
            ex_imm           : out STD_LOGIC_VECTOR(31 downto 0);
            ex_rs            : out STD_LOGIC_VECTOR(4 downto 0);
            ex_rt            : out STD_LOGIC_VECTOR(4 downto 0);
            ex_rd            : out STD_LOGIC_VECTOR(4 downto 0);
            ex_funct         : out STD_LOGIC_VECTOR(5 downto 0);
            ex_RegDst        : out STD_LOGIC;
            ex_ALUSrc        : out STD_LOGIC;
            ex_MemtoReg      : out STD_LOGIC;
            ex_RegWrite      : out STD_LOGIC;
            ex_MemRead       : out STD_LOGIC;
            ex_MemWrite      : out STD_LOGIC;
            ex_BranchEq      : out STD_LOGIC;
            ex_BranchNE      : out STD_LOGIC;
            ex_Jump          : out STD_LOGIC;
            ex_ALUOp         : out STD_LOGIC_VECTOR(1 downto 0)
        );
    end component;

begin
    -- Instantiate pipeline register
    uut: id_ex
        port map (
            clk              => clk,
            rst              => rst,
            stall            => stall,
            flush            => flush,
            id_pc_plus4_in   => id_pc_plus4_in,
            id_read_data1_in => id_read_data1_in,
            id_read_data2_in => id_read_data2_in,
            id_imm_in        => id_imm_in,
            id_rs_in         => id_rs_in,
            id_rt_in         => id_rt_in,
            id_rd_in         => id_rd_in,
            id_funct_in      => id_funct_in,
            id_RegDst_in     => id_RegDst_in,
            id_ALUSrc_in     => id_ALUSrc_in,
            id_MemtoReg_in   => id_MemtoReg_in,
            id_RegWrite_in   => id_RegWrite_in,
            id_MemRead_in    => id_MemRead_in,
            id_MemWrite_in   => id_MemWrite_in,
            id_BranchEq_in   => id_BranchEq_in,
            id_BranchNE_in   => id_BranchNE_in,
            id_Jump_in       => id_Jump_in,
            id_ALUOp_in      => id_ALUOp_in,
            ex_pc_plus4      => ex_pc_plus4,
            ex_read_data1    => ex_read_data1,
            ex_read_data2    => ex_read_data2,
            ex_imm           => ex_imm,
            ex_rs            => ex_rs,
            ex_rt            => ex_rt,
            ex_rd            => ex_rd,
            ex_funct         => ex_funct,
            ex_RegDst        => ex_RegDst,
            ex_ALUSrc        => ex_ALUSrc,
            ex_MemtoReg      => ex_MemtoReg,
            ex_RegWrite      => ex_RegWrite,
            ex_MemRead       => ex_MemRead,
            ex_MemWrite      => ex_MemWrite,
            ex_BranchEq      => ex_BranchEq,
            ex_BranchNE      => ex_BranchNE,
            ex_Jump          => ex_Jump,
            ex_ALUOp         => ex_ALUOp
        );

    -- Clock generation
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
        -- Apply reset for two cycles
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        -- Check reset clear
        assert ex_pc_plus4 = X"00000000" report "Reset didn't clear pc" severity error;
        assert ex_read_data1 = X"00000000" report "Reset didn't clear data1" severity error;
        assert ex_read_data2 = X"00000000" report "Reset didn't clear data2" severity error;
        assert ex_imm = X"00000000" report "Reset didn't clear imm" severity error;
        assert ex_rs = "00000" report "Reset didn't clear rs" severity error;
        assert ex_rt = "00000" report "Reset didn't clear rt" severity error;
        assert ex_rd = "00000" report "Reset didn't clear rd" severity error;
        assert ex_funct = "000000" report "Reset didn't clear funct" severity error;
        assert ex_ALUOp = "00" report "Reset didn't clear ALUOp" severity error;

        -- Normal update
        id_pc_plus4_in   <= X"00000008";
        id_read_data1_in <= X"11111111";
        id_read_data2_in <= X"22222222";
        id_imm_in        <= X"33333333";
        id_rs_in         <= "00100";
        id_rt_in         <= "00101";
        id_rd_in         <= "00110";
        id_funct_in      <= "100010";
        id_RegDst_in     <= '0'; id_ALUSrc_in <= '0';
        id_MemtoReg_in   <= '0'; id_RegWrite_in <= '0';
        id_MemRead_in    <= '0'; id_MemWrite_in <= '0';
        id_BranchEq_in   <= '0'; id_BranchNE_in <= '0'; id_Jump_in <= '0';
        id_ALUOp_in      <= "01";
        wait for 10 ns;
        assert ex_pc_plus4 = X"00000008" report "Update pc failed" severity error;
        assert ex_read_data1 = X"11111111" report "Update data1 failed" severity error;
        assert ex_read_data2 = X"22222222" report "Update data2 failed" severity error;
        assert ex_imm = X"33333333" report "Update imm failed" severity error;
        assert ex_rs = "00100" report "Update rs failed" severity error;
        assert ex_rt = "00101" report "Update rt failed" severity error;
        assert ex_rd = "00110" report "Update rd failed" severity error;
        assert ex_funct = "100010" report "Update funct failed" severity error;
        assert ex_ALUOp = "01" report "Update ALUOp failed" severity error;

        -- Stall: hold values
        stall <= '1';
        id_pc_plus4_in <= X"FFFFFFFF";
        id_read_data1_in <= X"EEEEEEEE";
        wait for 10 ns;
        assert ex_pc_plus4 = X"00000008" report "Stall didn't hold pc" severity error;
        stall <= '0';

        -- Flush: clear registers
        flush <= '1';
        wait for 10 ns;
        assert ex_pc_plus4 = X"00000000" report "Flush didn't clear pc" severity error;
        wait for 10 ns;
        flush <= '0';

        report "id_ex_tb completed" severity note;
        wait;
    end process;
end architecture Behavioral;
