LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY PLA IS
    GENERIC ( n : integer := 16; m : integer := 6);
	PORT(   IR                      : IN  std_logic_vector(n-1 DOWNTO 0);
	         FR                     : IN std_logic_vector(4 downto 0);
            baseaddress, currentaddress        : IN std_logic_vector(m-1 DOWNTO 0);
            nextaddress       : OUT std_logic_vector(m-1 DOWNTO 0));
END ENTITY PLA;

ARCHITECTURE pla_arch OF PLA IS
  
  signal Epla1, Epla2, Epla3, Epla4, Epla5, Epla6  : std_logic;  -- enables for 6 plas
  signal E2op, E1op, Ebonus, EHLT, Ebr  : std_logic; -- enables used by first pla
  signal EclIR, EclDR : std_logic; -- enables used by first pla as special cases for clear operation with direct and indirect registers
  signal Ebranch : std_logic; -- enable for branch states if the branch operation to be performed based on mux its selection lines are
                              --  IR bits stating type of branching.
  signal Ecl, Emov : std_logic; -- enables for special operations mov and clear
  signal EmovIR, EmovDR : std_logic; -- enables used by second pla as special cases for mov operation with direct and indirect registers
  signal Ecmp, EIRS, EIRD, EIDRD : std_logic; -- enable for compare operation, enable indirect source and destination
  
BEGIN
  
  -- pla enables
  Epla1 <= '1' when currentaddress = "110110"
  else '0';
    
  Epla2 <= '1' when currentaddress = "000001" or currentaddress = "000010" 
  else '0';
    
  Epla3 <= '1' when currentaddress = "000111" or currentaddress = "110111" or currentaddress = "010011"
  else '0';
    
  Epla4 <= '1' when currentaddress = "001000"
  else '0';
    
  Epla5 <= '1' when currentaddress = "010101" or currentaddress = "010110" or currentaddress = "011100"
  else '0';
    
  Epla6 <= '1' when currentaddress = "011010" or currentaddress = "001110"
  else '0';
  
  
  
  
  -- first pla enables
  E2op <= '1' when IR(n-1) = '0' or Emov = '1'
  else '0';
    
  E1op <= '1' when IR(n-1 downto n-3) = "100"
  else '0';
    
  Ebonus <= '1' when IR(n-1 downto n-3) = "111" 
  else '0';
    
  Ebr <= '1' when IR(n-1 downto n-3) = "101"
  else '0';
    
  EHLT <= '1' when IR(n-1 downto n-5) = "11000"
  else '0';
  
  
  
  
  -- mov, compare and clear special enables
  Emov <= '1' when IR(n-1 downto n-4) = "1101"
  else '0';
    
  Ecmp <= '1' when IR(n-1 downto n-4) = "0111"
  else '0';
    
  Ecl <= '1' when IR(n-1 downto n-7) = "1001110"
  else '0';
  
  
  
  
  -- clear special enables for direct register and indirect register (first pla)
  EclIR <= '1' when Ecl = '1' and IR(5 downto 3) = "001"
  else '0';
    
  EclDR <= '1' when Ecl = '1' and IR(5 downto 3) = "000"
  else '0';
  
  
  
  
  -- clear special enables for direct register and indirect register (first pla)
  EmovIR <= '1' when Emov = '1' and IR(5 downto 3) = "001"
  else '0';
    
  EmovDR <= '1' when Emov = '1' and IR(5 downto 3) = "000"
  else '0';
    
  EIRS <= not(IR(n-5) or IR(n-6)) and IR(n-7);
  EIRD <= not(IR(n-11) or IR(n-12)) and IR(n-13);
  EIDRD <= IR(n-11) or IR(n-12) or IR(n-13);
  
  
  -- branching mux
  Ebranch <= '0' when Ebr = '0'
  else '1' when IR(n-4 downto n-6) = "000"
  else '1' when IR(n-4 downto n-6) = "001" and FR(3) = '1'
  else '1' when IR(n-4 downto n-6) = "010" and FR(3) = '0'
  else '1' when IR(n-4 downto n-6) = "011" and FR(4) = '1'
  else '1' when IR(n-5 downto n-6) = "00" and (FR(4) = '1' or FR(3) = '1')
  else '1' when IR(n-5 downto n-6) = "01" and (FR(4) = '1' or FR(3) = '0')
  else '1' when IR(n-6) = '0' and FR(4) = '0'
  else '0';
  
  
  
  
  -- (PLA)
  
  -- PLA1
  nextaddress <= "00" & IR(n-5 downto n-6) & EIRS & '1' when Epla1 = '1' and E2op = '1'
  else "001000" when Epla1 = '1' and EclDR = '1'
  else "001110" when Epla1 = '1' and EclIR = '1'
  else IR(n-11 downto n-12)& EIRD &"100" when Epla1 = '1' and E1op = '1'
  else "101000" when Ebranch = '1' and Epla1 = '1'
  else IR(n-1 downto n-3)&'0'&IR(n-4 downto n-5) when Ebonus = '1' and Epla1 = '1' 
  else "110110" when Epla1 = '1' and EHLT = '1'
  -- PLA2
  else "111100" when Epla2 = '1' and EmovDR = '1'
  else "001110" when Epla2 = '1' and EmovIR = '1'
  else IR(n-11 downto n-12)& EIRD &"100" when Epla2 = '1'
  -- PLA3
  else "000" & IR(n-7) & "10" when Epla3 = '1'
  -- PLA4
  else "000000" when Epla4 = '1' and Ecmp = '1'
  else "00101"& EIDRD when Epla4 = '1' and Ecmp = '0'
  -- PLA5
  else "111110" when Emov = '1' and Epla5 = '1' and IR(n-13) = '0'
  else "001000" when Ecl = '1' and Epla5 = '1' and IR(n-13) = '0'
  else "011010" when (Emov = '1' or Ecl = '1') and Epla5 = '1' and IR(n-13) = '1'
  else "01"&IR(n-13)&"000" when not(Emov = '1' or Ecl = '1') and Epla5 = '1'
  -- PLA6
  else Emov & Emov & '1' & Emov & Emov & '0' when Epla6 = '1'
  else baseaddress;   -- this means No operation or a new operation to be done.
    
    
    
END pla_arch;


