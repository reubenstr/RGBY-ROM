// Hard coded RAM containing program for development purposes
// 2020-12-05T18:09:54
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
 (addr == 0) ? 12'h9D1 :
 (addr == 1) ? 12'hD05 :
 (addr == 2) ? 12'h5A1 :
 (addr == 3) ? 12'h9A0 :
 (addr == 4) ? 12'hE0A :
 (addr == 5) ? 12'h5C1 :
 (addr == 6) ? 12'hB03 :
 (addr == 7) ? 12'h9C4 :
 (addr == 8) ? 12'hE0A :
 (addr == 9) ? 12'h0C0 :
 (addr == 10) ? 12'h991 :
 (addr == 11) ? 12'hE0E :
 (addr == 12) ? 12'h3D1 :
 (addr == 13) ? 12'h0D3 :
 (addr == 14) ? 12'hB02 :
 (addr == 15) ? 12'h994 :
 (addr == 16) ? 12'hE13 :
 (addr == 17) ? 12'h3B1 :
 (addr == 18) ? 12'h0B3 :
 (addr == 19) ? 12'h090 :
 (addr == 20) ? 12'h9D0 :
 (addr == 21) ? 12'hD2B :
 (addr == 22) ? 12'h9B0 :
 (addr == 23) ? 12'hD1A :
 (addr == 24) ? 12'hCFF :
 (addr == 25) ? 12'hCFF :
 (addr == 26) ? 12'hCFF :
 (addr == 27) ? 12'h9C0 :
 (addr == 28) ? 12'hD27 :
 (addr == 29) ? 12'h9C1 :
 (addr == 30) ? 12'hD23 :
 (addr == 31) ? 12'h052 :
 (addr == 32) ? 12'h062 :
 (addr == 33) ? 12'h070 :
 (addr == 34) ? 12'hF00 :
 (addr == 35) ? 12'h052 :
 (addr == 36) ? 12'h060 :
 (addr == 37) ? 12'h072 :
 (addr == 38) ? 12'hF00 :
 (addr == 39) ? 12'h050 :
 (addr == 40) ? 12'h062 :
 (addr == 41) ? 12'h072 :
 (addr == 42) ? 12'hF00 :
 (addr == 43) ? 12'h9B0 :
 (addr == 44) ? 12'hD2E :
 (addr == 45) ? 12'hC08 :
 (addr == 46) ? 12'hC04 :
 (addr == 47) ? 12'hBFF :
 (addr == 48) ? 12'h64A :
 (addr == 49) ? 12'h0E3 :
 (addr == 50) ? 12'h9C0 :
 (addr == 51) ? 12'hD3C :
 (addr == 52) ? 12'h9C1 :
 (addr == 53) ? 12'hD39 :
 (addr == 54) ? 12'h76E :
 (addr == 55) ? 12'h77A :
 (addr == 56) ? 12'hF00 :
 (addr == 57) ? 12'h75E :
 (addr == 58) ? 12'h76A :
 (addr == 59) ? 12'hF00 :
 (addr == 60) ? 12'h75A :
 (addr == 61) ? 12'h77E :
 (addr == 62) ? 12'hF00 :
 (addr == 63) ? 12'h000 :
 (addr == 64) ? 12'h0 :
	0;
endmodule
