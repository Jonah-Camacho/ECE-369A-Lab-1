`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 11:46:41 PM
// Design Name: 
// Module Name: Reg_EX_MEM
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


module Reg_EX_MEM(
    input clk, reset,
    // Control signals
    input MemWrite_in, MemRead_in, Branch_in, //used in MEM
    input RegWrite_in, MemToReg_in, //used in WB
    // Data signals/32-bit
    input [31:0] ALUResult_in, WriteData_in, BranchTarget_in,
    input Zero_in,
    input [4:0] WriteReg_in,

    // Outputs
    output reg RegWrite_out, MemWrite_out, MemRead_out, Branch_out, MemToReg_out,
    output reg [31:0] ALUResult_out, WriteData_out, BranchTarget_out,
    output reg Zero_out,
    output reg [4:0] WriteReg_out
    );
    
        always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 0;
            MemWrite_out <= 0;
            MemRead_out  <= 0;
            Branch_out   <= 0;
            MemToReg_out <= 0;
            ALUResult_out <= 0;
            WriteData_out <= 0;
            BranchTarget_out <= 0;
            Zero_out <= 0;
            WriteReg_out <= 0;
        end
        else begin
            RegWrite_out <= RegWrite_in;
            MemWrite_out <= MemWrite_in;
            MemRead_out  <= MemRead_in;
            Branch_out   <= Branch_in;
            MemToReg_out <= MemToReg_in;
            ALUResult_out <= ALUResult_in;
            WriteData_out <= WriteData_in;
            BranchTarget_out <= BranchTarget_in;
            Zero_out <= Zero_in;
            WriteReg_out <= WriteReg_in;
        end
    end
    
endmodule
