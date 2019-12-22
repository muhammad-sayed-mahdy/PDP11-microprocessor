LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY controlUnit IS
    GENERIC ( n : integer := 16; m : integer := 15);
	PORT(   IR                      : IN  std_logic_vector(n-1 DOWNTO 0);
            inControlSignals        : OUT std_logic_vector(m-1 DOWNTO 0);
            outControlSignals       : OUT std_logic_vector(m-1-2 DOWNTO 0);
            readWriteControlSignals : OUT std_logic_vector(1 DOWNTO 0);
            aluSelectors            : OUT std_logic_vector(1 DOWNTO 0));
END ENTITY controlUnit;

ARCHITECTURE cu_arch OF controlUnit IS
BEGIN
END cu_arch;
