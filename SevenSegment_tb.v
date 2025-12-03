`timescale 1ns/1ps
module SevenSegment_tb;
  reg [3:0] n; wire [6:0] seg;
  SevenSegment dut(.numin(n), .segout(seg));
  integer i; initial begin
    for(i=0;i<16;i=i+1) begin n=i[3:0]; #1 $display("%0d -> %b", i, seg); end
    $display("SevenSegment_tb PASS"); $finish;
  end
endmodule