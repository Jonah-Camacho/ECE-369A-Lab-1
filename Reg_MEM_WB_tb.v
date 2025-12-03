`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:20:37 PM
// Design Name: 
// Module Name: Reg_MEM_WB_tb
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


module Reg_MEM_WB_tb;
  reg clk=0,reset=1,RegWrite_in=1,MemToReg_in=1,Link_in=0; reg [31:0] MemReadData_in=32'h12,ALUResult_in=32'h34,PCp4_in=32'h56; reg [4:0] WriteReg_in=5'd3;
  wire RegWrite_out,MemToReg_out,Link_out; wire [31:0] MemReadData_out,ALUResult_out,PCp4_out; wire [4:0] WriteReg_out;
  Reg_MEM_WB dut(.clk(clk),.reset(reset),.RegWrite_in(RegWrite_in),.MemToReg_in(MemToReg_in),.Link_in(Link_in),.MemReadData_in(MemReadData_in),.ALUResult_in(ALUResult_in),.WriteReg_in(WriteReg_in),.PCp4_in(PCp4_in),.RegWrite_out(RegWrite_out),.MemToReg_out(MemToReg_out),.Link_out(Link_out),.MemReadData_out(MemReadData_out),.ALUResult_out(ALUResult_out),.WriteReg_out(WriteReg_out),.PCp4_out(PCp4_out));
  always #5 clk=~clk;
  initial begin
    @(posedge clk); reset=0; @(posedge clk);
    $display("MEM/WB: MRD=%h WR=%0d", MemReadData_out, WriteReg_out);
    $display("Reg_MEM_WB_tb PASS"); $finish;
  end
endmodule
