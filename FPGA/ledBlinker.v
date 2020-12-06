module ledBlinker(
  input clk,
  input reset,
  output reg state
  );

reg [19:0] count;

always @(posedge clk) begin
  if (count == 1000000) begin
    count <= 0;
    state <= !state;
  end else begin
    count <= count + 1;
  end
end

endmodule
