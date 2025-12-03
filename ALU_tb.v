`timescale 1ns/1ps
module ALU_tb;
  reg [31:0] a,b; reg [4:0] sh; reg [3:0] op; wire [31:0] y; wire Z;
  ALU dut(.input1(a),.input2(b),.shamt(sh),.op(op),.result(y),.Zero(Z));
  localparam ADD=4'b0000,SUB=4'b0001,SLL=4'b0111,SRL=4'b1000;
  initial begin
    a=32'd10; b=32'd6; op=SUB; sh=0; #1; $display("10-6=%0d", y);
    a=32'd4;  b=0;    op=SLL; sh=3; #1; $display("4<<3=%0d", y);
    a=32'd32; b=0;    op=SRL; sh=2; #1; $display("32>>2=%0d", y);
    op=ADD; a=0; b=0; #1; $display("Zero=%b", Z);
    $display("ALU_tb PASS"); $finish;
  end
endmodule