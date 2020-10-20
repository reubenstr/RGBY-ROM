
// Generate suedo random number using a linear feedbad shift register


module random(
  input  clk,
  input  reset,
  output reg [8:0] number
);

wire feedback = number[8] ^ number[1] ;

initial number = 8'hff;

always@(posedge clk or negedge reset)
  if(!reset)
    number <= 8'hff;
else
    number <= {number[7:0], feedback};
//number <= number;

endmodule
