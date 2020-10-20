// Detect edge of asynchronous signal.
// Assert flag for one clock cycle upon edge detection.
module edgeDetect(clk, reset, signalIn, edgeFlag);
  input clk, reset, signalIn;
  output reg edgeFlag;
  reg [2:0] edge_mem;

  always@(posedge clk or negedge reset)
    if(!reset) begin
      edge_mem <= 3'b0;
      edgeFlag <= 1'b0;
    end
  else begin
    edge_mem <= {edge_mem[1:0], signalIn};
    edgeFlag <= edge_mem[1] ^ edge_mem[2];
  end
endmodule
