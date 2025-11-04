`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2025 02:13:28 PM
// Design Name: 
// Module Name: TopLevel
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


module TopLevel(
    input wire Clk,
    input wire Reset,
    output wire [6:0] out7,
    output wire [7:0] en_out
    );
    
    //IF
    //Address calculation, stored in Addr
    wire [31:0] PC_curr, PC_next;
    
    ProgramCounter pc(
        .Address(PC_curr),
        .PCResult(PC_next),
        .Reset(Reset),
        .Clk(Clk)
    );
    
    PCAdder pcadd(
        .PCResult(PC_curr),
        .PCAddResult(PC_next)
    );
    
    //Instruction from address in instruction memory, stored in InstrIF
    wire [31:0] InstrIF;
    InstructionMemory im(
        .Address(PC_curr),
        .Instruction(InstrIF)
    );
    
    //Jump address calculation, stored in JumpAddr
    wire [31:0] JumpAddrIF;
    Shift_left_2 jumpAddrCalc(
        .value_in(PC_curr),
        .value_out(JumpAddrIF)
    );
    
    //IF/ID Register
    wire [31:0] InstrID, AddrID, JumpAddrID;
    Reg_IF_ID IFID(
        .clk(Clk),
        .rst(Reset),
        .en(1), //Can changle later, enabled = 1
        .instr_in(InstrIF),
        .pc_in(AddrIF),
        .jump_addr_in(JumpAddrIF),
        .instr_out(InstrID),
        .pc_out(AddrID),
        .jump_addr_out(JumpAddrID)
    );
    
    //ID
    wire RegWriteID, ALUsrcID, ExtOpID, RegDstID, BranchID, JumpID, LinkID,
    JumpRegID, MemWriteID, MemReadID, MemToRegID;
    wire [3:0] ALUopID;
    wire [1:0] MemSizeID;
    
    Controller ctrl(
        .Instruction(InstrID),
        .RegWrite(RegWriteID),
        .ALUSrc(ALUSrcID),
        .ExtOp(ExtOpID),
        .RegDst(RegDstID),
        .Branch(BranchID),
        .Jump(JumpID),
        .Link(LinkID),
        .JumpReg(JumpRegID),
        .MemWrite(MemWriteID),
        .MemRead(MemReadID),
        .MemToReg(MemToRegID),
        .ALUop(ALUopID),
        .MemSize(MemSizeID)
    );
    
    //RegisterFile rf
    
    
    
endmodule
