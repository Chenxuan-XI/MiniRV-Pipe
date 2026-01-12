`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/01/01 18:21:08
// Design Name: 
// Module Name: ex_stage
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

module ex_stage #(
    parameter WIDTH = 32,
    parameter DEPTH = 64
) (
    input  logic [WIDTH-1:0] pc_in, //not used, for further branch judgement
    input  logic [3:0]  opcode_in,  //not used, just for verification
    input  logic [4:0]  rd_in,
    input  logic [WIDTH-1:0] rs1_val_in,
    input  logic [WIDTH-1:0] rs2_val_in,
    input  logic [WIDTH-1:0] imm_in,


    //control signals
    input logic        is_load_in,
    input logic        is_store_in,
    input logic        reg_write_in,
    input logic        alu_src_imm,
    input logic [2:0]  alu_op,

    //hazard unit
    input logic [4:0] rs1_idx_in,
    input logic [4:0] rs2_idx_in,
    input logic       exmem_reg_write,
    input logic [4:0] exmem_rd,
    input logic       memwb_reg_write,
    input logic [4:0] memwb_rd,
    input logic [WIDTH-1:0] exmem_alu_res,
    input logic [WIDTH-1:0] memwb_wdata,

    output logic [WIDTH-1:0] alu_res,
    output logic [WIDTH-1:0] store_data,
    output logic [4:0]  rd_out,
    output logic        reg_write_out,
    output logic        is_load_out,
    output logic        is_store_out
);

logic [WIDTH-1:0] alu_a;
logic [WIDTH-1:0] alu_b;
logic [WIDTH-1:0] rs2_fwd_val;

always_comb begin
    //default 
    alu_a       = rs1_val_in;
    alu_b       = (alu_src_imm) ? imm_in : rs2_val_in;
    rs2_fwd_val = rs2_val_in;

    if(exmem_reg_write && (exmem_rd != 0) && (exmem_rd == rs1_idx_in)) alu_a = exmem_alu_res;
    else if(memwb_reg_write && (memwb_rd != 0) && (memwb_rd == rs1_idx_in)) alu_a = memwb_wdata;
    else alu_a = rs1_val_in;

    // alu_b : either imm OR forwarded rs2
    if (alu_src_imm) begin
        alu_b = imm_in;
    end else begin
        if (exmem_reg_write && (exmem_rd != 0) && (exmem_rd == rs2_idx_in))
            alu_b = exmem_alu_res;
        else if (memwb_reg_write && (memwb_rd != 0) && (memwb_rd == rs2_idx_in))
            alu_b = memwb_wdata;
        else
            alu_b = rs2_val_in;
    end

    //store forwading
    if(exmem_reg_write && (exmem_rd != 0) && (exmem_rd == rs2_idx_in)) rs2_fwd_val = exmem_alu_res;
    else if (memwb_reg_write && (memwb_rd != 0) && (memwb_rd == rs2_idx_in)) rs2_fwd_val = memwb_wdata;
    else rs2_fwd_val = rs2_val_in;
end


always_comb begin
    alu_res    = '0;
    store_data = rs2_fwd_val; // store the value from rs2 to the memory address rs1+imm; MEM[ rs1 + imm ] ← rs2
    rd_out     = rd_in;
    is_load_out = is_load_in;
    is_store_out = is_store_in;
    reg_write_out = reg_write_in;



    case (alu_op)
        ALU_ADD: begin
            alu_res = alu_a + alu_b;
        end
        ALU_SUB: begin
            alu_res = alu_a - alu_b;
        end
        ALU_AND: begin
            alu_res = alu_a & alu_b;
        end
        ALU_NOP: begin

        end
        default: ;
    endcase
    if (rs1_idx_in == 0 && alu_a !== 0) $display("!!! X0 BROKEN in EX: rs1_idx_in==0 but alu_a=%h", alu_a);
    $display("EX@%0t pc=%h op=%h rd=%0d rs1=%0d rs2=%0d | rs1_val=%h rs2_val=%h alu_a=%h alu_b=%h | exmem(rd=%0d,we=%b) memwb(rd=%0d,we=%b)",
            $time, pc_in, opcode_in, rd_in, rs1_idx_in, rs2_idx_in,
            rs1_val_in, rs2_val_in, alu_a, alu_b,
            exmem_rd, exmem_reg_write, memwb_rd, memwb_reg_write
        );


end


endmodule
