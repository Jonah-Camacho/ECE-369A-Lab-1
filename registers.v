`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2017 11:04:29 AM
// Design Name: 
// Module Name: registers
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RegisterFile( ReadRegister2, WriteRegister, WriteData, Clk,  ReadData2,out_data, debug_reg);
	
	input [4:0] ReadRegister2;
	input [4:0] WriteRegister;
	input [31:0] WriteData;
	
	input Clk;

	
	output reg [31:0] ReadData2;
	output wire [31:0] out_data;
	output wire [31:0]  debug_reg;
(* mark_debug = "true" *)  	reg [31:0] regFile [0:31];
 	
	
	initial begin
		regFile[0] <= 0;
	end

    always @(negedge Clk) begin
        ReadData2 <= regFile[ReadRegister2];
	end

	always @(posedge Clk) begin
			regFile[WriteRegister] <= WriteData;
	end
		
assign out_data = regFile[23];
assign debug_reg = regFile[10];
endmodule