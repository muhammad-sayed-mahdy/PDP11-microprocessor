LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY DecF2_4 IS
	PORT (	IR	:	IN std_logic_vector(15 downto 0);		-- IR
			A	:	IN std_logic_vector(6 downto 0);		-- input
			e	:	IN std_logic;							-- enable
			D	:	OUT  std_logic_vector(14 downto 0));   -- output
END ENTITY DecF2_4;


ARCHITECTURE mix OF DecF2_4 IS

COMPONENT Dec IS
	GENERIC(m : integer := 4;
			n : integer := 16);
	PORT (	A	:	IN std_logic_vector(m-1 downto 0);		
			e	:	IN std_logic;							
			D	:	OUT  std_logic_vector(n-1 downto 0));	
END COMPONENT;

SIGNAL f2 : std_logic_vector(2 downto 0);
SIGNAL f3, f4 : std_logic_vector(1 downto 0);

SIGNAL se, de	:	std_logic;	-- Rsrc,Rdst enables

SIGNAL rsrcout, rdstout	:	std_logic_vector(7 downto 0);	-- Rsrc,Rdst outputs

BEGIN

	f2 <= A(6 downto 4);
	f3 <= A(3 downto 2);
	f4 <= A(1 downto 0);

	se <= '1' WHEN (E = '1' and f2 = "100")
		ELSE '0';

	de <= '1' WHEN (E = '1' and f2 = "101")
		ELSE '0';
	

	src: Dec GENERIC MAP (m => 3, n => 8)
			PORT MAP (IR(8 downto 6), se, rsrcout);

	dst: Dec GENERIC MAP (m => 3, n => 8)
			PORT MAP (IR(2 downto 0), de, rdstout);

	
	D(7 downto 0)	<=		"01000000"	WHEN	(E = '1' and F2 = "110")	-- SP
					ELSE	"10000000"	WHEN	(E = '1' and F2 = "001")	-- PC
					ELSE	rsrcout		WHEN	(E = '1' and F2 = "100")	-- Rsrc
					ELSE	rdstout		WHEN	(E = '1' and F2 = "101")	-- Rdst
					ELSE	"00000000";
					
	D(8)	<=	'1'	WHEN	(E = '1' and f4 = "10")		-- SRC
			ELSE	'0';
					
	D(9)	<=	'1'	WHEN	(E = '1' and f2 = "011")	-- Z
			ELSE	'0';
					
	D(10)	<=	'1'	WHEN	(E = '1' and f3 = "10")		-- MDR
			ELSE	'0';
					
	D(11)	<=	'1'	WHEN	(E = '1' and f2 = "111")	-- FR
			ELSE	'0';
					
	D(12)	<=	'1'	WHEN	(E = '1' and f2 = "010")	-- IR
			ELSE	'0';
					
	D(13)	<=	'1'	WHEN	(E = '1' and f3 = "01")		-- MAR
			ELSE	'0';
					
	D(14)	<=	'1'	WHEN	(E = '1' and f4 = "01")		-- Y
			ELSE	'0';

END mix;
