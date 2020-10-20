
// Generate suedo random number using a linear feedbad shift register
// Example code provided by

module random(
  input  clk,
  input  reset,
  output reg [8:0] number
);

initial number = 8'hff;

wire feedback = number[8] ^ number[1];

always@(posedge clk or negedge reset)
  if(!reset)
    number <= 8'hff;
else
    number <= {number[7:0], feedback};
endmodule
