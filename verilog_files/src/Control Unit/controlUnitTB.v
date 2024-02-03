`include "constants.v"
module controlUnitTestBench;

    wire clock;
    ClockGenerator clock_generator(clock);

    // Opcode to be sent
    reg [5:0] instructionCode;

    reg zeroFlag, negativeFlag, fullFlag, emptyFlag; 

    // Output signals
	wire [2:0] sigPCSrc;
    wire [1:0] sigALUOp, sigNewSP;
    wire sigDstReg, sigRB, sigALUSrc, sigWB, sigExt, sigStackMem, sigAddData, sigWriteVal;
    wire sigENW, sigMemW, sigMemR;

    
    // Stage enable signals
    wire enE, enIF, enID, enMem, enWRB;

    controlUnit control_unit(
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
    

    initial begin
		
        #0 
		// R-Type
        // AND takes 4 stages to complete (4 clock cycles) 
        instructionCode = AND;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #40
		
		// ADD takes 4 stages to complete (4 clock cycles) 
        instructionCode = ADD;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #40
		
		// SUB takes 4 stages to complete (4 clock cycles) 
        instructionCode = SUB;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #40
		
		// I-Type ALU Instructions
		
		// ANDI takes 4 stages to complete (4 clock cycles)
        instructionCode = ANDI;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
		#40
		
		// ADDI takes 4 stages to complete (4 clock cycles)
        instructionCode = ADDI; 
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #40
		
		// LW takes 5 stages to complete (5 clock cycles) 
        instructionCode = LW;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #50
		
		// LWPOI takes 4 stages to complete (4 clock cycles)
        instructionCode = LWPOI;
		negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #50
		
		// SW takes 4 stages to complete (4 clock cycles)
        instructionCode = SW;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #40
		
		// Branch operations take 3 stages to complete
		// BGT and Taken
		instructionCode = BGT;
        negativeFlag = 1;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #30
		
		//BGT and not Taken
		instructionCode = BGT;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #30
		
		// BLT and Taken
		instructionCode = BLT;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #30
		
		//BLT and not Taken
		instructionCode = BLT;
        negativeFlag = 1;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #30
		
		// BEQ and Taken
		instructionCode = BEQ;
        negativeFlag = 0;
        zeroFlag = 1;
		emptyFlag = 0;
		fullFlag = 0;
        #30
		
		// BEQ and not Taken
		instructionCode = BEQ;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #30

       	// BNE and Taken
		instructionCode = BNE;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #30
		
		// BNE and not Taken
		instructionCode = BNE;
        negativeFlag = 0;
        zeroFlag = 1;
		emptyFlag = 0;
		fullFlag = 0;
        #30
	
		// J-Type Instructions
		// JMP takes 3 stages to complete
		instructionCode = JMP;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #20
		
		// CALL takes 3 stages to complete 
        instructionCode = CALL;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #30
		
		// RET takes 3 stages to complete
		instructionCode = RET;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #30
		
		// PUSH takes 4 stages to complete
		// PUSH to an empty stack
        instructionCode = PUSH;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #40
		
		// PUSH takes 4 stages to complete
		// PUSH to a full stack
		instructionCode = PUSH;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 1;
        #40
		
		// POP takes 5 stages to complete
		// POP from a non-empty stack
        instructionCode = POP;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 0;
		fullFlag = 0;
        #50	
		
		// POP takes 5 stages to complete
		// POP from an empty stack
        instructionCode = POP;
        negativeFlag = 0;
        zeroFlag = 0;
		emptyFlag = 1;
		fullFlag = 0;
        #50
        #10 $finish;

    end

endmodule
