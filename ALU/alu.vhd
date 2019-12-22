library ieee;
use ieee.std_logic_1164.all;

entity alu is
    generic (n :integer := 16);
    port (
        A, B : in std_logic_vector(n-1 downto 0);       --A: Y, B: Bus
        Cin : in std_logic;
        Opcode: in std_logic_vector (4 downto 0);
        F : out std_logic_vector (n-1 downto 0);
        Cout, Z, NF, P, O : out std_logic
    ) ;
end alu;

architecture alu_arch of alu is
    
    signal F0, F1, F2, F3 : std_logic_vector (n-1 downto 0);
    signal Cout0, Cout1, Cout2, OV : std_logic;

begin
    u0: entity work.Arithmetic generic map(n)
        port map (A, B, Cin, Opcode(2 downto 0), F0, Cout0, OV);
    u1: entity work.Logic generic map(n)
        port map (A, B, Opcode(1 downto 0), F1);
    u2: entity work.ShiftRight generic map(n)
        port map (A, Cin, Opcode(1 downto 0), F2, Cout1);
    u3: entity work.ShiftLeft generic map(n)
        port map (A, Cin, Opcode(1 downto 0), F3, Cout2);

    F <= F1 when (Opcode(4 downto 2) = "101" or Opcode(4 downto 2) = "000")
    else F2 when (Opcode(4 downto 2) = "001")
    else F3 when (Opcode(4 downto 2) = "010")
    else F0;

    Cout <= '0' when (Opcode(4 downto 2) = "101" or Opcode(4 downto 2) = "000")
    else Cout1 when (Opcode(4 downto 2) = "001")
    else Cout2 when (Opcode(4 downto 2) = "010")
    else Cout0;

    Z <= nor F;     --all zeros
    NF <= '1' when F(n-1) = '1' else '0';
    P <= xnor F;    --even parity
    O <= OV when (Opcode(4 downto 2) = "011" or Opcode(4 downto 2) = "100") else '0';
end alu_arch ; 