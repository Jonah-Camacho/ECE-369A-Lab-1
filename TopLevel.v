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
    
    
    PCAdder pcadd(
        .PCResult(PC_curr),
        .PCAddResult(PC_next)
    );
    
   ProgramCounter pc(
        .Address(PC_next),
        .PCResult(PC_curr),
        .Reset(Reset),
        .Clk(Clk)
    );
    
    //Instruction from address in instruction memory, stored in InstrIF
    wire [31:0] Instr_IF;
    InstructionMemory im(
        .Address(PC_curr),
        .Instruction(Instr_IF)
    );
    
    //Jump address calculation, stored in JumpAddr
    wire [31:0] JumpAddr_IF;
    Shift_left_2 jumpAddrCalc(
        .value_in(PC_curr),
        .value_out(JumpAddr_IF)
    );
    
    //IF/ID Register
    wire [31:0] Instr_ID, Addr_ID, JumpAddr_ID;
    Reg_IF_ID IF_ID(
        .clk(Clk),
        .rst(Reset),
        .en(1), //Can changle later, enabled = 1
        .instr_in(Instr_IF),
        .pc_in(Addr_IF),
        .jump_addr_in(JumpAddr_IF),
        .instr_out(Instr_ID),
        .pc_out(Addr_ID),
        .jump_addr_out(JumpAddr_ID)
    );
    
    //ID
    wire RegWrite_ID, ALUsrc_ID, ExtOp_ID, RegDst_ID, Branch_ID, Jump_ID, Link_ID,
    JumpRegID, MemWrite_ID, MemRead_ID, MemToReg_ID;
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
    
    //Write Back

    wire RegWrite_WB;
    wire mem_wb_MemOrReg; //picks if the alu or memory data(control)
    wire [4:0] WriteReg_WB; //reg number 
    wire [31:0] mem_wb_alu_output;
    wire [31:0] mem_wb_read_data;
    wire [31:0] WriteData_WB;


    wire [31:0] WriteBack_Data; //the data
    wire [4:0] WriteReg_Wb; //write adress 
    wire RegWrite_Wb; //write data


  Mux_2x1 WriteBack_mux(

        .a(mem_wb_alu_output),
        .b(mem_wb_read_data),
        .control(mem_wb_MemOrReg),
        .out(WriteBack_Data)


    );

    assign RegWrite_WB = mem_wb_regwrite && (mem_wb_rd != 5'd0);
    assign WriteReg_WB = mem_wb_rd;



  
    
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
