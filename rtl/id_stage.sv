`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/12/22 16:28:24
// Design Name: 
// Module Name: id_stage
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

module id_stage #(
    parameter WIDTH = 32,
    parameter DEPTH = 64,
    parameter READ_ASYNC = 1
) (
    input  logic [WIDTH-1:0] pc_in,
    input  logic [WIDTH-1:0] instr_in,
    input  logic clk,
    input  logic rst_n,

    input  logic        wb_we,
    input  logic [4:0]  wb_rd,
    input  logic [WIDTH-1:0] wb_wdata,

    output logic [3:0]  opcode,
    output logic [4:0]  rd,
    output logic [WIDTH-1:0] rs1_val,
    output logic [WIDTH-1:0] rs2_val,
    output logic [WIDTH-1:0] imm,
    output logic [WIDTH-1:0] pc_out,
    output logic [4:0]       rs1d,
    output logic [4:0]       rs2d,

    //control signals
    output logic        is_load,
    output logic        is_store,
    output logic        reg_write,
    output logic        alu_src_imm,  // 1: use imm, 0: use rs2
    output logic [2:0]  alu_op

);

logic [12:0] imm_raw;
assign rs1d = instr_in[RS1_HI:RS1_LO];
assign rs2d = instr_in[RS2_HI:RS2_LO];

assign opcode = instr_in[OPCODE_HI:OPCODE_LO];
assign rd = instr_in[RD_HI:RD_LO];
assign imm_raw = instr_in[IMM_HI:IMM_LO];
assign imm = {{(WIDTH-13){imm_raw[12]}}, imm_raw};
assign pc_out = pc_in;

regfile#(
    .WIDTH(WIDTH),
    .READ_ASYNC(READ_ASYNC),
    .DEPTH(DEPTH)    
) RF (
    .clk(clk),
    .rst_n(rst_n),
    .we(wb_we),
    .waddr(wb_rd),
    .wdata(wb_wdata),
    .raddr1(rs1d),
    .raddr2(rs2d),
    .rdata1(rs1_val),
    .rdata2(rs2_val)
);

always_comb begin
    //default values
    reg_write = 1'b0;
    is_load = 1'b0;
    is_store = 1'b0;
    alu_src_imm = 1'b0;
    alu_op = ALU_NOP;

    case(opcode)
        OP_ADD: begin
            reg_write = 1'b1;
            alu_op = ALU_ADD;
        end
        OP_SUB: begin
            reg_write = 1'b1;
            alu_op = ALU_SUB;
        end
        OP_AND: begin
            reg_write = 1'b1;
            alu_op = ALU_AND;
        end
        OP_ADDI: begin
            reg_write   = 1'b1;
            alu_src_imm = 1'b1;
            alu_op      = ALU_ADD;
        end
        OP_LOAD: begin
            is_load = 1'b1;
            reg_write = 1'b1;
            alu_src_imm = 1'b1;
            alu_op = ALU_ADD; // calculate address
        end
        OP_STORE: begin
            is_store = 1'b1;
            reg_write = 1'b0;
            alu_src_imm = 1'b1;
            alu_op = ALU_ADD;
        end
        default: begin
            // NOP
        end
    endcase

end

// always_ff @(posedge clk) begin
//     if (rst_n) begin
//         if (opcode == OP_STORE) begin
//             $display(
//                 "ID STORE: pc=%h instr=%h rs1=%0d rs1_val=%0d rs2=%0d rs2_val=%0d imm=%0d",
//                 pc_in,
//                 instr_in,
//                 rs1,
//                 rs1_val,
//                 rs2,
//                 rs2_val,
//                 imm
//             );
//         end
//     end
// end

// always_ff @(posedge clk) begin
//   if (rst_n) begin
//     $display("ID: pc=%h instr=%h opcode=%h rd=%0d rs1=%0d rs2=%0d imm=%0d",
//              pc_in, instr_in, opcode, rd, rs1d, rs2d, imm);
//   end
// end

endmodule
