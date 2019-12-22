LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY tri_state IS
    GENERIC ( n : integer := 16);
    PORT(   E   : IN std_logic;
            I   : IN std_logic_vector(n-1 downto 0);
            O   : OUT std_logic_vector(n-1 downto 0));
END ENTITY tri_state;



ARCHITECTURE arch1 OF tri_state IS
BEGIN
    O <= I WHEN E = '1'
    ELSE (OTHERS=>'Z');
END arch1;


