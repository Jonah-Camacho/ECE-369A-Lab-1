`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/06/2025 06:23:55 PM
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


module TopLevel(Clk,Reset,out7,en_out);
    input Clk;
    input Reset;
    output [6:0] out7;
    output [7:0] en_out;
    
    wire [31:0] Instruction_out;
    wire [31:0] PCResult_out;  
    wire [31:0] Instruction; 
    wire [31:0] PCResult;        
    wire Clk_out;     
    
    ClkDiv a(.Clk(Clk),.Rst(Reset),.ClkOut(Clk_out));
    
    InstructionFetchUnit b(.Instruction(Instruction_out),.PCResult(PCResult_out),.Reset(Reset),.Clk(Clk_out));
    
    Two4DigitDisplay c(.Clk(Clk),.NumberA(Instruction_out[15:0]),.NumberB(PCResult_out[15:0]),.out7(out7),.en_out(en_out));
    

endmodule
