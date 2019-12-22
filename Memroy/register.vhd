LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY reg IS
    GENERIC ( n : integer := 16);
    PORT( Clk,Rst : IN std_logic;
            d : IN std_logic_vector(n-1 DOWNTO 0);
            q : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY reg;



ARCHITECTURE a_my_nDFF OF reg IS
BEGIN
        PROCESS (Clk,Rst)
        BEGIN
            IF Rst = '1' THEN
                    q <= (OTHERS=>'0');
            ELSIF (rising_edge(Clk)) and (d(0) /= 'Z') THEN
                    q <= d;
            END IF;
        END PROCESS;
END a_my_nDFF;

