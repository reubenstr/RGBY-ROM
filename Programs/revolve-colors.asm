# RGB ROM: Revolve
L:begin

# check speed button
# increment speed if set

and, inport, one
eq, result, one
bns, L:afterButton
adds, speed, one

# if (speed == 3): speed = 0
li, 3
eq, speed, imm
bos, L:afterButton
mov, speed, zero
# increment mode after
# speed cycles back to zero
adds, mode, one
# if (mode == 3): speed = 0
li, 3
eq, mode, imm
bos, L:afterButton
mov, mode, zero

L:afterButton


# set delay
# TODO


# check mode
# if (mode == 0)
eq, mode, zero
bos, L:modeRotate
# else if (mode == 1)


L:modeRotate
mov, red, rand
mov, green, rand
mov, blue, rand
j, L:begin


L:modeRevolve
# index++
adds, index, one

# if (index > 195)
# index = 0
li, 195
slt, index, imm
bos, L:pIndex
mov, index, zero
L:pIndex

# if (index < 65)
li, 85
slt, index, imm
bns, L:checkgreen
adds, red, one
mov, green, index
mov, blue, zero
j, L:begin

# else if (index < 130)
L:checkgreen
li, 130
slt, index, imm
bns, L:checkblue
mov, red, zero
sub, imm, index
mov, green, result
li, 65
sub, index, imm
mov, blue, result
j, L:begin

# else(index >= 130)
L:checkblue
li, 130
sub, index, imm
mov, red, result
mov, green, zero
li, 195
sub, imm, index
mov, blue, result
j, L:begin
