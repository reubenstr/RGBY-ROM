# RGBY-ROM:  
# Button Input Test

L:begin

# check mode button
eq, portIn, one
bns, L:modeEnd
adds, mode, one
L:modeEnd

delay, 200

# output mode value
mov, portOut, mode

j, L:begin

