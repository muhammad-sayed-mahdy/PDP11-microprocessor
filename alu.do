add wave sim:/alu/*

# Arithmetic
force -freeze sim:/alu/Opcode(4 downto 2) 100 0

# Cin = 0
force -freeze sim:/alu/Cin 0 0

force -freeze sim:/alu/A 16'h0F1F 0
force -freeze sim:/alu/B 16'h00F0 0

force -freeze sim:/alu/Opcode(2 downto 0) 000 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 001 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 010 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 011 0
run
force -freeze sim:/alu/Opcode(4 downto 2) 011 0
force -freeze sim:/alu/Opcode(2 downto 0) 100 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 101 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 110 0
run


# Cin = 1
force -freeze sim:/alu/Cin 1 0
force -freeze sim:/alu/Opcode(4 downto 2) 100 0
force -freeze sim:/alu/Opcode(2 downto 0) 000 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 001 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 010 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 011 0
run
force -freeze sim:/alu/Opcode(4 downto 2) 011 0
force -freeze sim:/alu/Opcode(2 downto 0) 100 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 101 0
run
force -freeze sim:/alu/Opcode(2 downto 0) 110 0
run


#Logic

force -freeze sim:/alu/A 16'h0F0F 0
force -freeze sim:/alu/B 16'h000A 0

force -freeze sim:/alu/Opcode(4 downto 2) 101 0

force -freeze sim:/alu/Opcode(1 downto 0) 00 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 01 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 10 0
run
force -freeze sim:/alu/Opcode 00011 0
run

#shift right

force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/Opcode(4 downto 2) 001 0

force -freeze sim:/alu/Opcode(1 downto 0) 00 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 01 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 10 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 11 0
run

force -freeze sim:/alu/Cin 1 0
force -freeze sim:/alu/Opcode(1 downto 0) 00 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 01 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 10 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 11 0
run


#shift left

force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/Opcode(4 downto 2) 010 0

force -freeze sim:/alu/Opcode(1 downto 0) 00 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 01 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 10 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 11 0
run

force -freeze sim:/alu/Cin 1 0
force -freeze sim:/alu/Opcode(1 downto 0) 00 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 01 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 10 0
run
force -freeze sim:/alu/Opcode(1 downto 0) 11 0
run

#subtraction to check flags
force -freeze sim:/alu/Opcode 10010 0
force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/A 16'h0000 0
force -freeze sim:/alu/B 16'h0000 0
run
force -freeze sim:/alu/A 16'h0000 0
force -freeze sim:/alu/B 16'h0001 0
run
force -freeze sim:/alu/A 16'h0001 0
force -freeze sim:/alu/B 16'h0000 0
run
force -freeze sim:/alu/A 16'h0001 0
force -freeze sim:/alu/B 16'h0001 0
run

force -freeze sim:/alu/Opcode 10011 0
force -freeze sim:/alu/Cin 1 0
force -freeze sim:/alu/A 16'h0000 0
force -freeze sim:/alu/B 16'h0000 0
run
force -freeze sim:/alu/A 16'h0000 0
force -freeze sim:/alu/B 16'h0001 0
run
force -freeze sim:/alu/A 16'h0001 0
force -freeze sim:/alu/B 16'h0000 0
run
force -freeze sim:/alu/A 16'h0001 0
force -freeze sim:/alu/B 16'h0001 0
run

#check overflow flag
force -freeze sim:/alu/Opcode 10000 0
force -freeze sim:/alu/Cin 0 0
force -freeze sim:/alu/A 16'hFFFF 0
force -freeze sim:/alu/B 16'h0001 0
run
force -freeze sim:/alu/A 16'h0001 0
force -freeze sim:/alu/B 16'hFFFF 0
run
force -freeze sim:/alu/A 16'h8000 0
force -freeze sim:/alu/B 16'h8000 0
run
force -freeze sim:/alu/A 16'h7FFF 0
force -freeze sim:/alu/B 16'h7FFF 0
run