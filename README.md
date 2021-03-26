# RGBY-ROM

<img src="https://github.com/reubenstr/RGBY-ROM/blob/main/images/RGBY-ROM-collage-set.jpg" alt="" width="640">

RGBY-ROM reads data cartridges comprised of red, green, blue, and yellow acrylic squares where each square acts as 2 bits of program data. 

<img src="https://github.com/reubenstr/RGBY-ROM/blob/main/images/RGBY-ROM-block-diagram-and-datapath.png" alt="" width="640">

The the program is then excuted on a custom simple CPU architecture instantiated on a FPGA to control a RGB LED and 8 LED indicators.

<img src="https://github.com/reubenstr/RGBY-ROM/blob/main/images/RGBY-ROM-assembler-screenshot.png" alt="" width="640"> 

The executed program is assembled using a custom assembler to create the data cartridge's color pattern.



RGBY-ROM uses the TinyFPGA Bx as the FPGA board.

The TinyFPGA uses the ATOM IDE with the APIO extension.

The HDL is Verilog.

The creator of TinyFPGA provide the following get started user guild: https://tinyfpga.com/bx/guide.html

Blog post: https://metaphasiclabs.com/rgby-rom-custom-fpga-retro-cpu/
