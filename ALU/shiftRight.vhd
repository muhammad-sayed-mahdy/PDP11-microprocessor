LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity ShiftRight is 
    generic (n: integer := 16);
    port(A: in std_logic_vector(n-1 downto 0);
        Cin: in std_logic;
        S: in std_logic_vector(1 downto 0);
        F: out std_logic_vector(n-1 downto 0);
        Cout: out std_logic);
end entity ShiftRight;

architecture ShiftRight_arch of ShiftRight is
    begin
        F <= '0' & A(n-1 downto 1) when (S = "00")
        else A(0) & A(n-1 downto 1) when (S = "01")
        else Cin & A(n-1 downto 1) when (S = "10")
        else A(n-1) & A(n-1 downto 1);
        Cout <= A(0);
    end ShiftRight_arch;