`timescale 1ns/1ps
module Mux_2x1_tb;
  reg [31:0] a=32'hAAAA, b=32'hBBBB; reg sel=0; wire [31:0] out;
  Mux_2x1 dut(.a(a),.b(b),.control(sel),.out(out));
  initial begin
    #1 $display("sel=0 -> %h", out); sel=1; #1 $display("sel=1 -> %h", out);
    $display("Mux_2x1_tb PASS"); $finish;
  end
endmodule