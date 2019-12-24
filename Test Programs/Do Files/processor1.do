add wave -position insertpoint sim:/processor/*
add wave -position insertpoint sim:/processor/controlsignals/mypla/currentAddress
mem load -filltype value -filldata 1101000000000001 -fillradix symbolic /processor/r0/ram(0)    
mem load -filltype value -filldata 0000000000000011 -fillradix symbolic /processor/r0/ram(1)    
mem load -filltype value -filldata 0010000001000000 -fillradix symbolic /processor/r0/ram(2)    
mem load -filltype value -filldata 1100000000000000 -fillradix symbolic /processor/r0/ram(3)    
force -freeze sim:/processor/reset 1 0
run
force -freeze sim:/processor/reset 0 0
force -freeze sim:/processor/mem_clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/clk 0 0, 1 {50 ps} -r 100
run