// Hard-coded RAM containing program for development purposes.
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
 (addr == 0) ? 12'h0F9 :
 (addr == 1) ? 12'h090 :
 (addr == 2) ? 12'h9F1 :
 (addr == 3) ? 12'hE09 :
 (addr == 4) ? 12'h5D1 :
 (addr == 5) ? 12'hB03 :
 (addr == 6) ? 12'h9D4 :
 (addr == 7) ? 12'hE09 :
 (addr == 8) ? 12'h0D0 :
 (addr == 9) ? 12'hB02 :
 (addr == 10) ? 12'h9F4 :
 (addr == 11) ? 12'hE11 :
 (addr == 12) ? 12'h5B1 :
 (addr == 13) ? 12'hB03 :
 (addr == 14) ? 12'h9B4 :
 (addr == 15) ? 12'hE11 :
 (addr == 16) ? 12'h0B0 :
 (addr == 17) ? 12'h9B0 :
 (addr == 18) ? 12'hD17 :
 (addr == 19) ? 12'h9B1 :
 (addr == 20) ? 12'hD16 :
 (addr == 21) ? 12'hC32 :
 (addr == 22) ? 12'hC32 :
 (addr == 23) ? 12'hC32 :
 (addr == 24) ? 12'h9D0 :
 (addr == 25) ? 12'hD21 :
 (addr == 26) ? 12'h9D1 :
 (addr == 27) ? 12'hD34 :
 (addr == 28) ? 12'hB07 :
 (addr == 29) ? 12'h142 :
 (addr == 30) ? 12'h813 :
 (addr == 31) ? 12'h083 :
 (addr == 32) ? 12'hF00 :
 (addr == 33) ? 12'h5A1 :
 (addr == 34) ? 12'hB07 :
 (addr == 35) ? 12'hA4A :
 (addr == 36) ? 12'hE2B :
 (addr == 37) ? 12'h0A0 :
 (addr == 38) ? 12'h9C0 :
 (addr == 39) ? 12'hD2A :
 (addr == 40) ? 12'h0C0 :
 (addr == 41) ? 12'hF2B :
 (addr == 42) ? 12'h0C1 :
 (addr == 43) ? 12'h0EA :
 (addr == 44) ? 12'h9C1 :
 (addr == 45) ? 12'hE31 :
 (addr == 46) ? 12'hB07 :
 (addr == 47) ? 12'h64E :
 (addr == 48) ? 12'h0E3 :
 (addr == 49) ? 12'h81E :
 (addr == 50) ? 12'h083 :
 (addr == 51) ? 12'hF00 :
 (addr == 52) ? 12'h5A1 :
 (addr == 53) ? 12'h08A :
 (addr == 54) ? 12'hF00 :
 (addr == 55) ? 12'h000 :
 (addr == 56) ? 12'h0 :
	0;
endmodule
