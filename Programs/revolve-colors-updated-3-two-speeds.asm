# RGBY-ROM: Revolve / Rotate

L:begin
#############
# check input button
# increment speed if set
eq, inport, one
bns, L:checkMode
adds, speed, one
# if (speed == 3)speed = 0
li, 3
eq, speed, imm
bns, L:checkMode
mov, speed, zero
# increment mode after
# speed cycles back to zero
adds, mode, one
# if (mode == 2) mode = 0
li, 2
eq, mode, imm
bns, L:checkMode
mov, mode, zero
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
# Set delay
eq, mode, zero
bns, L:nextRotateDelay
delay, 50
j, L:performRotate
L:nextRotateDelay
eq, mode, one
bns, L:performRotate
delay, 100

L:performRotate

mov, red, rand
mov, green, rand
mov, blue, rand

mov, porta, zero
j, L:begin
#############


L:modeRevolve
#############
# Set delay
eq, mode, zero
bns, L:nextRevolveDelay
delay, 5
j, L:performRevolve
L:nextRevolveDelay
eq, mode, one
bns, L:performRotate
delay, 10

L:performRevolve

# index++
adds, index, one
mov, porta, index

# if (index == 0) phase++
eq, index, zero
bns, L:phaseCheck
# phase++
adds, phase, one

# if (phase == 3) phase = 0
li, 3
eq, index, imm
bns, L:phaseCheck
mov, phase, zero

# Branch to phase
L:phaseCheck
eq, phase, one
bos, L:phaseOne
li, 2
eq, phase, imm
bos, L:phaseTwo

# Phases

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

