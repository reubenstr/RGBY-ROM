

// look in pins.pcf for all the pin names on the TinyFPGA BX board

module top (
  input CLK,    // 16MHz clock
  output reg LED,   // User/boot LED next to power LED
  output USBPU,  // USB pull-up resistor
  output PIN_1,
  output PIN_2,
  input PIN_3,
  output PIN_4,
  output PIN_5,
  output PIN_6,
  output PIN_7,
  output PIN_8,
  output PIN_9,
  output PIN_10,
  output PIN_11,
  input PIN_12,
  input PIN_13,
  output PIN_14,
  output PIN_15,
  output PIN_16,
  output PIN_17,
  output PIN_18,
  output PIN_19,
  output PIN_20,
  output PIN_21,
  output PIN_22,
  output PIN_23,
  output PIN_24,
  output PIN_25,
  output PIN_26);

  // drive USB pull-up resistor to '0' to disable USB
  assign USBPU = 0;

  wire clk;
  wire reset;
  wire [1:0] colorSelect;
  wire [1:0] color;
  wire [7:0] freqCount;
  wire [7:0] portIn;
  wire [7:0] portOut;
  wire [7:0] random;

  wire [11:0] ramData;
  wire [7:0] ramAddress;
  wire [7:0] red;
  wire [7:0] green;
  wire [7:0] blue;
  wire [7:0] debug;

  wire [3:0] sensorSelect;


  // Debounce and assign input buttons.
  assign reset = 1;
  assign portIn[7:2] = 6'b000000;
  buttonController buttonController1(.clk(clk), .reset(reset), .buttonIn(PIN_13), .buttonOut(portIn[0]));
  buttonController buttonController2(.clk(clk), .reset(reset), .buttonIn(PIN_12), .buttonOut(portIn[1]));

  // Assign external outputs.
  // assign {PIN_17, PIN_11, PIN_19, PIN_10, PIN_21, PIN_22, PIN_23, PIN_24} = portOut[7:0];

  // Assign sensor bar.
  assign signalFromSensor = PIN_3;
  assign {PIN_4, PIN_5, PIN_6, PIN_7} = sensorSelect[3:0];
  assign {PIN_8, PIN_9} = colorSelect[1:0];

  // Reduce 8MHz clock down to 1MHz for timing math simplification.
  clockDivider clkDiv1(.clk(CLK), .reset(reset), .clk_out(clk));

  // Toggle onboard LED's state every 1Hz for clock simply visual clock frequency verification.
  ledBlinker ledBlinker(.clk(clk), .reset(reset), .state(LED));



  // Attach random number generator.
  random random1(.clk(clk), .reset(reset), .out(random[7:0]));

  // Connect color registers to PWM controllers then output pins.
  //pwm pwm1(.clk(clk), .reset(reset), .duty(red), .signal(PIN_17));
  //pwm pwm2(.clk(clk), .reset(reset), .duty(green), .signal(PIN_8));
  //pwm pwm3(.clk(clk), .reset(reset), .duty(blue), .signal(PIN_19));

  // Assign status LEDs
  assign PIN_10 = !selectorComplete; // Mode: Read ROM
  assign PIN_27 = selectorComplete; // Mode: Execute

  // TEMP


  assign {PIN_17, PIN_26, PIN_19, PIN_25, PIN_21, PIN_22, PIN_23, PIN_24} =  color;


  //assign {PIN_17, PIN_26, PIN_19, PIN_25, PIN_21, PIN_22, PIN_23, PIN_24} =  {startSelector,selectorComplete, startDetection, detectionComplete, sensorSelect[1:0], freqCount[1:0]};



  // TEMP



  motionController motionController1(
    .clk(clk),
    .reset(reset),
    .xLimitMinus(),
    .xLimitPlus(),
    .xDirection(),
    .xStep(),
    .centerOfNib(),
    .opCompleted());
    // startDetection
    // selectorComplete

    wire startSelector, selectorComplete;
    wire startDetection, detectionComplete;

    assign startSelector = 1; // TEMP: signal from motionController, but start manually

    sensorSelector sensorSelector(
      .clk(clk),
      .reset(reset),
      .startSelector(startSelector),
      .detectionComplete(detectionComplete),
      .startDetection(startDetection),
      .sensorSelect(sensorSelect),
      .selectorComplete(selectorComplete));

      colorDetector colorDetector(
        .clk(clk),
        .reset(reset),
        .signalFromSensor(signalFromSensor),
        .startDetection(startDetection),
        .colorSelect(colorSelect),
        .detectionComplete(detectionComplete),
        .color(color),
        .freqCount(freqCount));

  ramController ram1(
    .clk(clk),
    .reset(reset),
    .colorFlag(detectionComplete),
    .color(color),
    .address(ramAddress),
    .dout(ramData));

  cpu cpu(
    .clk(clk),
    .reset(reset),
    .instruction(ramData),
    .programCounter(ramAddress),
    .portIn(portIn),
    .random(random),
    .portOut(portOut),
    .red(red),
    .green(green),
    .blue(blue),
    .debug(debug)
  );


  // extract ram data
  // TEMP test
  /*
  reg [7:0] addrRead;
  always @(posedge clk or negedge reset) begin
    if(!reset) begin
      addrRead <= 0;
    end else begin
      if (opCompleted) begin
        if (addrRead != 60) addrRead <= addrRead + 1;
      end
    end
  end
  */
  //assign ramAddress = addrRead;

