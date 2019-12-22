library IEEE;
use IEEE.std_logic_1164.all;

entity ShiftLeft is
  generic (n : integer := 16);
  port (
    A : in std_logic_vector (n-1 downto 0);
    Cin: in std_logic;
    S : in std_logic_vector(1 downto 0);
    F : out std_logic_vector (n-1 downto 0);
    Cout : out std_logic
  ) ;
end entity ShiftLeft;

architecture ShiftLeft_arch of ShiftLeft is

begin
    F <= A(n-2 downto 0) & '0' when(S = "00")
    else A(n-2 downto 0) & A(n-1) when(S = "01")
    else A(n-2 downto 0) & Cin when(S = "10")
    else (n-1 downto n/2 => '0') & A(n/2-1 downto 0);

    Cout <= A(n-1);
end ShiftLeft_arch ; 
