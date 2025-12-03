`timescale 1ns/1ps
module SignExtension_tb;
  reg [15:0] in; reg control; wire [31:0] out;
  SignExtension dut(.in(in), .control(control), .out(out));
  initial begin
    in=16'h8001; control=0; #1; $display("sign:%h", out);
    control=1;             #1; $display("zero:%h", out);
    $display("SignExtension_tb PASS"); $finish;
  end
endmodule