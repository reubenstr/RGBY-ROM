// Ram block per Lattice userguide:
//http://www.latticesemi.com/~/media/LatticeSemi/Documents/UserManuals/EI/iCEcube2_2013-08_userguide.pdf
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
