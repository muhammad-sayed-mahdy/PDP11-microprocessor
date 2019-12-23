LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;

--Control Store
ENTITY rom IS
	GENERIC ( n : integer := 21);
	PORT(
		address : IN  std_logic_vector(5 DOWNTO 0);
		dataout : OUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY rom;

ARCHITECTURE rom_arch OF rom IS

	TYPE rom_type IS ARRAY(0 TO 63) OF std_logic_vector(n-1 DOWNTO 0);
	SIGNAL rom : rom_type := (others => (others=>'1'));
	BEGIN
		dataout <= rom(to_integer(unsigned(address)));
END rom_arch;
