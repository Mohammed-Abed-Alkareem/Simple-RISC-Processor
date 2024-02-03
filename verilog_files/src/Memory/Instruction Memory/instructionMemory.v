`include "constants.v"
module instructionMemory (clock, address, instruction);

	input wire clock;
	input wire [31:0] address;
	output reg [0:31] instruction;
	reg [31:0] memory [0:255];
	always @(posedge clock)
		begin		
			instruction <= memory[address];
	end
	initial begin							   
        // memory[0] <= 32'd32;
		// memory[1] <= 32'd50;
		// memory[2] <= 32'd25;
		// R-Type Instructions
		
		memory[0] = {ADDI, R1, R2, 16'd10, 2'b00};   // R1 = R2 + 10 = 10
		memory[1] = {ADDI, R2, R3, 16'd20, 2'b00};   // R2 = R3 + 20 = 20
		memory[2] = {AND, R3, R1, R2, 14'b00};       // R3 = R1 & R2 = 0
		memory[3] = {ADD, R4, R1, R2, 14'b00};       // R4 = R1 + R2 = 30
		memory[4] = {SUB, R3, R2, R1, 14'b00};       // R3 = R2 - R1 = 10
		
		// I-Type ALU Instructions	 
		// I-Type Branch Instructions 
		//memory[5] = {ADDI, R15, R2, 16'd10, 2'b00};
//		memory[6] = {ADDI, R1, R3, 16'd20, 2'b00};	// R1 = 20
//		//BGT not Taken
//		memory[7] = {BGT, R15, R1, 16'd0, 2'b00};
		//memory[5] = {LW, R9, R1, 16'd30, 2'b00};
//		memory[6] = {LWPOI, R11, R12, 16'd40, 2'b00};
//		memory[7] = {ADDI, R13, R5, 16'd15, 2'b00};
//		memory[8] = {SW, R13, R5, 16'd100, 2'b00};





		// BGT and Taken
//		memory[4] = {BGT, R1, R15, 16'd15, 2'b00};		 
//		memory[5] = {ADDI, R5, R6, 16'd10, 2'b00};
//										   

//		memory[4] = {BLT, R7, R8, 16'd13, 2'b00};  
//		memory[5] = {ADDI, R9, R10, 16'd15, 2'b00};  
//											  
//		memory[6] = {BLT, R11, R12, 16'd15, 2'b00};	  
//		memory[7] = {ADDI, R13, R14, 16'd20, 2'b00};  
//										 
//		memory[8] = {BEQ, R15, R1, 16'd17, 2'b00};	 
//		memory[9] = {ADDI, R2, R3, 16'd25, 2'b00};  
//										 
//		memory[10] = {BEQ, R4, R5, 16'd19, 2'b00};	   
//		memory[11] = {ADDI, R6, R7, 16'd30, 2'b00};  
//							 
//		memory[12] = {BNE, R8, R9, 16'd21, 2'b00}; 
//		memory[13] = {ADDI, R10, R11, 16'd35, 2'b00};  
//									  
//		memory[14] = {BNE, R12, R13, 16'd23, 2'b00};	
//		memory[8] = {ADDI, R14, R15, 16'd40, 2'b00};  
//		
//		// J-Type Instructions
//		// JMP Unconditional Jump
//		memory[24] = {JMP, 26'd29};
//		
//		// CALL Subroutine Call
//		memory[25] = {CALL, 26'd26};
//		// Code of the subroutine
//		memory[26] = {RET, 26'd0};
//		
//		// S-Type Instructions
//		// PUSH.1
//		memory[27] = {PUSH, R1, 22'b00};
//		
//		// POP.1
//		memory[28] = {POP, R2, 22'b00};
//		
//		// JMP Address
//		memory[29] = {ADDI, R3, R4, 16'd40, 2'b00};
    end
endmodule
