`timescale 1ns/1ps
module ALUcontrol_tb;
  reg [3:0] ALUop; reg [5:0] funct; wire [3:0] ALUctrl;
  ALUcontrol dut(.ALUop(ALUop), .funct(funct), .ALUctrl(ALUctrl));
  initial begin
    ALUop=4'b0000; funct=6'bXXXXXX; #1; $display("I-type ALUctrl=%b", ALUctrl);
    ALUop=4'b1110; funct=6'b100000; #1; $display("ADD funct -> %b", ALUctrl);
    ALUop=4'b1110; funct=6'b000010; #1; $display("SRL funct -> %b", ALUctrl);
    $display("ALUcontrol_tb PASS"); $finish;
  end
endmodule