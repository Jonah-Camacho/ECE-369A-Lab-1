`timescale 1ns/1ps
module Shift_left_2_26_tb;
  reg [25:0] in; wire [27:0] out;
  Shift_left_2_26 dut(.in(in), .out(out));
  initial begin
    in=26'h3; #1; $display("3<<2=%h", out);
    in=26'h2A;#1; $display("2A<<2=%h", out);
    $display("Shift_left_2_26_tb PASS"); $finish;
  end
endmodule