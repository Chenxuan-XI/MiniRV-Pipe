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
    input  logic [WIDTH-1:0] pc_in,
    input  logic [3:0]  opcode_in,
    input  logic [4:0]  rd_in,
    input  logic [WIDTH-1:0] rs1_val_in,
    input  logic [WIDTH-1:0] rs2_val_in,
    input  logic [WIDTH-1:0] imm_in,

    output logic [WIDTH-1:0] alu_res,
    output logic [WIDTH-1:0] store_data,
    output logic [4:0]  rd_out,
    output logic        is_load,
    output logic        is_store
);

always_comb begin
    alu_res    = '0;
    store_data = rs2_val_in; // store the value from rs2 to the memory address rs1+imm; MEM[ rs1 + imm ] ← rs2
    rd_out     = rd_in;
    is_load    = 1'b0;
    is_store   = 1'b0;

    case (opcode_in)
        OP_ADD:   alu_res = rs1_val_in + rs2_val_in;
        OP_SUB:   alu_res = rs1_val_in - rs2_val_in;
        OP_AND:   alu_res = rs1_val_in & rs2_val_in;
        OP_LOAD: begin
            alu_res = rs1_val_in + imm_in;
            is_load = 1'b1;
        end
        OP_STORE: begin
            alu_res  = rs1_val_in + imm_in;
            is_store = 1'b1;
        end
        default: ;
    endcase
end


endmodule
