-- mem_wb_tb.vhd: Extended Testbench for MEM/WB Pipeline Register
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity mem_wb_tb is
end entity mem_wb_tb;

architecture Behavioral of mem_wb_tb is
    -- Clock and control signals
    signal clk            : STD_LOGIC := '0';
    signal rst            : STD_LOGIC := '0';
    signal stall          : STD_LOGIC := '0';
    signal flush          : STD_LOGIC := '0';

    -- MEM stage inputs
    signal mem_alu_result_in : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_read_data_in  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal mem_rt_in         : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal mem_rd_in         : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal mem_MemtoReg_in   : STD_LOGIC := '0';
    signal mem_RegWrite_in   : STD_LOGIC := '0';

    -- WB stage outputs
    signal wb_alu_result     : STD_LOGIC_VECTOR(31 downto 0);
    signal wb_read_data      : STD_LOGIC_VECTOR(31 downto 0);
    signal wb_write_reg      : STD_LOGIC_VECTOR(4 downto 0);
    signal wb_MemtoReg       : STD_LOGIC;
    signal wb_RegWrite       : STD_LOGIC;

    component mem_wb is
        port (
            clk               : in  STD_LOGIC;
            rst               : in  STD_LOGIC;
            stall             : in  STD_LOGIC;
            flush             : in  STD_LOGIC;
            mem_alu_result_in : in  STD_LOGIC_VECTOR(31 downto 0);
            mem_read_data_in  : in  STD_LOGIC_VECTOR(31 downto 0);
            mem_rt_in         : in  STD_LOGIC_VECTOR(4 downto 0);
            mem_rd_in         : in  STD_LOGIC_VECTOR(4 downto 0);
            mem_MemtoReg_in   : in  STD_LOGIC;
            mem_RegWrite_in   : in  STD_LOGIC;
            wb_alu_result     : out STD_LOGIC_VECTOR(31 downto 0);
            wb_read_data      : out STD_LOGIC_VECTOR(31 downto 0);
            wb_write_reg      : out STD_LOGIC_VECTOR(4 downto 0);
            wb_MemtoReg       : out STD_LOGIC;
            wb_RegWrite       : out STD_LOGIC
        );
    end component;

begin
    -- Instantiate MEM/WB register
    uut: mem_wb
        port map (
            clk               => clk,
            rst               => rst,
            stall             => stall,
            flush             => flush,
            mem_alu_result_in => mem_alu_result_in,
            mem_read_data_in  => mem_read_data_in,
            mem_rt_in         => mem_rt_in,
            mem_rd_in         => mem_rd_in,
            mem_MemtoReg_in   => mem_MemtoReg_in,
            mem_RegWrite_in   => mem_RegWrite_in,
            wb_alu_result     => wb_alu_result,
            wb_read_data      => wb_read_data,
            wb_write_reg      => wb_write_reg,
            wb_MemtoReg       => wb_MemtoReg,
            wb_RegWrite       => wb_RegWrite
        );

    -- Clock: 10 ns period
    clk_process: process
    begin
        while True loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    -- Stimulus
    stim_proc: process
    begin
        -- Apply reset for one cycle
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        -- Reset behavior: all outputs zero
        assert wb_alu_result = X"00000000" report "Reset clear failed: ALU result" severity error;
        assert wb_read_data = X"00000000" report "Reset clear failed: Read data" severity error;
        assert wb_write_reg = "00000" report "Reset clear failed: Write reg" severity error;
        assert wb_MemtoReg = '0' report "Reset clear failed: MemtoReg" severity error;
        assert wb_RegWrite = '0' report "Reset clear failed: RegWrite" severity error;

        -- Normal update: MemtoReg=1 selects rt
        mem_alu_result_in <= X"CAFEBABE";
        mem_read_data_in  <= X"DEADBEEF";
        mem_rt_in         <= "00111";
        mem_rd_in         <= "01000";
        mem_MemtoReg_in   <= '1';
        mem_RegWrite_in   <= '1';
        wait for 10 ns;
        assert wb_alu_result = X"CAFEBABE" report "Normal update failed: ALU result" severity error;
        assert wb_read_data = X"DEADBEEF" report "Normal update failed: Read data" severity error;
        assert wb_write_reg = "00111" report "Normal update failed: Write reg select rt" severity error;
        assert wb_MemtoReg = '1' report "Normal update failed: MemtoReg" severity error;
        assert wb_RegWrite = '1' report "Normal update failed: RegWrite" severity error;

        -- Now MemtoReg=0 selects rd
        mem_MemtoReg_in <= '0';
        wait for 10 ns;
        assert wb_write_reg = "01000" report "Write reg select rd failed" severity error;

        -- Stall: inputs change but outputs hold
        stall <= '1';
        mem_alu_result_in <= X"FFFFFFFF";
        wait for 10 ns;
        assert wb_alu_result = X"CAFEBABE" report "Stall did not hold ALU result" severity error;
        stall <= '0';

        -- Flush: clears outputs to zero
        flush <= '1';
        wait for 10 ns;
        assert wb_alu_result = X"00000000" report "Flush failed: ALU result" severity error;
        assert wb_read_data = X"00000000" report "Flush failed: Read data" severity error;
        assert wb_write_reg = "00000" report "Flush failed: Write reg" severity error;
        assert wb_MemtoReg = '0' report "Flush failed: MemtoReg" severity error;
        assert wb_RegWrite = '0' report "Flush failed: RegWrite" severity error;

        report "mem_wb_tb completed" severity note;
        wait;
    end process;
end architecture Behavioral;
