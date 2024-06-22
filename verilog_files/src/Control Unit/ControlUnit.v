`include "constants.v"
module controlUnit(
        clock,

        // Signals to be outputted by the CU
        sigPCSrc,
        sigDstReg,
        sigRB,
        sigENW,
        sigALUSrc,
        sigALUOp,
        sigExt,
        sigNewSP,
        sigStackMem,
        sigAddData,
        sigMemR,
        sigMemW,
        sigWB,
        sigWriteVal,

        // Enable signals to be outputted by the CU
        enIF, // enable instruction fetch
        enID, // enable instruction decode
        enE,  // enable execute
        enMem,// enable memory
        enWRB,

        // Inputs for CU, to manage branches, J-Type, and S-Type instructions
        zeroFlag,
        negativeFlag,
        fullFlag,
        emptyFlag,

        // Opcode to determine signals
        instructionCode
    );

    input wire clock;
    input wire zeroFlag, negativeFlag, fullFlag, emptyFlag;
	input wire [5:0] instructionCode;

	output reg [2:0] sigPCSrc = pcDefault;
    output reg [1:0] sigALUOp, sigNewSP;
    output reg sigDstReg, sigRB, sigALUSrc, sigWB, sigExt, sigStackMem, sigAddData, sigWriteVal;

    output reg sigENW = LOW,
                sigMemW = LOW,
                sigMemR = LOW;

    output reg  enE = LOW,
                enIF = LOW,
                enID = LOW, 
				enMem = LOW,
				enWRB = LOW;

    // Code to determine stages and manage stage paths
    `define STG_FTCH 3'b000
    `define STG_DCDE 3'b001
    `define STG_EXEC 3'b010
    `define STG_MEM 3'b011
    `define STG_WRB 3'b100
    `define STG_INIT 3'b101
    

    reg [2:0] currentStage = `STG_INIT;
    reg [2:0] nextStage = `STG_FTCH;

    always@(posedge clock) begin 

        currentStage = nextStage;

    end

    always@(posedge clock) begin 

        case (currentStage)

            `STG_INIT: begin                                    
                enIF = LOW;
                 sigPCSrc = pcDefault; // Set PC source to default during INIT
                nextStage <= `STG_FTCH;
            end

            `STG_FTCH: begin 
                // Disable all previous stages leading up to IF
                enID = LOW;
                enE = LOW;
				enMem = LOW;
				enWRB = LOW;

                // Disable signals
                sigENW = LOW;
                sigMemW = LOW;
                sigMemR = LOW;
				sigNewSP = 2'd0;

                // Enable IF
                enIF = HIGH; // Fetch after finding PC src

                // Determine next stage
                nextStage <= `STG_DCDE;

            end

            `STG_DCDE: begin 
                // Disable all previous stages leading up to ID
                enIF = LOW;

                // Enable IF
                enID = HIGH;
                
                // Next stage is determined by opcode
				if (instructionCode == CALL || instructionCode == RET) begin
					nextStage <= `STG_MEM;
				end	
				else if (instructionCode == JMP) begin
					nextStage <= `STG_FTCH;
				end
				else begin
					nextStage <= `STG_EXEC;
				end
						  

                	sigRB = (instructionCode == SW || instructionCode == BGT || instructionCode == BLT || instructionCode == BEQ || instructionCode == BNE || instructionCode == PUSH) ? HIGH : LOW;
				sigDstReg = (instructionCode == LWPOI && enID) ? LOW : HIGH; // Destination Register is R1 for this stage
				sigENW = (instructionCode == LWPOI || instructionCode == LW) ? HIGH : LOW;
				sigExt = (instructionCode == ANDI)	? LOW : HIGH;
				sigALUSrc = (instructionCode == ANDI || instructionCode == ADDI || instructionCode == LW || instructionCode == LWPOI || instructionCode == SW) ? LOW : HIGH;
				sigWriteVal = (instructionCode == LWPOI && enID) ? LOW : HIGH;



        // Determine PC source for next instruction only if the next stage is `STG_FTCH`
                if (nextStage == `STG_FTCH) begin
                    if (instructionCode == BGT && negativeFlag || instructionCode == BLT && ~negativeFlag || instructionCode == BEQ && zeroFlag || instructionCode == BNE && ~zeroFlag) begin
                        sigPCSrc = pcSgnImm;
                    end else if (instructionCode == JMP || instructionCode == CALL) begin
                        sigPCSrc = pcImm;
                    end else if (instructionCode == RET) begin
                        sigPCSrc = pcStack;
                    end else begin
                        sigPCSrc = pcDefault;
                    end
                end



            end

            `STG_EXEC: begin 
                
                // Disable all previous stages leading up to execute stage
                enID = LOW;

                // Enable execute stage
                enE = HIGH;

                // Next stage is determined by opcode
                if  (instructionCode == LW || instructionCode == LWPOI || instructionCode == SW || instructionCode == POP || instructionCode == PUSH) begin

                    nextStage <= `STG_MEM;

                end else if (instructionCode == AND || instructionCode == ADD || instructionCode == SUB || instructionCode == ANDI || instructionCode == ADDI) begin 

                    nextStage <= `STG_WRB;

                end else begin

                    nextStage <= `STG_FTCH;

                end

                // Set ALUOp signal based on the opcodes
                if (instructionCode == AND || instructionCode == ANDI) begin

                    sigALUOp = ALU_AND;

                end else if (instructionCode == ADD || instructionCode == ADDI || instructionCode == LW || instructionCode == LWPOI || instructionCode == SW) begin

                    sigALUOp = ALU_ADD;

                end else begin

                    sigALUOp = ALU_SUB;

                end	
				sigENW = LOW;


