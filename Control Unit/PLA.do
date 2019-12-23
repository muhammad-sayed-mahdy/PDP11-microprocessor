vsim -gui work.pla(pla_arch)

add wave sim:/pla/*
force -freeze sim:/pla/IR 1101000000000001 0
force -freeze sim:/pla/FR 11111 0
force -freeze sim:/pla/baseaddress 110101 0
force -freeze sim:/pla/currentaddress 000000 0
run

force -freeze sim:/pla/currentaddress 110101 0
force -freeze sim:/pla/baseaddress 110110 0
run

force -freeze sim:/pla/currentaddress 110110 0
force -freeze sim:/pla/baseaddress 000000 0
run

force -freeze sim:/pla/IR 1101001000000001 0
run

force -freeze sim:/pla/IR 1101010000000001 0
run

force -freeze sim:/pla/IR 1101110000000001 0
run

force -freeze sim:/pla/IR 1101100000000001 0
run

force -freeze sim:/pla/IR 1101101000000001 0
run

force -freeze sim:/pla/IR 1101111000000001 0
run

force -freeze sim:/pla/IR 1101011000000001 0
run

force -freeze sim:/pla/baseaddress 000111 0
force -freeze sim:/pla/currentaddress 000101 0
run

force -freeze sim:/pla/baseaddress 000010 0
force -freeze sim:/pla/currentaddress 000111 0
run

force -freeze sim:/pla/IR 1101010000000001 0
run

force -freeze sim:/pla/IR 1101110000000001 0
force -freeze sim:/pla/currentaddress 010011 0
run

force -freeze sim:/pla/IR 1101100000001001 0
run

force -freeze sim:/pla/baseaddress 000100 0
force -freeze sim:/pla/currentaddress 000010 0
run

force -freeze sim:/pla/IR 1101100000001001 0
run

force -freeze sim:/pla/IR 1101100000011001 0
run

force -freeze sim:/pla/IR 1101100000101001 0
run

force -freeze sim:/pla/IR 1101100000111001 0
run

force -freeze sim:/pla/IR 1101100000000001 0
run

force -freeze sim:/pla/IR 0101100000001001 0
run

force -freeze sim:/pla/IR 0101100000001001 0
run

force -freeze sim:/pla/IR 0101100000000001 0
run

force -freeze sim:/pla/IR 0101100000011001 0
run

force -freeze sim:/pla/IR 0101100000111001 0
run

force -freeze sim:/pla/currentaddress 001000 0
force -freeze sim:/pla/baseaddress 000000 0
force -freeze sim:/pla/IR 0111100000101001 0
run

force -freeze sim:/pla/IR 0101100000101001 0
run

force -freeze sim:/pla/IR 0101100000100001 0
run

force -freeze sim:/pla/IR 0101100000000001 0
run

force -freeze sim:/pla/currentaddress 110110 0
force -freeze sim:/pla/baseaddress 000000 0
force -freeze sim:/pla/IR 1111100000101001 0
run

force -freeze sim:/pla/IR 1110100000101001 0
run

force -freeze sim:/pla/IR 1111000000100001 0
run

force -freeze sim:/pla/IR 1010000000101001 0
run

force -freeze sim:/pla/IR 1010010000101001 0
run

force -freeze sim:/pla/IR 1010100000101001 0
run

force -freeze sim:/pla/IR 1001100000111001 0
run

force -freeze sim:/pla/IR 1001110000111001 0
run
force -freeze sim:/pla/IR 1001100000001001 0
run

force -freeze sim:/pla/IR 1001100000000001 0
run

force -freeze sim:/pla/IR 1001100000011001 0
run

force -freeze sim:/pla/IR 1001100000111001 0
run

force -freeze sim:/pla/IR 1001110000111001 0
run

force -freeze sim:/pla/IR 1001110000001001 0
run

force -freeze sim:/pla/IR 1001110000000001 0
run

force -freeze sim:/pla/IR 1001110000100001 0
run

force -freeze sim:/pla/IR 1001110000010001 0
run

force -freeze sim:/pla/currentaddress 010101 0
force -freeze sim:/pla/baseaddress 000000 0
run

force -freeze sim:/pla/IR 1011110000011001 0
run

force -freeze sim:/pla/IR 1011110000010001 0
run

force -freeze sim:/pla/IR 1101110000011001 0
run

force -freeze sim:/pla/IR 1101110000010001 0
run

force -freeze sim:/pla/IR 1001110000001001 0
run

force -freeze sim:/pla/IR 1001110000010001 0
run

force -freeze sim:/pla/currentaddress 001110 0
force -freeze sim:/pla/baseaddress 001000 0
force -freeze sim:/pla/IR 1101110000010001 0
run

force -freeze sim:/pla/IR 1001110000010001 0
run