endmodule

/////////////////////////////////////////////////////////////////////////////

module sensorSelector(
   input clk,
   input reset,
   input startSelector,
   input detectionComplete,
   output reg startDetection,
   output reg [3:0] sensorSelect,
   output reg selectorComplete);

  reg  [2:0] state;
  parameter [2:0] WAIT_FOR_START = 0, RESET_SELECT = 1, TRIGGER_DETECTION = 2, WAIT_FOR_COMPLETION = 3, INCREMENT_SELECTOR = 4, COMPLETE = 5;
  initial state = WAIT_FOR_START;

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
      if (detectionComplete) state <= INCREMENT_SELECTOR;
    end
    INCREMENT_SELECTOR : begin
      sensorSelect <= sensorSelect + 1;
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

module colorDetector (
  input clk,
  input reset,
  input signalFromSensor,
  input startDetection,
  output [1:0] colorSelect,
  output reg detectionComplete,
  output reg [1:0] color,
  output reg [7:0] freqCount
);

  edgeDetect edgeDetect1(.clk(clk), .reset(reset), .signalIn(signalFromSensor), .edgeFlag(edgeFlag));

  // temp for debugging
  //assign freqCount[7:2] = redFreq;
  //assign freqCount[1:0] = color;
  //assign freqCount[7:0] = greenFreq;
  ///

  reg [7:0] freqCount; //temp

  reg [23:0] color_count;
  reg [17:0] color_freq;
  reg [7:0] redFreq;
  reg [7:0] greenFreq;
  reg [7:0] blueFreq;


  reg [2:0] masterState;
  parameter [2:0] WAIT_FOR_START = 0, WAIT_FOR_FIRST_EDGE = 1, COUNT_ELASPED_TIME = 2, PROCESS_COUNT = 3, DECIDE_COLOR = 4;
  initial masterState = WAIT_FOR_START;

  // the colorState is the color being detected
  // the state value coincides with the S3 and S2 color select pins of the TCS32000 color sensor
  // {S3,S2} = {0,0} = red
  // {S3,S2} = {1,1} = green
  // {S3,S2} = {1,0} = blue
  // {S3,S2} = {1,1} = all colors
  reg [1:0] colorState;
  parameter [1:0] RED = 2'b00, GREEN = 2'b11, BLUE = 2'b10;
  initial colorState = RED;
  assign colorSelect = colorState;

  /////////////////////

  always @(posedge clk) begin

  // temp
  freqCount[2:0]  <= masterState[2:0];

    case(masterState)

      WAIT_FOR_START : begin
        freqCount[7:0] <= color; // TEMP
        detectionComplete <= 0;
        if (startDetection) begin
          masterState <= WAIT_FOR_FIRST_EDGE;
        end
      end

      WAIT_FOR_FIRST_EDGE : begin
        if (edgeFlag) begin
          color_count <= 0;
          masterState <= COUNT_ELASPED_TIME;
        end
      end

      COUNT_ELASPED_TIME : begin
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
            //freqCount[7:0] <= color_count[10:3]; // TEMP
            masterState <= WAIT_FOR_FIRST_EDGE;
            colorState <= GREEN;
          end
          GREEN : begin
            greenFreq <= color_count[10:3];
            //freqCount[7:0] <= color_count[10:3]; // TEMP
            masterState <= WAIT_FOR_FIRST_EDGE;
            colorState <= BLUE;
          end
          BLUE : begin
            blueFreq <= color_count[10:3];
            //freqCount[7:0] <= color_count[10:3]; // TEMP
            masterState <= DECIDE_COLOR;
            colorState <= RED;
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

//////////////////////////////////////////////////////////////////////////////


