LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

entity Logic is 
    generic (n: integer := 16);
    port(A, B: in std_logic_vector(n-1 downto 0);
        S : in std_logic_vector(1 downto 0);
        F: out std_logic_vector(n-1 downto 0));
end entity Logic;

architecture Logic_arch of Logic is
    begin
        F <= (A and B) when (S = "00")
        else (A or B) when (S = "01")
        else (A xnor B) when (S = "10")
        else (not A);
    end Logic_arch;
