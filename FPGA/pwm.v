// Pulse width modulation signal generator.
// 8-bit resolution
module pwm(
input clk,
input reset,
input [7:0] duty,
output signal);

reg [7:0] count;

always@(posedge clk or posedge reset)
  if(reset) begin
    // count <= 0;
  end
  else begin
    count <= count + 1;
  end

assign signal = (duty > count) ? 1 : 0;

endmodule
