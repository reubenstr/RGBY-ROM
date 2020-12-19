// clock divider
// divide by 2^3 = 8
module clockDivider(clk, clk_out);
  input clk;
  output reg clk_out;
  reg [2:0] count;
  always@(posedge clk) begin
    count <= count + 1;
    if (count == 2'b00) begin
      clk_out <= ~clk_out;
    end
  end
endmodule
