module ClockGenerator_tb;

    reg clock;

    // Instantiate the ClockGenerator module
    ClockGenerator uut (clock);

    initial begin
        $display("Simulation started at time %0t", $time);
    end

    // Monitor block to display clock changes
    always @(posedge clock) begin
        $display("(%0t) Clock toggled to %b", $time, clock);
    end

    // Stop simulation after some time
    initial #100 $finish;

endmodule
