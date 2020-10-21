

// look in pins.pcf for all the pin names on the TinyFPGA BX board

module top (
  input CLK,    // 16MHz clock
  input PIN_11,
  output reg LED,   // User/boot LED next to power LED
  output USBPU,  // USB pull-up resistor
  output PIN_1,
  output PIN_2,
  output PIN_3,
  output PIN_4,
  output PIN_5,
  output PIN_6,
  output PIN_7,
  output PIN_8,
  output PIN_9,
  output PIN_10,
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
  output PIN_24);

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
  wire [7:0] debug;

  // Assign external inputs.
  assign reset = 1;
  assign signalFromSensor = PIN_11;


  // Assign external outputs.
  assign {PIN_17, PIN_8, PIN_19, PIN_5, PIN_21, PIN_22, PIN_23, PIN_24} = portOut[7:0];
  assign {PIN_10, PIN_9} = colorSelect[1:0];

  // Reduce 8MHz clock down to 1MHz for timing math simplification.
  clockDivider clkDiv1(.clk(CLK), .reset(reset), .clk_out(clk));

  // Toggle onboard LED's state every 1Hz for clock simply visual clock frequency verification.
 ledBlinker ledBlinker(.clk(clk), .reset(reset), .state(LED));

  // Debounce and assign input buttons.
  buttonController buttonController1(.clk(clk), .reset(reset), .buttonIn(PIN_13), .buttonOut(portIn[0]));
  buttonController buttonController2(.clk(clk), .reset(reset), .buttonIn(PIN_12), .buttonOut(portIn[1]));

  random random1(.clk(clk), .reset(reset), .number(random[7:0]));

  motionController motionController1(
    .clk(clk),
    .reset(reset),
    .xLimitMinus(),
    .xLimitPlus(),
    .xDirection(),
    .xStep(),
    .centerOfNib(startDetection),
    .opCompleted(opCompleted));

  color colorModule(
    .clk(clk),
    .reset(reset),
    .signalFromSensor(signalFromSensor),
    .startDetection(startDetection),
    .colorSelect(colorSelect),
    .dataReady(dataReady),
    .color(color),
    .freqCount(freqCount));

  ramController ram1(
    .clk(clk),
    .reset(reset),
    .colorFlag(dataReady),
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

  // assign {PIN_1, PIN_2, PIN_3, PIN_4, PIN_5, PIN_6, PIN_7, PIN_8} = { waits[20], state, pulseFromSensor, freqCount[4:0]};
  // assign {PIN_1, PIN_2, PIN_3, PIN_4, PIN_5, PIN_6, PIN_7, PIN_8} = {freqCount[7:5], dataReady, color[1:0]};
  // assign {PIN_1, PIN_2, PIN_3, PIN_4, PIN_5, PIN_6, PIN_7, PIN_8} = opCompleted ? 8'b10101010 : freqCount[7:0];
  // assign {PIN_1, PIN_2, PIN_3, PIN_4, PIN_5, PIN_6, PIN_7, PIN_8} = ramDataOut;
  // assign {PIN_8, PIN_7, PIN_6, PIN_5, PIN_4, PIN_3, PIN_2, PIN_1} = ramDataOut[7:0];
  // assign {PIN_8, PIN_7, PIN_6, PIN_5, PIN_4, PIN_3, PIN_2, PIN_1} = opCompleted ? ramDataOut[7:0] : {dout[7:3], dataReady, color[1:0]};
  // assign {PIN_8, PIN_7, PIN_6, PIN_5, PIN_4, PIN_3, PIN_2, PIN_1} = debug;
endmodule

/////////////////////////////////////////////////////////////////////////////

module cpu(
  input clk,
  input reset,
  input [11:0] instruction,
  input [7:0] portIn,
  input [7:0] random,
  output [7:0] programCounter,
  output [7:0] portOut,
  output [7:0] debug
  );

  ////////////////////
  // debugging
  // assign debug = {ctrlPcDelay, portA[6:0]};
  ////////////////////

  wire set;
  wire [3:0] selectWriteRegister;
  wire ctrlWriteRegister;
  wire ctrlPcDelay;
  wire ctrlPcSelect;
  wire ctrlLoadImmediate;
  wire ctrlWriteSource;

  wire [7:0] aluResult;
  wire [7:0] registerA;
  wire [7:0] registerB;
  wire [7:0] writeData;

  controller controller(
    .clk(clk),
    .reset(reset),
    .instruction(instruction),
    .set(set),
    .selectWriteRegister(selectWriteRegister),
    .ctrlWriteRegister(ctrlWriteRegister),
    .ctrlPcDelay(ctrlPcDelay),
    .ctrlPcSelect(ctrlPcSelect),
    .ctrlLoadImmediate(ctrlLoadImmediate),
    .ctrlWriteSource(ctrlWriteSource));

  registers registers(
    .clk(clk),
    .reset(reset),
    .selectRegisterA(instruction[7:4]),
    .selectRegisterB(instruction[3:0]),
    .selectWriteRegister(selectWriteRegister),
    .writeData(writeData),
    .ctrlWriteRegister(ctrlWriteRegister),
    .portIn(portIn),
    .random(random),
    .registerA(registerA),
    .registerB(registerB),
    .registerPortOut(portOut),
    .registerPWMRed(),
    .registerPWMGreen(),
    .registerPWMBlue());

  alu alu(
    .clk(clk),
    .reset(reset),
    .aluOpCode(instruction[11:8]),
    .dataA(registerA),
    .dataB(registerB),
    .aluResult(aluResult),
    .set(set));

  pc pc(
    .clk(clk),
    .reset(reset),
    .ctrlPcDelay(ctrlPcDelay),
    .ctrlPcSelect(ctrlPcSelect),
    .instruction(instruction[7:0]),
    .programCounter(programCounter));

  // Writeback MUX
  assign writeData = (ctrlWriteSource == 1) ?  instruction[7:0] : aluResult;

endmodule

/////////////////////////////////////////////////////////////////////////////

module pc(
  input clk,
  input reset,
  input ctrlPcDelay,
  input ctrlPcSelect,
  input [7:0] instruction,
  output reg [7:0] programCounter);

  //wire [7:0] updatedProgramCounter;

  wire addImmediate;
  reg [25:0] delayCounter; // TODO: scale this reg down

  initial delayCounter = 0;

  // Increment program counter.
  always@(posedge clk or negedge reset)
    if(!reset) begin
      programCounter <= 0;
    end else begin
      // Increment MUX.
      programCounter <= (ctrlPcSelect == 1) ?  instruction : programCounter + addImmediate;
    end

  // Increment delay counter.
  always@(posedge clk) begin
    if (ctrlPcDelay) begin
      if (delayCounter != (instruction << 10))
        delayCounter <= delayCounter + 1;
      else
        delayCounter <= 0;
    end
  end

  // Increment MUX.
  //assign addImmediate = (delayCounter != (instruction << 10) && ctrlPcDelay == 1) ? 0 : 1;
  assign addImmediate = (delayCounter != (instruction << 10) && ctrlPcDelay == 1) ? 0 : 1;

endmodule

/////////////////////////////////////////////////////////////////////////////

module controller(
  input clk,
  input reset,
  input [11:0] instruction,
  input set,
  output [3:0] selectWriteRegister,
  output ctrlPcDelay,
  output ctrlPcSelect,
  output ctrlWriteRegister,
  output ctrlLoadImmediate,
  output ctrlWriteSource);

  wire [3:0] opCode = instruction[11:8];

  // select PC source
  assign ctrlPcSelect = (opCode == `OPCODE_BOS && set == 1) ? 1 :
    (opCode == `OPCODE_BNS && set == 0) ? 1 :
    (opCode == `OPCODE_J) ? 1 : 0;

  // enable PC delay
  assign ctrlPcDelay = (opCode == `OPCODE_DELAY) ? 1 : 0;

  // select register write data source
  assign ctrlWriteSource = (opCode == `OPCODE_LI) ? 1 : 0;

  // enable register writes for valid opcodes
  assign ctrlWriteRegister =
    (opCode == `OPCODE_MOV || opCode == `OPCODE_AND || opCode == `OPCODE_OR ||
     opCode == `OPCODE_XOR || opCode == `OPCODE_ADD || opCode == `OPCODE_ADDS ||
     opCode == `OPCODE_SUB || opCode == `OPCODE_SUBS || opCode == `OPCODE_LI ||
     opCode == `OPCODE_SHIFT) ? 1 : 0;

  // select which register to write
  assign selectWriteRegister =
    (opCode == `OPCODE_LI) ? `REG_IMM :
    (opCode == `OPCODE_MOV || opCode == `OPCODE_ADDS || opCode == `OPCODE_SUBS) ? instruction[7:4] : `REG_RESULT;
endmodule


// Contains registers used by the CPU.
//
// portIn is a special register that indicates button presses and
// requires machine code for the register to be cleared after reading.

module registers(
  input clk,
  input reset,
  input [3:0] selectRegisterA,
  input [3:0] selectRegisterB,
  input [3:0] selectWriteRegister,
  input [7:0] writeData,
  input ctrlWriteRegister,
  input [7:0] portIn,
  input [7:0] random,
  output [7:0] registerA,
  output [7:0] registerB,
  output [7:0] registerPortOut,
  output [7:0] registerPWMRed,
  output [7:0] registerPWMGreen,
  output [7:0] registerPWMBlue);

  reg [7:0] registers [15:0];

  initial registers [`REG_ZERO] = 8'h00;
  initial registers [`REG_ONE] = 8'h01;

  // Assign output registers to selected registers.
  assign registerA = registers[selectRegisterA];
  assign registerB = registers[selectRegisterB];

  always@(posedge clk)
    begin
        if (ctrlWriteRegister) begin
          // Make read-only registers read-only.
          if (selectWriteRegister != `REG_ZERO &&
              selectWriteRegister != `REG_ONE &&
              selectWriteRegister != `REG_RAND)
              begin
                // Write data to selected register.
                registers[selectWriteRegister] <= writeData;
          end
        end

        // Assign hardware ports to registers.
        registers[`REG_RAND] <= random;

        // Assign portIn data when register is not being written.
        if (!ctrlWriteRegister || selectWriteRegister != `REG_PORTIN)
          registers[`REG_PORTIN] <= registers[`REG_PORTIN]  | portIn;
    end

  // Assign registers to hardware ports.
  assign registerPortOut = registers[`REG_PORTOUT];
  assign registerPWMRed = registers[`REG_RED];
  assign registerPWMGreen = registers[`REG_GREEN];
  assign registerPWMBlue = registers[`REG_RED];

