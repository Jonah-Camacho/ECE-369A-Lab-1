`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2025 02:03:29 PM
// Design Name: 
// Module Name: InstructionFetchUnit_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module InstructionFetchUnit_tb();
    // Inputs
    reg Clk;
    reg Reset;

    // Outputs
    wire [31:0] Instruction;
    wire [31:0] PCResult;

    // Instantiate the DUT (Device Under Test)
    InstructionFetchUnit DUT (
        .Instruction(Instruction),
        .PCResult(PCResult),
        .Reset(Reset),
        .Clk(Clk)
    );

    // Clock generator: 10 ns period (100 MHz)
    initial Clk = 0;
    always #5 Clk = ~Clk;

    // Reset sequence and simulation control
    initial begin
        // For waveform dumping (if supported by your simulator)
        $dumpfile("ifu_tb.vcd");
        $dumpvars(0, tb_InstructionFetchUnit);

        // Apply Reset (active-high)
        Reset = 1;
        #20;          // hold reset for 20 ns (2 clock cycles)
        Reset = 0;

        // Run for 20 more clock cycles
        repeat (20) @(posedge Clk);

        $display("Simulation finished.");
        $finish;
    end

    // Monitor PC and Instruction at every positive edge of the clock
    always @(posedge Clk) begin
        $display("[%0t ns] PC = %0d (0x%08h), Instruction = %0d (0x%08h)",
                 $time, PCResult, PCResult, Instruction, Instruction);
    end
endmodule