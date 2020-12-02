
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
  // 8 microsteps
  // 36 teeth per head
  // 0.080" belt pitch
  // 555.556 steps per inch
  // 0.325" nit center to center, 180.5557 steps nit center to center.
  parameter [10:0] STEPS_BETWEEN_ROWS = 181;
  parameter [10:0] FIRST_ROW_STEPS_AFTER_HOME = 550;

  // Set the speed of the stepper.
  parameter [15:0] CYCLES_BETWEEN_STEPS = 512;

  reg [3:0] state;
  parameter [3:0] HOME = 0, MOVE_TO_FIRST_ROW = 1, TRAVERSE = 2, SCAN = 3, PARK = 4, FINISHED = 5;
  initial state = HOME;
  parameter UP = 1, DOWN = 0;

  assign motionControllerCompleted = (state == FINISHED);

  reg moveFlag;
  reg stepSignal;
  reg [15:0] stepCount;
  reg [4:0] rowCount;

  pulseExtender pulseExtender1(.clk(clk), .reset(reset), .signal(stepSignal), .extendedSignal(step));

  // State machine.
  always@(posedge clk or negedge reset)
    if(!reset) begin
      //state <= HOME;
      //rowCount <= 0;
    end
  else begin

    case(state)

      HOME : begin
        if (limitSwitch == 1) begin
          direction <= DOWN;
          moveFlag <= 0;
          state <= MOVE_TO_FIRST_ROW;
        end else begin
          direction <= UP;
          moveFlag <= 1;
        end
      end

      MOVE_TO_FIRST_ROW : begin
        if (stepCount == FIRST_ROW_STEPS_AFTER_HOME)
          begin
            moveFlag <= 0;
            startSelector <= 1;
            state <= SCAN;
          end else begin
              moveFlag <= 1;
          end
      end

      TRAVERSE : begin
        if (stepCount == STEPS_BETWEEN_ROWS)
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
          rowCount <= rowCount + 1;
          if (rowCount == 31)
          begin
            state <= PARK;
          end else begin
              state <= TRAVERSE;
          end
        end
      end

      PARK : begin
        if (limitSwitch == 1) begin
          direction <= DOWN;
          state <= FINISHED;
        end else begin
          direction <= UP;
          moveFlag <= 1;
        end
      end

      FINISHED : begin
        moveFlag <= 0;
      end

    endcase
  end

  // Step every X clock signals on set flag.
  // Count steps.
  reg [23:0] delayCounter;
  always@(posedge clk or  negedge reset)
    if(!reset) begin
      stepSignal <= 0;
    end
  else begin
    if (moveFlag) begin
      if (delayCounter == CYCLES_BETWEEN_STEPS) begin
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
