`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/04/2025 10:20:37 PM
// Design Name: 
// Module Name: PCAdder_tb
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


module PCAdder_tb;
  reg [31:0] PCResult; wire [31:0] PCAddResult;
  PCAdder dut(.PCResult(PCResult), .PCAddResult(PCAddResult));
  initial begin
    PCResult=32'h0;   #1; $display("PC+4=%h", PCAddResult);
    PCResult=32'h3C;  #1; $display("PC+4=%h", PCAddResult);
    $display("PCAdder_tb PASS"); $finish;
  end
endmodule
