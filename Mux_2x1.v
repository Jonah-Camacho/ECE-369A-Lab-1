`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 11:30:06 PM
// Design Name: 
// Module Name: Mux_2x1
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


module Mux_2x1(
    input  wire [31:0] a,   // Input 0
    input  wire [31:0] b,   // Input 1
    input  wire control, // Control signal //one bit cause it 1 or 0
    output reg  [31:0] out    // Output must be reg since assigned in always block
    );
    
        // we have the different bit 0 and 1 bit being where we going to chose and if there isn't an option then it will hit the default case

    always @(*) begin
        case (control)
            1'b0: out  = a;
            1'b1: out = b;
            default: output = 32'b0;
        endcase
    end
    
endmodule
