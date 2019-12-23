LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY DecF6 IS
	PORT (	A	:	IN std_logic_vector(1 downto 0);		-- input
			e	:	IN std_logic;							-- enable
			D	:	OUT  std_logic_vector(1 downto 0));   -- output
END ENTITY DecF6;


ARCHITECTURE mix OF DecF6 IS

BEGIN

    D   <=  not A  WHEN (E = '1' and (A(1) xor A(0)) = '1')
        ELSE    "00";

END mix;
