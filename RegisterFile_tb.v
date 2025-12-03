`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:20:37 PM
// Design Name: 
// Module Name: RegisterFile_tb
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


module RegisterFile_tb;
  reg Clk=0, Reset=1, RegWrite=0; reg [4:0] r1=0,r2=0,wr=0; reg [31:0] wd=0; wire [31:0] d1,d2;
  RegisterFile dut(.Clk(Clk),.Reset(Reset),.RegWrite(RegWrite),.ReadRegister1(r1),.ReadRegister2(r2),.WriteRegister(wr),.WriteData(wd),.ReadData1(d1),.ReadData2(d2));
  always #5 Clk=~Clk;
  initial begin
    repeat(2) @(posedge Clk); Reset=0;
    wr=5'd9; wd=32'h12345678; RegWrite=1; @(posedge Clk); RegWrite=0;
    r1=5'd9; r2=5'd0; #1; $display("R9=%h R0=%h", d1,d2);
    $display("RegisterFile_tb PASS"); $finish;
  end
endmodule
