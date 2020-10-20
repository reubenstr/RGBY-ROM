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
 (addr == 0) ? 12'hC64 :
 (addr == 1) ? 12'h082 :
 (addr == 2) ? 12'hF00 :
 (addr == 3) ? 12'h000 :
 (addr == 4) ? 12'h0 :
	0;
endmodule
