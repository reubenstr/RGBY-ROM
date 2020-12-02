// Increments sensor selection upon color detection completion.
// Delay between sensor selection for aesthetic effect.
module sensorSelector(
   input clk,
   input reset,
   input startSelector,
   input detectionComplete,
   output reg startDetection,
   output reg [3:0] sensorSelect,
   output reg selectorComplete);

  reg  [2:0] state;
  parameter [2:0] WAIT_FOR_START = 0, RESET_SELECT = 1, TRIGGER_DETECTION = 2, WAIT_FOR_COMPLETION = 3, DELAY = 4, INCREMENT_SELECTOR = 5, COMPLETE = 6;
  initial state = WAIT_FOR_START;

  reg [13:0] delay;

always @(posedge clk) begin
  case(state)
    WAIT_FOR_START : begin
      selectorComplete <= 0;
      if (startSelector) state <= RESET_SELECT;
    end
    RESET_SELECT : begin
      sensorSelect <= 0;
      state <= TRIGGER_DETECTION;
    end
    TRIGGER_DETECTION : begin
      startDetection <= 1;
      state <= WAIT_FOR_COMPLETION;
    end
    WAIT_FOR_COMPLETION : begin
      startDetection <= 0;
      delay <= 0;
      if (detectionComplete) state <= DELAY;
    end
    DELAY : begin
      state <= INCREMENT_SELECTOR;
    end
    INCREMENT_SELECTOR : begin
      sensorSelect <= sensorSelect + 1;
      delay <= 0;
      if (sensorSelect == 11) state <= COMPLETE;
      else state <= TRIGGER_DETECTION;
    end
    COMPLETE : begin
      selectorComplete <= 1;
      state <= WAIT_FOR_START;
    end
  endcase
end

endmodule
