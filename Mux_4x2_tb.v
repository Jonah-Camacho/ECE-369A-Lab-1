`timescale 1ns/1ps
module Mux_4x2_tb;
  reg [31:0] a=32'h1,b=32'h2,c=32'h3,d=32'h4; reg [1:0] sel=0; wire [31:0] out;
  Mux_4x2 dut(.a(a),.b(b),.c(c),.d(d),.control(sel),.out(out));
  initial begin
    repeat(4) begin #1 $display("sel=%b -> %h", sel,out); sel=sel+1; end
    $display("Mux_4x2_tb PASS"); $finish;
  end
endmodule