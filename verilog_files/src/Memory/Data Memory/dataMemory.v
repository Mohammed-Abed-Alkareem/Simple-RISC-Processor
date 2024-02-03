`include "constants.v"
module dataMemory(clock, ALUaddress, stackPointer, regData , addData , dataOut, ENW, ENR , address_data, stack_mem, EN, memory);

    input wire clock;
    input wire ENW;
    input wire ENR, EN;
    input wire address_data, stack_mem;

    // Address bus
    input wire [31:0] ALUaddress; 
	input wire [31:0] stackPointer;

   
    input wire [31:0] regData;	 
	input wire [31:0] addData;

    // Output of data memory
    output reg [31:0] dataOut;


    output reg [31:0] memory [0:255];	
	
	reg [31:0] AddressBus, dataIn;
	always  @(stack_mem) begin  // Determine where to fetch address from		   
		if (EN) begin
            if (stack_mem == memStore) begin
                AddressBus <= ALUaddress;	 
            end
                
            else if (stack_mem == stackStore) begin	
                AddressBus <= stackPointer;	 
            end
		end
	end	 
	
	
	always  @(address_data) begin  // Determine where to store data from
		if (EN) begin
            if (address_data == addressDataRF) begin
                dataIn <= regData;	 
            end
			
            else if (address_data == addressDataPC) begin	
                dataIn <= addData;	 
            end
		end
	end	   

    always  @(posedge clock) begin
		if(EN) begin
            if (ENR) begin
                dataOut <= memory[AddressBus];
            end else if (ENW) begin
                memory[AddressBus] <= dataIn;
            end
		end
    end
	
    initial begin
        // Store initial values in the memory for testing purposess
        memory[0] = 32'd10;
        memory[1] = 32'd5;
		memory[40] = 32'd6;
		memory[60] = 32'd5;
		memory[223] = 32'd15; 
    end	

endmodule