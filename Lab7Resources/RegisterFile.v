`timescale 1ns / 1ps

module RegisterFile (
    input Clk,
    input Reset,
    input RegWrite,
    input [4:0] ReadRegister1,
    input [4:0] ReadRegister2,
    input [4:0] WriteRegister,
    input [31:0] WriteData,
    output [31:0] ReadData1,
    output [31:0] ReadData2
);
    reg [31:0] regs [0:31];
    integer i;
    
    // CRITICAL: Manually initialize all 32 registers
    initial begin
        regs[0]  = 32'h00000000;
        regs[1]  = 32'h00000000;
        regs[2]  = 32'h00000000;
        regs[3]  = 32'h00000000;
        regs[4]  = 32'h00000000;
        regs[5]  = 32'h00000000;
        regs[6]  = 32'h00000000;
        regs[7]  = 32'h00000000;
        regs[8]  = 32'h00000000;
        regs[9]  = 32'h00000000;
        regs[10] = 32'h00000000;
        regs[11] = 32'h00000000;
        regs[12] = 32'h00000000;
        regs[13] = 32'h00000000;
        regs[14] = 32'h00000000;
        regs[15] = 32'h00000000;
        regs[16] = 32'h00000000;
        regs[17] = 32'h00000000;
        regs[18] = 32'h00000000;
        regs[19] = 32'h00000000;
        regs[20] = 32'h00000000;
        regs[21] = 32'h00000000;
        regs[22] = 32'h00000000;
        regs[23] = 32'h00000000;
        regs[24] = 32'h00000000;
        regs[25] = 32'h00000000;
        regs[26] = 32'h00000000;
        regs[27] = 32'h00000000;
        regs[28] = 32'h00000000;
        regs[29] = 32'h00000000;
        regs[30] = 32'h00000000;
        regs[31] = 32'h00000000;
    end
    
    always @(posedge Clk) begin
        if (Reset) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (RegWrite && (WriteRegister != 5'd0)) begin
            regs[WriteRegister] <= WriteData;
        end
    end
    
    assign ReadData1 = (ReadRegister1 == 5'd0) ? 32'b0 : 
    (RegWrite && WriteRegister == ReadRegister1 && WriteRegister != 0) ? WriteData :
    regs[ReadRegister1];
    assign ReadData2 = (ReadRegister2 == 5'd0) ? 32'b0 :
    (RegWrite && WriteRegister == ReadRegister2 && WriteRegister != 0) ? WriteData :
    regs[ReadRegister2];
    
endmodule
