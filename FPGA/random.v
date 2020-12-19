// Generate suedo random number using a linear feedbad shift register.

module random(
  input  clk,
  input  reset,
  output [7:0] out
);

reg [8:0] number;
initial number = 8'hff;

wire feedback = number[8] ^ number[1];

always@(posedge clk or posedge reset)
  if(reset)
    number <= 8'hff;
else
    number <= {number[7:0], feedback};

 assign out = number[7:0];

endmodule
