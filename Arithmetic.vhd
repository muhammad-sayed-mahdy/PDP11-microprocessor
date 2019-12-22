library ieee;
use ieee.std_logic_1164.all;

entity Arithmetic is
    generic (n : integer := 16);
    port (
        A, B : in std_logic_vector (n-1 downto 0);
        Cin : in std_logic;
        S : in std_logic_vector(2 downto 0);
        F : out std_logic_vector (n-1 downto 0);
        Cout, O : out std_logic
    ) ;
end Arithmetic;

architecture Arithmetic_arch of Arithmetic is

    signal Bi, Fi : std_logic_vector (n-1 downto 0);
    signal Couti, Cini, sub : std_logic;
begin
    Bi <= B when (S(2) = '0')
    else (others => '0');

    Cini <=  Cin when (S(2) = '0' and S(0) = '1')
    else '1' when (S(2) = '1')
    else '0';

    sub <= '1' when (S(2 downto 1) = "01" or S = "101")
    else '0';

    u0: entity work.nfullAddSub generic map(n)
        port map (A, Bi, Cini, sub, Fi, Couti, O);

    F <= (others => '0') when (S = "110")
    else Fi;

    Cout <= '0' when (S = "110")
    else Couti;

end Arithmetic_arch ;