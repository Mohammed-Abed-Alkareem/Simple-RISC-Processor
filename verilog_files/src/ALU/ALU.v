`include "constants.v"
module ALU( A, B, Output, zeroFlag, nFlag, ALUop, EN);

	// Select to determine ALU operation
	input wire [1:0] ALUop;

	// ALU Operands
	input wire [31:0] A, B;
	input wire EN;

	output reg	[31:0]	Output; // Output result of ALU
	output reg zeroFlag;
	output reg nFlag;

	// ----------------- LOGIC -----------------

	assign zeroFlag = (0 == Output);
	assign nFlag = (Output[31] == 1); // if 2s complement number is negative, MSB is 1

	always @(EN) begin 
		#1 // To wait for ALU source mux to select operands
		case (ALUop)
			ALU_AND:  Output <= A & B;
			ALU_ADD:  Output <= A + B;
			ALU_SUB:  Output <= A - B; 
			default: Output <= 0;
		endcase
	end	
	
	initial begin
		if (EN == LOW)begin
			Output = 32'd0;
		end
	end	
endmodule
