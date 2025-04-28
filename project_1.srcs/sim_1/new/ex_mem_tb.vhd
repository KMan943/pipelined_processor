-- ex_mem_tb.vhd: Extended Testbench for EX/MEM Pipeline Register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ex_mem_tb is
end entity ex_mem_tb;

architecture Behavioral of ex_mem_tb is
    -- Clock and control signals
    signal clk       : STD_LOGIC := '0';
    signal rst       : STD_LOGIC := '0';
    signal stall     : STD_LOGIC := '0';
    signal flush     : STD_LOGIC := '0';

    -- EX stage inputs
    signal ex_pc_plus4_in    : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ex_alu_result_in  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ex_write_data_in  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ex_zero_in        : STD_LOGIC := '0';
    signal ex_rt_in, ex_rd_in: STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal ex_MemtoReg_in    : STD_LOGIC := '0';
    signal ex_RegWrite_in    : STD_LOGIC := '0';
    signal ex_MemRead_in     : STD_LOGIC := '0';
    signal ex_MemWrite_in    : STD_LOGIC := '0';
    signal ex_BranchEq_in    : STD_LOGIC := '0';
    signal ex_BranchNE_in    : STD_LOGIC := '0';
    signal ex_Jump_in        : STD_LOGIC := '0';

    -- MEM stage outputs
    signal mem_pc_plus4      : STD_LOGIC_VECTOR(31 downto 0);
    signal mem_alu_result    : STD_LOGIC_VECTOR(31 downto 0);
    signal mem_write_data    : STD_LOGIC_VECTOR(31 downto 0);
    signal mem_zero          : STD_LOGIC;
    signal mem_rt, mem_rd    : STD_LOGIC_VECTOR(4 downto 0);
    signal mem_MemtoReg      : STD_LOGIC;
    signal mem_RegWrite      : STD_LOGIC;
    signal mem_MemRead       : STD_LOGIC;
    signal mem_MemWrite      : STD_LOGIC;
    signal mem_BranchEq      : STD_LOGIC;
    signal mem_BranchNE      : STD_LOGIC;
    signal mem_Jump          : STD_LOGIC;

    component ex_mem is
        port (
            clk              : in  STD_LOGIC;
            rst              : in  STD_LOGIC;
            stall            : in  STD_LOGIC;
            flush            : in  STD_LOGIC;
            ex_pc_plus4_in   : in  STD_LOGIC_VECTOR(31 downto 0);
            ex_alu_result_in : in  STD_LOGIC_VECTOR(31 downto 0);
            ex_write_data_in : in  STD_LOGIC_VECTOR(31 downto 0);
            ex_zero_in       : in  STD_LOGIC;
            ex_rt_in         : in  STD_LOGIC_VECTOR(4 downto 0);
            ex_rd_in         : in  STD_LOGIC_VECTOR(4 downto 0);
            ex_MemtoReg_in   : in  STD_LOGIC;
            ex_RegWrite_in   : in  STD_LOGIC;
            ex_MemRead_in    : in  STD_LOGIC;
            ex_MemWrite_in   : in  STD_LOGIC;
            ex_BranchEq_in   : in  STD_LOGIC;
            ex_BranchNE_in   : in  STD_LOGIC;
            ex_Jump_in       : in  STD_LOGIC;
            mem_pc_plus4     : out STD_LOGIC_VECTOR(31 downto 0);
            mem_alu_result   : out STD_LOGIC_VECTOR(31 downto 0);
            mem_write_data   : out STD_LOGIC_VECTOR(31 downto 0);
            mem_zero         : out STD_LOGIC;
            mem_rt           : out STD_LOGIC_VECTOR(4 downto 0);
            mem_rd           : out STD_LOGIC_VECTOR(4 downto 0);
            mem_MemtoReg     : out STD_LOGIC;
            mem_RegWrite     : out STD_LOGIC;
            mem_MemRead      : out STD_LOGIC;
            mem_MemWrite     : out STD_LOGIC;
            mem_BranchEq     : out STD_LOGIC;
            mem_BranchNE     : out STD_LOGIC;
            mem_Jump         : out STD_LOGIC
        );
    end component;
