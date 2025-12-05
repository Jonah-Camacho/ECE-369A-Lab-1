`timescale 1ns / 1ps



module Reg_IF_ID(
    input clk,
    input rst,
    input en,
    input flush,
    input [31:0] instr_in,
    input [31:0] pc_in,
    input[31:0] jump_addr_in,
    output reg [31:0] instr_out,
    output reg [31:0] pc_out,
    output reg [31:0] jump_addr_out
    );
    
    always @(posedge clk or posedge rst) begin
        if (rst || flush) begin //If resetting values
            instr_out <= 32'b0;
            pc_out <= 32'b0;
            jump_addr_out <= 32'b0;
        end
        else if (en) begin //If enabled
            instr_out <= instr_in;
            pc_out <= pc_in;
            jump_addr_out <= jump_addr_in;
        end
        else begin //If stalling/not enabled
            instr_out <= instr_out;
            pc_out <= pc_out;
            jump_addr_out <= jump_addr_out;
        end
    end
endmodule
