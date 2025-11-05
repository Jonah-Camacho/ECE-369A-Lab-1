`timescale 1ns/1ps
module Shift_left_2_32_tb;
  reg [31:0] in; wire [31:0] out;
  Shift_left_2_32 dut(.in(in), .out(out));
  initial begin
    in=32'h1;    #1; $display("1<<2=%h", out);
    in=32'h0020; #1; $display("20<<2=%h", out);
    $display("Shift_left_2_32_tb PASS"); $finish;
  end
endmodule