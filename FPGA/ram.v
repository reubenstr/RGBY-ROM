// Based on "Memory Usage Guide for iCE40 Devices" Technical Note TN1250
// Modified to have memory out as continuous assignment.
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

endmodule
