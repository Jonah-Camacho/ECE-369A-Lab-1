`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 11:59:58 PM
// Design Name: 
// Module Name: Adder_32bit
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


module Adder_32bit(
    input  [31:0] input1,  
    input  [31:0] input2,    
    output [31:0] out    
    );
    
    assign out = input1 + input2;
endmodule
