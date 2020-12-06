// Code repository of testing code

/*
   // Extract ram data.
   reg [7:0] addrRead;
   reg [2:0] nitSel;
   reg [1:0] nitVal;
   reg readBackCompleted;

   always @(posedge clk) begin

     if (motionControllerCompleted && !readBackCompleted) begin

          if (nitSel == 5) begin
             nitSel <= 0;
             addrRead <= addrRead + 1;
             if (addrRead == 32) readBackCompleted <= 1;
          end else begin
             nitSel <= nitSel + 1;
          end

          // TODO: flip nit sequence.
           nitVal <= readData >> (nitSel * 2);
     end
   end

   assign programCounter = addrRead;

   assign portOut[0] = ~(motionControllerCompleted && !readBackCompleted);
   assign portOut[2:1] = ~nitVal;
   assign portOut[3] = ~(motionControllerCompleted && !readBackCompleted) ?  1 : ~clk;
   assign portOut[4] = ~addrRead[0];
   assign portOut[7:5] = ~nitSel;
   */
