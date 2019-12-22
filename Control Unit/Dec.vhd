LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.numeric_std.all;

ENTITY Dec IS
	GENERIC(m : integer := 4;
			n : integer := 16);
	PORT (	A	:	IN std_logic_vector(m-1 downto 0);
			e	:	IN std_logic;
			D	:	OUT  std_logic_vector(n-1 downto 0));   
END ENTITY Dec;


ARCHITECTURE mix OF Dec IS

BEGIN

	D	<= 		(to_integer(unsigned(A)) => '1', others => '0')	WHEN (E = '1')
		ELSE	(others => '0');		

END mix;
