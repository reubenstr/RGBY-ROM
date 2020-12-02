// clock divider
// divide by 2^3 = 8
module clockDivider(clk, reset, clk_out);
  input clk, reset;
  output reg clk_out;
  reg [2:0] count;
  always@(posedge clk or negedge reset)
    if(!reset) begin
      count <= 2'b00;
      clk_out <= 0;
    end
  else begin
    count <= count + 1;
    if (count == 2'b00) begin
      clk_out <= ~clk_out;
    end
  end
endmodule
