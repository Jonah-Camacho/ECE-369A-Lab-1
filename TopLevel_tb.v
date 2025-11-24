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
    // Optional internal debug taps
    //
    // >>> IMPORTANT <<<
    // For the lab, the TA will pull out PC and the register-file
    // write data directly from the waveform using hierarchical
    // names. You *do not* have to print them here.
    //
    // If YOU want to print them to the console, find the correct
    // signal names in the Vivado "Scopes" pane and update the
    // assignments below, then uncomment the code.
    // ------------------------------------------------------------

    // Example: if inside TopLevel you have something like:
    //   ProgramCounter PC_inst (... .PC_out(PC_wire) ...);
    //   RegisterFile   RF_inst (... .WriteData(WriteData_WB) ...);
    // and WB control signals like:
    //   wire RegWrite_WB;
    //   wire [4:0] WriteReg_WB;
    //
    // then you could do something like this (edit names to match!):
    //
    /*
    wire [31:0] PC_debug;
    wire        RegWrite_debug;
    wire [4:0]  WriteReg_debug;
    wire [31:0] WriteData_debug;

    // Change the right-hand sides to your *actual* names:
    assign PC_debug        = dut.PC;              // e.g. dut.PC_wire or dut.IFU.PC_out
    assign RegWrite_debug  = dut.RegWrite_WB;     // WB stage RegWrite
    assign WriteReg_debug  = dut.WriteReg_WB;     // WB destination register
    assign WriteData_debug = dut.WriteData_WB;    // Data written to register file
    */

    // ------------------------------------------------------------
    // Optional monitor: print PC + RF writeback every cycle
    // (Uncomment after you hook up the *_debug signals above.)
    // ------------------------------------------------------------
    /*
    always @(posedge Clk) begin
        if (Reset) begin
            $display("t=%0t  RESET asserted", $time);
        end
        else begin
            if (RegWrite_debug) begin
                $display("t=%0t  PC=%h  rd=%0d  data=%h",
                         $time,
                         PC_debug,
                         WriteReg_debug,
                         WriteData_debug);
            end
            else begin
                $display("t=%0t  PC=%h  (no RF write)", $time, PC_debug);
            end
        end
    end
    */

    // ------------------------------------------------------------
    // Main stimulus
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