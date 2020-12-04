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

  reg [23:0] color_count;
  reg [17:0] color_freq;
  reg [7:0] redFreq;
  reg [7:0] greenFreq;
  reg [7:0] blueFreq;

  reg [2:0] masterState;
  parameter [2:0] WAIT_FOR_START = 0, WAIT_FOR_FIRST_EDGE = 1, COUNT_ELASPED_TIME = 2,  DELAY = 3, PROCESS_COUNT = 4, DECIDE_COLOR = 5;
  initial masterState = WAIT_FOR_START;

  // the colorState is the color being detected (with exception to NO_SELECTION)
  // the state value coincides with the S3 and S2 color select pins of the TCS32000 color sensor
  // {S3,S2} = {0,0} = red
  // {S3,S2} = {1,1} = green
  // {S3,S2} = {1,0} = blue
  // {S3,S2} = {1,1} = all colors
  reg [1:0] colorState;
  parameter [1:0] RED = 2'b00, GREEN = 2'b11, BLUE = 2'b10, NO_SELECTION = 2'b01;
  initial colorState = RED;
  assign colorSelect = colorState;

  reg [12:0] delay;

  always @(posedge clk) begin

    case(masterState)

      WAIT_FOR_START : begin
        // freqCount[7:0] <= color; // TEMP
        detectionComplete <= 0;
        if (startDetection) begin
          colorState <= RED;
          masterState <= DELAY;
        end
      end

      // Allow sensor to stablize after change in color selection.
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
          color_count <= 0;
          masterState <= COUNT_ELASPED_TIME;
        end
      end

      COUNT_ELASPED_TIME : begin
        delay <= 0;
        if (edgeFlag) begin
          masterState <= PROCESS_COUNT;
        end else begin
          color_count <= color_count + 1;
        end
      end

      PROCESS_COUNT : begin
        case(colorState)
          RED : begin
            redFreq <= color_count[10:3];
            masterState <= DELAY;
            colorState <= GREEN;
          end
          GREEN : begin
            greenFreq <= color_count[10:3];
            masterState <= DELAY;
            colorState <= BLUE;
          end
          BLUE : begin
            blueFreq <= color_count[10:3];
            masterState <= DECIDE_COLOR;
            colorState <= NO_SELECTION;
          end
        endcase
      end

      DECIDE_COLOR : begin
        // detecting yellow is tricky, but luckily due to the acrylic colors,
        // blue is only the highest value (least light) with the yellow acrylic
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

endmodule
