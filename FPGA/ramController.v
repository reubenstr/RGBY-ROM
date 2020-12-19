// Contains program memory sourced from the RGBY-ROM data cartridge.
// Contains logic to fill RAM two bits at a time as data is retreived from
// the RGBY-ROM data cartridge.
module ramController(
  input clk,
  input reset,
  input colorReady,
  input [1:0] color,
  input [7:0] readAddress,
  output [11:0] readData);

  reg writeEnable;
  reg [7:0] writeAddress = 8'b11111111;
  reg [11:0] writeData;
  reg [4:0] dataSectionCount;

  ram ram1(.din(writeData), .write_en(writeEnable), .waddr(writeAddress), .wclk(clk), .raddr(readAddress), .rclk(clk), .dout(readData));

  // Hard-coded ram with test program for development purposes.
  // ramHardcoded ram1(.din(writeData), .addr(readAddress), .write_en(0), .clk(clk), .dout(readData));

  // store color into ram, where six 2-bit nits equal one 12-bit ram address
  // shift two bits at a time (per color)
  always@(posedge clk)
    if(reset) begin
    
    end
  else begin
    if (colorReady) begin
      writeData <= (writeData << 2) | color;
      dataSectionCount <= dataSectionCount + 1;
    end else begin
      if (dataSectionCount == 6) begin
        dataSectionCount <= 0;
        writeAddress <= writeAddress + 1;
        writeEnable <= 1;
      end else begin
        writeEnable <= 0;
      end
    end
  end

endmodule
