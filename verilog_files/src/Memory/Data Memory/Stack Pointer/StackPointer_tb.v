`include "constants.v"
module StackPointer_tb;			   

	wire clock;				
	ClockGenerator clock_generator(clock);

    // Set newSP to the default value of 0
    reg [1:0] newSP = stackPointerDef;
	reg [31:0] SP;
	reg empty, full;

    stackPointer Module(clock, SP, newSP, empty , full);
    
    initial begin
        // Push in two values and pop one
        #0
        newSP <= stackPointerDef; // SP source default
        #10

        newSP <= stackPointerPush; // SP PUSH
        #10
        
        newSP <= stackPointerPush; // SP PUSH
        #10
        
        newSP <= stackPointerPop; // SP POP	  

        #10 
        $finish;
    end

endmodule