`timescale 1ns/1ps
module Reg_EX_MEM_tb;
  reg clk=0,reset=1,RegWrite_in=1,MemToReg_in=0,MemWrite_in=1,MemRead_in=0,Branch_in=0,Link_in=0,LoadSigned_in=1; reg [1:0] MemSize_in=2'b10;
  reg [31:0] ALUResult_in=32'hAA,WriteData_in=32'hBB,BranchTarget_in=32'hCC,PCp4_in=32'hDD; reg Zero_in=0; reg [4:0] WriteReg_in=5'd10;
  wire RegWrite_out,MemToReg_out,MemWrite_out,MemRead_out,Branch_out,Link_out,LoadSigned_out,Zero_out; wire [1:0] MemSize_out; wire [31:0] ALUResult_out,WriteData_out,BranchTarget_out,PCp4_out; wire [4:0] WriteReg_out;
  Reg_EX_MEM dut(.clk(clk),.reset(reset),.RegWrite_in(RegWrite_in),.MemToReg_in(MemToReg_in),.MemWrite_in(MemWrite_in),.MemRead_in(MemRead_in),.MemSize_in(MemSize_in),.LoadSigned_in(LoadSigned_in),.Branch_in(Branch_in),.Link_in(Link_in),.ALUResult_in(ALUResult_in),.WriteData_in(WriteData_in),.BranchTarget_in(BranchTarget_in),.Zero_in(Zero_in),.WriteReg_in(WriteReg_in),.PCp4_in(PCp4_in),.RegWrite_out(RegWrite_out),.MemToReg_out(MemToReg_out),.MemWrite_out(MemWrite_out),.MemRead_out(MemRead_out),.MemSize_out(MemSize_out),.LoadSigned_out(LoadSigned_out),.Branch_out(Branch_out),.Link_out(Link_out),.ALUResult_out(ALUResult_out),.WriteData_out(WriteData_out),.BranchTarget_out(BranchTarget_out),.Zero_out(Zero_out),.WriteReg_out(WriteReg_out),.PCp4_out(PCp4_out));
  always #5 clk=~clk;
  initial begin
    @(posedge clk); reset=0; @(posedge clk);
    $display("EX/MEM: ALU=%h WR=%0d", ALUResult_out, WriteReg_out);
    $display("Reg_EX_MEM_tb PASS"); $finish;
  end
endmodule