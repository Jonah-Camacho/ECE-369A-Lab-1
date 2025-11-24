`timescale 1ns / 1ps

module Reg_ID_EX(
    input clk, 
    input reset,
    input flush,  // added for inserting NOPs in EX when stalling
    // Control signals
    input RegWrite_in, 
    input MemWrite_in, 
    input MemRead_in, 
    input Branch_in, 
    input MemToReg_in,
    input ALUSrc_in, 
    input RegDst_in,
    input [3:0] ALUop_in,
    input [1:0] MemSize_in,      // NEW: 00=byte, 01=halfword, 10=word
    input LoadSigned_in,         // NEW: 1=signed (LB/LH), 0=unsigned (LBU/LHU)
    input Link_in,               // NEW: for JAL support
    input [31:0] JumpAddr_in,    // NEW: jump address passthrough
    // Data signals
    input [31:0] ReadData1_in, 
    input [31:0] ReadData2_in, 
    input [31:0] ExtImm_in, 
    input [31:0] PCp4_in,
    input [4:0] rs_in, 
    input [4:0] rt_in, 
    input [4:0] rd_in,
    input [5:0] funct_in,        // NEW: function field for R-type
    input [4:0] shamt_in,
    // Control outputs
    output reg RegWrite_out, 
    output reg MemWrite_out, 
    output reg MemRead_out, 
    output reg Branch_out, 
    output reg MemToReg_out,
    output reg ALUSrc_out, 
    output reg RegDst_out,
    output reg [3:0] ALUop_out,
    output reg [1:0] MemSize_out,   // NEW
    output reg LoadSigned_out,      // NEW
    output reg Link_out,            // NEW
    output reg [31:0] JumpAddr_out, // NEW
    // Data outputs
    output reg [31:0] ReadData1_out, 
    output reg [31:0] ReadData2_out, 
    output reg [31:0] ExtImm_out, 
    output reg [31:0] PCp4_out,
    output reg [4:0] rs_out, 
    output reg [4:0] rt_out, 
    output reg [4:0] rd_out,
    output reg [5:0] funct_out,     // NEW
    output reg [4:0] shamt_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Control signals
            RegWrite_out <= 1'b0;
            MemWrite_out <= 1'b0;
            MemRead_out  <= 1'b0;
            Branch_out   <= 1'b0;
            MemToReg_out <= 1'b0;
            ALUSrc_out   <= 1'b0;
            RegDst_out   <= 1'b0;
            ALUop_out    <= 4'b0000;
            MemSize_out  <= 2'b10;      // default to word
            LoadSigned_out <= 1'b1;     // default to signed
            Link_out     <= 1'b0;
            JumpAddr_out <= 32'b0;
            // Data signals
            ReadData1_out <= 32'b0;
            ReadData2_out <= 32'b0;
            ExtImm_out   <= 32'b0;
            PCp4_out     <= 32'b0;
            rs_out       <= 5'b0;
            rt_out       <= 5'b0;
            rd_out       <= 5'b0;
            funct_out    <= 6'b0;
            shamt_out    <= 5'b0;
        end
        else if (flush) begin //insert a NOP into EX
            // Control signals
            RegWrite_out <= 0;
            MemWrite_out <= 0;
            MemRead_out <= 0;
            Branch_out <= 0;
            MemToReg_out <= 0;
            ALUSrc_out <= 0;
            RegDst_out <= 0;       
            ALUop_out <= 4'b0;
            MemSize_out <= 2'b0;
            LoadSigned_out <= 0;
            Link_out <= 0;
            JumpAddr_out <= 0;
            // Data signals (does not matter if passed through or not, but will be set to 0 for safety)
            ReadData1_out <= 32'b0;
            ReadData2_out <= 32'b0;
            ExtImm_out   <= 32'b0;
            PCp4_out     <= 32'b0;
            rs_out       <= 5'b0;
            rt_out       <= 5'b0;
            rd_out       <= 5'b0;
            funct_out    <= 6'b0;
            shamt_out    <= 5'b0;     
        end
        else begin
            // Control signals
            RegWrite_out <= RegWrite_in;
            MemWrite_out <= MemWrite_in;
            MemRead_out  <= MemRead_in;
            Branch_out   <= Branch_in;
            MemToReg_out <= MemToReg_in;
            ALUSrc_out   <= ALUSrc_in;
            RegDst_out   <= RegDst_in;
            ALUop_out    <= ALUop_in;
            MemSize_out  <= MemSize_in;
            LoadSigned_out <= LoadSigned_in;
            Link_out     <= Link_in;
            JumpAddr_out <= JumpAddr_in;
            // Data signals
            ReadData1_out <= ReadData1_in;
            ReadData2_out <= ReadData2_in;
            ExtImm_out   <= ExtImm_in;
            PCp4_out     <= PCp4_in;
            rs_out       <= rs_in;
            rt_out       <= rt_in;
            rd_out       <= rd_in;
            funct_out    <= funct_in;
            shamt_out    <= shamt_in;
        end
    end
endmodule