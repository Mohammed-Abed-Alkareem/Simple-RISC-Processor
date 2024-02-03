`include "constants.v"
module dataMemoryTB;

    wire clock;
    ClockGenerator clock_generator(clock);

    // Data memory outputs and inputs
    reg [31:0] dataOut;
    reg [31:0] ALUaddress ,stackPointer, regData , addData; 	   
 	reg [31:0] memory [0:255];
	
    // Signals
    reg ENW = 0;
    reg ENR = 0;
	reg EN;
	reg address_data, stack_mem;


    dataMemory dataMem(clock, ALUaddress ,stackPointer, regData , addData , dataOut, ENW, ENR , address_data, stack_mem, EN, memory);


    initial begin
		EN = HIGH;
        #0
        ALUaddress <= 32'd1; // Address 1 
		stackPointer<= 32'd223;
        ENR <= 1; // Enable read
		ENW <= 0; // Disable write
		stack_mem <= memStore;
		#10

        ALUaddress <= 32'd1; // address 1 
		stackPointer<= 32'd223;
        ENR <= 1; // Enable read
		ENW <= 0; // Disable write
		stack_mem <= stackStore; 
   		#10

        ALUaddress <= 32'd2; // address 2 
		stackPointer<= 32'd224;
		regData <= 32'd4;
		addData <= 32'd16;
        ENR <= 0; // Disable read
		ENW <= 1; // Enable write	
		address_data <= addressDataRF;
		stack_mem <= memStore; 
		#10

        ALUaddress <= 32'd2; // address 2 
		stackPointer<= 32'd224;
		regData <= 32'd4;
		addData <= 32'd16;
        ENR <= 0; // Disable read
		ENW <= 1; // Enable write	
		address_data <= addressDataPC;
		stack_mem <= stackStore;
		#10

        ALUaddress <= 32'd0; // address 0 
		stackPointer<= 32'd223;
        ENR <= 1; // Enable read
		ENW <= 0; // Disable write
		stack_mem <= stackStore;
        #10 
        
        $finish;
    end

endmodule