`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/03/2025 12:09:42 AM
// Design Name: 
// Module Name: RegisterFile_tb
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


module RegisterFile_tb;
    // Inputs
    reg Clk;
    reg Reset;
    reg RegWrite;
    reg [4:0] ReadRegister1;
    reg [4:0] ReadRegister2;
    reg [4:0] WriteRegister;
    reg [31:0] WriteData;

    // Outputs
    wire [31:0] ReadData1;
    wire [31:0] ReadData2;

    // Instantiate the DUT (Device Under Test)
    RegisterFile uut (
        .Clk(Clk),
        .Reset(Reset),
        .RegWrite(RegWrite),
        .ReadRegister1(ReadRegister1),
        .ReadRegister2(ReadRegister2),
        .WriteRegister(WriteRegister),
        .WriteData(WriteData),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2)
     );

    // Clock generation: 10 ns period (100 MHz)
     initial Clk = 0;
     always #5 Clk = ~Clk;

    // Test sequence
    initial begin
        // Initialize signals
        Clk = 0;
        Reset = 0;
        RegWrite = 0;
        ReadRegister1 = 0;
        ReadRegister2 = 0;
        WriteRegister = 0;
        WriteData = 0;

        // Apply reset
        $display("Applying reset...");
        Reset = 1;
        #10;  // wait 1 clock cycle
        Reset = 0;
        $display("Reset released.\n");

        // Write to register 1
        @(posedge Clk);
        RegWrite = 1;
        WriteRegister = 5'd1;
        WriteData = 32'hAABBCCDD;
        @(posedge Clk);  // perform write

        // Write to register 2
        WriteRegister = 5'd2;
        WriteData = 32'h11223344;
        @(posedge Clk);

        // Disable RegWrite
        RegWrite = 0;
        @(posedge Clk);

        // Read back from registers 1 and 2
        ReadRegister1 = 5'd1;
        ReadRegister2 = 5'd2;
        #1; // small delay to allow propagation
        $display("ReadData1 = %h (expected aabbccdd)", ReadData1);
        $display("ReadData2 = %h (expected 11223344)\n", ReadData2);

        // Attempt to write to register $zero (should stay 0)
        @(posedge Clk);
        RegWrite = 1;
        WriteRegister = 5'd0;
        WriteData = 32'hFFFFFFFF;
        @(posedge Clk);
        RegWrite = 0;

        // Read from $zero
        ReadRegister1 = 5'd0;
        #1;
        $display("ReadData1 = %h (expected 00000000)\n", ReadData1);

        // End simulation
        #10;
        $display("Test completed.");
        $finish;
    end
    
endmodule
