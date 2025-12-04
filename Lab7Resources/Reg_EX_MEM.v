`timescale 1ns / 1ps

module Reg_EX_MEM(
    input  wire        clk,
    input  wire        reset,

    // Control (to MEM/WB)
    input  wire        RegWrite_in,
    input  wire        MemToReg_in,
    input  wire        MemWrite_in,
    input  wire        MemRead_in,
    input  wire [1:0]  MemSize_in,      // 00=byte, 01=half, 10=word
    input  wire        LoadSigned_in,   // 1=signed (LB/LH), 0=unsigned
    input  wire        Branch_in,
    input  wire        Link_in,         // for JAL

    // Data
    input  wire [31:0] ALUResult_in,
    input  wire [31:0] WriteData_in,    // rt value for stores
    input  wire [31:0] BranchTarget_in,
    input  wire        Zero_in,
    input  wire [4:0]  WriteReg_in,
    input  wire [31:0] PCp4_in,         // PC+4 (for link forwarding)

    // Outputs
    output reg         RegWrite_out,
    output reg         MemToReg_out,
    output reg         MemWrite_out,
    output reg         MemRead_out,
    output reg [1:0]   MemSize_out,
    output reg         LoadSigned_out,
    output reg         Branch_out,
    output reg         Link_out,

    output reg [31:0]  ALUResult_out,
    output reg [31:0]  WriteData_out,
    output reg [31:0]  BranchTarget_out,
    output reg         Zero_out,
    output reg [4:0]   WriteReg_out,
    output reg [31:0]  PCp4_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWrite_out   <= 1'b0;
            MemToReg_out   <= 1'b0;
            MemWrite_out   <= 1'b0;
            MemRead_out    <= 1'b0;
            MemSize_out    <= 2'b10;  // word by default
            LoadSigned_out <= 1'b1;   // signed by default
            Branch_out     <= 1'b0;
            Link_out       <= 1'b0;

            ALUResult_out     <= 32'b0;
            WriteData_out     <= 32'b0;
            BranchTarget_out  <= 32'b0;
            Zero_out          <= 1'b0;
            WriteReg_out      <= 5'b0;
            PCp4_out          <= 32'b0;
        end else begin
            RegWrite_out   <= RegWrite_in;
            MemToReg_out   <= MemToReg_in;
            MemWrite_out   <= MemWrite_in;
            MemRead_out    <= MemRead_in;
            MemSize_out    <= MemSize_in;
            LoadSigned_out <= LoadSigned_in;
            Branch_out     <= Branch_in;
            Link_out       <= Link_in;

            ALUResult_out     <= ALUResult_in;
            WriteData_out     <= WriteData_in;
            BranchTarget_out  <= BranchTarget_in;
            Zero_out          <= Zero_in;
            WriteReg_out      <= WriteReg_in;
            PCp4_out          <= PCp4_in;
        end
    end
endmodule