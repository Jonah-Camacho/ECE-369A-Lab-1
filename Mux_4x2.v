`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 11:29:53 PM
// Design Name: 
// Module Name: Mux_4x2
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


module Mux_4x2(
    input  wire [31:0] a,  // Input 0
    input  wire [31:0] b,  // Input 1
    input  wire  [31:0] c, //Input 2
    input  wire [31:0] d,    //Input 4
    input  wire  [1:0] control, // Control signal 
    output reg  [31:0] out   // Output must be reg since assigned in always block
    );
    
        // we have 2 bits now so we can decide which one it will wend up being if 0 1 2 in this 3X1 mux
    always @(*) begin
        case (control)
            2'b00: out = a;
            2'b01: out = b;
            2'b10: out = c;
            2'b11: out = d;
            default: out = 32'b0;
        endcase
    end
endmodule
