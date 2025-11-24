`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:20:37 PM
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


module InstructionFetchUnit_tb;

    reg         Clk;
    reg         Reset;
    reg  [31:0] PC_next;
    reg         PCWrite;
    wire [31:0] Instruction;
    wire [31:0] PC_curr;
    wire [31:0] PC_plus4;

    InstructionFetchUnit dut (
        .Clk        (Clk),
        .Reset      (Reset),
        .PC_next    (PC_next),
        .PCWrite    (PCWrite),
        .Instruction(Instruction),
        .PC_curr    (PC_curr),
        .PC_plus4   (PC_plus4)
    );

    // 10 ns period clock
    initial Clk = 0;
    always #5 Clk = ~Clk;

    initial begin
        $display("===== InstructionFetchUnit_tb START =====");

        // Initialize
        Reset   = 1;
        PCWrite = 1;
        PC_next = 32'h0000_0000;
        #20;

        // Release reset
        Reset = 0;
        PC_next = 32'h0000_0000;
        #10;
        $display("[%0t] PC=%h PC+4=%h Instr=%h",
                 $time, PC_curr, PC_plus4, Instruction);

        // Sequential advance
        PC_next = PC_plus4;
        #10;
        $display("[%0t] PC=%h PC+4=%h Instr=%h",
                 $time, PC_curr, PC_plus4, Instruction);

        // Another sequential advance
        PC_next = PC_plus4;
        #10;
        $display("[%0t] PC=%h PC+4=%h Instr=%h",
                 $time, PC_curr, PC_plus4, Instruction);

        // Stall PC
        PCWrite = 0;
        PC_next = PC_plus4;  // even though next changes, PC should hold
        #20;
        $display("[%0t] STALL: PC=%h PC+4=%h Instr=%h",
                 $time, PC_curr, PC_plus4, Instruction);

        // Resume
        PCWrite = 1;
        #10;
        $display("[%0t] RESUME: PC=%h PC+4=%h Instr=%h",
                 $time, PC_curr, PC_plus4, Instruction);

        $display("===== InstructionFetchUnit_tb DONE =====");
        $finish;
    end

endmodule
