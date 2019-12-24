mov #1, R0
mov #1, R1
mov R1, R2
mov #10, R3
add R1, R2
mov R1, R0
mov R2, R1
mov R0, R2
dec R3
cmp #0, R3
bne -7
hlt