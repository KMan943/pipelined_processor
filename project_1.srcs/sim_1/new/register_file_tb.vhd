-- register_file_tb.vhdl: Testbench for the Register File
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file_tb is
end register_file_tb;

architecture Behavioral of register_file_tb is
    signal clk        : STD_LOGIC := '0';
    signal rst        : STD_LOGIC := '1';
    signal we         : STD_LOGIC := '0';
    signal read_reg1  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal read_reg2  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal write_reg  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal write_data : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal rd1, rd2   : STD_LOGIC_VECTOR(31 downto 0);

    component register_file is
        port (
            clk         : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            we          : in  STD_LOGIC;
            read_reg1   : in  STD_LOGIC_VECTOR(4 downto 0);
            read_reg2   : in  STD_LOGIC_VECTOR(4 downto 0);
            write_reg   : in  STD_LOGIC_VECTOR(4 downto 0);
            write_data  : in  STD_LOGIC_VECTOR(31 downto 0);
            read_data1  : out STD_LOGIC_VECTOR(31 downto 0);
            read_data2  : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;
begin
    uut: register_file
        port map(
            clk        => clk,
            rst        => rst,
            we         => we,
            read_reg1  => read_reg1,
            read_reg2  => read_reg2,
            write_reg  => write_reg,
            write_data => write_data,
            read_data1 => rd1,
            read_data2 => rd2
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
        -- Initial reset
        rst <= '1';
        wait for 12 ns;
        rst <= '0';
        wait for 8 ns;

        -- Check two reads when regs are zero
        read_reg1 <= "00010"; -- R2
        read_reg2 <= "00101"; -- R5
        wait for 10 ns;
        assert rd1 = X"00000000"
            report "Initial read_data1 should be zero" severity error;
        assert rd2 = X"00000000"
            report "Initial read_data2 should be zero" severity error;

        -- Write to R2
        we <= '1';
        write_reg <= "00010";
        write_data <= X"AAAA0001";
        wait for 10 ns;
        we <= '0';
        wait for 10 ns;

        -- Read back R2 and R5
        read_reg1 <= "00010"; -- R2
        read_reg2 <= "00101"; -- R5
        wait for 10 ns;
        assert rd1 = X"AAAA0001"
            report "Write/read mismatch on R2" severity error;
        assert rd2 = X"00000000"
            report "R5 should remain zero" severity error;

        -- Attempt write to R0 (should remain zero)
        we <= '1';
        write_reg <= "00000";
        write_data <= X"DEADBEEF";
        wait for 10 ns;
        we <= '0';
        read_reg1 <= "00000"; -- R0
        wait for 10 ns;
        assert rd1 = X"00000000"
            report "R0 should remain zero despite write" severity error;

        report "register_file_tb completed" severity note;
        wait;
    end process;
end Behavioral;