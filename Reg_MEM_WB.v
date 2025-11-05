`timescale 1ns / 1ps

module Reg_MEM_WB(
    input  wire        clk,
    input  wire        reset,

    // Control
    input  wire        RegWrite_in,
    input  wire        MemToReg_in,
    input  wire        Link_in,          // JAL link

    // Data
    input  wire [31:0] MemReadData_in,   // from DataMemory
    input  wire [31:0] ALUResult_in,     // from EX/MEM
    input  wire [4:0]  WriteReg_in,      // destination reg
    input  wire [31:0] PCp4_in,          // for link value

    // Outputs
    output reg         RegWrite_out,
    output reg         MemToReg_out,
    output reg         Link_out,

    output reg [31:0]  MemReadData_out,
    output reg [31:0]  ALUResult_out,
    output reg [4:0]   WriteReg_out,
    output reg [31:0]  PCp4_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out     <= 1'b0;
            MemToReg_out     <= 1'b0;
            Link_out         <= 1'b0;

            MemReadData_out  <= 32'b0;
            ALUResult_out    <= 32'b0;
            WriteReg_out     <= 5'b0;
            PCp4_out         <= 32'b0;
        end else begin
            RegWrite_out     <= RegWrite_in;
            MemToReg_out     <= MemToReg_in;
            Link_out         <= Link_in;

            MemReadData_out  <= MemReadData_in;
            ALUResult_out    <= ALUResult_in;
            WriteReg_out     <= WriteReg_in;
            PCp4_out         <= PCp4_in;
        end
    end
endmodule
