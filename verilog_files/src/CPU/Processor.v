`include "constants.v"
module riscProcessor();
		
    initial begin		 
		#0 
        $display("(%0t) > initializing processor ...", $time);
		
        #450 $finish;
    end
														  
	
    // clock generator wires/registers
	wire clock;
	wire enIF, enID, enE, enMem, enWRB;
	
    // ----------------- Control Unit -----------------
								   
	wire [2:0] sigPCSrc;
    	wire [1:0] sigALUOp, sigNewSP;
	wire sigRB, sigDstReg, sigWriteVal, sigALUSrc, sigExt, sigEnW, sigStackMem, sigAddData, sigMemR, sigMemW, sigWB;
	wire zeroFlag, negativeFlag, fullFlag, emptyFlag;
	

    // ----------------- Instrution Memory -----------------

    // instruction memory wires/registers		
    wire [31:0] PC; // output of PC Module input to instruction memory
    reg [31:0] InstructionMem; // output if instruction memory, input to other modules

    // Instruction Parts
    wire [5:0] OpCode; // function code

    // R-Type
    wire [3:0] Rs1, Rd, Rs2; // register selection
	wire [1:0] mode;

	
	// ----------------- Register File -----------------
	wire [3:0] RA, RB, RW;
	wire [31:0] BusA, BusB, BusW;
	
	// ----------------- ALU -----------------
	wire [31:0] A, B;
	wire [31:0] ALURes;
	
	
	// ----------------- Data Memory -----------------
	wire [31:0]	DataMemAdd;
	
    // ----------------- Assignment -----------------

    // Function Code
    assign OpCode = InstructionMem[31:26];

    // R-Type
    assign Rd = InstructionMem[25:22];
    assign Rs1 = InstructionMem[21:18];
    assign Rs2 = InstructionMem[17:14];								 

    // I-Type
    wire signed [15:0] Imm16;
    assign Imm16 = InstructionMem[17:2];
	assign mode = InstructionMem[1:0];
	
	// J-Type
	wire [25:0]	Immediate26;
	assign Immediate26 = InstructionMem[25:0];
						  
	// S-Type
	wire [31:0] SP;
																				
    // ----------------- Register File -----------------
	wire [31:0] WBOutput;
	wire EnReg;
    assign RA = Rs1;
    assign RB = (sigRB == LOW) ? Rs2 : Rd;
    assign RW = (sigDstReg == LOW) ? Rs1 : Rd;
	assign EnReg = (enID || enWRB);
	assign BusW = (sigWriteVal == LOW) ? (BusA + 1'b1) : WBOutput;

    // ----------------- ALU -----------------
	wire [31:0] extendedImm;
	wire [31:0] signExtendedImm, zeroExtendedImm;
	assign signExtendedImm = {{16{Imm16[15]}}, Imm16};
	assign zeroExtendedImm = {{16{1'b0}}, Imm16};
	assign extendedImm = (sigExt == HIGH) ?  signExtendedImm: zeroExtendedImm;
	assign A = BusA;
	assign B = (sigALUSrc == HIGH) ? BusB : extendedImm;		
    
    										  
	ClockGenerator clockGenerator(clock);

    // -----------------------------------------------------------------
    // ----------------- Control Unit -----------------
    // -----------------------------------------------------------------
    

    controlUnit cu(
        clock,
        
        sigPCSrc,
		sigDstReg,
		sigRB,
		sigEnW,
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

        // stage enable outputs
        enIF,
        enID,
        enE,  // enable execute
		enMem,// enable memory
		enWRB,

        // inputs
        zeroFlag,
        negativeFlag,
        fullFlag,
        emptyFlag,
		OpCode
    );

    // -----------------------------------------------------------------
    // ----------------- Instruction Memory -----------------
    // -----------------------------------------------------------------
    
    // use en_instruction_fetch as clock for instruction memory
    instructionMemory insMem(enIF, PC, InstructionMem);

    // -----------------------------------------------------------------
    // ----------------- PC Module -----------------
    // -----------------------------------------------------------------

    pcModule pcMod(clock, PC, sigPCSrc, Immediate26, Imm16, DataMemAdd, enIF);
	
    // -----------------------------------------------------------------
    // ----------------- Register File -----------------
    // -----------------------------------------------------------------

									  			   
		
	wire [31:0] registers_array [0:15];
    registerFile regFile(clock, RA, RB, RW, sigEnW, BusW, BusA, BusB, EnReg,registers_array);
    // -----------------------------------------------------------------
    // ----------------- ALU -----------------
    // -----------------------------------------------------------------

    ALU alu(A, B, ALURes, zeroFlag, negativeFlag, sigALUOp, enE);  
	
	stackPointer stackP(clock, SP, sigNewSP, emptyFlag, fullFlag);
    // -----------------------------------------------------------------
    // ----------------- Data Memory -----------------
    // -----------------------------------------------------------------
	wire [31:0] memory [0:255];
    dataMemory dataMem(clock, ALURes, SP, BusB, PC, DataMemAdd, sigMemW, sigMemR, sigAddData, sigStackMem, enMem, memory);	   	
	
    // -----------------------------------------------------------------
    // ----------------- Write Back -----------------
    // -----------------------------------------------------------------

    assign WBOutput = (sigWB == 0) ? ALURes : DataMemAdd;


endmodule
