`timescale 1ns/1ps
module InstructionMemory_tb;
  reg [31:0] Address; wire [31:0] Instruction;
  InstructionMemory dut(.Address(Address), .Instruction(Instruction));
  initial begin
    Address=32'h0;   #1; $display("I[0]=%h", Instruction);
    Address=32'h18;  #1; $display("I[24]=%h", Instruction);
    Address=32'h30;  #1; $display("I[48]=%h", Instruction);
    $display("InstructionMemory_tb PASS"); $finish;
  end
endmodule