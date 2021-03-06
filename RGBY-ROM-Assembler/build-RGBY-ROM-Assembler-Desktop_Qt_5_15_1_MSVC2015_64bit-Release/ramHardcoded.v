// Hard coded RAM containing program for development purposes
   module ramHardcoded (din, addr, write_en, clk, dout);
   parameter addr_width = 8;
   parameter data_width = 12;
   input [addr_width-1:0] addr;
   input [data_width-1:0] din;
   input write_en, clk;
   output [data_width-1:0] dout;
   reg [data_width-1:0] mem [(1<<addr_width)-1:0];
   // Define RAM as an indexed memory array.

   always @(posedge clk) // Control with a clock edge.
     begin
       if (write_en) begin// And control with a write enable.
         mem[(addr)] <= din;
     end
     end

assign dout = 
 (addr == 0) ? 12'h991 :
 (addr == 1) ? 12'hE07 :
 (addr == 2) ? 12'h6D1 :
 (addr == 3) ? 12'hB03 :
 (addr == 4) ? 12'h9D4 :
 (addr == 5) ? 12'hE07 :
 (addr == 6) ? 12'h0B0 :
 (addr == 7) ? 12'hC64 :
 (addr == 8) ? 12'hF10 :
 (addr == 9) ? 12'h9D0 :
 (addr == 10) ? 12'hD10 :
 (addr == 11) ? 12'h9D1 :
 (addr == 12) ? 12'hD22 :
 (addr == 13) ? 12'hB02 :
 (addr == 14) ? 12'h9D4 :
 (addr == 15) ? 12'hD25 :
 (addr == 16) ? 12'h6A1 :
 (addr == 17) ? 12'hB08 :
 (addr == 18) ? 12'hE14 :
 (addr == 19) ? 12'h0A0 :
 (addr == 20) ? 12'h9C0 :
 (addr == 21) ? 12'hD18 :
 (addr == 22) ? 12'h0C0 :
 (addr == 23) ? 12'hF19 :
 (addr == 24) ? 12'h0C1 :
 (addr == 25) ? 12'h0EA :
 (addr == 26) ? 12'h9C1 :
 (addr == 27) ? 12'hE1f :
 (addr == 28) ? 12'hB07 :
 (addr == 29) ? 12'h74E :
 (addr == 30) ? 12'h03E :
 (addr == 31) ? 12'hA1E :
 (addr == 32) ? 12'h083 :
 (addr == 33) ? 12'hF00 :
 (addr == 34) ? 12'h6A1 :
 (addr == 35) ? 12'h08A :
 (addr == 36) ? 12'hF00 :
 (addr == 37) ? 12'h082 :
 (addr == 38) ? 12'hF00 :
 (addr == 39) ? 12'h000 :
 (addr == 40) ? 12'h0 :
	0;
endmodule
