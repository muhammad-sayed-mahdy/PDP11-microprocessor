LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY processor IS
    GENERIC ( n : integer := 16; m : integer := 15);               --n: register size, m: number of registers
    PORT(   clk, mem_clk   : IN std_logic;  
            reset          : IN std_logic_vector(m-1 DOWNTO 0);
            bidir          : INOUT std_logic_vector(n-1 DOWNTO 0));
END ENTITY processor;

ARCHITECTURE struct OF processor IS
    COMPONENT reg IS
    GENERIC ( n     : integer := 16);
    PORT( E, Clk,Rst   : IN std_logic;
            d       : IN std_logic_vector(n-1 DOWNTO 0);
            q       : OUT std_logic_vector(n-1 DOWNTO 0));
    END COMPONENT;

    COMPONENT tri_state IS
    GENERIC ( n : integer := 16);
    PORT(   E   : IN std_logic;
            I   : IN std_logic_vector(n-1 downto 0);
            O   : OUT std_logic_vector(n-1 downto 0));
    END COMPONENT;

    COMPONENT ram IS
    PORT(   clk     : IN std_logic;
            we      : IN std_logic;
            address : IN  std_logic_vector(n-1 DOWNTO 0);
            datain  : IN  std_logic_vector(n-1 DOWNTO 0);
            dataout : OUT std_logic_vector(n-1 DOWNTO 0));
    END COMPONENT;

    COMPONENT controlUnit IS
    GENERIC ( n : integer := 16);
	PORT(     clk                     : IN  std_logic;
            IR                      : IN  std_logic_vector(n-1 DOWNTO 0);
            FR                      : IN  std_logic_vector(4 DOWNTO 0);   -- flag register required for branching decisions in PLA
            inControlSignals        : OUT std_logic_vector(m-1 DOWNTO 0);
            outControlSignals       : OUT std_logic_vector(m-1-2 DOWNTO 0);
            readWriteControlSignals : OUT std_logic_vector(1 DOWNTO 0);
            aluSelectors            : OUT std_logic_vector(1 DOWNTO 0));
    END COMPONENT;

    COMPONENT alu is
        generic (n :integer := 16);
        port (  A, B                : in std_logic_vector(n-1 downto 0);
                Cin                 : in std_logic;
                Opcode              : in std_logic_vector (4 downto 0);
                F                   : out std_logic_vector (n-1 downto 0);
                Cout, Z, NF, P, O   : out std_logic
        ) ;
    end COMPONENT;
    type reg_arr is array (m-1 downto 0) of std_logic_vector(n-1 downto 0);         

    SIGNAL registerWriteArray   : reg_arr;       --register write data holders (q)

    --TriStates = Cotrol Signals (read: in) (write: out)
    SIGNAL regEnable            : std_logic_vector(m-1 downto 0);   
    SIGNAL tristaterWriteArray  : std_logic_vector(m-1-2 downto 0); --tristate write enable
    SIGNAL tristaterReadWRite   : std_logic_vector(1 downto 0);     --tristate read write memory enable

    SIGNAL sALU     : std_logic_vector(1 downto 0);     --control unit alu selectors
    SIGNAL oALU     : std_logic_vector(n-1 downto 0);   --alu output

    SIGNAL oRAM     :std_logic_vector(n-1 downto 0);   --ram output
    SIGNAL iMDR     :std_logic_vector(n-1 downto 0);   --mdr input (d)
    SIGNAL rom_clk  :std_logic;  --clock used by micro memory address register
--INDEXING
--0     R0
--1     R1
--2     R2
--3     R3
--4     R4
--5     R5
--6     R6
--7     R7
--8     SOURCE
--9     Z
--10    MDR
--11    FR
--12    IR
--13    MAR
--14    Y
BEGIN
    --Register
    createRegisters: FOR i IN m-1-6 DOWNTO 0 GENERATE                                           --SOURCE to R0
        cr: reg PORT MAP ( regEnable(i), clk, reset(i), bidir, registerWriteArray(i));
    END GENERATE createRegisters;
    crz: reg PORT MAP ( regEnable(m-1-5), clk, reset(m-1-5), oALU, registerWriteArray(m-1-5));  --Z
    crmdr: reg PORT MAP ( regEnable(m-1-4), clk, reset(m-1-4), iMDR, registerWriteArray(m-1-4));
    createRegisters2: FOR i IN m-1 DOWNTO m-1-3 GENERATE                                        --Y to FR
        cr2: reg PORT MAP ( regEnable(i), clk, reset(i), bidir, registerWriteArray(i));
    END GENERATE createRegisters2;

    --Enable registers write(out) operations
    writeToBus: FOR i IN m-1-2 DOWNTO 0 GENERATE                                        --IR to R0
        tw: tri_state PORT MAP (tristaterWriteArray(i), registerWriteArray(i), bidir); 
    END GENERATE writeToBus;

    --Ram
    r0: ram PORT MAP (mem_clk, tristaterReadWRite(1), registerWriteArray(13), registerWriteArray(10), oRAM);
    --read in mdr in case of signal read
    iMDR <= oRAM WHEN (tristaterReadWRite(0) = '1')
    ELSE bidir;     

    --Read all control signals
    controlsignals: controlUnit PORT MAP (rom_clk, registerWriteArray(12),  registerWriteArray(m-4)(4 downto 0), regEnable, tristaterWriteArray, tristaterReadWRite, sALU);

    --ALU
    --I would like it to take IR, control store selectors, A(Y), BUS(bidir)...OUTPUT: what should be put in Z
    --This line should work
    --a0: alu PORT MAP (registerWriteArray(12), sALU, registerWriteArray(14), bidir, oALU) 
END struct;
