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

import minirv_types::*;


module id_ex_reg #(
    parameter WIDTH = 32,
    parameter DEPTH = 64
) (
    input  logic [WIDTH-1:0] pc_in,
    input  logic [3:0]       opcode_in,
    input  logic [4:0]       rd_in,
    input  logic [WIDTH-1:0] rs1_val_in,
    input  logic [WIDTH-1:0] rs2_val_in,
    input  logic [WIDTH-1:0] imm_in,
    input  logic [4:0]       rs1_in,
    input  logic [4:0]       rs2_in,

    //control signals
    input logic        is_load_in,
    input logic        is_store_in,
    input logic        reg_write_in,
    input logic        alu_src_imm_in,
    input logic [2:0]  alu_op_in,

    input  logic clk,
    input  logic rst_n,
    input  logic flush,

    output logic [WIDTH-1:0] pc_out,
    output logic [3:0]       opcode_out,
    output logic [4:0]       rd_out,
    output logic [WIDTH-1:0] rs1_val_out,
    output logic [WIDTH-1:0] rs2_val_out,
    output logic [WIDTH-1:0] imm_out,
    output logic [4:0]       rs1_out,
    output logic [4:0]       rs2_out,

    output logic        is_load_out,
    output logic        is_store_out,
    output logic        reg_write_out,
    output logic        alu_src_imm_out,  // 1: use imm, 0: use rs2
    output logic [2:0]  alu_op_out
);



always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pc_out <= '0;
        opcode_out <= '0;
        rd_out <= '0;
        rs1_val_out <= '0;
        rs2_val_out <= '0;
        imm_out <= '0;
        is_load_out <= '0;
        is_store_out <= '0;
        reg_write_out <= '0;
        alu_src_imm_out <= '0;
        alu_op_out <= '0;
        rs1_out <= '0;
        rs2_out <= '0;
    end else if (flush) begin
        is_load_out <= '0;
        is_store_out <= '0;
        reg_write_out <= '0;
        alu_src_imm_out <= '0;
        alu_op_out <= ALU_NOP;

        pc_out <= '0;
        opcode_out <= '0;
        rd_out <= '0;
        rs1_val_out <= '0;
        rs2_val_out <= '0;
        imm_out <= '0;
        rs1_out <= '0;
        rs2_out <= '0;
                                
    end else begin
        pc_out <= pc_in;
        opcode_out <= opcode_in;
        rd_out <= rd_in;
        rs1_val_out <= rs1_val_in;
        rs2_val_out <= rs2_val_in;
        imm_out <= imm_in;
        is_load_out <= is_load_in;
        is_store_out <= is_store_in;
        reg_write_out <= reg_write_in;
        alu_src_imm_out <= alu_src_imm_in;
        alu_op_out <= alu_op_in;
        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
    end     

end

always_ff @(posedge clk) begin
  if (rst_n) begin
    $display("IDEX@%0t flush=%b | op=%h rd=%0d rs1=%0d rs2=%0d | alu_src_imm=%b imm=%h alu_op=%h",
      $time, flush, opcode_out, rd_out, rs1_out, rs2_out, alu_src_imm_out, imm_out, alu_op_out);
  end
end


endmodule
