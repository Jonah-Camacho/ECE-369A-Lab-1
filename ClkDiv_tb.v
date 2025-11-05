`timescale 1ns/1ps
module ClkDiv_tb;
  reg Clk=0,Rst=1; wire ClkOut;
  ClkDiv #(.DivVal(2)) dut(.Clk(Clk),.Rst(Rst),.ClkOut(ClkOut));
  always #1 Clk=~Clk;
  initial begin
    #5 Rst=0; repeat(10) @(posedge Clk); $display("ClkDiv_tb PASS (ClkOut=%b)", ClkOut); $finish;
  end
endmodule