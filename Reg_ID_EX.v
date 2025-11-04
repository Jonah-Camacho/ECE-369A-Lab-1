`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2025 05:05:36 PM
// Design Name: 
// Module Name: Reg_ID_EX
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


module Reg_ID_EX(
    input clk, reset,
    input RegWrite_in, MemWrite_in, MemRead_in, Branch_in, MemToReg_in,
    input ALUSrc_in, RegDst_in,
    input [31:0] JumpAddr_in,
    input [1:0] MemSize_in,
    input [3:0] ALUop_in,
    input [31:0] ReadData1_in, ReadData2_in, ExtImm_in, PCp4_in,
    input [4:0] rs_in, rt_in, rd_in,
    input [4:0] shamt_in,
    output reg RegWrite_out, MemWrite_out, MemRead_out, Branch_out, MemToReg_out,
    output reg ALUSrc_out, RegDst_out,
    output reg [31:0] JumpAddr_out;
    output reg [1:0] MemSize_out;
    output reg [3:0] ALUop_out,
    output reg [31:0] ReadData1_out, ReadData2_out, ExtImm_out, PCp4_out,
    output reg [4:0] rs_out, rt_out, rd_out,
    output reg [4:0] shamt_out // used in ALU if a shift is decoded in ALUController
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 0;
            MemWrite_out <= 0;
            MemRead_out  <= 0;
            Branch_out   <= 0;
            MemToReg_out <= 0;
            ALUSrc_out   <= 0;
            RegDst_out   <= 0;
            ALUop_out    <= 4'b0000;
            ReadData1_out <= 0;
            ReadData2_out <= 0;
            ExtImm_out <= 0;
            PCp4_out <= 0;
            rs_out <= 0;
            rt_out <= 0;
            rd_out <= 0;
            shamt_out <= 5'b0;
            JumpAddr_out <=0;
            MemSize_out <=0;
         end
         else begin
            RegWrite_out <= RegWrite_in;
            MemWrite_out <= MemWrite_in;
            MemRead_out  <= MemRead_in;
            Branch_out   <= Branch_in;
            MemToReg_out <= MemToReg_in;
            ALUSrc_out   <= ALUSrc_in;
            RegDst_out   <= RegDst_in;
            ALUop_out    <= ALUop_in;
            ReadData1_out <= ReadData1_in;
            ReadData2_out <= ReadData2_in;
            ExtImm_out <= ExtImm_in;
            PCp4_out <= PCp4_in;
            rs_out <= rs_in;
            rt_out <= rt_in; //rt gets saved no matter what, even if not used (e.g. I-type)
            rd_out <= rd_in;
            shamt_out <= shamt_in;
            JumpAddr_out <= JumpAddr_in;
            MemSize_out <= MemSize_in;
         end
    end
endmodule
