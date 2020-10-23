# RGBY-ROM: Revolve / Rotate

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
# if (speed == 3)speed = 0
li, 3
eq, speed, imm
bns, L:speedCheckEnd
mov, speed, zero
L:speedCheckEnd
####################


####################
# set delay

# if (speed == 0)
eq, speed, zero
bos, L:speedZero
eq, speed, one
bos, L:speedOne
# assume speed == 2
# li, 2
# eq, speed, imm
# bos, L:speedTwo

L:speedTwo
delay, 5
L:speedOne
delay, 5
L:speedZero
delay, 5 
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


L:modeRotate
mov, red, rand
mov, green, rand
mov, blue, rand
j,L:begin


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

####################
# Branch to phase
eq, phase, zero
bos, L:phaseZero
eq, phase, one
bos, L:phaseOne
# assum (phase == 2)
# li, 2
# eq, phase, imm
# bos, L:phaseTwo

####################
# Phases


L:phaseTwo
mov, red, zero
li, 255
sub, imm, index
sin, green, result
sin, blue, index
j, L:begin

L:phaseOne
li, 255
sub, imm, index
sin, red, result
sin, green, index
mov, blue, zero
j, L:begin

L:phaseZero
sin, red, index
mov, green, zero
li, 255
sub, imm, index
sin, blue, result
j, L:begin
####################
