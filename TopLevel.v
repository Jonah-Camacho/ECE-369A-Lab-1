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
    wire [31:0] PC_curr, PC_plus4, PC_next_final;
    
    
   ProgramCounter pc(
        .Address(PC_next_final),
        .PCResult(PC_curr),
        .Reset(Reset),
        .Clk(Clk)
    );
    
    PCAdder pcadd(
        .PCResult(PC_curr),
        .PCAddResult(PC_plus4)
    );
    
    //Instruction from address in instruction memory, stored in InstrIF
    wire [31:0] Instr_IF;
    InstructionMemory im(
        .Address(PC_curr),
        .Instruction(Instr_IF)
    );
    
    //Jump address calculation, stored in JumpAddr_IF
    wire [31:0] JumpShifted_IF, JumpAddr_IF;
    Shift_left_2 jumpAddrCalc(
        .value_in({6'b0, Instr_IF[25:0]}),
        .value_out(JumpShifted_IF)
    );
    
    assign JumpAddr_IF = {PC_ID[31:28], JumpShifted_IF[27:0] };
    
    //IF/ID Register
    wire [31:0] Instr_ID, Addr_ID, JumpAddr_ID, PC_ID;
    Reg_IF_ID IF_ID(
        .clk(Clk),
        .rst(Reset),
        .en(1), //Can changle later, enabled = 1
        .instr_in(Instr_IF),
        .pc_in(PC_plus4),
        .jump_addr_in(JumpAddr_IF),
        .instr_out(Instr_ID),
        .pc_out(PC_ID),
        .jump_addr_out(JumpAddr_ID)
    );
    
    //ID
    wire RegWrite_ID, ALUsrc_ID, ExtOp_ID, RegDst_ID, Branch_ID, Jump_ID, Link_ID,
    JumpReg_ID, MemWrite_ID, MemRead_ID, MemToReg_ID;
    wire [3:0] ALUop_ID;
    wire [1:0] MemSize_ID;
    
    Controller ctrl(
        .Instruction(Instr_ID),
        .RegWrite(RegWrite_ID),
        .ALUSrc(ALUSrc_ID),
        .ExtOp(ExtOp_ID),
        .RegDst(RegDst_ID),
        .Branch(Branch_ID),
        .Jump(Jump_ID),
        .Link(Link_ID),
        .JumpReg(JumpReg_ID),
        .MemWrite(MemWrite_ID),
        .MemRead(MemRead_ID),
        .MemToReg(MemToReg_ID),
        .ALUop(ALUop_ID),
        .MemSize(MemSize_ID)
    );
    
    //Storing values from GPR[rs], GPR[rt] and GPR[rt] in ReadData1 and ReadData2 _ID
    
    wire RegWrite_WB;
    wire [4:0] WriteReg_WB;
    wire [31:0] WriteData_WB;
    wire [31:0] ReadData1_ID, ReadData2_ID;

    wire [4:0] shamt_ID = Instr_ID[10:6];
    
  
    
    
    //Sign/zero extending immediate based on control signal
    wire [31:0] Imm_ID;
    Extension ext(
       .in(Instr_ID[15:0]),
       .control(ExtOp_ID),
       .out(Imm_ID)
    );
    
    //ID/EX Register
    wire RegWrite_EX, MemWrite_EX, MemRead_EX, Branch_EX;
    wire MemToReg_EX, ALUSrc_EX, RegDst_EX;
    wire [3:0] ALUop_EX;
    wire [1:0] MemSize_EX;
    wire [31:0] ReadData1_EX, ReadData2_EX, Imm_EX, PC_EX;
    wire [4:0] rs_EX, rt_EX, rd_EX, shamt_EX;
    Reg_ID_EX ID_EX(
        .clk(Clk),
        .reset(Reset),
        .RegWrite_in(RegWrite_ID),
        .MemWrite_in(MemWrite_ID),
        .MemRead_in(MemRead_ID),
        .Branch_in(Branch_ID),
        .MemSize_in(MemSize_ID),
        .MemToReg_in(MemToReg_ID),
        .ALUSrc_in(ALUSrc_ID),
        .RegDst_in(RegDst_ID),
        .ALUop_in(ALUop_ID),
        .ReadData1_in(ReadData1_ID),
        .ReadData2_in(ReadData2_ID),
        .ExtImm_in(Imm_ID),
        .PCp4_in(PC_ID),
        .rs_in(rs_ID),
        .rt_in(rt_ID),
        .rd_in(rd_ID),
        .shamt_in(shamt_ID),
        .RegWrite_out(RegWrite_EX),
        .MemWrite_out(MemWrite_EX),
        .MemRead_out(MemRead_EX),
        .Branch_out(Branch_EX),
        .MemSize_out(MemSize_EX),
        .MemToReg_out(MemToReg_EX),
        .ALUSrc_out(ALUSrc_EX),
        .RegDst_out(RegDst_EX),
        .ALUop_out(ALUop_EX),
        .ReadData1_out(ReadData1_EX),
        .ReadData2_out(ReadData2_EX),
        .ExtImm_out(Imm_EX),
        .PCp4_out(PC_EX),
        .rs_out(rs_EX),
        .rt_out(rt_EX),
        .rd_out(rd_EX),
        .shamt_out(shamt_EX)
    );





    //Write Back

    wire RegWrite_WB;
    wire MemToReg_WB; //picks if the alu or memory data(control)
    wire [4:0] WriteReg_WB; //reg number 
    wire [31:0] ALUres_WB;
    wire [31:0] MemReadData_WB;
    wire [31:0] WriteData_WB;


    wire [31:0] WriteBack_Data; //the data
    wire [4:0] WriteReg_Wb; //write adress 
    wire RegWrite_Wb; //write data


  Mux_2x1 WriteBack_mux(

        .a(ALUres_WB),
        .b(MemReadData_WB),
        .control(MemToReg_WB),
        .out(WriteBack_Data)


    );

    assign RegWrite_WB = mem_wb_regwrite && (rd_WB != 5'd0);
    assign WriteReg_WB = rd_WB;
    




    wire [4:0] rs_ID = Instr_ID[25:21];
    wire [4:0] rt_ID = Instr_ID[20:16];
    wire [4:0] rd_ID = Instr_ID[15:11];
    



      RegisterFile rf(
        .Clk(Clk),
        .Reset(Reset),
        .RegWrite(RegWrite_WB),
        .ReadRegister1(rs_ID),
        .ReadRegister2(rt_ID),
        .WriteRegister(WriteReg_WB),
        .WriteData(WriteData_WB),
        .ReadData1(ReadData1_ID),
        .ReadData2(ReadData2_ID)
    );
endmodule
