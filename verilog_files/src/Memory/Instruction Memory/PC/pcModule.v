`include "constants.v"

// 0: Pc = Pc + 1
// 1: PC = {PC[31:26], Immediate26 }
// 2: PC = PC + sign_extended (Imm16)
// 3: PC = top of the stack

module pcModule(clock, PC, PCsrc, immediate26, Imm16, topStack, EN);

    input wire clock;

    input wire [1:0] PCsrc;
    input wire [25:0] immediate26;
    input wire [31:0] topStack;
    input wire signed [15:0] Imm16;
	input wire EN;

    // PC Output
    output reg [31:0] PC;

    // To store assignments
    wire [31:0] PC1;
    wire [31:0] Immediate;

    // PC + 1
    assign PC1 = PC + 32'd1;
    // Concatinate PC and immediate
    assign Immediate = {PC[31:26], immediate26};

    initial begin
        PC <= 32'd0;
    end


    always @(posedge clock) begin
		if(EN) begin
            case (PCsrc)
                pcDefault: begin
                    // PC = PC + 1
                    PC = PC1;
                end
                pcImm:  begin
                    // PC = {PC[31:26], Immediate26 }
                    PC = Immediate;
                end
                pcSgnImm: begin
                    // PC = PC + sign_extended (Imm16)
                    PC = PC + {{16{Imm16[15]}}, Imm16};
                end
                pcStack: begin
                    // PC = top of the stack
                    PC = topStack;
                end
            endcase
		end
    end
endmodule
