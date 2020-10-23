# test portOut

L:begin

li, 1
mov, portOut, imm
delay, 100

li, 2
mov, portOut, imm
delay, 100

li, 4
mov, portOut, imm
delay, 100

li, 8
mov, portOut, imm
delay, 100

li, 16
mov, portOut, imm
delay, 100

li, 32
mov, portOut, imm
delay, 100

li, 64
mov, portOut, imm
delay, 100

li, 128
mov, portOut, imm
delay, 100

j, L:begin