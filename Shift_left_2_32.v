`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 04:29:47 AM
// Design Name: 
// Module Name: Shift_left_2_32
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


module Shift_left_2_32(
input [31:0] in, 
output [31:0] out // we end with 28 
);


assign out = {in[29:0], 2'b00};

endmodule
