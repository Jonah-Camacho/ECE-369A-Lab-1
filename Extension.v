`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 11:36:53 PM
// Design Name: 
// Module Name: Extension
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


module Extension(
  input [15:0] in, // the 16 bit input
  input control,
  output reg [31:0] out // the 32 bit output
    );
    
    always @(*) begin
        out = 32'b0;
        if (control) // 1 = sign extend
            out = {{16{in[15]}}, in}; 
        else // 0 = zero extend
            out = {16'b0, in};
    end
    
    
endmodule
