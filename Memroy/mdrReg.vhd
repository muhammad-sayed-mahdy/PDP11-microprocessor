LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mdrReg IS
    GENERIC ( n : integer := 16);
    PORT( E, Clk1, Clk2, Rst : IN std_logic;
            d : IN std_logic_vector(n-1 DOWNTO 0);
            q : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY mdrReg;



ARCHITECTURE a_my_nDFF OF mdrReg IS
BEGIN
        PROCESS (Clk1, Clk2, Rst)
        BEGIN
            IF Rst = '1' THEN
                    q <= (OTHERS=>'0');
            ELSIF (rising_edge(Clk1) OR falling_edge(Clk2)) and (E = '1') THEN
                    q <= d;
            END IF;
        END PROCESS;
END a_my_nDFF;

