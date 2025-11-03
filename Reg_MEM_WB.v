`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/02/2025 11:54:03 PM
// Design Name: 
// Module Name: Reg_MEM_WB
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


module Reg_MEM_WB(
    input clk, reset,
    // Control signals
    input RegWrite_in, MemToReg_in,
    // Data signals
    input [31:0] ReadData_in, ALUResult_in,
    input [4:0] WriteReg_in,

    // Outputs
    output reg RegWrite_out, MemToReg_out,
    output reg [31:0] ReadData_out, ALUResult_out,
    output reg [4:0] WriteReg_out
    );
    
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out <= 0;
            MemToReg_out <= 0;
            ReadData_out <= 0;
            ALUResult_out <= 0;
            WriteReg_out <= 0;
        end
        else begin
            RegWrite_out <= RegWrite_in;
            MemToReg_out <= MemToReg_in;
            ReadData_out <= ReadData_in;     //lw
            ALUResult_out <= ALUResult_in;   //ALU output
            WriteReg_out <= WriteReg_in;     //write register address number (e.g. t1)
        end
    end
    
endmodule
