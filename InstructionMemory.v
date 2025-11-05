`timescale 1ns / 1ps


module InstructionMemory(
    input [31:0] Address,
    output [31:0] Instruction
    );
    reg [31:0] memory [0:1023];
    
    initial begin
        //replace instructions.mem with filename
        $readmemh("instructions.mem", memory);
    end
    
    
    assign Instruction = memory[Address[11:2]];
    
endmodule
