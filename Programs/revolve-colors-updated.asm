# RGB ROM: Revolve
L:begin

# check input button
# increment speed if set
eq, inport, one
bns, L:afterButton
adds, speed, one
# if (speed == 3)speed = 0
li, 3
eq, speed, imm
bns, L:afterButton
mov, speed, zero
# increment mode after
# speed cycles back to zero
adds, mode, one
# if (mode == 3) mode = 0
li, 3
eq, mode, imm
bns, L:afterButton
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

# if (index == 0) phase++
eq, index, zero
bns, L:phaseCheck
# phase++
adds, genA, one

# if (phase == 3) phase = 0
li, 3
eq, index, imm
bns, L:phaseCheck
mov, genA, zero

L:phaseCheck
eq, genA, one
bos, L:phaseOne
li, 2
eq, genA, imm
bos, L:phaseTwo

L:phaseZero
mov, red, index
mov, green, zero
li, 255
sub, imm, index
mov, blue, result

L:phaseOne
li, 255
sub, imm, index
mov, red, result
mov, green, index
mov, blue, zero

L:phaseTwo
mov, red, zero
li, 255
sub, imm, index
mov, green, result
mov, blue, index

j, L:begin


