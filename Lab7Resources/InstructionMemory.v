`timescale 1ns/1ps
module InstructionMemory(
    input  [31:0] Address,
    output [31:0] Instruction
);
    reg [31:0] memory [0:1023];
    integer i, rc;

    initial begin
        // Default to NOPs so reads are never X even if file missing
        for (i = 0; i < 1024; i = i + 1) memory[i] = 32'h00000000;

        // Try to load; rc is undefined by standard, so use a sentinel check
        $display("[IMEM] Attempting to load ./instruction_memory.mem ...");
        $readmemh("instruction_memory.mem", memory);
        // Print a few words to confirm
        $display("[IMEM] memory[0]=%h  [1]=%h  [7]=%h  [13]=%h",
                 memory[0], memory[1], memory[7], memory[13]);
    end

    // Use word address bits; if Address is X early, guard with 0
    wire [9:0] waddr = (^Address[11:2] === 1'bX) ? 10'd0 : Address[11:2];
    assign Instruction = memory[waddr];
endmodule
