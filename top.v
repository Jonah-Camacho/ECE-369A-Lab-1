`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2017 11:05:09 AM
// Design Name: 
// Module Name: top
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
module top(Clk,Reset,out7,en_out);
    input Clk;             // Main clock input
    input Reset;           // Reset button input
    output [6:0] out7;     // 7-segment display segments (A-G)
    output [7:0] en_out;    // 7-segment display enable lines
 // Main clock input
    wire [31:0] Instruction_out; //output instruction
    wire [31:0] PCResult_out;   // PC out
    wire [31:0] Instruction; // come into play later
    wire [31:0] PCResult;        
    wire Clk_out;             // Clock output from ClkDiv
    
  //  module Top(Clk,Reset,out7,en_out);
    // Clock Div
      ClkDiv a(
        .Clk(Clk),
        .Rst(Reset),
        .ClkOut(Clk_out)
    );
    // Instruction Fetch Unit 
    InstructionFetchUnit b(
        .Instruction(Instruction_out),  //  instruction output
        .PCResult(PCResult_out),        //  PC output
        .Reset(Reset),
        .Clk(Clk_out)                // Use divided clock from ClkDiv
    );
    // Two 4-Digit Display
    Two4DigitDisplay c(
        .Clk(Clk),              // Use the original clock for display
        .NumberA(Instruction_out[15:0]),   // Instruction lower 16 bits 
        .NumberB(PCResult_out[15:0]),      // PC result lower 16 bits 
        .out7(out7),             // 7-segment display segments
        .en_out(en_out)          // 7-segment enable
    );
endmodule
