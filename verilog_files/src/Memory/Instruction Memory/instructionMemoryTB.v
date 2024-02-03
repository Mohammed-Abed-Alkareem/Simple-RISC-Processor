module instructionMemoryTB;
	wire clock;		
	ClockGenerator clock_generator(clock);
	reg [31:0]	address;
	reg [31:0] instruction;	 
	
	instructionMemory insMem (clock, address, instruction);
	initial begin

        #0

        address <= 5'd0; // set address to 0
        #5

        address <= 5'd1; // set address to 1
        #10

        address <= 5'd2; // set address to 2
        #10

        address <= 5'd3; // set address to 3
        #10 
        
        $finish;
    end
endmodule			 