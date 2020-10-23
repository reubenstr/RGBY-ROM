# Generate a Verilog sin table module.

import math

SAMPLES = 256
OUTMAX = 255
print("module sinTable(")
print("input [7:0] in,")
print("output [7:0] out);")
print("")
print("assign out = ")

for sample in range(SAMPLES):
    
    angle = (sample * 180) / SAMPLES -90
    sine = math.sin(math.radians(angle))    
    rescaled = int(round(((sine + 1) * OUTMAX ) / 2.0))
    print ("\t(in == %d) ? %d : "  % (sample, rescaled));
    
print("\t0;")
print("endmodule")