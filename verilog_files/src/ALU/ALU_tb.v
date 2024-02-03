`include "constants.v"
module ALU_tb;

	wire EN;

	ClockGenerator clock_generator(EN);


    reg [31:0] A, B;
    wire [31:0] Output;
    wire zeroFlag;
    wire nFlag;


    // signals
    reg [2:0] ALUop;


    ALU alu(A, B, Output, zeroFlag, nFlag, ALUop, EN);

    initial begin

        #0
        A <= 32'd10;
        B <= 32'd20;
        ALUop <= ALU_AND;

        #10

        A <= 32'd30;
        B <= 32'd20;
        ALUop <= ALU_ADD;

        #10

        A <= 32'h00000FFF;
        B <= 32'h00000F0F;
        ALUop <= ALU_SUB;

        #10


        #5 $finish;
    end

endmodule