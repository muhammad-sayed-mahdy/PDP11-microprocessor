LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY zReg IS
    GENERIC ( n : integer := 16);
    PORT( E, Clk, Rst : IN std_logic;
            d : IN std_logic_vector(n-1 DOWNTO 0);
            q : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY zReg;



ARCHITECTURE a_my_nDFF OF zReg IS
BEGIN
        PROCESS (Clk, Rst)
        BEGIN
            IF Rst = '1' THEN
                    q <= (OTHERS=>'0');
            ELSIF falling_edge(Clk) and (E = '1') THEN
                    q <= d;
            END IF;
        END PROCESS;
END a_my_nDFF;