module motionController (
  input clk,
  input reset,
  input xLimitMinus,
  input xLimitPlus,
  output reg xDirection,
  output xStep,
  output reg centerOfNib,
  output reg opCompleted);

  // http://buildlog.net/cnc_laser/belt_calcs.htm
  // 200 steps per revolution
  // 18 teeth per head
  // 8 microsteps
  // 747 per nib center
  // 2259 steps per inch
  parameter [15:0] PULSE_PER_NIB = 836; // origil : 747
  parameter [15:0] PULSE_PER_ROW = 14218; // 8364 = 10 nibs ((PULSE_PER_NIB * NIBS) - 1)

  reg [3:0] state;
  parameter [3:0] GO_TO_INDEX = 0, TRAVERSE_X = 1, HALT = 2, OP_COMPLETED = 3;
  initial state = GO_TO_INDEX;

  reg xStepTrigger;
  reg yStepTrigger;
  reg xTraverseFlag;
  reg yTraverseFlag;
  reg [15:0] pulseCount;
  reg [15:0] nibPulseCount;

  pulseExtender xStepper(.clk(clk), .reset(reset), .signal(xStepTrigger), .extendedSignal(xStep));
  pulseExtender yStepper(.clk(clk), .reset(reset), .signal(yStepTrigger), .extendedSignal(yStep));

  always@(posedge clk or negedge reset)
    if(!reset) begin
      state = GO_TO_INDEX;
      xTraverseFlag <= 0;
      opCompleted <= 0;
    end
  else begin

    case(state)

      GO_TO_INDEX : begin

        xDirection <= 0;
        xTraverseFlag <= 1;

        if (xLimitMinus == 0) begin
          xTraverseFlag <= 0; // required to some reset counters
          nibPulseCount = 0;
          state <= TRAVERSE_X;
        end

      end

      TRAVERSE_X : begin

        xDirection <= 1;
        xTraverseFlag <= 1;

        // check for center of nib
        if (pulseCount == nibPulseCount) begin
          nibPulseCount <= nibPulseCount + PULSE_PER_NIB;
          centerOfNib <= 1;
        end else begin
          centerOfNib <= 0;
        end

        // check for end of row
        if (pulseCount == PULSE_PER_ROW) begin
          xTraverseFlag <= 0;
          state <= OP_COMPLETED;
        end

        // check for physical end of row limit
        if (xLimitPlus == 0) state <= HALT;

      end

      HALT : begin
        xTraverseFlag <= 0;
      end

      OP_COMPLETED : begin

        opCompleted <= 1;

      end


    endcase
  end


  // traverse X or Y
  // generate step pulse interval, count pulses
  reg [23:0] pulseFreqCount;
  always@(posedge clk or  negedge reset)
    if(!reset) begin
      xStepTrigger <= 0;
      yStepTrigger <= 0;
    end
  else begin
    if (xTraverseFlag) begin
      if (pulseFreqCount == 128) begin
        pulseFreqCount <= 0;
        xStepTrigger <= 1;
        pulseCount <= pulseCount + 1;
      end else begin
        pulseFreqCount <= pulseFreqCount + 1;
        xStepTrigger <= 0;
      end
    end else begin
      pulseFreqCount <= 0;
      pulseCount <= 0;
    end
  end

endmodule


/////////////////////////////////////////////////////////////////////////////

// Contains program memory sourced from the RGBY-ROM data cartridge.
module ramController(
  input clk,
  input reset,
  input colorFlag,
  input [1:0] color,
  input [7:0] address,
  output [11:0] dout);

  reg writeEn;

  reg [7:0] dataWriteAddress;
  reg [11:0] dataToWrite;
  reg [4:0] dataSectionCount;

  reg [7:0] ramAddress; // should be a with with mux assignment, but due to compiler issues this is a work around

  // TEMP TO REDUCE WARNINGS
  always@(posedge clk)      // TEMP
   dataToWrite <= 12'h000;  // TEMP

  //ram ram1(.din(dataToWrite), .addr(ramAddress), .write_en(writeEn), .clk(clk), .dout(dout));
  ramHardcoded ram1(.din(dataToWrite), .addr(address), .write_en(writeEn), .clk(clk), .dout(dout)); // TEMP

  /*
  //assign ramAddress = writeEn ? dataWriteAddress : addr;

  // store color into ram, where six 2-bit nibs equal one 12-bit ram address
  // shift two bits at a time (per color)
  always@(posedge clk or negedge reset)
    if(!reset) begin
      dataWriteAddress <= 0;
      dataSectionCount <= 0;
      writeEn <= 0;
    end
  else begin

    if (colorFlag) begin
      dataToWrite <= (dataToWrite << 2) | color;
      dataSectionCount <= dataSectionCount + 1;
    end else begin
      if (dataSectionCount == 6) begin
        dataSectionCount <= 0;
        dataWriteAddress <= dataWriteAddress + 1;
        writeEn <= 1;
        ramAddress <= dataWriteAddress;
      end else begin
        writeEn <= 0;
        ramAddress <= address;
      end
    end
  end
*/
endmodule




// clock divider
// divide by 2^3 = 8
module clockDivider(clk, reset, clk_out);
  input clk, reset;
  output reg clk_out;
  reg [2:0] count;
  always@(posedge clk or negedge reset)
    if(!reset) begin
      count <= 2'b00;
      clk_out <= 0;
    end
  else begin
    count <= count + 1;
    if (count == 2'b00) begin
      clk_out <= ~clk_out;
    end
  end
endmodule

//////////////////////////////////////////////////////////////////////////////

// clock divider for pwm signal
//
// divide by 2^3 = 8
module pwmClockDivider(clk, reset, clk_out);
  input clk, reset;
  output reg clk_out;
  reg [2:0] count;
  always@(posedge clk or negedge reset)
    if(!reset) begin
      count <= 2'b00;
      clk_out <= 0;
    end
  else begin
    count <= count + 1;
    if (count == 2'b00) begin
      clk_out <= ~clk_out;
    end
  end
endmodule