endmodule

/////////////////////////////////////////////////////////////////////////////

// Arithmetic logic unit; performs arithmetic operations.
module alu(
  input clk,
  input reset,
  input [3:0] aluOpCode,
  input [7:0] dataA,
  input [7:0] dataB,
  output [7:0] aluResult,
  output reg set);

  assign aluResult =
    (aluOpCode == `OPCODE_MOV) ? dataB :
    (aluOpCode == `OPCODE_AND) ? dataA & dataB :
    (aluOpCode == `OPCODE_OR) ? dataA | dataB :
    (aluOpCode == `OPCODE_XOR) ? dataA ^ dataB :
    (aluOpCode == `OPCODE_SHIFT) ? dataA << dataB :
    (aluOpCode == `OPCODE_ADD || aluOpCode == `OPCODE_ADDS) ? dataA + dataB :
    (aluOpCode == `OPCODE_SUB || aluOpCode == `OPCODE_SUBS) ? dataA - dataB : 0;

    always@(posedge clk)
       begin
          if (aluOpCode == `OPCODE_SLT)
            set <= dataA < dataB;
          else if (aluOpCode == `OPCODE_EQ)
            set <=  dataA == dataB;
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


/////////////////////////////////////////////////////////////////////////////

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

//////////////////////////////////////////////////////////////////////////////


module color (
  input clk,
  input reset,
  input signalFromSensor,
  input startDetection,
  output [1:0] colorSelect,
  output reg dataReady,
  output reg [1:0] color,
  output [7:0] freqCount
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

    case(masterState)

      WAIT_FOR_START : begin

        freqCount[7:0] <= color; // TEMP

        dataReady <= 0;
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
            freqCount[7:0] <= color_count[10:3]; // TEMP
            masterState <= WAIT_FOR_FIRST_EDGE;
            colorState <= GREEN;
          end
          GREEN : begin
            greenFreq <= color_count[10:3];
            freqCount[7:0] <= color_count[10:3]; // TEMP
            masterState <= WAIT_FOR_FIRST_EDGE;
            colorState <= BLUE;
          end
          BLUE : begin
            blueFreq <= color_count[10:3];
            freqCount[7:0] <= color_count[10:3]; // TEMP
            masterState <= DECIDE_COLOR;
            colorState <= RED;
          end
        endcase
      end

      DECIDE_COLOR : begin
        dataReady <= 1;
        masterState <= WAIT_FOR_START;
        // detecting yellow is tricky, but luckily due to the acrylic colors,
        // blue is only the highest value (least light) with the yellow acrylic
        if (blueFreq > redFreq && blueFreq > greenFreq) color <= 2'b11; // yellow
        else if (redFreq < greenFreq && redFreq < blueFreq) color <= 2'b00; // red
        else if (greenFreq < redFreq && greenFreq < blueFreq) color <= 2'b01; // green
        else if (blueFreq < redFreq && blueFreq < greenFreq) color <= 2'b10; // blue
        else  color <= 2'b00; // edge case where the two lowest values the equal, should never happen
      end

    endcase
  end

endmodule

//////////////////////////////////////////////////////////////////////////////

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
