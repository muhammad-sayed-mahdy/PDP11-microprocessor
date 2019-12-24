mov #1, R0
mov #1, R1
mov R1, R2
mov #0, R3
add R0, R2
mov R1, R0
mov R2, R1
inc R3
cmp R3, #10
bne -7
hlt