`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:20:37 PM
// Design Name: 
// Module Name: InstructionFetchUnit_tb
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


module InstructionFetchUnit_tb;
  reg Clk=0, Reset=1; reg [31:0] PC_next=0; wire [31:0] Instruction, PC_curr, PC_plus4;
  InstructionFetchUnit dut(.Clk(Clk),.Reset(Reset),.PC_next(PC_next),.Instruction(Instruction),.PC_curr(PC_curr),.PC_plus4(PC_plus4));
  always #5 Clk=~Clk;
  initial begin
    repeat(2) @(posedge Clk); Reset=0;
    PC_next=32'h0; @(posedge Clk); $display("PC=%h PC+4=%h", PC_curr, PC_plus4);
    PC_next=PC_plus4; @(posedge Clk); $display("PC=%h PC+4=%h", PC_curr, PC_plus4);
    $display("InstructionFetchUnit_tb PASS"); $finish;
  end
endmodule
