`timescale 1ns / 1ps

///////
// Participation: 33% Jonah Camacho, 33% Alex Melde, 33% Daniel Rivera Castelo
//////

module TopLevel_tb;

    reg  Clk   = 1'b0;
    reg  Reset = 1'b1;
    wire [6:0] out7;
    wire [7:0] en_out;

    // DUT
    TopLevel dut (
        .Clk(Clk),
        .Reset(Reset),
        .out7(out7),
        .en_out(en_out)
    );

    // 100 MHz clock
    always #5 Clk = ~Clk;

    initial begin
        $display("========================================");
        $display("=== POST-IMPLEMENTATION SIMULATION ===");
        $display("========================================");
        
        // Hold reset
        #30;
        Reset = 1'b0;
        $display("Reset released at time %0t", $time);
        
        // Run for a long time
        #10000;
        
        $display("========================================");
        $display("=== SIMULATION COMPLETE ===");
        $display("========================================");
        $display("Check waveform for:");
        $display("  - Seven segment display changes");
        $display("  - Clock and reset behavior");
        
        $finish;
    end

endmodule