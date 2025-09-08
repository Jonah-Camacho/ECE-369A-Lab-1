`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 06:23:42 PM
// Design Name: 
// Module Name: TopLevel
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


module TopLevel(Clk, Reset, out7, en_out);
    input wire Clk;
    input wire Reset;
    output wire [6:0] out7;
    output wire [7:0] en_out;
    
    wire [31:0] Instruction;
    
    InstructionFetchUnit IFU(.Reset(Reset), .Clk(Clk), .Instruction(Instruction));
    
     Two4DigitDisplay T4DD(
        .Clk(Clk),
        .NumberA(Instruction[15:0]),   
        .NumberB(Instruction[31:16]), 
        .out7(out7),
        .en_out(en_out)
    );
    
endmodule
