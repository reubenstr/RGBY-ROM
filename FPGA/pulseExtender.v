// Extends signal by X clock cycles.
// 2^4 = 16 clock cycles
module pulseExtender(
  input clk,
  input reset,
  input signal,
  output reg extendedSignal);

  reg [3:0] clockCount;
  reg countFlag;

  always@(posedge clk or posedge reset)
    if(reset) begin
      // clockCount <= 0;
      // countFlag <= 0;
      // extendedSignal <= 0;
    end
  else begin
    if (signal) begin
      countFlag <= 1;
      extendedSignal <= 1;
    end
    if (countFlag) begin
      if (clockCount == 4'b1111) begin
        extendedSignal <= 0;
        countFlag <=0;
        clockCount <= 0;
      end else begin
        clockCount <= clockCount + 1;
      end
    end
  end
endmodule
