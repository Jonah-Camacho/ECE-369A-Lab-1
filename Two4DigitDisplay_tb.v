`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:20:37 PM
// Design Name: 
// Module Name: Two4DigitDisplay_tb
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



module Two4DigitDisplay_tb;
  reg Clk=0; reg [15:0] A=16'h1234,B=16'hABCD; wire [6:0] out7; wire [7:0] en_out;
  Two4DigitDisplay dut(.Clk(Clk),.NumberA(A),.NumberB(B),.out7(out7),.en_out(en_out));
  always #1 Clk=~Clk;
  initial begin
    repeat(2000) @(posedge Clk);
    $display("Two4DigitDisplay_tb PASS"); $finish;
  end
endmodule
