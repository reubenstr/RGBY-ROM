
// Controllers stepper motor during RGBYROM read operation.
module motionController (
  input clk,
  input reset,
  input limitSwitch,
  input selectorComplete,
  output reg startSelector,
  output direction,
  output step,
  output motionControllerCompleted);

  // http://buildlog.net/cnc_laser/belt_calcs.htm
  // 200 steps per revolution
  // 18 teeth per head
  // 8 microsteps
  // 747 per nib center
  // 2259 steps per inch
  parameter [15:0] PULSE_PER_NIB = 836; // origil : 747
  parameter [15:0] PULSE_PER_ROW = 14218; // 8364 = 10 nibs ((PULSE_PER_NIB * NIBS) - 1)

  reg [3:0] state;
  parameter [3:0] HOME = 0, FIRST_ROW = 6, TRAVERSE = 1, HOLD = 5, HALT = 2, FINISHED = 3, SCAN = 4;
  initial state = HOME;
  parameter UP = 1, DOWN = 0;

  assign motionControllerCompleted = (state == FINISHED);

  reg moveFlag;
  reg stepSignal;
  reg [15:0] stepCount;

  pulseExtender pulseExtender1(.clk(clk), .reset(reset), .signal(stepSignal), .extendedSignal(step));

  always@(posedge clk or negedge reset)
    if(!reset) begin
      state = HOME;
    end
  else begin

    case(state)
      ////////////////////////////////

      HOME : begin
        if (limitSwitch == 1) begin
          direction <= DOWN;
          moveFlag <= 0;
          state <= FIRST_ROW;
        end else begin
          direction <= UP;
          moveFlag <= 1;
        end
      end

      ////////////////////////////////

      FIRST_ROW : begin
        if (stepCount == 550)
          begin
            moveFlag <= 0;
            startSelector <= 1;
            state <= SCAN;
          end else begin
              moveFlag <= 1;
          end
      end

      ////////////////////////////////

      TRAVERSE : begin
        if (stepCount == 300)
          begin
            moveFlag <= 0;
            startSelector <= 1;
            state <= SCAN;
          end else begin
            moveFlag <= 1;
          end
      end

      SCAN : begin
        startSelector <= 0;
        if (selectorComplete == 1)
        begin          
          state <= TRAVERSE;
        end
      end

      ////////////////////////////////

      FINISHED : begin
        moveFlag <= 0;
      end

      ////////////////////////////////
    endcase
  end



  // Step every X clock signals on flag.
  // Count steps.
  reg [23:0] delayCounter;
  always@(posedge clk or  negedge reset)
    if(!reset) begin
      stepSignal <= 0;
    end
  else begin
    if (moveFlag) begin
      if (delayCounter == 1024) begin
        delayCounter <= 0;
        stepSignal <= 1;
        stepCount <= stepCount + 1;
      end else begin
        delayCounter <= delayCounter + 1;
        stepSignal <= 0;
      end
    end else begin
      stepSignal <= 0;
      delayCounter <= 0;
      stepCount <= 0;
    end
  end


endmodule
