`timescale 1ns / 1ps

///////
// Participation: 33% Jonah Camacho, 33% Alex Melde, 33% Daniel Rivera Castelo
//////
`define SIMULATION

module TopLevel_tb;

    // ------------------------------------------------------------
    // Clock / reset and top-level I/O of the DUT
    // ------------------------------------------------------------
    reg        Clk   = 1'b0;
    reg        Reset = 1'b1;
    wire [6:0] out7;
    wire [7:0] en_out;
    
  

    // ------------------------------------------------------------
    // Device Under Test (DUT)
    // ------------------------------------------------------------
    
    
    TopLevel dut (
        .Clk   (Clk),
        .Reset (Reset),
        .out7  (out7),
        .en_out(en_out)
    );

    // ------------------------------------------------------------
    // 100 MHz clock (10 ns period)
    // ------------------------------------------------------------
    always #5 Clk = ~Clk;

    // ------------------------------------------------------------
   
    integer cycle_count;

    initial begin
        $display("========================================");
        $display("=== POST-IMPLEMENTATION SIMULATION ===");
        $display("========================================");

        cycle_count = 0;

        // Hold reset for a bit so everything initializes
        Reset = 1'b1;
        #30;
        Reset = 1'b0;
        $display("Reset released at time %0t", $time);

        // Let the program run.
        //  - 10 ns per cycle (100 MHz clock)
        //  - Here we run for 5000 cycles = 50 us of simulated time
        //    Adjust RUN_CYCLES if you want more/less.
        repeat (5000) begin
            @(posedge Clk);
            cycle_count = cycle_count + 1;
        end

        $display("========================================");
        $display("=== SIMULATION COMPLETE ===");
        $display("========================================");
        $display("Total cycles simulated: %0d", cycle_count);
        $display("Check waveform for:");
        $display("  - Program Counter (PC)");
        $display("  - Register file write data");
        $display("  - out7/en_out seven-seg behavior");

        $finish;
    end

endmodule