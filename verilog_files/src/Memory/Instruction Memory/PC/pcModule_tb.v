`include "constants.v"
module pcModule_tb;			   

	wire clock;				
	ClockGenerator clock_generator(clock);

    reg [1:0] PCsrc = pcDefault;
    reg [31:0] topStack;
	reg [31:0] Immediate;
	reg EN;
    reg signed [15:0] Imm16;
    wire [31:0] PC;
	
    
    pcModule Module(clock, PC, PCsrc, Immediate, Imm16, topStack, EN);
    
    initial begin
		EN = HIGH;
        #0

        PCsrc <= pcDefault; // PC = PC + 1
        #10

        PCsrc <= pcImm; // PC = {PC[31:26], Immediate26 }
        Immediate <= 32'd2; // Write value 2
        #10
        
        PCsrc <= pcSgnImm; // PC = PC + sign_extended (Imm16)
        Imm16 <= 16'd10; // Add 10 to PC  
        #10
        
        PCsrc <= pcStack; // PC = top of the stack
        topStack <= 32'd8; // Top value in stack is 8
        #10

        #10 
        $finish;
    end

endmodule							

