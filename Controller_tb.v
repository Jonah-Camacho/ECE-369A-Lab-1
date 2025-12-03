`timescale 1ns/1ps
module Controller_tb;
  reg [31:0] Instruction; wire RegWrite,ALUSrc,ExtOp,RegDst,Branch,Jump,Link,JumpReg,MemWrite,MemRead,MemToReg,LoadSigned; wire [3:0] ALUop; wire [1:0] MemSize;
  Controller dut(.Instruction(Instruction), .RegWrite(RegWrite), .ALUSrc(ALUSrc), .ExtOp(ExtOp), .RegDst(RegDst), .Branch(Branch), .Jump(Jump), .Link(Link), .JumpReg(JumpReg), .MemWrite(MemWrite), .MemRead(MemRead), .MemToReg(MemToReg), .ALUop(ALUop), .MemSize(MemSize), .LoadSigned(LoadSigned));
  function [31:0] I; input [5:0]op; input[4:0]rs,rt; input[15:0]im; begin I={op,rs,rt,im}; end endfunction
  function [31:0] R; input[4:0]rs,rt,rd,sh; input[5:0]fn; begin R={6'b0,rs,rt,rd,sh,fn}; end endfunction
  initial begin
    Instruction=I(6'b001000,0,8,16'h0006); #1; $display("ADDI: RegWrite=%b ALUSrc=%b ALUop=%b",RegWrite,ALUSrc,ALUop);
    Instruction=R(1,2,3,0,6'b100010);     #1; $display("SUB (R): RegDst=%b ALUop=%b",RegDst,ALUop);
    Instruction=I(6'b100011,0,16,0);      #1; $display("LW: MemRead=%b MemToReg=%b",MemRead,MemToReg);
    $display("Controller_tb PASS"); $finish;
  end
endmodule