`timescale 1ns/1ps
module DataMemory_tb;
  reg Clk=0, MemWrite=0, MemRead=0, LoadSigned=1; reg [1:0] MemSize=2'b10;
  reg [31:0] Address=0, WriteData=0; wire [31:0] ReadData;
  DataMemory dut(.Clk(Clk),.MemWrite(MemWrite),.MemRead(MemRead),.MemSize(MemSize),.LoadSigned(LoadSigned),.Address(Address),.WriteData(WriteData),.ReadData(ReadData));
  always #5 Clk=~Clk;
  initial begin
    // SW/LW a word
    Address=32'h0; WriteData=32'hAABBCCDD; MemSize=2'b10; MemWrite=1; @(posedge Clk); MemWrite=0;
    MemRead=1; #1; $display("LW @0 = %h", ReadData); MemRead=0;
    // SB/LB a byte
    Address=32'h1; WriteData=32'h000000FF; MemSize=2'b00; MemWrite=1; @(posedge Clk); MemWrite=0;
    MemRead=1; LoadSigned=0; #1; $display("LBU @1 = %h", ReadData); MemRead=0;
    $display("DataMemory_tb PASS"); $finish;
  end
endmodule