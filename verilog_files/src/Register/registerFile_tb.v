module registerFile_tb;

	wire clock;
	ClockGenerator clock_generator(clock);

    reg [3:0] RA, RB, RW;
    reg EnW, EN;
    reg [31:0] BusW;
    wire [31:0] BusA, BusB;		
	wire [31:0] registers_array [0:15];
    registerFile regFile(clock, RA, RB, RW, EnW, BusW, BusA, BusB, EN, registers_array);
    
    initial begin
		EN = 1;
		#0
		
		RW <= 4'd1; // Write to register 1
		BusW <= 32'd16; // write value 16
		EnW <= 1; // Enable write
		EN <= 1;
		#10
		
		RW <= 4'd2; // Write to register 2
		BusW <= 32'd32; // Write value 32
		EnW <= 1; // Enable write
		#10
		
		RA <= 4'd1;
		RB <= 4'd2;
		EnW <= 0; // Disable write
		#10
		
		RW <= 4'd2; // Write to register 2
		BusW <= 32'd64; // Write value 64
		EnW <= 1; // Enable write
		EN <= 1;
		#10
		
		RW <= 4'd2; // Write to register 2
		BusW <= 32'd128; // Write value 128
		EnW <= 0; // Disable write
		#10
		
		#10 
		$finish;
    end

endmodule  
