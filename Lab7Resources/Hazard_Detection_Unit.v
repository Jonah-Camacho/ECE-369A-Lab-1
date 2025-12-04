`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 11:11:01 AM
// Design Name: 
// Module Name: Hazard_Detection_Unit
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


module Hazard_Detection_Unit(
    // ID Stage Inputs
    input Branch_ID,   // BAW
    input JumpReg_ID,  // JRAW
    input [4:0] rs_ID, // checking for matching
    input [4:0] rt_ID, // checking for matching
    
    // EX Stage Inputs
    input MemRead_EX,    // LU
    input MemRead_MEM, //LU
    input RegWrite_EX,   // RAW
    input [4:0] rt_EX,   // For load-use
    input [4:0] DestReg_EX, // dest reg of EX (rt = I, rd = R)
    
    // MEM Stage Inputs
    input RegWrite_MEM,  // RAW
    input [4:0] WriteReg_MEM,  // RAW
    
    // WB Stage Inputs
    input RegWrite_WB,
    input [4:0] WriteReg_WB,
    input MemToReg_WB,
    
    // Control Signal Outputs
    output reg PCWrite, //control whether PC should write next instruction sequentially (Stall > Seq)
    output reg IF_ID_Write, //control whether we should write next insrtuction to IF_ID
    output reg ID_EX_Flush //control flushing of ID_EX register 
    );
    
    
    // =================================
    // Load-Use (EX Load --> Used in ID)
    // =================================
    wire load_use_hazard;
    // if we're reading mem in EX and either the rs or rt of the ID insrtuction is equal to the register being read from (and rt_EX != 0/nop)
    assign load_use_hazard =
    (MemRead_EX  && ((rt_EX       == rs_ID) || (rt_EX       == rt_ID)) && (rt_EX       != 5'd0)) ||
    (MemRead_MEM && ((WriteReg_MEM == rs_ID) || (WriteReg_MEM == rt_ID)) && (WriteReg_MEM != 5'd0)) ||
    (MemToReg_WB && ((WriteReg_WB  == rs_ID) || (WriteReg_WB  == rt_ID)) && (WriteReg_WB  != 5'd0));

    
    // =========================================
    // ALU -> ALU RAW (assuming no forwarding)
    // EX-stage instr writes a reg that ID uses
    // =========================================
    wire ex_raw_hazard;
    wire mem_raw_hazard;
    
    wire wb_raw_hazard;
    
    assign ex_raw_hazard = RegWrite_EX && !MemRead_EX && (DestReg_EX != 5'd0) && ( (DestReg_EX == rs_ID) || (DestReg_EX == rt_ID));
    assign mem_raw_hazard = RegWrite_MEM && !MemRead_MEM && ( WriteReg_MEM != 5'd0) && ((WriteReg_MEM == rs_ID) || (WriteReg_MEM == rt_ID));
    assign wb_raw_hazard = RegWrite_WB && 
                        !MemToReg_WB &&
                       (WriteReg_WB != 5'd0) && 
                       ((WriteReg_WB == rs_ID) || (WriteReg_WB == rt_ID));
    //May be able to remove mem_raw_hazards later, needs checking
    wire raw_hazard = ex_raw_hazard | mem_raw_hazard | wb_raw_hazard;
    
    // ====================================================================
    // Branch Hazards (Branch in ID relies on EX/MEM result)
    // Branches compares rs/rt in ID, but regs are being written in EX/MEM
    // ====================================================================
    wire branch_dep_ex;
    wire branch_dep_mem;
    wire branch_dep_wb;
    
    assign branch_dep_ex = 
        Branch_ID && RegWrite_EX && !MemRead_EX && (DestReg_EX != 5'd0) &&
        ( (DestReg_EX == rs_ID) || (DestReg_EX == rt_ID) );
        
    assign branch_dep_mem =
        Branch_ID && RegWrite_MEM && !MemRead_MEM && (WriteReg_MEM != 5'd0) &&
        ( (WriteReg_MEM == rs_ID) || (WriteReg_MEM == rt_ID) );
     
    assign branch_dep_wb = 
        Branch_ID && RegWrite_WB && !MemToReg_WB && (WriteReg_WB != 5'd0) &&
        ( ( WriteReg_WB == rs_ID) || (WriteReg_WB == rt_ID) );
    wire branch_hazard = branch_dep_ex | branch_dep_mem | branch_dep_wb;
    
    // ==============================================
    // JR Hazards (JR in ID relies on EX/MEM result)
    // jr rs, but rs being computed in EX/MEM
    // ==============================================
    
    wire jr_dep_ex;
    wire jr_dep_mem;
    wire jr_dep_wb;
    
    assign jr_dep_ex = JumpReg_ID && RegWrite_EX && !MemRead_EX && DestReg_EX != 5'd0 && (DestReg_EX == rs_ID);
    assign jr_dep_mem = JumpReg_ID && RegWrite_MEM && !MemRead_MEM && WriteReg_MEM != 5'd0 && (WriteReg_MEM == rs_ID);
    assign jr_dep_wb = JumpReg_ID && RegWrite_WB && !MemToReg_WB && WriteReg_WB != 5'd0 && (WriteReg_WB == rs_ID);
    
    wire jr_hazard = jr_dep_ex | jr_dep_mem | jr_dep_wb;
    
    // Checking for any hazard
    wire hazard_any = load_use_hazard | raw_hazard | branch_hazard | jr_hazard;
    
    always @(*) begin
        // Default, no hazard detected
        PCWrite = 1'b1;
        IF_ID_Write = 1'b1;
        ID_EX_Flush = 1'b0;
        
        if (hazard_any) begin
            PCWrite     = 1'b0;  // stall PC
            IF_ID_Write = 1'b0;  // stall IF/ID
            ID_EX_Flush = 1'b1;  // insert bubble into EX
        end
    
    end
endmodule
