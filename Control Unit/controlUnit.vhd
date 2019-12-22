LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY controlUnit IS
    GENERIC ( n : integer := 16; m : integer := 15);
    PORT(   IR                      : IN  std_logic_vector(n-1 DOWNTO 0);
            controlWord             : IN  std_logic_vector(20 downto 0);
            inControlSignals        : OUT std_logic_vector(m-1 DOWNTO 0);
            outControlSignals       : OUT std_logic_vector(m-1-2 DOWNTO 0);
            readWriteControlSignals : OUT std_logic_vector(1 DOWNTO 0);
            aluSelectors            : OUT std_logic_vector(1 DOWNTO 0));
END ENTITY controlUnit;

ARCHITECTURE cu_arch OF controlUnit IS

COMPONENT DecF1 IS
	PORT (	IR	:	IN std_logic_vector(15 downto 0);
			A	:	IN std_logic_vector(3 downto 0);
			e	:	IN std_logic;
			D	:	OUT  std_logic_vector(12 downto 0));
END COMPONENT;

COMPONENT DecF2_4 IS
    PORT (	IR	:	IN std_logic_vector(15 downto 0);
            A	:	IN std_logic_vector(6 downto 0);
            e	:	IN std_logic;
            D	:	OUT  std_logic_vector(14 downto 0));
END COMPONENT;

COMPONENT DecF6 IS
    PORT (	A	:	IN std_logic_vector(1 downto 0);
            e	:	IN std_logic;
            D	:	OUT  std_logic_vector(1 downto 0));
END COMPONENT;

SIGNAL controlEnable : std_logic;

BEGIN

    -- controlWord either input or signal from rom component
    -- controlEnable is always 1 (unless HLT ?)

    controlEnable <= '1';

    f1 : DecF1 PORT MAP (IR, controlWord(14 downto 11), controlEnable, outControlSignals);

    f2_4 : DecF2_4 PORT MAP (IR, controlWord(10 downto 4), controlEnable, inControlSignals);

    alu : aluSelectors <= controlWord(3 downto 2)   WHEN (controlEnable = '1');

    f6  : DecF6 PORT MAP (controlWord(1 downto 0), controlEnable, readWriteControlSignals);

END cu_arch;
