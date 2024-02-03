`include "constants.v"

module stackPointer(clock, SP, newSP, empty, full);		  
	
    input wire clock;
	
    output reg [31:0] SP; 
	
	output reg  empty, full;
	
	input wire [1:0] newSP;
	

    // SP + 1
    wire [31:0] SPPlus1;
	assign  SPPlus1 = SP + 32'd1;	
	
	// SP - 1
    wire [31:0] SPMin1;	
	assign  SPMin1 = SP - 32'd1;
	
	initial begin
		SP <= 32'd222;
		empty = 1'b1 ;
		full = 1'b0	;
	end

	
	always @(posedge clock) begin
		
		if (SP == 32'd222) begin
            empty <= 1'b1;
        end 
		
		else begin
            empty <= 1'b0;
        end

        if (SP == 32'd256) begin
            full <= 1'b1;
        end 
		else begin
            full <= 1'b0;
        end
			
	end
	
	
    always @(posedge clock) begin
        case (newSP)   
			
            stackPointerDef: begin
                // Do nothing   
            end    
			
            stackPointerPop: begin
                // SP = SP - 1
                SP = SPMin1;
            end  
            
			 stackPointerPush: begin
                // SP = SP + 1
                SP = SPPlus1;
            end  
			
        endcase
	end
    
endmodule 