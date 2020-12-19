//#defines used to match assembler and FPGA
//instruction and registor addresses.

// instruction opcodes generated by RGBY-ROM Assembler
`define OPCODE_MOV 4'h0
`define OPCODE_AND 4'h1
`define OPCODE_OR 4'h2
`define OPCODE_XOR 4'h3
`define OPCODE_ADD 4'h4
`define OPCODE_ADDS 4'h5
`define OPCODE_SUB 4'h6
`define OPCODE_SIN 4'h7
`define OPCODE_SHIFT 4'h8
`define OPCODE_EQ 4'h9
`define OPCODE_SLT 4'hA
`define OPCODE_LI 4'hB
`define OPCODE_DELAY 4'hC
`define OPCODE_BOS 4'hD
`define OPCODE_BNS 4'hE
`define OPCODE_J 4'hF


// registers generated by RGBY-ROM Assembler
`define REG_ZERO 4'h0
`define REG_ONE 4'h1
`define REG_RAND 4'h2
`define REG_RESULT 4'h3
`define REG_IMM 4'h4
`define REG_RED 4'h5
`define REG_GREEN 4'h6
`define REG_BLUE 4'h7
`define REG_PORTOUT 4'h8
`define REG_PORTIN 4'h9
`define REG_INDEX 4'hA
`define REG_SPEED 4'hB
`define REG_PHASE 4'hC
`define REG_MODE 4'hD
`define REG_GENA 4'hE
`define REG_GENB 4'hF




module cpu(
  input clk,
  input reset,
  input halt,
  input [11:0] instruction,
  input [7:0] portIn,
  input [7:0] random,
  output [7:0] programCounter,
  output [7:0] portOut,
  output [7:0] red,
  output [7:0] green,
  output [7:0] blue,
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
    .red(red),
    .green(green),
    .blue(blue));

  alu alu(
    .clk(clk),
    .reset(reset),
    .aluOpCode(instruction[11:8]),
    .dataA(registerA),
    .dataB(registerB),
    .aluResult(aluResult),
    .set(set));

  pcControler pcControler(
    .clk(clk),
    .reset(reset),
    .halt(halt),
    .ctrlPcDelay(ctrlPcDelay),
    .ctrlPcSelect(ctrlPcSelect),
    .instruction(instruction[7:0]),
    .programCounter(programCounter));

  // Writeback MUX
  assign writeData = (ctrlWriteSource == 1) ?  instruction[7:0] : aluResult;

endmodule

/////////////////////////////////////////////////////////////////////////////

module pcControler(
  input clk,
  input reset,
  input halt,
  input ctrlPcDelay,
  input ctrlPcSelect,
  input [7:0] instruction,
  output reg [7:0] programCounter);

  wire addImmediate;

  reg [20:0] delayCounter;
  initial delayCounter = 0;

  // Increment program counter.
  always@(posedge clk or posedge reset)
    if(reset) begin
      // programCounter <= 0;
    end else begin
      if (halt == 0)
      begin
        // Increment MUX.
        programCounter <= (ctrlPcSelect == 1) ?  instruction : programCounter + addImmediate;
      end
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
  assign addImmediate = (delayCounter != (instruction << 10) && ctrlPcDelay == 1) ? 0 : 1;

endmodule

/////////////////////////////////////////////////////////////////////////////

module controller(
  input clk,
  input reset,
  input [11:0] instruction,
  input [3:0] regA,
  input set,
  output [3:0] selectWriteRegister,
  output ctrlPcDelay,
  output ctrlPcSelect,
  output ctrlWriteRegister,
  output ctrlLoadImmediate,
  output ctrlWriteSource);

  wire [3:0] opCode = instruction[11:8];
  wire [3:0] regA = instruction[7:4];

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
     opCode == `OPCODE_SUB || opCode == `OPCODE_SIN || opCode == `OPCODE_LI ||
     opCode == `OPCODE_SHIFT) ? 1 : 0;

  // select which register to write
  assign selectWriteRegister =
    (opCode == `OPCODE_LI) ? `REG_IMM :
    (opCode == `OPCODE_MOV || opCode == `OPCODE_ADDS || opCode == `OPCODE_SIN) ? regA : `REG_RESULT;

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
  output [7:0] red,
  output [7:0] green,
  output [7:0] blue);

  reg [7:0] registers [15:0];

  initial begin
     registers [`REG_ZERO] = 8'h00;
     registers [`REG_ONE] = 8'h01;
  end

  // Assign output registers to selected registers.
  assign registerA = registers[selectRegisterA];
  assign registerB = registers[selectRegisterB];

  always@(posedge clk)
    begin

    //registers[`REG_ZERO] <= 8'h00;
    //registers[`REG_ONE] <= 8'h01;

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
  assign red = registers[`REG_RED];
  assign green = registers[`REG_GREEN];
  assign blue = registers[`REG_BLUE];

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

  wire [7:0] sinResult;
  sinTable sinTable(dataB, sinResult);

  assign aluResult =
    (aluOpCode == `OPCODE_MOV) ? dataB :
    (aluOpCode == `OPCODE_AND) ? dataA & dataB :
    (aluOpCode == `OPCODE_OR) ? dataA | dataB :
    (aluOpCode == `OPCODE_XOR) ? dataA ^ dataB :
    (aluOpCode == `OPCODE_SHIFT) ? dataA << dataB :
    (aluOpCode == `OPCODE_SIN) ? sinResult :
    (aluOpCode == `OPCODE_ADD || aluOpCode == `OPCODE_ADDS) ? dataA + dataB :
    (aluOpCode == `OPCODE_SUB) ? dataA - dataB : 0;

    always@(posedge clk)
       begin
          if (aluOpCode == `OPCODE_SLT)
            set <= dataA < dataB;
          else if (aluOpCode == `OPCODE_EQ)
            set <=  dataA == dataB;
        end

endmodule
