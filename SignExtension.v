`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2025 01:24:06 PM
// Design Name: 
// Module Name: SignExtension
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


module SignExtension (
  input [15:0] in,        // 16-bit immediate input
  input ExtendOp,         // 1 = sign extend, 0 = zero extend
  output [31:0] out       // 32-bit extended output
);

  // Conditional extension based on ExtendOp control signal
  assign out = ExtendOp ? {{16{in[15]}}, in}    // Sign extend: replicate MSB
                        : {16'b0, in};           // Zero extend: pad with zeros

endmodule
