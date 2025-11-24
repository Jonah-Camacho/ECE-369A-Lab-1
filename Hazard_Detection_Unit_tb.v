`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2025 05:56:21 PM
// Design Name: 
// Module Name: Hazard_Detection_Unit_tb
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


module Hazard_Detection_Unit_tb;

    // ID stage inputs
    reg        Branch_ID;
    reg        JumpReg_ID;
    reg [4:0]  rs_ID;
    reg [4:0]  rt_ID;

    // EX stage inputs
    reg        MemRead_EX;
    reg        RegWrite_EX;
    reg [4:0]  rt_EX;
    reg [4:0]  DestReg_EX;

    // MEM stage inputs
    reg        RegWrite_MEM;
    reg [4:0]  WriteReg_MEM;

    // Outputs
    wire       PCWrite;
    wire       IF_ID_Write;
    wire       ID_EX_Flush;

    // DUT
    Hazard_Detection_Unit dut (
        .Branch_ID    (Branch_ID),
        .JumpReg_ID   (JumpReg_ID),
        .rs_ID        (rs_ID),
        .rt_ID        (rt_ID),
        .MemRead_EX   (MemRead_EX),
        .RegWrite_EX  (RegWrite_EX),
        .rt_EX        (rt_EX),
        .DestReg_EX   (DestReg_EX),
        .RegWrite_MEM (RegWrite_MEM),
        .WriteReg_MEM (WriteReg_MEM),
        .PCWrite      (PCWrite),
        .IF_ID_Write  (IF_ID_Write),
        .ID_EX_Flush  (ID_EX_Flush)
    );
    
    reg[127:0] test_names [0:3];

    // Simple task to dump signals
    task show(test_names);
        begin
            $display("[%0t] %s:", $time, name);
            $display("  PCWrite=%0b IF_ID_Write=%0b ID_EX_Flush=%0b",
                     PCWrite, IF_ID_Write, ID_EX_Flush);
        end
    endtask

    initial begin
        $display("===== Hazard_Detection_Unit_tb START =====");

        // -------------------------------
        // 0) No hazard - everything idle
        // -------------------------------
        Branch_ID    = 0;
        JumpReg_ID   = 0;
        rs_ID        = 5'd1;
        rt_ID        = 5'd2;
        MemRead_EX   = 0;
        RegWrite_EX  = 0;
        rt_EX        = 5'd0;
        DestReg_EX   = 5'd0;
        RegWrite_MEM = 0;
        WriteReg_MEM = 5'd0;
        #10; show("No hazard (baseline)");

        // --------------------------------------
        // 1) Load-use hazard: lw in EX, ID uses
        // --------------------------------------
        MemRead_EX   = 1;
        rt_EX        = 5'd8;  // load writes to r8
        rs_ID        = 5'd8;  // ID reads r8 as source
        rt_ID        = 5'd3;
        RegWrite_EX  = 0;
        RegWrite_MEM = 0;
        #10; show("Load-use hazard (EX load -> ID rs)");

        // ---------------------------------------------------
        // 2) EX RAW hazard: EX writes dest, ID uses that reg
        // ---------------------------------------------------
        MemRead_EX   = 0;
        RegWrite_EX  = 1;
        DestReg_EX   = 5'd9;
        rs_ID        = 5'd9;
        rt_ID        = 5'd4;
        rt_EX        = 5'd0;
        #10; show("EX RAW hazard (ALU result needed by ID)");

        // ---------------------------------------------------
        // 3) MEM RAW hazard: MEM writes dest, ID uses that reg
        // ---------------------------------------------------
        RegWrite_EX  = 0;
        DestReg_EX   = 5'd0;
        RegWrite_MEM = 1;
        WriteReg_MEM = 5'd10;
        rs_ID        = 5'd10;
        rt_ID        = 5'd0;
        #10; show("MEM RAW hazard");

        // -----------------------------------------------
        // 4) Branch hazard: branch in ID depends on EX/MEM
        // -----------------------------------------------
        Branch_ID    = 1;
        JumpReg_ID   = 0;
        RegWrite_EX  = 1;
        DestReg_EX   = 5'd11;
        rs_ID        = 5'd11;
        RegWrite_MEM = 0;
        #10; show("Branch hazard (branch depends on EX)");

        Branch_ID    = 1;
        RegWrite_EX  = 0;
        DestReg_EX   = 5'd0;
        RegWrite_MEM = 1;
        WriteReg_MEM = 5'd12;
        rs_ID        = 5'd12;
        #10; show("Branch hazard (branch depends on MEM)");

        // ------------------------
        // 5) JR hazard (JumpReg)
        // ------------------------
        Branch_ID    = 0;
        JumpReg_ID   = 1;
        RegWrite_EX  = 1;
        DestReg_EX   = 5'd13;
        rs_ID        = 5'd13; // jr rs, but rs is being produced in EX
        RegWrite_MEM = 0;
        #10; show("JR hazard (EX)");

        JumpReg_ID   = 1;
        RegWrite_EX  = 0;
        DestReg_EX   = 5'd0;
        RegWrite_MEM = 1;
        WriteReg_MEM = 5'd14;
        rs_ID        = 5'd14; // jr rs, rs produced in MEM
        #10; show("JR hazard (MEM)");

        // ----------------------------------
        // 6) Clear all hazards - back to OK
        // ----------------------------------
        Branch_ID    = 0;
        JumpReg_ID   = 0;
        MemRead_EX   = 0;
        RegWrite_EX  = 0;
        rt_EX        = 5'd0;
        DestReg_EX   = 5'd0;
        RegWrite_MEM = 0;
        WriteReg_MEM = 5'd0;
        rs_ID        = 5'd1;
        rt_ID        = 5'd2;
        #10; show("No hazard (end)");

        $display("===== Hazard_Detection_Unit_tb DONE =====");
        $finish;
    end

endmodule