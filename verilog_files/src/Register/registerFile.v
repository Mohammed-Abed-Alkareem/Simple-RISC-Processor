`include "constants.v"
module registerFile(clock, RA, RB, RW, EnW, BusW, BusA, BusB, EN, registers_array);
    
	input wire clock;

	input wire EnW, EN;

	input wire [3:0] RA, RB, RW;
    
	output reg [31:0] BusA, BusB; 
	
	
	input wire [31:0] BusW;

	output reg [31:0] registers_array [0:15];
	
	always @(posedge clock) begin
		if(EN) begin
			BusA = registers_array[RA];
			BusB = registers_array[RB];
		end
	end

	always @(posedge EnW ) begin
		
		if ( RW != 4'b0 && EN) begin
			registers_array[RW] = BusW;	
		end
		
	end

	initial begin
		// Initialize registers to be zeros
		registers_array[0] <= 32'h00000000;
		registers_array[1] <= 32'h00000000;
		registers_array[2] <= 32'h00000000;
		registers_array[3] <= 32'h00000000;
		registers_array[4] <= 32'h00000000;
		registers_array[5] <= 32'h00000000;
		registers_array[6] <= 32'h00000000;		
		registers_array[7] <= 32'h00000000;		
		registers_array[8] <= 32'h00000000;
		registers_array[9] <= 32'h00000000;
		registers_array[10] <= 32'h00000000;
		registers_array[11] <= 32'h00000000;
		registers_array[12] <= 32'h00000000;
		registers_array[13] <= 32'h00000000;
		registers_array[14] <= 32'h00000000;
		registers_array[15] <= 32'h00000000;
	end
endmodule						 

