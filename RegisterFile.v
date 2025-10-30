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

    always @(posedge Clk) begin
        if (Reset) begin
            for (i = 0; i < 32; i = i + 1)
                regs[i] <= 32'b0;
        end else if (RegWrite && (WriteRegister != 5'd0)) begin
            regs[WriteRegister] <= WriteData;
        end
    end

    assign ReadData1 = (ReadRegister1 == 5'd0) ? 32'b0 : regs[ReadRegister1];
    assign ReadData2 = (ReadRegister2 == 5'd0) ? 32'b0 : regs[ReadRegister2];
endmodule
