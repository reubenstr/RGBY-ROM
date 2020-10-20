# RGBY-ROM: Revolve / Rotate

L:begin
#############
# check input button
# increment speed if set
eq, inport, one
bns, L:setDelay
adds, speed, one
# if (speed == 3)speed = 0
li, 3
eq, speed, imm
bns, L:setDelay
mov, speed, zero
# increment mode after
# speed cycles back to zero
adds, mode, one
# if (mode == 2) mode = 0
li, 2
eq, mode, imm
bns, L:setDelay
mov, mode, zero
#############


L:setDelay
#############
eq, mode, zero
bns, L:nextDelay0
delay, 50
j, L:checkMode

L:nextDelay0
eq, mode, one
bns, L:nextDelay1
delay, 50
j, L:checkMode

L:nextDelay1
li, 2
eq, mode, imm
bns, L:checkMode
delay, 50
#############


L:checkMode
# check mode
#############
# if (mode == 0)
eq, mode, zero
bos, L:modeRotate
# else if (mode == 1)
j, L:modeRevolve
#############


L:modeRotate
#############
mov, red, rand
mov, green, rand
mov, blue, rand
j, L:begin
#############


L:modeRevolve
#############
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
#############