// Determine PC source for next instruction only if the next stage is `STG_FTCH`
                if (nextStage == `STG_FTCH) begin
                    if (instructionCode == BGT && negativeFlag || instructionCode == BLT && ~negativeFlag || instructionCode == BEQ && zeroFlag || instructionCode == BNE && ~zeroFlag) begin
                        sigPCSrc = pcSgnImm;
                    end else if (instructionCode == JMP || instructionCode == CALL) begin
                        sigPCSrc = pcImm;
                    end else if (instructionCode == RET) begin
                        sigPCSrc = pcStack;
                    end else begin
                        sigPCSrc = pcDefault;
                    end
                end



            end

            `STG_MEM: begin 
                // Disable all previous stages leading up to memory stage
				enE = LOW;
				enID = LOW;

                // Enable memory stage
				enMem = HIGH;
                
                // Next stage determined by opcodes
                nextStage <= (instructionCode == LW || instructionCode == LWPOI || instructionCode == POP) ? `STG_WRB : `STG_FTCH;

                // Memory write is determined by the SW instruction
				sigMemW = (instructionCode == SW) ? HIGH : LOW;
				
                // Memory Read is determined by Load instructions
               	sigMemR = (instructionCode == LW || instructionCode == LWPOI) ? HIGH : LOW;

                // Signals determined by opcodes 
				sigStackMem = (instructionCode == CALL || instructionCode == RET || instructionCode == PUSH || instructionCode == POP) ? HIGH : LOW;
				sigAddData = (instructionCode == CALL) ? HIGH : LOW;
				
                // Stack pointer signal is determined by opcodes
            	if ((instructionCode == RET || instructionCode == POP) && ~emptyFlag) begin

                    sigNewSP = stackPointerPop;

               	end else if ((instructionCode == CALL || instructionCode == PUSH) && ~fullFlag) begin

                    sigNewSP = stackPointerPush;

                end else begin

                    sigNewSP = stackPointerDef;

                end


// Determine PC source for next instruction only if the next stage is `STG_FTCH`
                if (nextStage == `STG_FTCH) begin
                    if (instructionCode == BGT && negativeFlag || instructionCode == BLT && ~negativeFlag || instructionCode == BEQ && zeroFlag || instructionCode == BNE && ~zeroFlag) begin
                        sigPCSrc = pcSgnImm;
                    end else if (instructionCode == JMP || instructionCode == CALL) begin
                        sigPCSrc = pcImm;
                    end else if (instructionCode == RET) begin
                        sigPCSrc = pcStack;
                    end else begin
                        sigPCSrc = pcDefault;
                    end
                end

            end

            `STG_WRB: begin 
                // Disable all previous stages leading up to WRB
                sigMemW = LOW;
                sigMemR = LOW;
                enE = LOW;
				enMem = LOW;
				sigNewSP = 2'b00;

                // Enable WRB stage
				enWRB = HIGH;
                
                // Next stage following WRB is IF
                nextStage <= `STG_FTCH;

                // Enable writing to register filw
                sigENW = HIGH;
				sigENW = (instructionCode == SW || instructionCode == BGT || instructionCode == BLT || instructionCode == BEQ || instructionCode == BNE || instructionCode == JMP || instructionCode == CALL || instructionCode == PUSH) ? LOW : HIGH;
                
                // Determine the register to write to
				sigWB = (instructionCode == AND || instructionCode == ADD || instructionCode == SUB || instructionCode == ANDI || instructionCode == ADDI) ? LOW : HIGH;
				
                // Set to 1 for all instructions
				sigDstReg = HIGH;	
				sigWriteVal = HIGH;


// Determine PC source for next instruction only if the next stage is `STG_FTCH`
                if (nextStage == `STG_FTCH) begin
                    if (instructionCode == BGT && negativeFlag || instructionCode == BLT && ~negativeFlag || instructionCode == BEQ && zeroFlag || instructionCode == BNE && ~zeroFlag) begin
                        sigPCSrc = pcSgnImm;
                    end else if (instructionCode == JMP || instructionCode == CALL) begin
                        sigPCSrc = pcImm;
                    end else if (instructionCode == RET) begin
                        sigPCSrc = pcStack;
                    end else begin
                        sigPCSrc = pcDefault;
                    end
                end


            end						  

        endcase

    end		
endmodule
