parameter
// Kept these just in case
// Levels

    LOW = 1'b0,
    HIGH = 1'b1,

// Instruction codes
// 6-bit instruction code

	// R-Type Instructions

    AND = 6'b000000, // Reg(Rd) = Reg(Rs1) & Reg(Rs2) 
    ADD = 6'b000001, // Reg(Rd) = Reg(Rs1) + Reg(Rs2) 
    SUB = 6'b000010, // Reg(Rd) = Reg(Rs1) - Reg(Rs2)

    // I-Type Instructions
	
    ANDI = 6'b000011, // Reg(Rd) = Reg(Rs1) & Immediate14
    ADDI = 6'b000100, // Reg(Rd) = Reg(Rs1) + Immediate14
    LW   = 6'b000101, // Reg(Rd) = Mem(Reg(Rs1) + Imm_14)	
	LWPOI = 6'b000110, /* Reg(Rd) = Mem(Reg(Rs1) + Imm16) 
					   Reg[Rs1] = Reg[Rs1] + 4 */  

    SW   = 6'b000111, // Mem(Reg(Rs1) + Imm_14) = Reg(Rd)
	BGT  = 6'b001000, /* if (Reg(Rd) > Reg(Rs1))  
				        	Next PC = PC + sign_extended (Imm16) 
						 else PC = PC + 4 */
	BLT  = 6'b001001, /* if (Reg(Rd) < Reg(Rs1))  
						    Next PC = PC + sign_extended (Imm16) 
						else PC = PC + 4 */
			
    BEQ  = 6'b001010, /* if (Reg(Rd) == Reg(Rs1))  
					        Next PC = PC + sign_extended (Imm16) 
						else PC = PC + 4 */
	BNE  = 6'b001011, /* if (Reg(Rd) != Reg(Rs1))  
					        Next PC = PC + sign_extended (Imm16) 
						else PC = PC + 4 */
		
    // J-Type Instructions
	
    JMP    = 6'b001100, // Next PC = {PC[31:26], Immediate26 }
    CALL  = 6'b001101, /* Next PC = {PC[31:26], Immediate26 } 
						  PC + 4 is pushed on the stack */
	RET = 6'b001110, // Next PC = top of the stack	 

    // S-Type Instructions
	
    PUSH  = 6'b001111,
	POP = 6'b010000,

// *Signals*

// PC src
// 2-bit select to determine next PC value

	pcDefault = 2'b00, // PC = PC + 1
	pcImm = 2'b01, // PC = {PC[31:26], Immediate26 }
	pcSgnImm = 2'b10, // PC = PC + sign_extended (Imm16)
	pcStack = 2'b11, // PC = top of the stack
	

// Dst Reg
// 1-bit select to determine on which register to write

	Rs1 = 1'b0, // RW = Rs1
	Rd = 1'b1, // RW = Rd

// RB
// 1-bit select to determine second register

	Rs2 = 1'b0, // RB = Rs2
	Rsd = 1'b1, // RB = Rd

// En W
// 1-bit select to E/D write on registers

	WD = 1'b0, // Write enabled
	WE = 1'b1, // Write disabled

// Write Value
// 2-bit select to determine value to be written on register

	WS4 = 2'b00, // Write the value from stage 4 as it is
	WS4Incremented = 2'b01, // Write the value from stage 4 incremented by 1
	WS5 = 2'b10, // Write the value from stage 5
	
// ALU src
// 1-bit source select to determine first input of the ALU

	Imm = 1'b0,	// B = Immediate
	BusB = 1'b1, // B = BusB
	
// ALU op
// 2-bit select to determine operation of ALU

	ALU_AND = 2'b00,
	ALU_ADD = 2'b01,
	ALU_SUB = 2'b10,
						  
// Mem R
// 1-bit select to enable read from memory	

	MRD = 1'b0,	// Memory read disabled
	MRE = 1'b1, // Memory read enabled

// Mem W
// 1-bit select to enable write to memory  

	MWD = 1'b0,	// Memory write disabled
	MWE = 1'b1, // Memory write enabled		   
	
// WB									   
// 1-bit select to determine return value from stage 5 
								
	WBALU = 1'b0, // Data from ALU
	WBMem = 1'b1, // Data from memory
	
// ext
// 1-bit select to determine logical or signed extension 

	logExt = 1'b0, // Logical extension
	sgnExt = 1'b1, // Signed extension
	
// Push
// 1-bit select to enable push	 

	pushD = 1'b0, // Push disabled
	pushE = 1'b1, // Push enabled
	
// Pop
// 1-bit select to enable pop	   

	popD = 1'b0, // Pop disabled
	popE = 1'b1, // Pop enabled
	
// new sp
// 2-bit select to determine the new value of the stack pointer

	stackPointerDef = 2'b00,
	stackPointerPop = 2'b01,
	stackPointerPush = 2'b10,
	
// stack/mem
// 1-bit select to store address of data in memory or push on stack	   

	memStore = 1'b0, // Calculate address of the memory
	stackStore = 1'b1, // Stack pointer
	
// address/data
// 1-bit select to determine source of data to be stored in memory, wether from register file or PC + 1

    addressDataRF = 1'b0, // Data from register file
    addressDataPC = 1'b1, // PC + 1	
	
// 16 registers

    R0 = 4'd0, // zero register
    R1 = 4'd1, // general purpose register
    R2 = 4'd2, // general purpose register
    R3 = 4'd3, // general purpose register
    R4 = 4'd4, // general purpose register
    R5 = 4'd5, // general purpose register
    R6 = 4'd6, // general purpose register
    R7 = 4'd7, // general purpose register
    R8 = 4'd8, // general purpose register
    R9 = 4'd9, // general purpose register
    R10 = 4'd10, // general purpose register
    R11 = 4'd11, // general purpose register
    R12 = 4'd12, // general purpose register
    R13 = 4'd13, // general purpose register
    R14 = 4'd14, // general purpose register
    R15 = 4'd15; // general purpose register
    
