LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY controlUnit IS
    GENERIC ( n : integer := 16; m : integer := 15);
    PORT(   clk                     : IN  std_logic;
            IR                      : IN  std_logic_vector(n-1 DOWNTO 0);
            FR                      : IN  std_logic_vector(4 DOWNTO 0);   -- flag register required for branching decisions in PLA
            interrupt               : IN std_logic;
            inControlSignals        : OUT std_logic_vector(m-1 DOWNTO 0);
            outControlSignals       : OUT std_logic_vector(m-1-2 DOWNTO 0);
            readWriteControlSignals : OUT std_logic_vector(1 DOWNTO 0);
            aluSelectors            : OUT std_logic_vector(1 DOWNTO 0));
END ENTITY controlUnit;

ARCHITECTURE cu_arch OF controlUnit IS

COMPONENT rom IS
GENERIC ( n : integer := 21);
PORT(
    address : IN  std_logic_vector(5 DOWNTO 0);
    dataout : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT DecF1 IS
	PORT (	IR	:	IN std_logic_vector(15 downto 0);
			A	:	IN std_logic_vector(3 downto 0);
			e	:	IN std_logic;
			D	:	OUT  std_logic_vector(12 downto 0));
END COMPONENT;

COMPONENT PLA IS
    GENERIC ( n : integer := 16; m : integer := 6);
	PORT(   IR                      : IN  std_logic_vector(n-1 DOWNTO 0);
	         FR                     : IN std_logic_vector(4 downto 0);
            baseaddress, currentaddress        : IN std_logic_vector(m-1 DOWNTO 0);
            nextaddress       : OUT std_logic_vector(m-1 DOWNTO 0));
END COMPONENT;

COMPONENT DecF2_4 IS
    PORT (	IR	:	IN std_logic_vector(15 downto 0);
            A	:	IN std_logic_vector(6 downto 0);
            e	:	IN std_logic;
            D	:	OUT  std_logic_vector(14 downto 0));
END COMPONENT;

COMPONENT reg IS
    GENERIC ( n : integer := 16);
    PORT( E, Clk,Rst : IN std_logic;
            d : IN std_logic_vector(n-1 DOWNTO 0);
            q : OUT std_logic_vector(n-1 DOWNTO 0));
END COMPONENT;

COMPONENT DecF6 IS
    PORT (	A	:	IN std_logic_vector(1 downto 0);
            e	:	IN std_logic;
            D	:	OUT  std_logic_vector(1 downto 0));
END COMPONENT;

SIGNAL controlEnable    : std_logic;
SIGNAL controlWord      : std_logic_vector(20 downto 0);
SIGNAL newAddress, nextAddress       : std_logic_vector(5 downto 0);
SIGNAL currentAddress   : std_logic_vector(5 downto 0) := "000000";
BEGIN
  
    microMar: reg GENERIC MAP (6) PORT MAP(controlEnable, clk, '0', nextAddress, currentAddress); 
    cw : rom GENERIC MAP (21) PORT MAP (currentAddress, controlWord);
    mypla: PLA GENERIC MAP (16,6) PORT MAP (IR, FR, controlWord(20 downto 15), currentAddress, newAddress);

    controlEnable   <=  '0' WHEN (IR = "1100000000000000")  -- HLT
                    ELSE '1';
                      
    nextAddress <= "111011" when newAddress = "000000" and interrupt = '1'
    else "111010" when newAddress = "111111" and interrupt = '0'
    else newAddress;

    f1 : DecF1 PORT MAP (IR, controlWord(14 downto 11), controlEnable, outControlSignals);

    f2_4 : DecF2_4 PORT MAP (IR, controlWord(10 downto 4), controlEnable, inControlSignals);

    alu : aluSelectors <= controlWord(3 downto 2)   WHEN (controlEnable = '1');

    f6  : DecF6 PORT MAP (controlWord(1 downto 0), controlEnable, readWriteControlSignals);

END cu_arch;
