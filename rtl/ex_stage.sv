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


module ex_stage (
    parameter WIDTH = 32,
    parameter DEPTH = 64
) (
    input  logic [WIDTH-1:0] pc_in, //not used, for further branch judgement
    input  logic [3:0]  opcode_in, //not used, just for verification
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

    output logic [WIDTH-1:0] alu_res,
    output logic [WIDTH-1:0] store_data,
    output logic [4:0]  rd_out,
    output logic        reg_write_out,
    output logic        is_load_out,
    output logic        is_store_out
);

logic [WIDTH-1:0] alu_a;
assign alu_a = rs1_val_in;
logic [WIDTH-1:0] alu_b;
assign alu_b = (alu_src_imm) ? imm_in : rs2_val_in;

always_comb begin
    alu_res    = '0;
    store_data = rs2_val_in; // store the value from rs2 to the memory address rs1+imm; MEM[ rs1 + imm ] ← rs2
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
end


endmodule
