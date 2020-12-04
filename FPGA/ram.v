// Ram block per Lattice userguide:
//http://www.latticesemi.com/~/media/LatticeSemi/Documents/UserManuals/EI/iCEcube2_2013-08_userguide.pdf
/*
module ram (din, addr, write_en, clk, dout);

  input [data_width-1:0] din;
  input [addr_width-1:0] addr;
  input write_en, clk;
  output [data_width-1:0] dout;

  parameter addr_width = 8;
  parameter data_width = 12;

  // Define RAM as an indexed memory array.
  reg [data_width-1:0] mem [(1<<addr_width)-1:0];

  always @(posedge clk)
    begin
      if (write_en) // And control with a write enable.
        mem[(addr)] <= din;
    end
  assign dout = mem[addr];

endmodule

*/

// Memory Usage Guide for iCE40 Devices
// Technical Note TN1250
module ram (din, write_en, waddr, wclk, raddr, rclk, dout);

 parameter addr_width = 8;
 parameter data_width = 12;

 input [addr_width-1:0] waddr, raddr;
 input [data_width-1:0] din;
 input write_en, wclk, rclk;
 output [data_width-1:0] dout;
 reg [data_width-1:0] mem [(1<<addr_width)-1:0] ;

 always @(posedge wclk) // Write memory.
   begin
     if (write_en)
      mem[waddr] <= din; // Using write address bus.
     end

assign dout = mem[raddr];

/*
 always @(posedge rclk) // Read memory.
  begin
    dout <= mem[raddr]; // Using read address bus.
 end
 */

endmodule
