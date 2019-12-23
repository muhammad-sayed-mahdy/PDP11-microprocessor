LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY DecF1 IS
	PORT (	IR	:	IN std_logic_vector(15 downto 0);		-- IR
			A	:	IN std_logic_vector(3 downto 0);		-- input
			e	:	IN std_logic;							-- enable
			D	:	OUT  std_logic_vector(12 downto 0));   -- output
END ENTITY DecF1;


ARCHITECTURE mix OF DecF1 IS

COMPONENT Dec IS
	GENERIC(m : integer := 4;
			n : integer := 16);
	PORT (	A	:	IN std_logic_vector(m-1 downto 0);
			e	:	IN std_logic;
			D	:	OUT  std_logic_vector(n-1 downto 0));
END COMPONENT;

SIGNAL se, de	:	std_logic;	-- Rsrc,Rdst enables

SIGNAL rsrcout, rdstout	:	std_logic_vector(7 downto 0);	-- Rsrc,Rdst outputs

BEGIN

	se <= '1' WHEN (E = '1' and A = "0100")
		ELSE '0';

	de <= '1' WHEN (E = '1' and A = "0101")
		ELSE '0';
	

	src: Dec GENERIC MAP (m => 3, n => 8)
			PORT MAP (IR(8 downto 6), se, rsrcout);

	dst: Dec GENERIC MAP (m => 3, n => 8)
			PORT MAP (IR(2 downto 0), de, rdstout);

	
	D(7 downto 0)	<=		"01000000"	WHEN	(E = '1' and A = "1000")	-- SP
					ELSE	"10000000"	WHEN	(E = '1' and A = "0001")	-- PC
					ELSE	rsrcout		WHEN	(E = '1' and A = "0100")	-- Rsrc
					ELSE	rdstout		WHEN	(E = '1' and A = "0101")	-- Rdst
					ELSE	"00000000";
					
	D(12 downto 8)	<=		"00001"	WHEN	(E = '1' and A = "0110")	-- SRC
					ELSE	"00010"	WHEN	(E = '1' and A = "0011")	-- Z
					ELSE	"00100"	WHEN	(E = '1' and A = "0010")	-- MDR
					ELSE	"01000"	WHEN	(E = '1' and A = "0111")	-- FR
					ELSE	"10000"	WHEN	(E = '1' and A = "1001")	-- IR
					ELSE	"00000";

END mix;
