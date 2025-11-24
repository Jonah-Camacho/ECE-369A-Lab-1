`timescale 1ns/1ps
module ProgramCounter_tb;

    reg  Clk;
    reg  Reset;
    reg  PCWrite;
    reg  [31:0] Address;
    wire [31:0] PCResult;

    ProgramCounter dut (
        .Address (Address),
        .Reset   (Reset),
        .Clk     (Clk),
        .PCWrite (PCWrite),
        .PCResult(PCResult)
    );

    // 10 ns period clock
    initial Clk = 0;
    always #5 Clk = ~Clk;

    initial begin
        $display("===== ProgramCounter_tb START =====");

        // Init
        Reset   = 1;
        PCWrite = 1;
        Address = 32'h0000_0000;
        #20;

        // Release reset
        Reset = 0;
        Address = 32'h0000_0004;
        #10;  // one clock
        $display("[%0t] PCResult=%h (expect 00000004)", $time, PCResult);

        Address = 32'h0000_0008;
        #10;
        $display("[%0t] PCResult=%h (expect 00000008)", $time, PCResult);

        // Stall test: PCWrite = 0, Address keeps changing
        PCWrite = 0;
        Address = 32'h0000_000C;
        #10;
        $display("[%0t] PCResult=%h (expect still 00000008)", $time, PCResult);

        Address = 32'h0000_0010;
        #10;
        $display("[%0t] PCResult=%h (expect still 00000008)", $time, PCResult);

        // Resume
        PCWrite = 1;
        #10;
        $display("[%0t] PCResult=%h (expect 00000010)", $time, PCResult);

        $display("===== ProgramCounter_tb DONE =====");
        $finish;
    end

endmodule