# test button debounce
# test button masking

L:begin

# check mode button
eq, portIn, one
bns, L:modeEnd
adds, mode, one
L:modeEnd

mov, portOut, mode

j, L:begin