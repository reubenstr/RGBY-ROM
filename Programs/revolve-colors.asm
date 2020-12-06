# RGBY-ROM: Revolve / Rotate

L:begin

####################
# both modes cycle phases
# share code to save instructions

# if (mode == 1) goto: phaseIncrement
eq, mode, one
bos, L:phaseIncrement

# index++
adds, index, one
# if (index == 0) phase++
eq, index, zero
bns, L:endCheck

L:phaseIncrement
# phase++
adds, phase, one
# if (phase == 3) phase = 0
li, 3
eq, phase, imm
bns, L:endCheck
mov, phase, zero
L:endCheck
####################


####################
# check input buttons

# check mode button
eq, portIn, one
bns, L:modeCheckEnd
xor, mode, one
mov, mode, result
L:modeCheckEnd

# check speed button
li, 2
eq, portIn, imm
bns, L:speedCheckEnd
xor, speed, one
mov, speed, result
L:speedCheckEnd

# clear portIn per
# CPU requirements
mov, portIn, zero
####################


####################
# route mode

# if (mode == 0)
eq, mode, zero
bos, L:modeRevolve
# else: j, L:modeRotate
####################


####################
# rotate color pattern
L:modeRotate

# set delay
eq, speed, zero
bos, L:speedRotateZero
L:speedRotateOne
delay, 255
delay, 255
L:speedRotateZero
delay, 255

# branch to phases
eq, phase, zero
bos, L:rotateSet0
eq, phase, one
bos, L:rotateSet1

# phases
L:rotateSet2
mov, red, rand
mov, green, rand
mov, blue, zero
j, L:begin

L:rotateSet1
mov, red, rand
mov, green, zero
mov, blue, rand
j, L:begin

L:rotateSet0
mov, red, zero
mov, green, rand
mov, blue, rand
j, L:begin
####################


####################
# revolve color pattern
L:modeRevolve

# set delay
# if (speed == 0)
eq, speed, zero
bos, L:speedZero
L:speedOne
delay, 8
L:speedZero
delay, 4 

# perform shared math
# used in all phases.
li, 255
sub, imm, index
mov, genA, result

# branch to phases
eq, phase, zero
bos, L:phaseZero
eq, phase, one
bos, L:phaseOne

# Phases
L:phaseTwo
sin, green, genA
sin, blue, index
j, L:begin

L:phaseOne
sin, red, genA
sin, green, index
j, L:begin

L:phaseZero
sin, red, index
sin, blue, genA
j, L:begin
####################
