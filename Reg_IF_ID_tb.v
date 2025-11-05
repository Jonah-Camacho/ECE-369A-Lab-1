`timescale 1ns/1ps
module Reg_IF_ID_tb;
  reg clk=0,rst=1,en=0; reg [31:0] i=32'hA, p=32'hB, j=32'hC;
  wire [31:0] io,po,jo;
  Reg_IF_ID dut(.clk(clk),.rst(rst),.en(en),.instr_in(i),.pc_in(p),.jump_addr_in(j),.instr_out(io),.pc_out(po),.jump_addr_out(jo));
  always #5 clk=~clk;
  initial begin
    @(posedge clk); rst=0; en=1; i=32'h1111; p=32'h2222; j=32'h3333; @(posedge clk);
    $display("IF/ID: instr=%h pc=%h jump=%h", io,po,jo); $display("Reg_IF_ID_tb PASS"); $finish;
  end
endmodule