`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/22 16:53:57
// Design Name: 
// Module Name: id_ex_reg
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


module id_ex_reg(
    parameter WIDTH = 32,
    parameter DEPTH = 64
) (
    input  logic [WIDTH-1:0] pc_in,
    input  logic [3:0]       opcode_in,
    input  logic [4:0]       rd_in,
    input  logic [WIDTH-1:0] rs1_val_in,
    input  logic [WIDTH-1:0] rs2_val_in,
    input  logic [WIDTH-1:0] imm_in,

    input  logic clk,
    input  logic rst_n,

    output logic [WIDTH-1:0] pc_out,
    output logic [3:0]       opcode_out,
    output logic [4:0]       rd_out,
    output logic [WIDTH-1:0] rs1_val_out,
    output logic [WIDTH-1:0] rs2_val_out,
    output logic [WIDTH-1:0] imm_out
);

always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc_out <= '0;
        opcode_out <= '0;
        rd_out <= '0;
        rs1_val_out <= '0;
        rs2_val_out <= '0;
        imm_out <= '0;
    end else begin
        pc_out <= pc_in;
        opcode_out <= opcode_in;
        rd_out <= rd_in;
        rs1_val_out <= rs1_val_in;
        rs2_val_out <= rs2_val_in;
        imm_out <= imm_in;
    end     

end

endmodule
