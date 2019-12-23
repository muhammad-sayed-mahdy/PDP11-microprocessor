add wave sim:/alucontroller/*

#CMP
force -freeze sim:/alucontroller/IR 0111000000000000 0
force -freeze sim:/alucontroller/A 16'h0f0f 0
force -freeze sim:/alucontroller/B 16'h001f 0
force -freeze sim:/alucontroller/Cin 0 0
run
force -freeze sim:/alucontroller/Cin 1 0
run

#ADD
force -freeze sim:/alucontroller/controlS 00 0
run

#INC
force -freeze sim:/alucontroller/controlS 01 0
run

#DEC
force -freeze sim:/alucontroller/controlS 10 0
run

#Operation
force -freeze sim:/alucontroller/controlS 11 0

#branching (pass byte)
force -freeze sim:/alucontroller/IR 1011000000000000 0
run
force -freeze sim:/alucontroller/A 16'h0f3a 0
run

#ADC (two operands)
force -freeze sim:/alucontroller/IR 0001000000000000 0
run

#INV (one operand)
force -freeze sim:/alucontroller/IR 1000011000000000 0
run

#CLR 
force -freeze sim:/alucontroller/IR 1001110000000000 0
run