begin
    -- Instantiate EX/MEM register
    uut: ex_mem
        port map (
            clk              => clk,
            rst              => rst,
            stall            => stall,
            flush            => flush,
            ex_pc_plus4_in   => ex_pc_plus4_in,
            ex_alu_result_in => ex_alu_result_in,
            ex_write_data_in => ex_write_data_in,
            ex_zero_in       => ex_zero_in,
            ex_rt_in         => ex_rt_in,
            ex_rd_in         => ex_rd_in,
            ex_MemtoReg_in   => ex_MemtoReg_in,
            ex_RegWrite_in   => ex_RegWrite_in,
            ex_MemRead_in    => ex_MemRead_in,
            ex_MemWrite_in   => ex_MemWrite_in,
            ex_BranchEq_in   => ex_BranchEq_in,
            ex_BranchNE_in   => ex_BranchNE_in,
            ex_Jump_in       => ex_Jump_in,
            mem_pc_plus4     => mem_pc_plus4,
            mem_alu_result   => mem_alu_result,
            mem_write_data   => mem_write_data,
            mem_zero         => mem_zero,
            mem_rt           => mem_rt,
            mem_rd           => mem_rd,
            mem_MemtoReg     => mem_MemtoReg,
            mem_RegWrite     => mem_RegWrite,
            mem_MemRead      => mem_MemRead,
            mem_MemWrite     => mem_MemWrite,
            mem_BranchEq     => mem_BranchEq,
            mem_BranchNE     => mem_BranchNE,
            mem_Jump         => mem_Jump
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
        -- Apply reset for one cycle
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        -- Reset check
        assert mem_pc_plus4 = X"00000000" report "Reset failed: pc" severity error;
        assert mem_alu_result = X"00000000" report "Reset failed: alu_result" severity error;
        assert mem_write_data = X"00000000" report "Reset failed: write_data" severity error;
        assert mem_zero = '0' report "Reset failed: zero" severity error;
        assert mem_rt = "00000" report "Reset failed: rt" severity error;
        assert mem_rd = "00000" report "Reset failed: rd" severity error;
        assert mem_MemtoReg = '0' report "Reset failed: MemtoReg" severity error;
        assert mem_RegWrite = '0' report "Reset failed: RegWrite" severity error;
        assert mem_MemRead = '0' report "Reset failed: MemRead" severity error;
        assert mem_MemWrite = '0' report "Reset failed: MemWrite" severity error;
        assert mem_BranchEq = '0' report "Reset failed: BranchEq" severity error;
        assert mem_BranchNE = '0' report "Reset failed: BranchNE" severity error;
        assert mem_Jump = '0' report "Reset failed: Jump" severity error;

        -- Normal update
        ex_pc_plus4_in   <= X"00000008";
        ex_alu_result_in <= X"AAAAAAAA";
        ex_write_data_in <= X"BBBBBBBB";
        ex_zero_in       <= '1';
        ex_rt_in         <= "01010";
        ex_rd_in         <= "01011";
        ex_MemtoReg_in   <= '1';
        ex_RegWrite_in   <= '1';
        ex_MemRead_in    <= '1';
        ex_MemWrite_in   <= '1';
        ex_BranchEq_in   <= '1';
        ex_BranchNE_in   <= '1';
        ex_Jump_in       <= '1';
        wait for 10 ns;
        assert mem_pc_plus4 = X"00000008" report "Normal update failed: pc" severity error;
        assert mem_alu_result = X"AAAAAAAA" report "Normal update failed: alu_result" severity error;
        assert mem_write_data = X"BBBBBBBB" report "Normal update failed: write_data" severity error;
        assert mem_zero = '1' report "Normal update failed: zero" severity error;
        assert mem_rt = "01010" report "Normal update failed: rt" severity error;
        assert mem_rd = "01011" report "Normal update failed: rd" severity error;
        assert mem_MemtoReg = '1' report "Normal update failed: MemtoReg" severity error;
        assert mem_RegWrite = '1' report "Normal update failed: RegWrite" severity error;
        assert mem_MemRead = '1' report "Normal update failed: MemRead" severity error;
        assert mem_MemWrite = '1' report "Normal update failed: MemWrite" severity error;
        assert mem_BranchEq = '1' report "Normal update failed: BranchEq" severity error;
        assert mem_BranchNE = '1' report "Normal update failed: BranchNE" severity error;
        assert mem_Jump = '1' report "Normal update failed: Jump" severity error;

        -- Stall: inputs change but outputs hold
        stall <= '1';
        ex_pc_plus4_in <= X"FFFFFFFF";
        wait for 10 ns;
        assert mem_pc_plus4 = X"00000008" report "Stall did not hold pc" severity error;
        stall <= '0';

        -- Flush: clear registers
        flush <= '1';
        wait for 10 ns;
        assert mem_pc_plus4 = X"00000000" report "Flush did not clear pc" severity error;
        assert mem_alu_result = X"00000000" report "Flush did not clear alu_result" severity error;
        assert mem_write_data = X"00000000" report "Flush did not clear write_data" severity error;
        assert mem_zero = '0' report "Flush did not clear zero" severity error;
        assert mem_rt = "00000" report "Flush did not clear rt" severity error;
        assert mem_rd = "00000" report "Flush did not clear rd" severity error;
        assert mem_MemtoReg = '0' report "Flush did not clear MemtoReg" severity error;
        assert mem_RegWrite = '0' report "Flush did not clear RegWrite" severity error;
        assert mem_MemRead = '0' report "Flush did not clear MemRead" severity error;
        assert mem_MemWrite = '0' report "Flush did not clear MemWrite" severity error;
        assert mem_BranchEq = '0' report "Flush did not clear BranchEq" severity error;
        assert mem_BranchNE = '0' report "Flush did not clear BranchNE" severity error;
        assert mem_Jump = '0' report "Flush did not clear Jump" severity error;

        report "ex_mem_tb completed" severity note;
        wait;
    end process;
end architecture Behavioral;
