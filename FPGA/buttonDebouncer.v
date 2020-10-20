
// Asserts button for one clock cycle on every press.
// Allows only one assertion every X seconds.
// Button in is active low
// Button out is active high

module buttonController(
  input clk,
  input reset,
  input buttonIn,
  output reg buttonOut
  );

reg [50:0] count;

parameter pressed = 1'b0;
parameter released = 1'b1;
parameter low = 1'b0;
parameter high = 1'b1;

reg state;

always @(posedge clk) begin

  if (buttonOut == high)
  begin
    buttonOut <= low;
    count <= 0;
  end
  else begin

    if (buttonIn == pressed)
    begin
      if (count == 10000)
      begin
          buttonOut <= high;
      end
      count <= 0;
    end
    else if (buttonIn == released)
    begin
      if (count < 10000) count <= count + 1;
    end
  end
end

endmodule
