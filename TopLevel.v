`timescale 1ns / 1ps

///////
// Participation: 33% Jonah Camacho, 33% Alex Melde, 33% Daniel Rivera Castelo
// 5-stage pipeline
// make sure to 
//////

module TopLevel(
    input  wire       Clk,
    input  wire       Reset,
    output wire [6:0] out7,      // Seven-segment display segments
    output wire [7:0] en_out     // Seven-segment display enable


);

    // ========================================================================
    // CLOCK DIVIDER - Slow down clock for visible display on FPGA
    // ========================================================================
    
    // IMPORTANT: uncomment these two for simulation
    wire ClkSlow;

    //assign ClkSlow = Clk;

    // IMPORTANT: uncomment this for fpga board
    ClkDiv clock_divider(
        .Clk(Clk),           // 100 MHz input from board
        .Rst(Reset),
        .ClkOut(ClkSlow)     // 1 Hz output (1 instruction/second)
   );
    

    // ========================================================================
    // IF STAGE - Instruction Fetch
    // ========================================================================
    wire [31:0] PC_curr, PC_IF, PC_next_final;
    wire [31:0] Instr_IF;
    wire PCWrite;
    wire IF_ID_Write;
    wire ID_EX_Flush;
    
    // Create Instruction Fetch Unit, not sure if this is necessary
    ProgramCounter pc (
        .Address(PC_next_final),
        .PCWrite(PCWrite),
        .PCResult(PC_curr),
        .Reset(Reset),
        .Clk(ClkSlow)
    );
    
    assign PC_IF = PC_curr + 4;
    
    InstructionMemory im (
        .Address(PC_IF),
        .Instruction(Instr_IF)
    );
    
    // Jump address calculation (moved here for clarity)
    wire [27:0] JumpShifted_IF;
    wire [31:0] JumpAddr_IF;                
    Shift_left_2_26 u_jump_shift (
      .in (Instr_IF[25:0]),
      .out(JumpShifted_IF)
    );
    assign JumpAddr_IF = {PC_IF[31:28], JumpShifted_IF};

    // ========================================================================
    // IF/ID PIPELINE REGISTER
    // ========================================================================
    wire [31:0] Instr_ID, PC_ID, JumpAddr_ID;
    Reg_IF_ID IF_ID(
        .clk(ClkSlow),       // Use slow clock
        .rst(Reset),
        .en(IF_ID_Write),                      
        .instr_in(Instr_IF),
        .pc_in(PC_IF),
        .jump_addr_in(JumpAddr_IF),
        .instr_out(Instr_ID),
        .pc_out(PC_ID),                 
        .jump_addr_out(JumpAddr_ID)
    );

    // ========================================================================
    // ID STAGE - Instruction Decode
    // ========================================================================
    
    // Decode instruction fields
    wire [4:0] rs_ID    = Instr_ID[25:21];
    wire [4:0] rt_ID    = Instr_ID[20:16];
    wire [4:0] rd_ID    = Instr_ID[15:11];
    wire [4:0] shamt_ID = Instr_ID[10:6];
    wire [5:0] funct_ID = Instr_ID[5:0];

    // Control signals
    wire RegWrite_ID, ALUSrc_ID, ExtOp_ID, RegDst_ID, Branch_ID, Jump_ID, Link_ID, JumpReg_ID;
    wire MemWrite_ID, MemRead_ID, MemToReg_ID, LoadSigned_ID;
    wire [3:0] ALUop_ID;
    wire [1:0] MemSize_ID;

    Controller ctrl(
        .Instruction(Instr_ID),
        .RegWrite(RegWrite_ID),
        .ALUSrc(ALUSrc_ID),
        .ExtOp(ExtOp_ID),               // 0=sign extend, 1=zero extend
        .RegDst(RegDst_ID),             // 0=rt, 1=rd
        .Branch(Branch_ID),             // BEQ
        .Jump(Jump_ID),                 // J/JAL
        .Link(Link_ID),                 // JAL
        .JumpReg(JumpReg_ID),           // JR
        .MemWrite(MemWrite_ID),
        .MemRead(MemRead_ID),
        .MemToReg(MemToReg_ID),         // 0=ALU result, 1=Memory data
        .ALUop(ALUop_ID),
        .MemSize(MemSize_ID),           // 00=byte, 01=halfword, 10=word
        .LoadSigned(LoadSigned_ID)      // 1=signed (LB/LH), 0=unsigned (LBU/LHU)
    );

    // WB stage outputs (forward declared for RegisterFile)
    wire        RegWrite_WB_final;
    wire [4:0]  WriteReg_WB_final;
    (* mark_debug = "true" *)
    wire [31:0] WriteData_WB_final;

    // Register File
    wire [31:0] ReadData1_ID, ReadData2_ID;
    RegisterFile rf(
        .Clk(ClkSlow),       // Use slow clock
        .Reset(Reset),
        .RegWrite(RegWrite_WB_final),
        .ReadRegister1(rs_ID),
        .ReadRegister2(rt_ID),
        .WriteRegister(WriteReg_WB_final),
        .WriteData(WriteData_WB_final),
        .ReadData1(ReadData1_ID),
        .ReadData2(ReadData2_ID)
    );

    // Sign/Zero Extension
    wire [31:0] Imm_ID;
    SignExtension ext(
        .in(Instr_ID[15:0]),
        .control(ExtOp_ID),             // 0=sign, 1=zero
        .out(Imm_ID)
    );

    // JR target = value in rs register
    wire [31:0] JRTarget_ID = ReadData1_ID;

        // Calculating Branch Address (ID Stage)
    
    wire [31:0] ImmShifted_ID;
    wire [31:0] BranchAddr_ID;
    
    // branch shifted left 2 for byte offset
    Shift_left_2_32 br_id (
        .in(Imm_ID),
        .out(ImmShifted_ID)
    );
    
    // branchtarget = current PC + 4 + shifted Immediate
    
    assign BranchAddr_ID = PC_ID + ImmShifted_ID;
    
    // BEQ (branch if GPR[rs] == GPR[rt])
    wire Zero_ID = (ReadData1_ID == ReadData2_ID);
    wire BranchTaken_ID = Branch_ID & Zero_ID;
    
    // ===========================================================
    //  PC SELECTION = Priority: JR > J > Branch > Sequantial (+4)
    // ==========================================================
    wire [31:0] PC_branch_or_seq = BranchTaken_ID ? BranchAddr_ID : PC_curr + 4;
    
    assign PC_next_final = (PCWrite == 0) ? PC_curr : JumpReg_ID ? JRTarget_ID  :  // JR: use rs value (from ID)
                           Jump_ID ? JumpAddr_ID  :  // J/JAL: use jump address (from ID)
                                     PC_branch_or_seq; // Branch (ID) or PC+4

    // ========================================================================
    // ID/EX PIPELINE REGISTER
    // ========================================================================
    wire RegWrite_EX, MemWrite_EX, MemRead_EX, MemToReg_EX;
    wire ALUSrc_EX, RegDst_EX, Link_EX, LoadSigned_EX;
    wire [3:0] ALUop_EX;
    wire [1:0] MemSize_EX;
    wire [31:0] ReadData1_EX, ReadData2_EX, Imm_EX, PC_EX, JumpAddr_EX;
    wire [4:0]  rs_EX, rt_EX, rd_EX, shamt_EX;
    wire [5:0]  funct_EX;
    assign flush = ID_EX_Flush ? 1 : 0;

    Reg_ID_EX ID_EX(
        .clk(ClkSlow),       // Use slow clock
        .reset(Reset),
        .flush(flush),
        // Control signals in
        .RegWrite_in(RegWrite_ID),
        .MemWrite_in(MemWrite_ID),
        .MemRead_in(MemRead_ID),
        .MemToReg_in(MemToReg_ID),
        .ALUSrc_in(ALUSrc_ID),
        .RegDst_in(RegDst_ID),
        .ALUop_in(ALUop_ID),
        .MemSize_in(MemSize_ID),
        .LoadSigned_in(LoadSigned_ID),
        .Link_in(Link_ID),
        .JumpAddr_in(JumpAddr_ID),
        // Data signals in
        .ReadData1_in(ReadData1_ID),
        .ReadData2_in(ReadData2_ID),
        .ExtImm_in(Imm_ID),
        .PCp4_in(PC_ID),
        .rs_in(rs_ID),
        .rt_in(rt_ID),
        .rd_in(rd_ID),
        .funct_in(funct_ID),
        .shamt_in(shamt_ID),
        // Control signals out
        .RegWrite_out(RegWrite_EX),
        .MemWrite_out(MemWrite_EX),
        .MemRead_out(MemRead_EX),
        .MemToReg_out(MemToReg_EX),
        .ALUSrc_out(ALUSrc_EX),
        .RegDst_out(RegDst_EX),
        .ALUop_out(ALUop_EX),
        .MemSize_out(MemSize_EX),
        .LoadSigned_out(LoadSigned_EX),
        .Link_out(Link_EX),
        .JumpAddr_out(JumpAddr_EX),
        // Data signals out
        .ReadData1_out(ReadData1_EX),
        .ReadData2_out(ReadData2_EX),
        .ExtImm_out(Imm_EX),
        .PCp4_out(PC_EX),
        .rs_out(rs_EX),
        .rt_out(rt_EX),
        .rd_out(rd_EX),
        .funct_out(funct_EX),
        .shamt_out(shamt_EX)
    );

    // ========================================================================
    // EX STAGE - Execute
    // ========================================================================
    
    // Destination register: rd for R-type, rt for I-type
    wire [4:0] DestReg_EX = (RegDst_EX) ? rd_EX : rt_EX;
    
    // ALU second operand: immediate or register
    wire [31:0] ALU_2nd = (ALUSrc_EX) ? Imm_EX : ReadData2_EX;

    // ALU control decoding
    wire [3:0] ALUCtrl_EX;
    ALUcontrol alu_ctrl(
        .ALUop(ALUop_EX),
        .funct(funct_EX),
        .ALUctrl(ALUCtrl_EX)
    );

    // ALU operation
    wire [31:0] ALUres_EX;
    wire Zero_EX;
    ALU alu(
        .input1(ReadData1_EX),
        .input2(ALU_2nd),
        .shamt(shamt_EX),
        .op(ALUCtrl_EX),
        .result(ALUres_EX),
        .Zero(Zero_EX)
    );

    // ========================================================================
    // EX/MEM PIPELINE REGISTER
    // ========================================================================
    wire RegWrite_MEM, MemToReg_MEM, MemWrite_MEM, MemRead_MEM, Link_MEM;
    wire [1:0] MemSize_MEM;
    wire LoadSigned_MEM, Zero_MEM;
    wire [31:0] ALUres_MEM, WriteData_MEM, PC_MEM;
    wire [4:0]  WriteReg_MEM;

    Reg_EX_MEM ex_mem(
        .clk(ClkSlow),       // Use slow clock
        .reset(Reset),
        // Control signals in
        .RegWrite_in(RegWrite_EX),
        .MemToReg_in(MemToReg_EX),
        .MemWrite_in(MemWrite_EX),
        .MemRead_in(MemRead_EX),
        .MemSize_in(MemSize_EX),
        .LoadSigned_in(LoadSigned_EX),
        .Link_in(Link_EX),
        // Data signals in
        .ALUResult_in(ALUres_EX),
        .WriteData_in(ReadData2_EX),    // RT value for stores
        .Zero_in(Zero_EX),
        .WriteReg_in(DestReg_EX),
        .PCp4_in(PC_EX),
        // Control signals out
        .RegWrite_out(RegWrite_MEM),
        .MemToReg_out(MemToReg_MEM),
        .MemWrite_out(MemWrite_MEM),
        .MemRead_out(MemRead_MEM),
        .MemSize_out(MemSize_MEM),
        .LoadSigned_out(LoadSigned_MEM),
        .Link_out(Link_MEM),
        // Data signals out
        .ALUResult_out(ALUres_MEM),
        .WriteData_out(WriteData_MEM),
        .Zero_out(Zero_MEM),
        .WriteReg_out(WriteReg_MEM),
        .PCp4_out(PC_MEM)
    );

    // ========================================================================
    // MEM STAGE - Memory Access
    // ========================================================================
    
    // Data Memory
    wire [31:0] MemReadData_MEM;
    DataMemory data_mem(
        .Clk(ClkSlow),           // Use slow clock
        .Address(ALUres_MEM),
        .WriteData(WriteData_MEM),
        .MemWrite(MemWrite_MEM),
        .MemRead(MemRead_MEM),
        .MemSize(MemSize_MEM),
        .LoadSigned(LoadSigned_MEM),
        .ReadData(MemReadData_MEM)
    );

     //PC selection moved to ID (changed from here)
 

    // ========================================================================
    // MEM/WB PIPELINE REGISTER
    // ========================================================================
    wire RegWrite_WB, MemToReg_WB, Link_WB;
    (* mark_debug = "true" *)
    wire [31:0] ALUres_WB, MemReadData_WB, PC_WB;
    wire [4:0]  WriteReg_WB_core;

    Reg_MEM_WB mem_wb(
        .clk(ClkSlow),       // Use slow clock
        .reset(Reset),
        // Control signals in
        .RegWrite_in(RegWrite_MEM),
        .MemToReg_in(MemToReg_MEM),
        .Link_in(Link_MEM),
        // Data signals in
        .ALUResult_in(ALUres_MEM),
        .MemReadData_in(MemReadData_MEM),
        .WriteReg_in(WriteReg_MEM),
        .PCp4_in(PC_MEM),
        // Control signals out
        .RegWrite_out(RegWrite_WB),
        .MemToReg_out(MemToReg_WB),
        .Link_out(Link_WB),
        // Data signals out
        .ALUResult_out(ALUres_WB),
        .MemReadData_out(MemReadData_WB),
        .WriteReg_out(WriteReg_WB_core),
        .PCp4_out(PC_WB)
    );

    // ========================================================================
    // WB STAGE - Write Back
    // ========================================================================
    
    // Select between ALU result and memory data
    wire [31:0] WriteData_WB_core = (MemToReg_WB) ? MemReadData_WB : ALUres_WB;

    // JAL override: if Link is set, write PC+4 to $ra (register 31)
    assign RegWrite_WB_final  = Link_WB ? 1'b1            : RegWrite_WB;
    assign WriteReg_WB_final  = Link_WB ? 5'd31           : WriteReg_WB_core;
    assign WriteData_WB_final = Link_WB ? PC_WB           : WriteData_WB_core;

    // ========================================================================
    // DISPLAY: show PC (low 16) and RF write data (low 16)
    // ========================================================================
    wire [31:0] pc_wb_instr = PC_WB - 32'd4;  // align with the actual instruction address

    wire [15:0] dispA = pc_wb_instr[15:0];        // lower 16 bits of PC at WB
    wire [15:0] dispB = WriteData_WB_final[15:0]; // lower 16 bits of WB data
    
    Two4DigitDisplay disp (
        .Clk    (Clk),    // fast clock for multiplexing
        .NumberA(dispA),
        .NumberB(dispB),
        .out7   (out7),
        .en_out (en_out)
    );
    
    Hazard_Detection_Unit hdu (
    // ID stage
    .Branch_ID (Branch_ID),
    .JumpReg_ID (JumpReg_ID),
    .rs_ID (rs_ID),
    .rt_ID (rt_ID),
    
    // EX stage
    .MemRead_MEM (MemRead_MEM),
    .MemRead_EX (MemRead_EX),
    .RegWrite_EX (RegWrite_EX),
    .rt_EX (rt_EX),
    .DestReg_EX (DestReg_EX),
    
    // MEM stage
    .RegWrite_MEM (RegWrite_MEM),
    .WriteReg_MEM (WriteReg_MEM),
    
    // Output
    .PCWrite (PCWrite),
    .IF_ID_Write (IF_ID_Write),
    .ID_EX_Flush (ID_EX_Flush)
    );

    

endmodule