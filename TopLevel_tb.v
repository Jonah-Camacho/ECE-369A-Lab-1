`timescale 1ns / 1ps

module TopLevel_tb;

    reg Clk = 0;
    reg Reset = 1;

    // DUT outputs
    wire [6:0] out7;
    wire [7:0] en_out;

    // DUT
    TopLevel dut(
        .Clk(Clk),
        .Reset(Reset),
        .out7(out7),
        .en_out(en_out)
    );

    // ----------------------------------------
    // Internal signal taps
    // ----------------------------------------
    wire [31:0] PC_curr       = dut.PC_curr;      // From IFU
    wire [31:0] Instr_ID    = dut.Instr_ID;     // IF/ID instruction
    wire PCWrite            = dut.PCWrite;
    wire IF_ID_Write        = dut.IF_ID_Write;
    wire ID_EX_Flush        = dut.ID_EX_Flush;

    // WB logging
    wire        wb_RegWrite    = dut.RegWrite_WB_final;
    wire [15:0]  wb_WriteData    = dut.dispA;
    wire [15:0] wb_WriteReg   = dut.dispB;
    wire [15:0] wb_PCp4        = dut.PC_WB;
    wire [4:0] rs_ID = dut.rs_ID;
    wire [4:0] rt_ID = dut.rt_ID;
    wire [4:0] rt_EX = dut.rt_EX;
    wire MemRead_MEM = dut.MemRead_MEM;
    wire MemRead_EX = dut.MemRead_EX;
    wire RegWrite_EX = dut.RegWrite_EX;
    wire [4:0] DestReg_EX = dut.DestReg_EX;
    wire DestReg_MEM = dut.WriteReg_MEM;
    

    // stall detection
    wire stall = (!PCWrite || !IF_ID_Write);

    integer cycle = 0;

    // ----------------------------------------
    // Logging on each cycle
    // ----------------------------------------
    always @(posedge Clk) begin
        if (!Reset) begin
            // Log write-back
            if (wb_RegWrite) begin
                $display("  WB Commit:");
                $display("     WB_PC      = %h", wb_PCp4 - 32'd4);
                $display("     writebackdata   = %h", wb_WriteReg);
            end

        end
    end

    // ----------------------------------------
    // Clock generator
    // ----------------------------------------
    always #5 Clk = ~Clk;

    // ----------------------------------------
    // Test sequence
    // ----------------------------------------
    initial begin
        $display("==== BEGIN PIPELINE TEST ====");

        Reset = 1;
        repeat (4) @(posedge Clk);
        Reset = 0;

        // Run long enough to see multiple loops and stalls
        repeat (50) begin
            @(posedge Clk);
            cycle = cycle + 1;
        end

        $display("==== END SIMULATION ====");
        $finish;
    end

endmodule
