# RGBY-ROM: LED Patterns

L:begin

# delay
delay, 100

#############
# check mode button
eq, portIn, one
bns, L:modeEnd
adds, mode, one
# if (mode == 3)mode = 0
li, 3
eq, mode, imm
bns, L:modeEnd
mov, mode, zero
L:modeEnd
#############


#############
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
bos, L:modeRand
#############


#############
# Kit LED pattern
L:modeKit

# index++
adds, index, one

# if (index == 8) index = 0
li, 8
eq, index, imm
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
#############



#############
# Count up LED pattern
L:modeCount
adds, genA, one
mov, portOut, genA
j, L:begin
#############


#############
# Random LED pattern
L:modeRand
mov, portOut, rand
j, L:begin
#############



