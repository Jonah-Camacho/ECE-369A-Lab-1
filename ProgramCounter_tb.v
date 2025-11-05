`timescale 1ns/1ps
module ProgramCounter_tb;
  reg Clk=0, Reset=1; reg [31:0] Address=0; wire [31:0] PCResult;
  ProgramCounter dut(.Address(Address), .PCResult(PCResult), .Reset(Reset), .Clk(Clk));
  always #5 Clk=~Clk;
  initial begin
    repeat(2) @(posedge Clk); Reset=0;
    Address=32'h4;  @(posedge Clk);
    Address=32'h8;  @(posedge Clk);
    $display("ProgramCounter_tb PASS: PC=%h", PCResult); $finish;
  end
endmodule