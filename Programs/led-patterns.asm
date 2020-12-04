# RGBY-ROM: LED Patterns
# 3 patterns
# 3 speeds

L:begin

####################
# check input buttons

# save portIn state
mov, genB, portIn

# clear portIn per
# CPU requirements
mov, portIn, zero

# check mode button
# if (mode pressed) mode++
eq, genB, one
bns, L:modeCheckEnd
adds, mode, one
# if (mode == 3)mode = 0
li, 3
eq, mode, imm
bns, L:modeCheckEnd
mov, mode, zero
L:modeCheckEnd

# check speed button
# if (speed pressed) speed++
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
# if (speed == 1)
eq, speed, one
bos, L:speedOne
# if speed == 2
li, 2
eq, speed, imm
bos, L:speedTwo


L:speedTwo
delay, 50
L:speedOne
delay, 50
L:speedZero
delay, 50 
####################


####################
# route mode

# if (mode == 0)
eq, mode, zero
bos, L:modeKit

# if (mode == 1)
eq, mode, one
bos, L:modeCount

# if (mode == 2)
li, 2
eq, mode, imm
bos, L:modeSparkle
####################


####################
# Sparkle LED pattern
L:modeSparkle
li, 7
and, imm, rand
shift, one, result
mov, portOut, result
j, L:begin
####################


####################
# Kit LED pattern
L:modeKit

# index++
adds, index, one

# if (index > 7) index = 0
li, 7
slt, imm, index
bns, L:endPhaseToggle
mov, index, zero

# toggle phase
# phase = !phase
eq, phase, zero
bos, L:phaseSetOne
mov, phase, zero
j, L:endPhaseToggle
L:phaseSetOne
mov, phase, one
L:endPhaseToggle

# Opposite direction
# if (phase == 1) 
# genA = 7 - genA
mov, genA, index
eq, phase, one
bns, L:shiftPort
li, 7
sub, imm, genA
mov, genA, result

# Shift LED position
L:shiftPort
shift, one, genA
mov, portOut, result

j, L:begin
####################


####################
# Count up LED pattern
L:modeCount
adds, index, one
mov, portOut, index
j, L:begin
####################




