`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2025 06:56:32 PM
// Design Name: 
// Module Name: InstructionMemory_tb
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


module InstructionMemory_tb;

    reg [31:0] PC;
    wire [31:0] Instruction;
    
    InstructionMemory IM (
        .Address(PC),
        .Instruction(Instruction)
    );
    
    initial begin
        PC = 0;
        #10 PC = 4;
        #10 PC = 8;
        #10 PC = 8;
        #10 PC = 12;
    end
endmodule
