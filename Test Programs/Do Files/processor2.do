add wave -position insertpoint sim:/processor/*
add wave -position insertpoint sim:/processor/controlsignals/mypla/*
mem load -filltype value -filldata 1101001000000001 -fillradix symbolic /processor/r0/ram(0)    
#MOV @(R0), R1
mem load -filltype value -filldata 0111000000000000 -fillradix symbolic /processor/r0/ram(1)    
#CMP R0, R0
mem load -filltype value -filldata 1011000000000001 -fillradix symbolic /processor/r0/ram(2)    
#BLS 1
mem load -filltype value -filldata 1100000000000000 -fillradix symbolic /processor/r0/ram(3)    
#HLT
mem load -filltype value -filldata 0111000001000000 -fillradix symbolic /processor/r0/ram(4)    
#CMP R1, R0
mem load -filltype value -filldata 1010110000000001 -fillradix symbolic /processor/r0/ram(5)    
#BLO 1
mem load -filltype value -filldata 1100000000000000 -fillradix symbolic /processor/r0/ram(6)    
#HLT
mem load -filltype value -filldata 0110000001001000 -fillradix symbolic /processor/r0/ram(7)    
#XNOR R1, @(R0)
mem load -filltype value -filldata 1100000000000000 -fillradix symbolic /processor/r0/ram(8)    
#HLT
force -freeze sim:/processor/reset 1 0
run
force -freeze sim:/processor/reset 0 0
force -freeze sim:/processor/mem_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/clk 0 0, 1 {50 ps} -r 100
run