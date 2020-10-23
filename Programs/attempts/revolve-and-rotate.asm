# RGBY-ROM: Revolve / Rotate
# Program may overflow max instructions.
# rotate requires more color selection
# modifications.

L:begin

####################
# check input buttons

# save portIn state
mov, genB, portIn

# clear portIn per
# CPU requirements
mov, portIn, zero

# check mode button
eq, genB, one
bns, L:modeCheckEnd
adds, mode, one
# if (mode > 1)mode = 0
slt, one, mode
bns, L:modeCheckEnd
mov, mode, zero
L:modeCheckEnd

# check speed button
li, 2
eq, genB, imm
bns, L:speedCheckEnd
adds, speed, one
# if (speed > 1)speed = 0
slt, one, speed
bns, L:speedCheckEnd
mov, speed, zero
L:speedCheckEnd
####################


####################
# set delay

# if (mode == 0)
eq, mode, zero
bos, L:speedRevolve

# if mode is rotate
L:speedRotate
delay, 100
# if (speed == 1)
eq, speed, one
bns, L:speedEnd
delay, 100
j, L:speedEnd

# if mode is revolve
L:speedRevolve
delay, 5
# if (speed == 1)
eq, speed, one
bns, L:speedEnd
delay, 5

L:speedEnd
####################


####################
# route mode

# if (mode == 0)
eq, mode, zero
bos, L:modeRevolve

# assume mode == 1
# if (mode == 1)
# eq, mode, one
# bos, L:modeRotate
####################


####################
# rotate color pattern
L:modeRotate
mov, red, rand
mov, green, rand
mov, blue, rand
j,L:begin
####################


####################
# revolve color pattern
# index++
L:modeRevolve
adds, index, one

# if (index == 0) phase++
eq, index, zero
bns, L:endCheck
# phase++
adds, phase, one

# if (phase == 3) phase = 0
li, 3
eq, phase, imm
bns, L:endCheck
mov, phase, zero
L:endCheck

# load comparison imm
# prior to phase jump
li, 255

####################
# Branch to phase
eq, phase, zero
bos, L:phaseZero
eq, phase, one
bos, L:phaseOne
# assum phase two
# li, 2
# eq, phase, imm
# bos, L:phaseTwo

####################
# Phases

L:phaseTwo
mov, red, zero
sub, imm, index
mov, green, result
mov, blue, index
j, L:begin

L:phaseOne
sub, imm, index
mov, red, result
mov, green, index
mov, blue, zero
j, L:begin

L:phaseZero
mov, red, index
mov, green, zero
sub, imm, index
mov, blue, result
j, L:begin
####################

