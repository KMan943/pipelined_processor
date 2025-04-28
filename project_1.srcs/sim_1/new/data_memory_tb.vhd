-- data_memory_tb.vhdl: Testbench for Data Memory
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory_tb is
end entity data_memory_tb;

architecture Behavioral of data_memory_tb is
    signal clk         : STD_LOGIC := '0';
    signal MemRead     : STD_LOGIC := '0';
    signal MemWrite    : STD_LOGIC := '0';
    signal addr        : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal write_data  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal read_data   : STD_LOGIC_VECTOR(31 downto 0);

    component data_memory is
        Port (
            clk         : in  STD_LOGIC;
            MemRead     : in  STD_LOGIC;
            MemWrite    : in  STD_LOGIC;
            addr        : in  STD_LOGIC_VECTOR(31 downto 0);
            write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
            read_data   : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
begin
    uut: data_memory port map(
        clk        => clk,
        MemRead    => MemRead,
        MemWrite   => MemWrite,
        addr       => addr,
        write_data => write_data,
        read_data  => read_data
    );

    -- Clock generation
    clk_process: process
    begin
        while true loop
            clk <= '0'; wait for 5 ns;
            clk <= '1'; wait for 5 ns;
        end loop;
    end process;

    stim_proc: process
    begin
        -- Write value 0xDEADBEEF to address 0
        addr <= X"00000000";
        write_data <= X"DEADBEEF";
        MemWrite <= '1';
        wait for 10 ns;
        MemWrite <= '0';
        wait for 10 ns;

        -- Read back from address 0
        MemRead <= '1';
        wait for 10 ns;
        assert read_data = X"DEADBEEF" report "Readback mismatch at addr=0" severity error;

        -- Read from invalid address (out-of-range)
        MemRead <= '1';
        addr <= X"00000040";  -- > 15*4
        wait for 10 ns;
        assert read_data = X"00000000" report "Out-of-range read should return 0" severity note;

        -- Write and read multiple locations
        MemRead <= '0';
        addr <= X"00000004"; write_data <= X"12345678"; MemWrite <= '1';
        wait for 10 ns; MemWrite <= '0';
        wait for 10 ns;
        MemRead <= '1';
        wait for 10 ns;
        assert read_data = X"12345678" report "Readback mismatch at addr=4" severity error;

        report "data_memory_tb completed";
        wait;
    end process;
end architecture Behavioral;
