`timescale 1ns / 1ps

module InstructionFetchUnit(
    input  wire        Clk,
    input  wire        Reset,
    input  wire [31:0] PC_next,      // Next PC value from branch/jump logic
    output wire [31:0] Instruction,  // Current instruction
    output wire [31:0] PC_curr,      // Current PC value
    output wire [31:0] PC_plus4      // PC + 4 for sequential execution
);

    // Program Counter
    ProgramCounter pc(
        .Address(PC_next),
        .PCResult(PC_curr),
        .Reset(Reset),
        .Clk(Clk)
    );

    // PC + 4 Adder
    PCAdder pcadd(
        .PCResult(PC_curr),
        .PCAddResult(PC_plus4)
    );

    // Instruction Memory
    InstructionMemory im(
        .Address(PC_curr),
        .Instruction(Instruction)
    );

endmodule