
// RGBY-ROM
//
// FPGA implemented motion controller, ram controller, and RGBY-ROM CPU
//
// Reuben Strangelove
// Winter 2019 - Winter 2020
//
// FPGA Hardware: TinyFpga BX
// Color dection sensors: TCS32000
// Stepper driver: Pololu A4988

module top (
  input CLK,      // 16MHz clock
  output LED,     // User/boot LED next to power LED
  output USBPU,   // USB pull-up resistor
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
  // output PIN_11,
  input PIN_12,
  input PIN_13,
  output PIN_14,
  output PIN_15,
  output PIN_16,
  output PIN_17,
  // output PIN_18,
  output PIN_19,
  // output PIN_20,
  output PIN_21,
  output PIN_22,
  output PIN_23,
  output PIN_24,
  output PIN_25,
  output PIN_26,
  output PIN_27,
  output PIN_28,
  input PIN_29,
  input PIN_30);

  // Create wires.
  wire clk;
  wire reset;
  wire [1:0] colorSelect;
  wire [1:0] color;
  wire [7:0] freqCount;
  wire frequencyFromColorSensor;
  wire [7:0] portIn;
  wire [7:0] portOut;
  wire [7:0] random;
  wire [11:0] readData;
  wire [7:0] programCounter;
  wire [7:0] red, green, blue;
  wire [7:0] redReg, greenReg, blueReg;
  wire [7:0] debug;
  wire [3:0] sensorSelect;
  wire motionControllerCompleted;
  wire startSelector, selectorComplete;
  wire startDetection, detectionComplete;

  // Drive USB pull-up resistor to '0' to disable USB.
  assign USBPU = 0;

  // Reduce 8MHz clock down to 1MHz (consider changing the PLL).
  clockDivider clkDiv1(.clk(CLK), .reset(reset), .clk_out(clk));

  // Toggle onboard LED's state every 1Hz for clock simply visual clock frequency verification.
  ledBlinker ledBlinker(.clk(clk), .reset(reset), .state(LED));

  // Assign input buttons (route some buttons through a debouncer)
  wire limitSwitch = PIN_12;
  assign reset = 1;
  assign portIn[7:2] = 6'b000000;
  buttonController buttonController1(.clk(clk), .reset(reset), .buttonIn(~PIN_30), .buttonOut(portIn[0]));
  buttonController buttonController2(.clk(clk), .reset(reset), .buttonIn(~PIN_29), .buttonOut(portIn[1]));
  //buttonController buttonController2(.clk(clk), .reset(reset), .buttonIn(~PIN_13), .buttonOut(reset));

  // Assign external outputs.
  assign {PIN_17, PIN_26, PIN_19, PIN_25, PIN_21, PIN_22, PIN_23, PIN_24} = portOut[7:0];
  //assign {PIN_17, PIN_26, PIN_19, PIN_25, PIN_21, PIN_22, PIN_23, PIN_24} =  blue; // Debug

  // Assign sensor bar.
  assign frequencyFromColorSensor = PIN_3;
  assign {PIN_4, PIN_5, PIN_6, PIN_7} = sensorSelect[3:0];
  assign {PIN_8, PIN_9} = colorSelect[1:0];

  // Assign red, green, blue LEDs after routing color registers through PWM hardware.
  pwm pwm1(.clk(clk), .reset(reset), .duty(red), .signal(PIN_14));
  pwm pwm2(.clk(clk), .reset(reset), .duty(green), .signal(PIN_15));
  pwm pwm3(.clk(clk), .reset(reset), .duty(blue), .signal(PIN_16));

  // Assign status LEDs
  assign PIN_10 = !motionControllerCompleted; // Mode: Read ROM
  assign PIN_27 = motionControllerCompleted; // Mode: Execute

  // Attach random number generator.
  random random1(.clk(clk), .reset(reset), .out(random[7:0]));

  // Assign stepper motor driver pins.
  wire direction = PIN_1;
  wire step = PIN_2;
  wire PIN_28 = motionControllerCompleted; // Stepper driver enable pin, active low.

  // Instantiate and connect main modules.
  motionController motionController1(
    .clk(clk),
    .reset(reset),
    .limitSwitch(limitSwitch),
    .selectorComplete(selectorComplete),
    .startSelector(startSelector),
    .direction(direction),
    .step(step),
    .motionControllerCompleted(motionControllerCompleted));

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
    .frequencyFromColorSensor(frequencyFromColorSensor),
    .startDetection(startDetection),
    .colorSelect(colorSelect),
    .detectionComplete(detectionComplete),
    .color(color),
    .freqCount(freqCount));

  ramController ram1(
    .clk(clk),
    .reset(reset),
    .colorReady(detectionComplete),
    .color(color),
    .readAddress(programCounter),
    .readData(readData));

  cpu cpu(
    .clk(clk),
    .reset(reset),
    .halt(~motionControllerCompleted),
    .instruction(readData),
    .programCounter(programCounter),
    .portIn(portIn),
    .random(random),
    .portOut(portOut),
    .red(redReg),
    .green(greenReg),
    .blue(blueReg),
    .debug(debug));

    // Assignments and MUXes.
    // Show detected colors upon reading the data cartridge.
  assign red = motionControllerCompleted ? redReg : (color == 0 || color == 3) ? 65 : 0;
  assign green = motionControllerCompleted ? greenReg : (color == 1 || color == 3) ? 65 : 0;
  assign blue = motionControllerCompleted ? blueReg : (color == 2) ? 65 : 0;

endmodule
