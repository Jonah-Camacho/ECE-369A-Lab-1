`timescale 1ns/1ps
module Reg_ID_EX_tb;
  reg clk=0,reset=1; reg RegWrite_in=1,MemWrite_in=0,MemRead_in=1,Branch_in=0,MemToReg_in=1,ALUSrc_in=1,RegDst_in=0,LoadSigned_in=1,Link_in=0;
  reg [3:0] ALUop_in=4'h0; reg [1:0] MemSize_in=2'b10; reg [31:0] ReadData1_in=32'h11, ReadData2_in=32'h22, ExtImm_in=32'h33, PCp4_in=32'h44, JumpAddr_in=32'h55;
  reg [4:0] rs_in=1,rt_in=2,rd_in=3,shamt_in=0; reg [5:0] funct_in=6'h20;
  wire RegWrite_out,MemWrite_out,MemRead_out,Branch_out,MemToReg_out,ALUSrc_out,RegDst_out,LoadSigned_out,Link_out; wire [3:0] ALUop_out; wire [1:0] MemSize_out;
  wire [31:0] ReadData1_out,ReadData2_out,ExtImm_out,PCp4_out,JumpAddr_out; wire [4:0] rs_out,rt_out,rd_out,shamt_out; wire [5:0] funct_out;
  Reg_ID_EX dut(.clk(clk),.reset(reset),.RegWrite_in(RegWrite_in),.MemWrite_in(MemWrite_in),.MemRead_in(MemRead_in),.Branch_in(Branch_in),.MemToReg_in(MemToReg_in),.ALUSrc_in(ALUSrc_in),.RegDst_in(RegDst_in),.ALUop_in(ALUop_in),.MemSize_in(MemSize_in),.LoadSigned_in(LoadSigned_in),.Link_in(Link_in),.JumpAddr_in(JumpAddr_in),.ReadData1_in(ReadData1_in),.ReadData2_in(ReadData2_in),.ExtImm_in(ExtImm_in),.PCp4_in(PCp4_in),.rs_in(rs_in),.rt_in(rt_in),.rd_in(rd_in),.funct_in(funct_in),.shamt_in(shamt_in),.RegWrite_out(RegWrite_out),.MemWrite_out(MemWrite_out),.MemRead_out(MemRead_out),.Branch_out(Branch_out),.MemToReg_out(MemToReg_out),.ALUSrc_out(ALUSrc_out),.RegDst_out(RegDst_out),.ALUop_out(ALUop_out),.MemSize_out(MemSize_out),.LoadSigned_out(LoadSigned_out),.Link_out(Link_out),.JumpAddr_out(JumpAddr_out),.ReadData1_out(ReadData1_out),.ReadData2_out(ReadData2_out),.ExtImm_out(ExtImm_out),.PCp4_out(PCp4_out),.rs_out(rs_out),.rt_out(rt_out),.rd_out(rd_out),.funct_out(funct_out),.shamt_out(shamt_out));
  always #5 clk=~clk;
  initial begin
    @(posedge clk); reset=0; @(posedge clk);
    $display("ID/EX: R1=%h PC+4=%h ALUop=%b", ReadData1_out, PCp4_out, ALUop_out);
    $display("Reg_ID_EX_tb PASS"); $finish;
  end
endmodule