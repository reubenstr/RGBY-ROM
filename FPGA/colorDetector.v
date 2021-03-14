// Interfaces with the TCS3200 color detection sensor.
// The TCS3200 converts red/green/blue light intensity to frequency.
module colorDetector (
  input clk,
  input reset,
  input frequencyFromColorSensor,
  input startDetection,
  output [1:0] colorSelect,
  output reg detectionComplete,
  output reg [1:0] color,
  output reg [7:0] freqCount // Debug
);

  wire edgeFlag;
  edgeDetect edgeDetect1(.clk(clk), .reset(reset), .signalIn(frequencyFromColorSensor), .edgeFlag(edgeFlag));

  reg [23:0] elapsedTickCount;
  reg [23:0] redFreq;
  reg [23:0] greenFreq;
  reg [23:0] blueFreq;

  reg [2:0] masterState;
  parameter [2:0] WAIT_FOR_START = 0, WAIT_FOR_FIRST_EDGE = 1, COUNT_ELASPED_TIME = 2,  DELAY = 3, PROCESS_COUNT = 4, DECIDE_COLOR = 5;
  initial masterState = WAIT_FOR_START;

  // The colorState is the color being detected (with exception to NO_SELECTION).
  // The state value coincides with the S3 and S2 color select pins of the TCS32000 color sensor.
  // color sensor {S3,S2} = {0,0} = red
  // color sensor {S3,S2} = {1,1} = green
  // color sensor {S3,S2} = {1,0} = blue
  // color sensor {S3,S2} = {0,1} = all colors
  reg [1:0] colorState;
  parameter [1:0] RED = 2'b00, GREEN = 2'b11, BLUE = 2'b10, NO_SELECTION = 2'b01;
  assign colorSelect = colorState;

  reg [4:0] edgeCount;
  reg [11:0] delay;

  always @(posedge clk or posedge reset) begin
    if(reset) begin
      masterState <= WAIT_FOR_START;
    end else begin

      case(masterState)

        WAIT_FOR_START : begin
          detectionComplete <= 0;
          if (startDetection) begin
            colorState <= RED;
            masterState <= DELAY;
          end else begin
            colorState <= NO_SELECTION;
          end
        end

        // Allow sensor to stablize after change in color selection.
        // Delay also serves as visual effect.
        DELAY : begin
          if (&delay) begin
            delay <= 0;
            masterState <= WAIT_FOR_FIRST_EDGE;
          end else begin
            delay <= delay + 1;
          end
        end

        WAIT_FOR_FIRST_EDGE : begin
          if (edgeFlag) begin
            elapsedTickCount <= 0;
            masterState <= COUNT_ELASPED_TIME;
          end
        end

        // Count elapsed ticks between x edge counts.
        // Counting multiple edges is required for a deterministic signal.
        COUNT_ELASPED_TIME : begin
          if (edgeFlag) begin
            if (&edgeCount) begin
                edgeCount <=0;
                masterState <= PROCESS_COUNT;
              end else begin
                edgeCount <= edgeCount + 1;
              end
            end
            elapsedTickCount <= elapsedTickCount + 1;
        end

        PROCESS_COUNT : begin
          case(colorState)
            RED : begin
              redFreq <= elapsedTickCount;
              masterState <= DELAY;
              colorState <= GREEN;
            end
            GREEN : begin
              greenFreq <= elapsedTickCount;
              masterState <= DELAY;
              colorState <= BLUE;
            end
            BLUE : begin
              blueFreq <= elapsedTickCount;
              masterState <= DECIDE_COLOR;
              colorState <= NO_SELECTION;
            end
          endcase
        end

        DECIDE_COLOR : begin
          // Decide color by comparing color frequency (elasped ticks).
          // Detecting yellow is tricky, but luckily due to the acrylic colors,
          // blue is only the highest value (least light) with the yellow acrylic.
          if (blueFreq > redFreq && blueFreq > greenFreq) color <= 2'b11; // yellow
          else if (redFreq < greenFreq && redFreq < blueFreq) color <= 2'b00; // red
          else if (greenFreq < redFreq && greenFreq < blueFreq) color <= 2'b01; // green
          else if (blueFreq < redFreq && blueFreq < greenFreq) color <= 2'b10; // blue
          else  color <= 2'b00; // edge case where the two lowest values are equal, should never happen
          detectionComplete <= 1;
          masterState <= WAIT_FOR_START;
        end

      endcase
    end
  end

endmodule
