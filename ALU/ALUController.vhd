library ieee;
use ieee.std_logic_1164.all;

entity ALUController is
    generic (n : integer := 16);
    port (
        controlS : in std_logic_vector (1 downto 0);  --control unit selectors
        IR, A, B: in std_logic_vector (n-1 downto 0);
        Cin : in std_logic;
        F, FR: out std_logic_vector (n-1 downto 0)
    ) ;
end ALUController;

architecture ALUController_arch of ALUController is

    signal Opcode, Operation : std_logic_vector(4 downto 0);

begin
    Operation <=  "10010" when (IR(n-1 downto n-4) = "0111")    --CMP
    else IR(n-3 downto n-7) when (IR(n-1 downto n-3) = "100")   --one operand
    else "01011" when IR(n-1 downto n-3) = "101"                --branching (pass byte)
    else '1' & IR(n-1 downto n-4);                              --two operand

    Opcode <= "10000" when (controlS = "00")    --ADD
    else "01100" when (controlS = "01")         --INC
    else "01101" when (controlS = "10")         --DEC
    else Operation;

    a0: entity work.alu generic map (n)
        port map (A, B, Cin, Opcode, F, FR(4), FR(3), FR(2), FR(1), FR(0));
end ALUController_arch ; 