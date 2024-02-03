// Generates clock square wave with 10ns period

module ClockGenerator (clock);

	initial begin
	    $display("(%0t) > initializing clock generator ...", $time);
	end
	
	output reg clock=0; // starting LOW is important for first instruction fetch
	
	always #5 begin
	    clock = ~clock;
	end			   

endmodule